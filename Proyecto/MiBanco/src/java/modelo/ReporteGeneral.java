package modelo;

public class ReporteGeneral {
    private String area;
    private int totalTrabajadores;
    private int asistencias;
    private int tardanzas;
    private int faltas;
    private int salidasAnticipadas;

    // Getters y Setters
    public String getArea() { return area; }
    public void setArea(String area) { this.area = area; }

    public int getTotalTrabajadores() { return totalTrabajadores; }
    public void setTotalTrabajadores(int totalTrabajadores) { this.totalTrabajadores = totalTrabajadores; }

    public int getAsistencias() { return asistencias; }
    public void setAsistencias(int asistencias) { this.asistencias = asistencias; }

    public int getTardanzas() { return tardanzas; }
    public void setTardanzas(int tardanzas) { this.tardanzas = tardanzas; }

    public int getFaltas() { return faltas; }
    public void setFaltas(int faltas) { this.faltas = faltas; }

    public int getSalidasAnticipadas() { return salidasAnticipadas; }
    public void setSalidasAnticipadas(int salidasAnticipadas) { this.salidasAnticipadas = salidasAnticipadas; }
}

