package Controlador;

import DAO.DashboardDAO;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet(name = "DashboardDataServlet", urlPatterns = {"/DashboardDataServlet"})
public class DashboardDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");

        String tipo = request.getParameter("tipo"); // "asistencias" o "resumen"
        Gson gson = new Gson();
        String json;

        DashboardDAO dao = new DashboardDAO();

        try (PrintWriter out = response.getWriter()) {
            if (tipo == null) {
                json = gson.toJson("Parámetro 'tipo' no proporcionado");
                out.print(json);
                return;
            }

            switch (tipo.toLowerCase()) {
                case "asistencias":
                    Map<String, Integer> asistencias = dao.obtenerAsistenciasUltimos7Dias();
                    json = gson.toJson(asistencias);
                    break;

                case "resumen":
                    Map<String, Integer> resumen = dao.obtenerResumenHoy();
                    json = gson.toJson(resumen);
                    break;

                default:
                    json = gson.toJson("Tipo de dato no válido: " + tipo);
                    break;
            }

            out.print(json);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                json = gson.toJson("Error al procesar los datos del dashboard");
                out.print(json);
            }
        }
    }
}