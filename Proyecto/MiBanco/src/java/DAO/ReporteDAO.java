package DAO;

import java.sql.*;
import java.util.*;
import util.Conexion;
import modelo.ReporteGeneral;

public class ReporteDAO {
    public List<ReporteGeneral> obtenerReporteGeneral(String areaFiltro) {
        List<ReporteGeneral> lista = new ArrayList<>();
        String sql = 
            "SELECT t.area, " +
            "       COUNT(DISTINCT t.id_trabajador) AS total_trabajadores, " +
            "       SUM(CASE WHEN a.estado = 'Puntual' THEN 1 ELSE 0 END) AS asistencias, " +
            "       SUM(CASE WHEN a.estado = 'Tardanza' THEN 1 ELSE 0 END) AS tardanzas, " +
            "       SUM(CASE WHEN a.estado = 'Falta' THEN 1 ELSE 0 END) AS faltas, " +
            "       SUM(CASE WHEN a.estado = 'Salida_Anticipada' THEN 1 ELSE 0 END) AS salidas_anticipadas " +
            "FROM trabajador t " +
            "LEFT JOIN asistencia a ON t.id_trabajador = a.id_trabajador ";

        if (areaFiltro != null && !areaFiltro.trim().isEmpty()) {
            sql += "WHERE t.area LIKE ? ";
        }

        sql += "GROUP BY t.area ORDER BY t.area";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (areaFiltro != null && !areaFiltro.trim().isEmpty()) {
                stmt.setString(1, "%" + areaFiltro + "%");
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ReporteGeneral rg = new ReporteGeneral();
                rg.setArea(rs.getString("area"));
                rg.setTotalTrabajadores(rs.getInt("total_trabajadores"));
                rg.setAsistencias(rs.getInt("asistencias"));
                rg.setTardanzas(rs.getInt("tardanzas"));
                rg.setFaltas(rs.getInt("faltas"));
                rg.setSalidasAnticipadas(rs.getInt("salidas_anticipadas"));
                lista.add(rg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }
}

