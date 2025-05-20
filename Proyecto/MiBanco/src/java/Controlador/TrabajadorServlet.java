package Controlador;

import DAO.TrabajadorDAO;
import modelo.Trabajador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/trabajadores")
public class TrabajadorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener parámetros de búsqueda con valores por defecto si son nulos
        String dni = request.getParameter("dni") != null ? request.getParameter("dni").trim() : "";
        String area = request.getParameter("area") != null ? request.getParameter("area").trim() : "";
        String turno = request.getParameter("turno") != null ? request.getParameter("turno").trim() : "";

        // Obtener lista filtrada de trabajadores
        TrabajadorDAO dao = new TrabajadorDAO();
        List<Trabajador> lista = dao.listarTrabajadores(dni, area, turno);

        // Pasar mensajes opcionales desde otras acciones (registro, error, etc.)
        String mensaje = request.getParameter("mensaje");
        String error = request.getParameter("error");

        if (mensaje != null) {
            request.setAttribute("mensaje", mensaje);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }

        // Pasar filtros seleccionados nuevamente al JSP para mantener el estado
        request.setAttribute("dni", dni);
        request.setAttribute("area", area);
        request.setAttribute("turno", turno);

        // Pasar la lista de trabajadores al JSP
        request.setAttribute("listaTrabajadores", lista);

        // Redirigir al JSP (ajusta la ruta si usas otra estructura de carpetas)
        request.getRequestDispatcher("vista/trabajadores.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirigir POST hacia GET por si se usan formularios sin método explícito
        doGet(request, response);
    }
}






