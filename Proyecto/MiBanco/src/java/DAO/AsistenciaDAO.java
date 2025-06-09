package DAO;

import modelo.AsistenciaVisual;
import util.Conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AsistenciaDAO {

public boolean registrarAsistencia(int idTrabajador, String fecha, String hora, String tipo, String estado, String observacion) {
    try (Connection con = Conexion.getConnection()) {
        if ("Entrada".equalsIgnoreCase(tipo)) {
            String checkSql = "SELECT COUNT(*) FROM asistencia WHERE ID_Trabajador = ? AND Fecha = ?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setInt(1, idTrabajador);
            checkPs.setString(2, fecha);
            ResultSet checkRs = checkPs.executeQuery();
            checkRs.next();
            if (checkRs.getInt(1) > 0) return false;

            String insertSql = "INSERT INTO asistencia (ID_Trabajador, Fecha, HoraEntrada, Estado, Observaciones) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(insertSql);
            ps.setInt(1, idTrabajador);
            ps.setString(2, fecha);
            ps.setString(3, hora);
            ps.setString(4, estado);
            ps.setString(5, observacion);
            return ps.executeUpdate() > 0;

        } else if ("Salida".equalsIgnoreCase(tipo)) {
            String updateSql = "UPDATE asistencia SET HoraSalida = ?, Estado = ?, Observaciones = ? WHERE ID_Trabajador = ? AND Fecha = ?";
            PreparedStatement ps = con.prepareStatement(updateSql);
            ps.setString(1, hora);
            ps.setString(2, estado);
            ps.setString(3, observacion);
            ps.setInt(4, idTrabajador);
            ps.setString(5, fecha);
            return ps.executeUpdate() > 0;

        } else if ("Falta".equalsIgnoreCase(tipo)) {
            String checkSql = "SELECT COUNT(*) FROM asistencia WHERE ID_Trabajador = ? AND Fecha = ?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setInt(1, idTrabajador);
            checkPs.setString(2, fecha);
            ResultSet checkRs = checkPs.executeQuery();
            checkRs.next();
            if (checkRs.getInt(1) > 0) return false;

            String insertSql = "INSERT INTO asistencia (ID_Trabajador, Fecha, Estado, Observaciones) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(insertSql);
            ps.setInt(1, idTrabajador);
            ps.setString(2, fecha);
            ps.setString(3, estado);
            ps.setString(4, observacion);
            return ps.executeUpdate() > 0;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}


    public void marcarFaltasAutomaticamente(String fechaActual) {
        try (Connection con = Conexion.getConnection()) {
            String sql = "INSERT INTO asistencia (ID_Trabajador, Fecha, Estado, Observaciones) SELECT t.ID_Trabajador, ?, 'Falta', 'No justificada' FROM trabajador t WHERE NOT EXISTS (SELECT 1 FROM asistencia a WHERE a.ID_Trabajador = t.ID_Trabajador AND a.Fecha = ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, fechaActual);
            ps.setString(2, fechaActual);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean existeEntradaHoy(int idTrabajador, String fecha) {
        try (Connection con = Conexion.getConnection()) {
            String sql = "SELECT COUNT(*) FROM asistencia WHERE ID_Trabajador = ? AND Fecha = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idTrabajador);
            ps.setString(2, fecha);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<AsistenciaVisual> listarAsistencias(String fecha, String dni, String estado) {
        return listarAsistenciasPaginado(fecha, dni, estado, -1, -1);
    }

    public List<AsistenciaVisual> listarAsistenciasPaginado(String fecha, String dni, String estado, int limite, int offset) {
        List<AsistenciaVisual> lista = new ArrayList<>();

        String sql = "SELECT a.ID_Asistencia, a.Fecha, u.Nombre_Completo, u.DNI, t.Horario, " +
                     "a.HoraEntrada, a.HoraSalida, a.Estado, a.Observaciones " +
                     "FROM asistencia a " +
                     "JOIN trabajador t ON a.ID_Trabajador = t.ID_Trabajador " +
                     "JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                     "WHERE 1=1";

        if (fecha != null && !fecha.isEmpty()) sql += " AND a.Fecha = ?";
        if (dni != null && !dni.isEmpty()) sql += " AND u.DNI = ?";
        if (estado != null && !estado.isEmpty()) sql += " AND a.Estado = ?";

        sql += " ORDER BY a.Fecha DESC, a.ID_Asistencia DESC";
        if (limite > 0 && offset >= 0) sql += " LIMIT ? OFFSET ?";

        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            int index = 1;
            if (fecha != null && !fecha.isEmpty()) ps.setString(index++, fecha);
            if (dni != null && !dni.isEmpty()) ps.setString(index++, dni);
            if (estado != null && !estado.isEmpty()) ps.setString(index++, estado);
            if (limite > 0 && offset >= 0) {
                ps.setInt(index++, limite);
                ps.setInt(index++, offset);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AsistenciaVisual a = new AsistenciaVisual();
                a.setIdAsistencia(rs.getInt("ID_Asistencia"));
                a.setFecha(rs.getString("Fecha"));
                a.setNombreCompleto(rs.getString("Nombre_Completo"));
                a.setDni(rs.getString("DNI"));
                a.setHorario(rs.getString("Horario"));
                a.setHoraEntrada(rs.getString("HoraEntrada"));
                a.setHoraSalida(rs.getString("HoraSalida"));
                a.setEstado(rs.getString("Estado"));
                a.setObservaciones(rs.getString("Observaciones"));
                lista.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    public int contarAsistencias(String fecha, String dni, String estado) {
        int total = 0;

        String sql = "SELECT COUNT(*) FROM asistencia a " +
                     "JOIN trabajador t ON a.ID_Trabajador = t.ID_Trabajador " +
                     "JOIN usuario u ON t.ID_Usuario = u.ID_Usuario WHERE 1=1";

        if (fecha != null && !fecha.isEmpty()) sql += " AND a.Fecha = ?";
        if (dni != null && !dni.isEmpty()) sql += " AND u.DNI = ?";
        if (estado != null && !estado.isEmpty()) sql += " AND a.Estado = ?";

        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            int index = 1;
            if (fecha != null && !fecha.isEmpty()) ps.setString(index++, fecha);
            if (dni != null && !dni.isEmpty()) ps.setString(index++, dni);
            if (estado != null && !estado.isEmpty()) ps.setString(index++, estado);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) total = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }
}
