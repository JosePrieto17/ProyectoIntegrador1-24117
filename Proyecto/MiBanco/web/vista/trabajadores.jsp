<%-- 
    Document   : trabajadores
    Created on : 18 may. 2025, 00:56:01
    Author     : AlonsoPC
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.Trabajador" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    String error = request.getParameter("error");
    String mensaje = request.getParameter("mensaje");
    String dniFiltro = request.getParameter("dni") != null ? request.getParameter("dni") : "";
    String areaFiltro = request.getParameter("area") != null ? request.getParameter("area") : "";
    String turnoFiltro = request.getParameter("turno") != null ? request.getParameter("turno") : "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Trabajadores</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { font-family: Arial, sans-serif; background-color: #f8f9fa; }
        .sidebar {
            height: 100vh; background-color: #007a33; color: white;
            transition: width 0.3s; overflow-x: hidden;
        }
        .sidebar a {
            color: white; text-decoration: none;
            padding: 0.75rem 1rem; display: flex; align-items: center; gap: 10px;
        }
        .sidebar a:hover { background-color: #006128; }
        .sidebar .submenu { padding-left: 2.5rem; display: none; }
        .sidebar .submenu.show { display: block; }
        .sidebar-collapsed { width: 80px !important; }
        .sidebar-collapsed a {
            flex-direction: column; justify-content: center; text-align: center;
        }
        .sidebar-collapsed .sidebar-text { display: block !important; font-size: 0.75rem; }
        .sidebar-collapsed .submenu { display: none !important; }
        .header-bar {
            background-color: #007a33; color: white;
            padding: 10px; display: flex; justify-content: space-between; align-items: center;
        }
        .sidebar-toggler {
            background: none; border: none; color: white;
            font-size: 20px; margin-bottom: 10px;
        }
        .sidebar-logo { width: 120px; margin-bottom: 10px; }
        .sidebar-collapsed .sidebar-logo,
        .sidebar-collapsed .user-info { display: none; }
        .sidebar hr { border-top: 1px solid #ffffff40; }
        .btn-exportar { margin-right: 10px; }
        .table th { background-color: #ffc107; }
        .icono-editar { color: #f0ad4e; cursor: pointer; }
        .filtros select, .filtros input { margin-right: 10px; }
    </style>
</head>
<body>
<% if ("dni".equals(error)) { %>
<script>
    window.addEventListener('load', function() {
        var modal = new bootstrap.Modal(document.getElementById('modalNuevoTrabajador'));
        modal.show();
        alert('Ya existe un trabajador con ese DNI.');
    });
</script>
<% } %>
<% if ("registrado".equals(mensaje)) { %>
<div class="alert alert-success text-center">Trabajador registrado correctamente.</div>
<% } %>
<% if ("actualizado".equals(mensaje)) { %>
<div class="alert alert-info text-center">Trabajador actualizado correctamente.</div>
<% } %>
<div class="d-flex">
    <div id="sidebar" class="sidebar d-flex flex-column p-2" style="width: 250px;">
        <button class="sidebar-toggler ms-auto" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
        <div class="text-center user-info">
            <img src="${pageContext.request.contextPath}/img/mibanco_logo1.png" alt="MiBanco" class="sidebar-logo">
            <p class="mt-2 mb-1 sidebar-text">Usuario:</p>
            <strong class="sidebar-text"><%= usuario.getNombreCompleto() %></strong>
        </div>
        <hr class="sidebar-text">
        <a href="${pageContext.request.contextPath}/vista/dashboard_admin.jsp"><i class="fas fa-house"></i><span class="sidebar-text">Dashboard</span></a>
        <a href="${pageContext.request.contextPath}/AsistenciasServlet"><i class="fas fa-user-check"></i><span class="sidebar-text">Asistencias</span></a>
        <a href="${pageContext.request.contextPath}/trabajadores"><i class="fas fa-users"></i><span class="sidebar-text">Trabajadores</span></a>
        <a href="javascript:void(0);" onclick="toggleSubmenu('reportes')">
            <i class="fas fa-file-pen"></i><span class="sidebar-text">Reportes</span><i class="fas fa-caret-down ms-auto"></i>
        </a>
        <div id="submenu-reportes" class="submenu">
            <a href="${pageContext.request.contextPath}/ReporteGeneralServlet"><span class="sidebar-text">Reporte General</span></a>
            <a href="${pageContext.request.contextPath}/vista/reporte_personal.jsp"><span class="sidebar-text">Mi Reporte Personal</span></a>
        </div>
        <a href="#"><i class="fas fa-file-lines"></i><span class="sidebar-text">Justificaciones</span></a>
        <hr class="sidebar-text">
        <a href="javascript:void(0);" onclick="toggleSubmenu('opciones')">
            <i class="fas fa-gear"></i><span class="sidebar-text">Opciones</span><i class="fas fa-caret-down ms-auto"></i>
        </a>
        <div id="submenu-opciones" class="submenu">
            <a href="#"><i class="fas fa-rotate"></i><span class="sidebar-text">Cambiar Contraseña</span></a>
            
<a href="${pageContext.request.contextPath}/CerrarSesion"><i class="fas fa-right-from-bracket"></i><span class="sidebar-text">Salir</span></a>

        </div>
    </div>
    <div class="flex-grow-1">
        <div class="header-bar text-center w-100">
            <div></div>
            <div>
                <h5 class="m-0">BIENVENIDO</h5>
                <small>
                    Hoy es:
                    <%
                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy", new java.util.Locale("es", "ES"));
                        out.print(sdf.format(new java.util.Date()));
                    %>
                </small>
            </div>
            <span><%= usuario.getNombreCompleto() %></span>
        </div>

        <div class="container-fluid mt-4">
            <h4 class="text-success">Trabajadores</h4>

            <form class="row filtros mb-3" method="get" action="${pageContext.request.contextPath}/trabajadores">
                <div class="col-md-10 d-flex flex-wrap align-items-center">
                    <input type="text" class="form-control me-2 mb-2" name="dni" placeholder="DNI" style="width: 150px;" value="<%= dniFiltro %>">
                    <input type="text" class="form-control me-2 mb-2" name="area" placeholder="Área" style="width: 150px;" value="<%= areaFiltro %>">
                    <select class="form-select me-2 mb-2" name="turno" style="width: 150px;">
                        <option value="">Turno</option>
                        <option value="Regular" <%= "Regular".equals(turnoFiltro) ? "selected" : "" %>>Regular</option>
                        <option value="Rotativo" <%= "Rotativo".equals(turnoFiltro) ? "selected" : "" %>>Rotativo</option>
                    </select>
                    <button type="submit" class="btn btn-warning mb-2">Buscar</button>
                    <a href="${pageContext.request.contextPath}/trabajadores" class="btn btn-secondary ms-2 mb-2">Limpiar Filtros</a>
                </div>
            </form>

            <div class="table-responsive">
                <table class="table table-bordered text-center">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre Completo</th>
                            <th>DNI</th>
                            <th>Área</th>
                            <th>Cargo</th>
                            <th>Turno</th>
                            <th>Horario</th>
                            <th>Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Trabajador> lista = (List<Trabajador>) request.getAttribute("listaTrabajadores");
                        if (lista != null && !lista.isEmpty()) {
                            for (Trabajador t : lista) {
                    %>
                        <tr>
                            <td><%= t.getId() %></td>
                            <td><%= t.getNombreCompleto() %></td>
                            <td><%= t.getDni() %></td>
                            <td><%= t.getArea() %></td>
                            <td><%= t.getCargo() %></td>
                            <td><%= t.getTipoTurno() %></td>
                            <td><%= t.getHorario() %></td>
                            <td><a href="${pageContext.request.contextPath}/EditarTrabajador?id=<%= t.getId() %>"><i class="fas fa-pen icono-editar"></i></a></td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr><td colspan="8">No se encontraron trabajadores.</td></tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <div class="d-flex justify-content-between mt-4">
                <div>
                    <button class="btn btn-danger btn-exportar"><a href="ExportarTrabajadoresServlet?tipo=pdf&dni=<%= dniFiltro %>&area=<%= areaFiltro %>&turno=<%= turnoFiltro %>" class="btn btn-danger">EXPORTAR PDF</a></button>
                    <button class="btn btn-success"><a href="ExportarTrabajadoresServlet?tipo=excel&dni=<%= dniFiltro %>&area=<%= areaFiltro %>&turno=<%= turnoFiltro %>" class="btn btn-success">EXPORTAR EXCEL</a></button>
                </div>
                <div>
                    <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#modalNuevoTrabajador">Nuevo trabajador</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Nuevo Trabajador -->
<div class="modal fade" id="modalNuevoTrabajador" tabindex="-1" aria-labelledby="modalNuevoTrabajadorLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="${pageContext.request.contextPath}/RegistrarTrabajador" method="post" onsubmit="return validarFormulario();">
        <div class="modal-header bg-success text-white">
          <h5 class="modal-title" id="modalNuevoTrabajadorLabel">Registro de Nuevo Trabajador</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-md-6">
              <label>Nombre Completo</label>
              <input type="text" class="form-control" name="nombre" required>
            </div>
            <div class="col-md-6">
              <label>DNI</label>
              <input type="text" class="form-control" name="dni" id="dni" maxlength="8" pattern="[0-9]{8}" requiredreadonly>
            </div>
            <div class="col-md-6 mt-3">
              <label>Correo</label>
              <input type="email" class="form-control" name="correo" required>
            </div>
            <div class="col-md-6 mt-3">
              <label>Teléfono</label>
              <input type="text" class="form-control" name="telefono" id="telefono" maxlength="9" pattern="[0-9]{9}">
            </div>
            <div class="col-md-6 mt-3">
              <label>Área</label>
              <select class="form-select" name="area" required>
                <option>Atencion al Cliente</option>
                <option>Marketing y Comunicacion</option>
                <option>Comercial y Ventas</option>
                <option>Finanzas y Contabilidad</option>
                <option>Tecnologia de la Informacion(TI)</option>
              </select>
            </div>
            <div class="col-md-6 mt-3">
              <label>Cargo</label>
              <select class="form-select" name="cargo" required>
                <option>Cajero</option>
                <option>Asesor</option>
                <option>Jefe de Area</option>
                <option>Community manager</option>
                <option>Diseñador grafico</option>
                <option>Ejecutivo de ventas</option>
                <option>Coordinador comercial</option>
                <option>Contador</option>
                <option>Analista financiero</option>
                <option>Tesorero</option>
                <option>Soporte tecnico</option>
                <option>Desarrolladores</option>
              </select>
            </div>
            <div class="col-md-6 mt-3">
              <label>Tipo de Turno</label>
              <select class="form-select" name="turno" required>
                <option>Regular</option>
                <option>Rotativo</option>
              </select>
            </div>
            <div class="col-md-6 mt-3">
              <label>Horario</label>
              <select class="form-select" name="horario" required>
                <option>Lunes - Viernes 08:00:00 - 16:00:00</option>
                <option>Lunes - Sabado 09:00:00 - 18:00:00</option>
                <option>Lunes - Viernes 08:30:00 - 15:30:00</option>
                <option>Lunes - Viernes 10:00:00 - 19:00:00</option>
              </select>
            </div>
            <div class="col-12 mt-3">
              <label>Observaciones</label>
              <textarea class="form-control" name="observaciones" rows="2"></textarea>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">REGISTRAR</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">CANCELAR</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function toggleSidebar() {
    document.getElementById("sidebar").classList.toggle("sidebar-collapsed");
  }
  function toggleSubmenu(id) {
    const submenu = document.getElementById('submenu-' + id);
    submenu.classList.toggle("show");
  }
  
function validarFormulario() {
    const dniInput = document.getElementById("dni");
    const telefono = document.getElementById("telefono").value;

    if (!dniInput.readOnly && !/^[0-9]{8}$/.test(dniInput.value)) {
      alert("El DNI debe tener 8 dígitos numéricos.");
      return false;
    }

    if (telefono && !/^[0-9]{9}$/.test(telefono)) {
      alert("El teléfono debe tener 9 dígitos numéricos.");
      return false;
    }

    return true;
}
$/.test(dni)) {
      alert("El DNI debe tener 8 dígitos numéricos.");
      return false;
    }
    if (telefono && !/^[0-9]{9}$/.test(telefono)) {
      alert("El teléfono debe tener 9 dígitos numéricos.");
      return false;
    }
    return true;
  }
</script>

<%-- Modal Edición de Trabajador (si existe atributo trabajadorEditar) --%>
<%
    Trabajador trabajadorEditar = (Trabajador) request.getAttribute("trabajadorEditar");
    if (trabajadorEditar != null) {
%>
<script>
    window.addEventListener('load', function() {
        var modal = new bootstrap.Modal(document.getElementById('modalEditarTrabajador'));
        modal.show();
    });
</script>

<div class="modal fade" id="modalEditarTrabajador" tabindex="-1" aria-labelledby="modalEditarTrabajadorLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="${pageContext.request.contextPath}/ActualizarTrabajador" method="post" onsubmit="return validarFormulario();">
        <div class="modal-header bg-info text-white">
          <h5 class="modal-title" id="modalEditarTrabajadorLabel">Editar Trabajador</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="id" value="<%= trabajadorEditar.getId() %>">
          <div class="row">
            <div class="col-md-6">
              <label>Nombre Completo</label>
              <input type="text" class="form-control" name="nombre" value="<%= trabajadorEditar.getNombreCompleto() %>" required>
            </div>
            <div class="col-md-6">
              <label>DNI</label>
              <input type="text" class="form-control" name="dni" id="dni" maxlength="8" pattern="[0-9]{8}" value="<%= trabajadorEditar.getDni() %>" required readonly>
            </div>
            <div class="col-md-6 mt-3">
              <label>Correo</label>
              <input type="email" class="form-control" name="correo" value="<%= trabajadorEditar.getCorreo() %>" required>
            </div>
            <div class="col-md-6 mt-3">
              <label>Teléfono</label>
              <input type="text" class="form-control" name="telefono" id="telefono" maxlength="9" pattern="[0-9]{9}" value="<%= trabajadorEditar.getTelefono() %>">
            </div>
            <div class="col-md-6 mt-3">
              <label>Área</label>
              <select class="form-select" name="area" required>
                <option <%= "Atencion al Cliente".equals(trabajadorEditar.getArea()) ? "selected" : "" %>>Atencion al Cliente</option>
                <option <%= "Marketing y Comunicacion".equals(trabajadorEditar.getArea()) ? "selected" : "" %>>Marketing y Comunicación</option>
                <option <%= "Comercial y Ventas".equals(trabajadorEditar.getArea()) ? "selected" : "" %>>Comercial y Ventas</option>
                <option <%= "Finanzas y Contabilidad".equals(trabajadorEditar.getArea()) ? "selected" : "" %>>Finanzas y Contabilidad</option>
                <option <%= "Tecnologia de la Informacion(TI)".equals(trabajadorEditar.getArea()) ? "selected" : "" %>>Tecnologia de la Informacion(TI)</option>
              </select>
            </div>
            <div class="col-md-6 mt-3">
              <label>Cargo</label>
              <select class="form-select" name="cargo" required>
                <option <%= "Cajero".equals(trabajadorEditar.getCargo()) ? "selected" : "" %>>Cajero</option>
                <option <%= "Asesor".equals(trabajadorEditar.getCargo()) ? "selected" : "" %>>Asesor</option>
                <option <%= "Jefe de Área".equals(trabajadorEditar.getCargo()) ? "selected" : "" %>>Jefe de Area</option>
                <option <%= "Community manager".equals(trabajadorEditar.getCargo()) ? "selected" : "" %>>Community manager</option>
                <option <%= "Diseñador gráfico".equals(trabajadorEditar.getCargo()) ? "selected" : "" %>>Diseñador gráfico</option>
                <option <%= "Ejecutivo de ventas".equals(trabajadorEditar.getCargo()) ? "selected" : "" %>>Ejecutivo de ventas</option>
                <option <%= "Coordinador comercial".equals(trabajadorEditar.getCargo()) ? "selected" : "" %>>Coordinador comercial</option>
                <option <%= "Contador".equals(trabajadorEditar.getCargo()) ? "selected" : "" %>>Contador</option>
                <option <%= "Analista financiero".equals(trabajadorEditar.getCargo()) ? "selected" : "" %>>Analista financiero</option>
                <option <%= "Tesorero".equals(trabajadorEditar.getCargo()) ? "selected" : "" %>>Tesorero</option>
                <option <%= "Soporte Tecnico".equals(trabajadorEditar.getCargo()) ? "selected" : "" %>>Soporte Tecnico</option>
                <option <%= "Desarrolladores".equals(trabajadorEditar.getCargo()) ? "selected" : "" %>>Desarrolladores</option>
              </select>
            </div>
            <div class="col-md-6 mt-3">
              <label>Tipo de Turno</label>
              <select class="form-select" name="turno" required>
                <option <%= "Regular".equals(trabajadorEditar.getTipoTurno()) ? "selected" : "" %>>Regular</option>
                <option <%= "Rotativo".equals(trabajadorEditar.getTipoTurno()) ? "selected" : "" %>>Rotativo</option>
              </select>
            </div>
            <div class="col-md-6 mt-3">
              <label>Horario</label>
              <select class="form-select" name="horario" required>
                <option <%= "Lunes - Viernes 08:00:00 - 16:00:00".equals(trabajadorEditar.getHorario()) ? "selected" : "" %>>Lunes - Viernes 08:00:00 - 16:00:00</option>
                <option <%= "Lunes - Sábado 09:00:00 - 18:00:00".equals(trabajadorEditar.getHorario()) ? "selected" : "" %>>Lunes - Sábado 09:00:00 - 18:00:00</option>
                <option <%= "Lunes - Viernes 08:30:00 - 15:30:00".equals(trabajadorEditar.getHorario()) ? "selected" : "" %>>Lunes - Viernes 08:30:00 - 15:30:00</option>
                <option <%= "Lunes - Viernes 10:00:00 - 19:00:00".equals(trabajadorEditar.getHorario()) ? "selected" : "" %>>Lunes - Viernes 10:00:00 - 19:00:00</option>
              </select>
            </div>
            <div class="col-12 mt-3">
              <label>Observaciones</label>
              <textarea class="form-control" name="observaciones" rows="2"><%= trabajadorEditar.getObservaciones() %></textarea>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">ACTUALIZAR</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">CANCELAR</button>
        </div>
      </form>
    </div>
  </div>
</div>
<% } %>



<script>
  function toggleSidebar() {
    document.getElementById("sidebar").classList.toggle("sidebar-collapsed");
  }

  function toggleSubmenu(id) {
    const submenu = document.getElementById('submenu-' + id);
    submenu.classList.toggle("show");
  }

  // Restore submenu state if needed
  document.addEventListener("DOMContentLoaded", () => {
    const submenuIds = ["reportes", "opciones"];
    submenuIds.forEach(id => {
      const link = document.querySelector(`[onclick*="toggleSubmenu('${id}')"]`);
      if (link) {
        link.addEventListener("click", () => toggleSubmenu(id));
      }
    });
  });
</script>

</body>
</html>