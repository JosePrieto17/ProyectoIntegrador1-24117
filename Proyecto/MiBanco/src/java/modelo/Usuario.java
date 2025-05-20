package modelo;

public class Usuario {
    private int idUsuario;
    private String nombreCompleto;
    private String dni;
    private String correo;
    private String telefono;
    private String contrasena;
    private int idRol;

    public Usuario() {}

    public Usuario(int idUsuario, String nombreCompleto, String dni, String correo, String telefono, int idRol) {
        this.idUsuario = idUsuario;
        this.nombreCompleto = nombreCompleto;
        this.dni = dni;
        this.correo = correo;
        this.telefono = telefono;
        this.idRol = idRol;
    }

    public Usuario(int idUsuario, String nombreCompleto, String dni, String correo, String telefono, String contrasena, int idRol) {
        this(idUsuario, nombreCompleto, dni, correo, telefono, idRol);
        this.contrasena = contrasena;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    // ⚠️ Opción: eliminar o proteger el getter de contraseña
    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public int getIdRol() {
        return idRol;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
    }
}

