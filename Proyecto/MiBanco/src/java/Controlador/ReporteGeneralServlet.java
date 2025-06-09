package Controlador;

import DAO.ReporteDAO;
import modelo.ReporteGeneral;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ReporteGeneralServlet")
public class ReporteGeneralServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tipoReporte = request.getParameter("tipoReporte");
        if (tipoReporte == null || tipoReporte.trim().isEmpty()) {
            tipoReporte = "general";
        }

        String area = request.getParameter("area");

        ReporteDAO dao = new ReporteDAO();
        List<ReporteGeneral> lista = dao.obtenerReporteGeneral(area);

        request.setAttribute("reporteGeneral", lista);
        request.setAttribute("tipoReporte", tipoReporte);
        request.setAttribute("area", area);

        request.getRequestDispatcher("/vista/reportes.jsp").forward(request, response);
    }
}

