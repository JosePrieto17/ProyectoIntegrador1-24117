package modelo;

public class Trabajador {

    private int id;
    private String nombreCompleto;
    private String dni;
    private String correo;
    private String telefono;
    private String area;
    private String cargo;
    private String tipoTurno;
    private String horario;
    private String observaciones;

    // Constructor vacío (obligatorio para frameworks y JDBC)
    public Trabajador() {
    }

    // Constructor útil para instanciación rápida (opcional)
    public Trabajador(int id, String nombreCompleto, String dni, String correo, String telefono,
                      String area, String cargo, String tipoTurno, String horario, String observaciones) {
        this.id = id;
        this.nombreCompleto = nombreCompleto;
        this.dni = dni;
        this.correo = correo;
        this.telefono = telefono;
        this.area = area;
        this.cargo = cargo;
        this.tipoTurno = tipoTurno;
        this.horario = horario;
        this.observaciones = observaciones;
    }

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getDni() { return dni; }
    public void setDni(String dni) { this.dni = dni; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getArea() { return area; }
    public void setArea(String area) { this.area = area; }

    public String getCargo() { return cargo; }
    public void setCargo(String cargo) { this.cargo = cargo; }

    public String getTipoTurno() { return tipoTurno; }
    public void setTipoTurno(String tipoTurno) { this.tipoTurno = tipoTurno; }

    public String getHorario() { return horario; }
    public void setHorario(String horario) { this.horario = horario; }

    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
}