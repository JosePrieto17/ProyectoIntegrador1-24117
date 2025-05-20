package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import util.Conexion;

public class DashboardDAO {

    public int contarTrabajadores() {
        String sql = "SELECT COUNT(*) " +
                     "FROM trabajador t " +
                     "INNER JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                     "WHERE u.ID_Rol IN (1, 2) AND u.Estado = 'Activo'";
        return contar(sql);
    }

    public int contarAsistenciasHoy() {
        String sql = "SELECT COUNT(*) " +
                     "FROM asistencia a " +
                     "INNER JOIN trabajador t ON a.ID_Trabajador = t.ID_Trabajador " +
                     "INNER JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                     "WHERE a.Fecha = CURDATE() AND u.ID_Rol IN (1, 2)";
        return contar(sql);
    }

    public int contarTardanzasHoy() {
        String sql = "SELECT COUNT(*) " +
                     "FROM asistencia a " +
                     "INNER JOIN trabajador t ON a.ID_Trabajador = t.ID_Trabajador " +
                     "INNER JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                     "WHERE a.Fecha = CURDATE() AND a.Estado = 'Tardanza' AND u.ID_Rol IN (1, 2)";
        return contar(sql);
    }

    public int contarSalidasAnticipadasHoy() {
        String sql = "SELECT COUNT(*) " +
                     "FROM asistencia a " +
                     "INNER JOIN trabajador t ON a.ID_Trabajador = t.ID_Trabajador " +
                     "INNER JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                     "WHERE a.Fecha = CURDATE() AND a.Estado = 'Salida_Anticipada' AND u.ID_Rol IN (1, 2)";
        return contar(sql);
    }

    public int contarFaltasHoy() {
        String sql = "SELECT COUNT(*) " +
                     "FROM asistencia a " +
                     "INNER JOIN trabajador t ON a.ID_Trabajador = t.ID_Trabajador " +
                     "INNER JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                     "WHERE a.Fecha = CURDATE() AND a.Estado = 'Falta' AND u.ID_Rol IN (1, 2)";
        return contar(sql);
    }

public Map<String, Integer> obtenerAsistenciasUltimos7Dias() {
    Map<String, Integer> datos = new LinkedHashMap<>();
    SimpleDateFormat sdf = new SimpleDateFormat("EEEE", new Locale("es", "ES"));

    // 1. Inicializar los 7 días anteriores incluyendo hoy
    try {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.add(java.util.Calendar.DAY_OF_MONTH, -6); // hace 6 días hasta hoy

        for (int i = 0; i < 7; i++) {
            String dia = sdf.format(cal.getTime());
            dia = dia.substring(0, 1).toUpperCase() + dia.substring(1); // Capitalizar
            datos.put(dia, 0); // Inicializar con 0
            cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
        }
    } catch (Exception e) {
        System.out.println("❌ Error inicializando días en obtenerAsistenciasUltimos7Dias");
        e.printStackTrace();
    }

    // 2. Consultar la BD y reemplazar los valores si hay registros
    String sql = "SELECT a.Fecha, COUNT(*) AS total " +
                 "FROM asistencia a " +
                 "INNER JOIN trabajador t ON a.ID_Trabajador = t.ID_Trabajador " +
                 "INNER JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                 "WHERE a.Fecha >= CURDATE() - INTERVAL 6 DAY AND u.ID_Rol IN (1, 2) " +
                 "GROUP BY a.Fecha " +
                 "ORDER BY a.Fecha";

    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            java.sql.Date fecha = rs.getDate("Fecha");
            String dia = sdf.format(fecha);
            dia = dia.substring(0, 1).toUpperCase() + dia.substring(1);

            if (datos.containsKey(dia)) {
                datos.put(dia, rs.getInt("total"));
            }
        }

    } catch (SQLException e) {
        System.out.println("❌ Error en obtenerAsistenciasUltimos7Dias:");
        e.printStackTrace();
    }

    return datos;
}

    public Map<String, Integer> obtenerResumenHoy() {
        Map<String, Integer> resumen = new LinkedHashMap<>();
        resumen.put("Tardanza", contarTardanzasHoy());
        resumen.put("Falta", contarFaltasHoy());
        resumen.put("Salida_Anticipada", contarSalidasAnticipadasHoy());
        return resumen;
    }

    // Utilitario
    private int contar(String sql) {
        int total = 0;
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                total = rs.getInt(1);
            }

        } catch (SQLException e) {
            System.out.println("❌ Error en contar:");
            e.printStackTrace();
        }
        return total;
    }
}
