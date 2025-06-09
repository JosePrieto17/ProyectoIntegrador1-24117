package Test;

import DAO.AsistenciaDAO;
import DAO.TrabajadorDAO;
import modelo.Trabajador;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.LinkedHashSet;
import java.util.Scanner;
import java.util.Set;
import java.util.regex.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.Conexion;

public class TestAsistenciaDAO {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        TrabajadorDAO trabajadorDAO = new TrabajadorDAO();
        AsistenciaDAO asistenciaDAO = new AsistenciaDAO();

        System.out.println("===== TEST MANUAL DE ASISTENCIAS =====");

        System.out.print("Ingrese DNI del trabajador: ");
        String dni = scanner.nextLine();

        System.out.print("Ingrese tipo (Entrada / Salida / Falta): ");
        String tipo = scanner.nextLine();

        System.out.print("Ingrese fecha (YYYY-MM-DD): ");
        String fecha = scanner.nextLine();

        String hora = null;
        if (!"Falta".equalsIgnoreCase(tipo)) {
            System.out.print("Ingrese hora (HH:mm:ss): ");
            hora = scanner.nextLine();
        }

        Trabajador trabajador = trabajadorDAO.obtenerPorDNI(dni);
        if (trabajador == null) {
            System.out.println("❌ Trabajador no encontrado.");
            return;
        }

        int idTrabajador = trabajador.getId();

        if ("Entrada".equalsIgnoreCase(tipo) && asistenciaDAO.existeEntradaHoy(idTrabajador, fecha)) {
            System.out.println("⚠️ Ya existe una entrada para esta fecha.");
            return;
        }

        if ("Falta".equalsIgnoreCase(tipo)) {
            if (asistenciaDAO.existeEntradaHoy(idTrabajador, fecha)) {
                System.out.println("⚠️ Ya existe un registro para esa fecha.");
                return;
            }
            String estado = "Falta";
            String observacion = "No justificada";
            boolean exito = asistenciaDAO.registrarAsistencia(idTrabajador, fecha, null, tipo, estado, observacion);
            if (exito) {
                System.out.println("✅ Falta registrada como No justificada para " + trabajador.getNombreCompleto());
            } else {
                System.out.println("❌ No se pudo registrar la falta.");
            }
            return;
        }

        String estado = "";
        String observacion = "";

        try {
            String horario = trabajador.getHorario();
            Pattern pattern = Pattern.compile("(\\d{2}:\\d{2}:\\d{2})\\s*-\\s*(\\d{2}:\\d{2}:\\d{2})");
            Matcher matcher = pattern.matcher(horario);

            if (!matcher.find()) {
                System.out.println("❌ No se encontraron horas válidas en el campo horario.");
                System.out.println("Horario recibido: " + horario);
                return;
            }

            String horaEntradaStr = matcher.group(1);
            String horaSalidaStr = matcher.group(2);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
            LocalTime hEntrada = LocalTime.parse(horaEntradaStr, formatter);
            LocalTime hSalida = LocalTime.parse(horaSalidaStr, formatter);
            LocalTime hActual = LocalTime.parse(hora, formatter);

            if ("Entrada".equalsIgnoreCase(tipo)) {
                if (hActual.isBefore(hEntrada) || hActual.isAfter(hSalida)) {
                    System.out.println("⚠️ Fuera de Rango: el horario es de " + horaEntradaStr + " a " + horaSalidaStr);
                    return;
                }

                long diferencia = ChronoUnit.MINUTES.between(hEntrada, hActual);
                if (diferencia > 10) {
                    estado = "Tardanza";
                    String observacionPrevio = "";
                    try (Connection con = Conexion.getConnection()) {
                        String sql = "SELECT Observaciones FROM asistencia WHERE ID_Trabajador = ? AND Fecha = ?";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ps.setInt(1, idTrabajador);
                        ps.setString(2, fecha);
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) {
                            observacionPrevio = rs.getString("Observaciones") != null ? rs.getString("Observaciones") : "";
                        }
                    }
                    String nueva = "Llegó " + diferencia + " min tarde";
                    observacion = deduplicarObservacion(observacionPrevio, nueva);
                } else {
                    estado = "Puntual";
                }
            } else if ("Salida".equalsIgnoreCase(tipo)) {
                String estadoPrevio = "";
                String observacionPrevio = "";
                boolean entradaRegistrada = false;

                try (Connection con = Conexion.getConnection()) {
                    String sql = "SELECT Estado, Observaciones, HoraEntrada FROM asistencia WHERE ID_Trabajador = ? AND Fecha = ?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setInt(1, idTrabajador);
                    ps.setString(2, fecha);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        entradaRegistrada = rs.getString("HoraEntrada") != null;
                        estadoPrevio = rs.getString("Estado") != null ? rs.getString("Estado") : "";
                        observacionPrevio = rs.getString("Observaciones") != null ? rs.getString("Observaciones") : "";
                    }
                }

                if (!entradaRegistrada) {
                    System.out.println("⚠️ Fuera de Rango: no se ha registrado una hora de entrada para hoy.");
                    return;
                }

                estado = estadoPrevio;
                String nuevaObservacion = "Se retiró a las " + hora + ", antes de las " + horaSalidaStr;

                if (hActual.isBefore(hSalida)) {
                    if (!estado.contains("Salida Anticipada")) {
                        if (!estado.isEmpty()) estado += " | ";
                        estado += "Salida Anticipada";
                    }
                    observacion = deduplicarObservacion(observacionPrevio, nuevaObservacion);
                } else {
                    observacion = deduplicarObservacion(observacionPrevio, null);
                    if (estado.isEmpty()) estado = "Puntual";
                }
            }

        } catch (Exception e) {
            System.out.println("❌ Error al analizar horario del trabajador.");
            e.printStackTrace();
            return;
        }

        boolean exito = asistenciaDAO.registrarAsistencia(idTrabajador, fecha, hora, tipo, estado, observacion.isEmpty() ? null : observacion);

        if (exito) {
            System.out.println("✅ " + tipo + " registrada como " + estado + " para " + trabajador.getNombreCompleto() + " a las " + hora);
        } else {
            System.out.println("❌ No se pudo registrar la asistencia.");
        }
    }

private static String deduplicarObservacion(String observacionPrevio, String nueva) {
    Set<String> partesUnicas = new LinkedHashSet<>();
    boolean yaExisteTardanza = false;
    Pattern regexTardanza = Pattern.compile("Llegó \\d+ min tarde");

    if (observacionPrevio != null && !observacionPrevio.trim().isEmpty()) {
        for (String parte : observacionPrevio.split(" \\| ")) {
            parte = parte.trim();
            if (!parte.isEmpty()) {
                if (regexTardanza.matcher(parte).matches()) {
                    if (!yaExisteTardanza) {
                        partesUnicas.add(parte);
                        yaExisteTardanza = true;
                    }
                } else {
                    partesUnicas.add(parte);
                }
            }
        }
    }

    if (nueva != null && !nueva.trim().isEmpty()) {
        String parte = nueva.trim();
        if (regexTardanza.matcher(parte).matches()) {
            if (!yaExisteTardanza) {
                partesUnicas.add(parte);
            }
        } else {
            partesUnicas.add(parte);
        }
    }

    return String.join(" | ", partesUnicas);
}
}
