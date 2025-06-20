package DAO;

import java.sql.*;
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
                     "WHERE a.Fecha = CURDATE() AND a.Estado LIKE '%Tardanza%' AND u.ID_Rol IN (1, 2)";
        return contar(sql);
    }

    public int contarSalidasAnticipadasHoy() {
        String sql = "SELECT COUNT(*) " +
                     "FROM asistencia a " +
                     "INNER JOIN trabajador t ON a.ID_Trabajador = t.ID_Trabajador " +
                     "INNER JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                     "WHERE a.Fecha = CURDATE() AND a.Estado LIKE '%Salida Anticipada%' AND u.ID_Rol IN (1, 2)";
        return contar(sql);
    }

    public int contarFaltasHoy() {
        String sql = "SELECT COUNT(*) " +
                     "FROM asistencia a " +
                     "INNER JOIN trabajador t ON a.ID_Trabajador = t.ID_Trabajador " +
                     "INNER JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                     "WHERE a.Fecha = CURDATE() AND a.Estado LIKE '%Falta%' AND u.ID_Rol IN (1, 2)";
        return contar(sql);
    }

public Map<String, Integer> obtenerAsistenciasUltimos7Dias() {
    Map<String, Integer> datos = new LinkedHashMap<>();
    SimpleDateFormat sdf = new SimpleDateFormat("EEEE", new Locale("es", "ES"));

    try {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.add(java.util.Calendar.DAY_OF_MONTH, -6); // Últimos 7 días

        for (int i = 0; i < 7; i++) {
            String dia = sdf.format(cal.getTime());
            dia = dia.substring(0, 1).toUpperCase() + dia.substring(1);
            datos.put(dia, 0);
            cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
        }
    } catch (Exception e) {
        System.out.println("❌ Error inicializando días:");
        e.printStackTrace();
    }

    String sql = "SELECT a.Fecha, COUNT(DISTINCT a.ID_Trabajador) AS total " +
                 "FROM asistencia a " +
                 "INNER JOIN trabajador t ON a.ID_Trabajador = t.ID_Trabajador " +
                 "INNER JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                 "WHERE a.Fecha >= CURDATE() - INTERVAL 6 DAY " +
                 "AND u.ID_Rol IN (1, 2) " +
                 "AND (a.Estado LIKE '%Puntual%' OR a.Estado LIKE '%Tardanza%') " +
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

    String sql = "SELECT a.Estado " +
                 "FROM asistencia a " +
                 "INNER JOIN trabajador t ON a.ID_Trabajador = t.ID_Trabajador " +
                 "INNER JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                 "WHERE a.Fecha = CURDATE() AND u.ID_Rol IN (1, 2)";

    int tardanza = 0, falta = 0, salidaAnticipada = 0;

    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            String estado = rs.getString("Estado");
            if (estado != null) {
                if (estado.contains("Tardanza")) tardanza++;
                if (estado.contains("Falta")) falta++;
                if (estado.contains("Salida Anticipada")) salidaAnticipada++;
            }
        }

    } catch (SQLException e) {
        System.out.println("❌ Error en obtenerResumenHoy:");
        e.printStackTrace();
    }

    resumen.put("Tardanza", tardanza);
    resumen.put("Falta", falta);
    resumen.put("Salida Anticipada", salidaAnticipada);
    return resumen;
}

    // Utilitario generalizado
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
