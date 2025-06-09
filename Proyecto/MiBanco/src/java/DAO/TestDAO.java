package DAO;

import modelo.Trabajador;

public class TestDAO {
    public static void main(String[] args) {
        String dni = "73739553"; // Cambia por el DNI que deseas probar

        TrabajadorDAO dao = new TrabajadorDAO();
        Trabajador trabajador = dao.obtenerPorDNI(dni);

        if (trabajador != null) {
            System.out.println("✅ Trabajador encontrado:");
            System.out.println("ID_Trabajador: " + trabajador.getId());
            System.out.println("Nombre: " + trabajador.getNombreCompleto());
            System.out.println("Correo: " + trabajador.getCorreo());
            System.out.println("Área: " + trabajador.getArea());
            System.out.println("Tipo Turno: " + trabajador.getTipoTurno());
            System.out.println("Horario: " + trabajador.getHorario());
            System.out.println("Observaciones: " + trabajador.getObservaciones());
        } else {
            System.out.println("❌ No se encontró un trabajador con el DNI: " + dni);
        }
    }
}
