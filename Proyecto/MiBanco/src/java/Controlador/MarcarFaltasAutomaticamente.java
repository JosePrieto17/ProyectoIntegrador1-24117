package Controlador;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import DAO.AsistenciaDAO;

@WebServlet("/MarcarFaltasAutomaticamente")
public class MarcarFaltasAutomaticamente extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener la fecha actual en formato yyyy-MM-dd
        String fechaActual = new SimpleDateFormat("yyyy-MM-dd").format(new Date());

        // Invocar lógica de negocio en el DAO
        try {
            AsistenciaDAO asistenciaDAO = new AsistenciaDAO();
            asistenciaDAO.marcarFaltasAutomaticamente(fechaActual);

            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().println("✅ Faltas marcadas correctamente para trabajadores que no asistieron el " + fechaActual);

        } catch (Exception e) {
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().println("❌ Error al marcar faltas: " + e.getMessage());
            e.printStackTrace();
        }
    }
}