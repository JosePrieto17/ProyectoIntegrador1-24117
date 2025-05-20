package Controlador;

import DAO.TrabajadorDAO;
import modelo.Trabajador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegistrarTrabajador")
public class RegistrarTrabajador extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Establecer codificación por si vienen caracteres especiales
        request.setCharacterEncoding("UTF-8");

        // 1. Recoger datos del formulario
        String nombre = request.getParameter("nombre");
        String dni = request.getParameter("dni");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String area = request.getParameter("area");
        String cargo = request.getParameter("cargo");
        String turno = request.getParameter("turno");
        String horario = request.getParameter("horario");
        String observaciones = request.getParameter("observaciones");

        // 2. Validar datos nulos básicos antes de continuar
        if (nombre == null || dni == null || correo == null || area == null || cargo == null || turno == null || horario == null) {
            response.sendRedirect("trabajadores?error=datosInvalidos");
            return;
        }

        // 3. Crear objeto Trabajador
        Trabajador trabajador = new Trabajador();
        trabajador.setNombreCompleto(nombre.trim());
        trabajador.setDni(dni.trim());
        trabajador.setCorreo(correo.trim());
        trabajador.setTelefono(telefono != null ? telefono.trim() : "");
        trabajador.setArea(area.trim());
        trabajador.setCargo(cargo.trim());
        trabajador.setTipoTurno(turno.trim());
        trabajador.setHorario(horario.trim());
        trabajador.setObservaciones(observaciones != null ? observaciones.trim() : "");

        // 4. Insertar en la base de datos
        TrabajadorDAO dao = new TrabajadorDAO();

        // Validar si el DNI ya existe
        if (dao.existeDni(dni.trim())) {
            response.sendRedirect("trabajadores?error=dni");
            return;
        }

        // Insertar trabajador
        boolean registrado = dao.insertarTrabajador(trabajador);

        if (registrado) {
            response.sendRedirect("trabajadores?mensaje=registrado");
        } else {
            // Podrías registrar logs aquí para depurar
            response.sendRedirect("trabajadores?error=insert");
        }
    }
}







