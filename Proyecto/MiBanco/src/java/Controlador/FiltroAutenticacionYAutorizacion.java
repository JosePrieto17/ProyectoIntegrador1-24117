package Controlador;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import modelo.Usuario;

@WebFilter(filterName = "FiltroAutenticacionYAutorizacion", urlPatterns = {"/vista/*"})
public class FiltroAutenticacionYAutorizacion implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        String uri = req.getRequestURI();

        // Especificamos las rutas públicas que no deben ser filtradas
        boolean recursoPublico = uri.contains("login.jsp") || uri.contains("acceso_denegado.jsp") || uri.contains("mibanco_logo")
                               || uri.contains("LoginServlet");

        if (recursoPublico) {
            chain.doFilter(request, response); // permite acceso
            return;
        }

        // Verifica sesión activa
        if (session == null || session.getAttribute("usuario") == null) {
            res.sendRedirect(req.getContextPath() + "/vista/login.jsp");
            return;
        }

        // Usuario autenticado
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        int rol = usuario.getIdRol();

        // Valida los roles según las vistas protegidas
        if ((uri.contains("dashboard_admin") || uri.contains("trabajadores") || uri.contains("reportes")
             || uri.contains("asistencias") || uri.contains("justificaciones")) && rol != 1) {
            res.sendRedirect(req.getContextPath() + "/vista/acceso_denegado.jsp");
            return;
        }

        if ((uri.contains("dashboard_trabajador") || uri.contains("reporte_personal")
             || uri.contains("mis_justificaciones") || uri.contains("solicitar_justificacion")) && rol != 2) {
            res.sendRedirect(req.getContextPath() + "/vista/acceso_denegado.jsp");
            return;
        }

        if (uri.contains("registro_asistencia.jsp") && rol != 3) {
            res.sendRedirect(req.getContextPath() + "/vista/acceso_denegado.jsp");
            return;
        }

        // Todo válido
        chain.doFilter(request, response);
    }
}
