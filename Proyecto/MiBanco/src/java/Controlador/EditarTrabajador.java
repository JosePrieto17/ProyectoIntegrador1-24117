package Controlador;

import DAO.TrabajadorDAO;
import modelo.Trabajador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "EditarTrabajador", urlPatterns = {"/EditarTrabajador"})
public class EditarTrabajador extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);

                TrabajadorDAO dao = new TrabajadorDAO();
                Trabajador trabajador = dao.obtenerTrabajadorPorId(id);

                if (trabajador != null) {
                    request.setAttribute("trabajadorEditar", trabajador);
                    request.setAttribute("mostrarModalEditar", true);
                }

            } catch (NumberFormatException e) {
                System.out.println("❌ ID inválido en EditarTrabajador");
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("/vista/trabajadores.jsp").forward(request, response);
    }
}










