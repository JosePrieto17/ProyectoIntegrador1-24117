package DAO;

import modelo.Trabajador;
import util.Conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TrabajadorDAO {

    public List<Trabajador> listarTrabajadores(String dni, String area, String turno) {
        List<Trabajador> lista = new ArrayList<>();
        String sql = "SELECT t.ID_Trabajador, u.Nombre_Completo, u.DNI, u.Correo, u.Telefono, " +
                     "t.Area, t.Cargo, t.TipoTurno, t.Horario, t.Observaciones " +
                     "FROM trabajador t " +
                     "INNER JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                     "WHERE u.DNI LIKE ? AND t.Area LIKE ? AND t.TipoTurno LIKE ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + dni + "%");
            ps.setString(2, "%" + area + "%");
            ps.setString(3, "%" + turno + "%");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Trabajador t = new Trabajador();
                t.setId(rs.getInt("ID_Trabajador"));
                t.setNombreCompleto(rs.getString("Nombre_Completo"));
                t.setDni(rs.getString("DNI"));
                t.setCorreo(rs.getString("Correo"));
                t.setTelefono(rs.getString("Telefono"));
                t.setArea(rs.getString("Area"));
                t.setCargo(rs.getString("Cargo"));
                t.setTipoTurno(rs.getString("TipoTurno"));
                t.setHorario(rs.getString("Horario"));
                t.setObservaciones(rs.getString("Observaciones"));
                lista.add(t);
            }

        } catch (SQLException e) {
            System.out.println("❌ Error en listarTrabajadores:");
            e.printStackTrace();
        }

        return lista;
    }

    public boolean insertarTrabajador(Trabajador t) {
        String sqlUsuario = "INSERT INTO usuario (Nombre_Completo, DNI, Correo, Telefono, ID_Rol, Estado, Contraseña) " +
                            "VALUES (?, ?, ?, ?, 2, 'Activo', '123456')";
        String sqlTrabajador = "INSERT INTO trabajador (ID_Usuario, Area, Cargo, TipoTurno, Horario, Observaciones) " +
                               "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = Conexion.getConnection();
             PreparedStatement psUsuario = con.prepareStatement(sqlUsuario, Statement.RETURN_GENERATED_KEYS)) {

            psUsuario.setString(1, t.getNombreCompleto());
            psUsuario.setString(2, t.getDni());
            psUsuario.setString(3, t.getCorreo());
            psUsuario.setString(4, t.getTelefono());

            int filasUsuario = psUsuario.executeUpdate();
            if (filasUsuario > 0) {
                ResultSet rs = psUsuario.getGeneratedKeys();
                if (rs.next()) {
                    int idUsuario = rs.getInt(1);
                    try (PreparedStatement psTrabajador = con.prepareStatement(sqlTrabajador)) {
                        psTrabajador.setInt(1, idUsuario);
                        psTrabajador.setString(2, t.getArea());
                        psTrabajador.setString(3, t.getCargo());
                        psTrabajador.setString(4, t.getTipoTurno());
                        psTrabajador.setString(5, t.getHorario());
                        psTrabajador.setString(6, t.getObservaciones());
                        int filasTrabajador = psTrabajador.executeUpdate();
                        return filasTrabajador > 0;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Error en insertarTrabajador:");
            e.printStackTrace();
        }

        return false;
    }

    public boolean actualizarTrabajador(Trabajador t) {
        String sqlUsuario = "UPDATE usuario SET Nombre_Completo = ?, DNI = ?, Correo = ?, Telefono = ? " +
                            "WHERE ID_Usuario = (SELECT ID_Usuario FROM trabajador WHERE ID_Trabajador = ?)";
        String sqlTrabajador = "UPDATE trabajador SET Area = ?, Cargo = ?, TipoTurno = ?, Horario = ?, Observaciones = ? " +
                               "WHERE ID_Trabajador = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement psUsuario = con.prepareStatement(sqlUsuario);
             PreparedStatement psTrabajador = con.prepareStatement(sqlTrabajador)) {

            psUsuario.setString(1, t.getNombreCompleto());
            psUsuario.setString(2, t.getDni());
            psUsuario.setString(3, t.getCorreo());
            psUsuario.setString(4, t.getTelefono());
            psUsuario.setInt(5, t.getId());
            psUsuario.executeUpdate();

            psTrabajador.setString(1, t.getArea());
            psTrabajador.setString(2, t.getCargo());
            psTrabajador.setString(3, t.getTipoTurno());
            psTrabajador.setString(4, t.getHorario());
            psTrabajador.setString(5, t.getObservaciones());
            psTrabajador.setInt(6, t.getId());

            int filas = psTrabajador.executeUpdate();
            return filas > 0;

        } catch (SQLException e) {
            System.out.println("❌ Error en actualizarTrabajador:");
            e.printStackTrace();
        }

        return false;
    }

    public boolean existeDni(String dni) {
        String sql = "SELECT ID_Usuario FROM usuario WHERE DNI = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dni);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("❌ Error en existeDni:");
            e.printStackTrace();
        }
        return false;
    }

    public Trabajador obtenerTrabajadorPorId(int id) {
        String sql = "SELECT t.ID_Trabajador, u.Nombre_Completo, u.DNI, u.Correo, u.Telefono, " +
                     "t.Area, t.Cargo, t.TipoTurno, t.Horario, t.Observaciones " +
                     "FROM trabajador t " +
                     "INNER JOIN usuario u ON t.ID_Usuario = u.ID_Usuario " +
                     "WHERE t.ID_Trabajador = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Trabajador t = new Trabajador();
                t.setId(rs.getInt("ID_Trabajador"));
                t.setNombreCompleto(rs.getString("Nombre_Completo"));
                t.setDni(rs.getString("DNI"));
                t.setCorreo(rs.getString("Correo"));
                t.setTelefono(rs.getString("Telefono"));
                t.setArea(rs.getString("Area"));
                t.setCargo(rs.getString("Cargo"));
                t.setTipoTurno(rs.getString("TipoTurno"));
                t.setHorario(rs.getString("Horario"));
                t.setObservaciones(rs.getString("Observaciones"));
                return t;
            }

        } catch (SQLException e) {
            System.out.println("❌ Error en obtenerTrabajadorPorId:");
            e.printStackTrace();
        }

        return null;
    }
}
