package Controlador;

import DAO.TrabajadorDAO;
import modelo.Trabajador;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ExportarTrabajadoresServlet")
public class ExportarTrabajadoresServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tipo = request.getParameter("tipo");
        TrabajadorDAO dao = new TrabajadorDAO();
        String dni = request.getParameter("dni") != null ? request.getParameter("dni") : "";
        String area = request.getParameter("area") != null ? request.getParameter("area") : "";
        String turno = request.getParameter("turno") != null ? request.getParameter("turno") : "";
    List<Trabajador> lista = dao.listarTrabajadores(dni, area, turno);

        try {
            if ("excel".equalsIgnoreCase(tipo)) {
                exportarExcel(lista, response);
            } else if ("pdf".equalsIgnoreCase(tipo)) {
                exportarPDF(lista, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void exportarExcel(List<Trabajador> lista, HttpServletResponse response) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Trabajadores");
        Row header = sheet.createRow(0);
        String[] titulos = {"ID", "Nombre", "DNI", "Correo", "Teléfono", "Área", "Cargo", "Turno", "Horario", "Observaciones"};
        for (int i = 0; i < titulos.length; i++) {
            header.createCell(i).setCellValue(titulos[i]);
        }
        int fila = 1;
        for (Trabajador t : lista) {
            Row row = sheet.createRow(fila++);
            row.createCell(0).setCellValue(t.getId());
            row.createCell(1).setCellValue(t.getNombreCompleto());
            row.createCell(2).setCellValue(t.getDni());
            row.createCell(3).setCellValue(t.getCorreo());
            row.createCell(4).setCellValue(t.getTelefono());
            row.createCell(5).setCellValue(t.getArea());
            row.createCell(6).setCellValue(t.getCargo());
            row.createCell(7).setCellValue(t.getTipoTurno());
            row.createCell(8).setCellValue(t.getHorario());
            row.createCell(9).setCellValue(t.getObservaciones());
        }
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=trabajadores.xlsx");
        workbook.write(response.getOutputStream());
        workbook.close();
    }

    private void exportarPDF(List<Trabajador> lista, HttpServletResponse response) throws Exception {
        Document document = new Document();
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=trabajadores.pdf");
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();
        PdfPTable table = new PdfPTable(10);
        table.setWidthPercentage(100);
        String[] titulos = {"ID", "Nombre", "DNI", "Correo", "Teléfono", "Área", "Cargo", "Turno", "Horario", "Observaciones"};
        for (String t : titulos) {
            PdfPCell celda = new PdfPCell(new Phrase(t));
            table.addCell(celda);
        }
        for (Trabajador t : lista) {
            table.addCell(String.valueOf(t.getId()));
            table.addCell(t.getNombreCompleto());
            table.addCell(t.getDni());
            table.addCell(t.getCorreo());
            table.addCell(t.getTelefono());
            table.addCell(t.getArea());
            table.addCell(t.getCargo());
            table.addCell(t.getTipoTurno());
            table.addCell(t.getHorario());
            table.addCell(t.getObservaciones());
        }
        document.add(table);
        document.close();
    }
}
