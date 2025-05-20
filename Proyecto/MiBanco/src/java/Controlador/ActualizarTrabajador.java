/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import DAO.TrabajadorDAO;
import modelo.Trabajador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ActualizarTrabajador")
public class ActualizarTrabajador extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
            String dni = request.getParameter("dni");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            String area = request.getParameter("area");
            String cargo = request.getParameter("cargo");
            String turno = request.getParameter("turno");
            String horario = request.getParameter("horario");
            String observaciones = request.getParameter("observaciones");

            Trabajador trabajador = new Trabajador();
            trabajador.setId(id);
            trabajador.setNombreCompleto(nombre);
            trabajador.setDni(dni);
            trabajador.setCorreo(correo);
            trabajador.setTelefono(telefono);
            trabajador.setArea(area);
            trabajador.setCargo(cargo);
            trabajador.setTipoTurno(turno);
            trabajador.setHorario(horario);
            trabajador.setObservaciones(observaciones);

            TrabajadorDAO dao = new TrabajadorDAO();
            boolean actualizado = dao.actualizarTrabajador(trabajador);

            if (actualizado) {
                response.sendRedirect("trabajadores?mensaje=actualizado");
            } else {
                response.sendRedirect("trabajadores?error=actualizar");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("trabajadores?error=excepcion");
        }
    }
}















