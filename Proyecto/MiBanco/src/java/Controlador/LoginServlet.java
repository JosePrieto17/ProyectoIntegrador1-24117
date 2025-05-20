package Controlador;

import DAO.UsuarioDAO;
import modelo.Usuario;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Recibir datos del formulario
        String dni = request.getParameter("dni");
        String password = request.getParameter("clave");

        // 2. Validar usuario con DAO
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuario = usuarioDAO.validarUsuario(dni, password);

        if (usuario != null) {
            // 3. Crear sesión y redirigir por rol
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            int rol = usuario.getIdRol();

            switch (rol) {
                case 1:
                    response.sendRedirect("vista/dashboard_admin.jsp");
                    break;
                case 2:
                    response.sendRedirect("vista/dashboard_trabajador.jsp");
                    break;
                case 3:
                    response.sendRedirect("vista/registro_asistencia.jsp");
                    break;
                default:
                    request.setAttribute("mensaje", "Rol no reconocido.");
                    request.getRequestDispatcher("/vista/login.jsp").forward(request, response);
                    break;
            }

        } else {
            // 4. Si no es válido
            request.setAttribute("mensaje", "DNI o Contraseña incorrectos.");
            request.getRequestDispatcher("/vista/login.jsp").forward(request, response);
        }
    }
}
