package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import modelo.Usuario;
import util.Conexion;

public class UsuarioDAO {

    /**
     * Valida las credenciales del usuario a partir de su DNI y contraseña.
     * @param dni DNI ingresado
     * @param contrasena Contraseña ingresada
     * @return Objeto Usuario si las credenciales son correctas, null en caso contrario
     */
    public Usuario validarUsuario(String dni, String contrasena) {
        Usuario usuario = null;
        String sql = "SELECT * FROM usuario WHERE DNI = ? AND Contraseña = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, dni);
            ps.setString(2, contrasena);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("ID_Usuario"));
                usuario.setNombreCompleto(rs.getString("Nombre_Completo"));
                usuario.setDni(rs.getString("DNI"));
                usuario.setCorreo(rs.getString("Correo"));
                usuario.setTelefono(rs.getString("Telefono"));
                usuario.setIdRol(rs.getInt("ID_Rol"));
            }

        } catch (SQLException e) {
            System.err.println("Error al validar usuario: " + e.getMessage());
        }

        return usuario;
    }
}
