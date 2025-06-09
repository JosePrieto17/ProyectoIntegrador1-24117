package Controlador;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.LinkedHashSet;
import java.util.regex.*;

import DAO.TrabajadorDAO;
import DAO.AsistenciaDAO;
import java.util.Set;
import modelo.Trabajador;
import util.Conexion;

@WebServlet("/RegistrarAsistencia")
public class RegistrarAsistencia extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String dni = request.getParameter("dni");
        String tipo = request.getParameter("tipo");
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");

        TrabajadorDAO trabajadorDAO = new TrabajadorDAO();
        AsistenciaDAO asistenciaDAO = new AsistenciaDAO();

        String context = request.getContextPath();

        Trabajador trabajador = trabajadorDAO.obtenerPorDNI(dni);
        if (trabajador == null) {
            String mensaje = "❌ Trabajador no encontrado. DNI: " + dni;
            response.sendRedirect(context + "/vista/registro_asistencia.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));
            return;
        }

        int idTrabajador = trabajador.getId();

        if ("Entrada".equalsIgnoreCase(tipo) &&
                asistenciaDAO.existeEntradaHoy(idTrabajador, fecha)) {
            String mensaje = "⚠️ Ya registraste tu entrada hoy.";
            response.sendRedirect(context + "/vista/registro_asistencia.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));
            return;
        }

        String estado = "";
        String observacion = "";

        try {
            String horario = trabajador.getHorario();
            Pattern pattern = Pattern.compile("(\\d{2}:\\d{2}:\\d{2})\\s*-\\s*(\\d{2}:\\d{2}:\\d{2})");
            Matcher matcher = pattern.matcher(horario);

            if (!matcher.find()) {
                String mensaje = "❌ No se encontraron horas válidas en el horario: " + horario;
                response.sendRedirect(context + "/vista/registro_asistencia.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));
                return;
            }

            String horaEntradaStr = matcher.group(1);
            String horaSalidaStr = matcher.group(2);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
            LocalTime horaEntradaEsperada = LocalTime.parse(horaEntradaStr, formatter);
            LocalTime horaSalidaEsperada = LocalTime.parse(horaSalidaStr, formatter);
            LocalTime horaActual = LocalTime.parse(hora, formatter);

            if ("Entrada".equalsIgnoreCase(tipo)) {
                if (horaActual.isBefore(horaEntradaEsperada) || horaActual.isAfter(horaSalidaEsperada)) {
                    String mensaje = "⚠️ Fuera de Rango: el horario es de " + horaEntradaStr + " a " + horaSalidaStr;
                    response.sendRedirect(context + "/vista/registro_asistencia.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));
                    return;
                }

                long minutosTarde = ChronoUnit.MINUTES.between(horaEntradaEsperada, horaActual);
                if (minutosTarde > 10) {
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
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    String nueva = "Llegó " + minutosTarde + " min tarde";
                    observacion = deduplicarObservacion(observacionPrevio, nueva);
                } else {
                    estado = "Puntual";
                }
            }

            if ("Salida".equalsIgnoreCase(tipo)) {
                String estadoPrevio = "";
                String observacionPrevio = "";

                try (Connection con = Conexion.getConnection()) {
                    String sql = "SELECT Estado, Observaciones, HoraEntrada FROM asistencia WHERE ID_Trabajador = ? AND Fecha = ?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setInt(1, idTrabajador);
                    ps.setString(2, fecha);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        estadoPrevio = rs.getString("Estado") != null ? rs.getString("Estado") : "";
                        observacionPrevio = rs.getString("Observaciones") != null ? rs.getString("Observaciones") : "";
                        String horaEntradaRegistrada = rs.getString("HoraEntrada");
                        if (horaEntradaRegistrada == null || horaEntradaRegistrada.trim().isEmpty()) {
                            String mensaje = "⚠️ Fuera de Rango: aún no has registrado tu entrada.";
                            response.sendRedirect(context + "/vista/registro_asistencia.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));
                            return;
                        }
                    } else {
                        String mensaje = "⚠️ Fuera de Rango: aún no has registrado tu entrada.";
                        response.sendRedirect(context + "/vista/registro_asistencia.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));
                        return;
                    }

                    estado = estadoPrevio;
                    String nuevaObservacion = "Se retiró a las " + hora + ", antes de las " + horaSalidaStr;

                    if (horaActual.isBefore(horaSalidaEsperada)) {
                        if (!estado.contains("Salida Anticipada")) {
                            if (!estado.isEmpty()) estado += " | ";
                            estado += "Salida Anticipada";
                        }
                        observacion = deduplicarObservacion(observacionPrevio, nuevaObservacion);
                    } else {
                        observacion = deduplicarObservacion(observacionPrevio, null);
                        if (estado.isEmpty()) {
                            estado = "Puntual";
                        }
                    }
                } catch (Exception e) {
                    String mensaje = "❌ Error al obtener estado previo: " + e.getMessage();
                    response.sendRedirect(context + "/vista/registro_asistencia.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));
                    return;
                }
            }

        } catch (Exception e) {
            String mensaje = "❌ Error al procesar el horario. Detalles: " + e.getMessage();
            response.sendRedirect(context + "/vista/registro_asistencia.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));
            return;
        }

        try {
            boolean exito = asistenciaDAO.registrarAsistencia(idTrabajador, fecha, hora, tipo, estado, observacion.isEmpty() ? null : observacion);
            String mensaje;
            if (exito) {
                mensaje = tipo + " registrada como " + estado + " para " + trabajador.getNombreCompleto() + " a las " + hora;
            } else {
                mensaje = "❌ No se pudo registrar la asistencia";
            }
            response.sendRedirect(context + "/vista/registro_asistencia.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));
        } catch (Exception e) {
            String mensaje = "❌ Error interno al registrar asistencia: " + e.getMessage();
            response.sendRedirect(context + "/vista/registro_asistencia.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));
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
