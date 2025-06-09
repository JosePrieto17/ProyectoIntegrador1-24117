package Controlador;

import DAO.AsistenciaDAO;
import modelo.AsistenciaVisual;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ExportarAsistenciasServlet")
public class ExportarAsistenciasServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String formato = request.getParameter("formato");
        String fecha = request.getParameter("fecha") != null ? request.getParameter("fecha") : "";
        String dni = request.getParameter("dni") != null ? request.getParameter("dni") : "";
        String estado = request.getParameter("estado") != null ? request.getParameter("estado") : "";

        AsistenciaDAO dao = new AsistenciaDAO();
        List<AsistenciaVisual> lista = dao.listarAsistencias(fecha, dni, estado);

        try {
            if ("excel".equalsIgnoreCase(formato)) {
                exportarExcel(lista, response);
            } else if ("pdf".equalsIgnoreCase(formato)) {
                exportarPDF(lista, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void exportarExcel(List<AsistenciaVisual> lista, HttpServletResponse response) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Asistencias");

        Row header = sheet.createRow(0);
        String[] titulos = {"ID", "Fecha", "Nombre", "DNI", "Horario", "Hora Entrada", "Hora Salida", "Estado", "Observaciones"};
        for (int i = 0; i < titulos.length; i++) {
            header.createCell(i).setCellValue(titulos[i]);
        }

        int fila = 1;
        for (AsistenciaVisual a : lista) {
            Row row = sheet.createRow(fila++);
            row.createCell(0).setCellValue(a.getIdAsistencia());
            row.createCell(1).setCellValue(a.getFecha());
            row.createCell(2).setCellValue(a.getNombreCompleto());
            row.createCell(3).setCellValue(a.getDni());
            row.createCell(4).setCellValue(a.getHorario());
            row.createCell(5).setCellValue(a.getHoraEntrada() != null ? a.getHoraEntrada() : "-");
            row.createCell(6).setCellValue(a.getHoraSalida() != null ? a.getHoraSalida() : "-");
            row.createCell(7).setCellValue(a.getEstado());
            row.createCell(8).setCellValue(a.getObservaciones() != null ? a.getObservaciones() : "-");
        }

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=asistencias.xlsx");
        workbook.write(response.getOutputStream());
        workbook.close();
    }

    private void exportarPDF(List<AsistenciaVisual> lista, HttpServletResponse response) throws Exception {
        Document document = new Document();
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=asistencias.pdf");

        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        PdfPTable table = new PdfPTable(9);
        table.setWidthPercentage(100);
        String[] titulos = {"ID", "Fecha", "Nombre", "DNI", "Horario", "Hora Entrada", "Hora Salida", "Estado", "Observaciones"};
        for (String t : titulos) {
            PdfPCell celda = new PdfPCell(new Phrase(t));
            table.addCell(celda);
        }

        for (AsistenciaVisual a : lista) {
            table.addCell(String.valueOf(a.getIdAsistencia()));
            table.addCell(a.getFecha());
            table.addCell(a.getNombreCompleto());
            table.addCell(a.getDni());
            table.addCell(a.getHorario());
            table.addCell(a.getHoraEntrada() != null ? a.getHoraEntrada() : "-");
            table.addCell(a.getHoraSalida() != null ? a.getHoraSalida() : "-");
            table.addCell(a.getEstado());
            table.addCell(a.getObservaciones() != null ? a.getObservaciones() : "-");
        }

        document.add(table);
        document.close();
    }
}
