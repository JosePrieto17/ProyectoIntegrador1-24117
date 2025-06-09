package Controlador;

import DAO.AsistenciaDAO;
import modelo.AsistenciaVisual;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AsistenciasServlet")
public class AsistenciasServlet extends HttpServlet {

    private static final int REGISTROS_POR_PAGINA = 15;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fecha = request.getParameter("fecha");
        String dni = request.getParameter("dni");
        String estado = request.getParameter("estado");

        // Normalizar valores "null" enviados como string
        if ("null".equals(fecha)) fecha = null;
        if ("null".equals(dni)) dni = null;
        if ("null".equals(estado)) estado = null;

        // Página actual
        int pagina = 1;
        if (request.getParameter("pagina") != null) {
            try {
                pagina = Integer.parseInt(request.getParameter("pagina"));
                if (pagina < 1) pagina = 1;
            } catch (NumberFormatException e) {
                pagina = 1;
            }
        }

        AsistenciaDAO dao = new AsistenciaDAO();

        // Total de registros con filtros
        int totalRegistros = dao.contarAsistencias(fecha, dni, estado);
        int totalPaginas = (int) Math.ceil((double) totalRegistros / REGISTROS_POR_PAGINA);

        // Ajuste de página si se pasa del total
        if (pagina > totalPaginas && totalPaginas > 0) {
            pagina = totalPaginas;
        }

        int offset = (pagina - 1) * REGISTROS_POR_PAGINA;

        // Lista paginada
        List<AsistenciaVisual> asistencias = dao.listarAsistenciasPaginado(fecha, dni, estado, REGISTROS_POR_PAGINA, offset);

        // Enviar datos a la vista
        request.setAttribute("asistencias", asistencias);
        request.setAttribute("paginaActual", pagina);
        request.setAttribute("totalPaginas", totalPaginas);
        request.setAttribute("fecha", fecha);
        request.setAttribute("dni", dni);
        request.setAttribute("estado", estado);

        request.getRequestDispatcher("/vista/asistencias.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
