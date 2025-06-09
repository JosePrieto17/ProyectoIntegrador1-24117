<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.AsistenciaVisual" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/vista/login.jsp");
        return;
    }

    // Corregimos los valores "null" enviados como string
    String fecha = (String) request.getAttribute("fecha");
    String dni = (String) request.getAttribute("dni");
    String estado = (String) request.getAttribute("estado");
    if ("null".equals(fecha)) fecha = null;
    if ("null".equals(dni)) dni = null;
    if ("null".equals(estado)) estado = null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Asistencias</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { font-family: Arial, sans-serif; background-color: #f8f9fa; }
        .sidebar { height: 100vh; background-color: #007a33; color: white; transition: width 0.3s; overflow-x: hidden; }
        .sidebar a { color: white; text-decoration: none; padding: 0.75rem 1rem; display: flex; align-items: center; gap: 10px; }
        .sidebar a:hover { background-color: #006128; }
        .sidebar .submenu { padding-left: 2.5rem; display: none; }
        .sidebar .submenu.show { display: block; }
        .sidebar-collapsed { width: 80px !important; }
        .sidebar-collapsed a { flex-direction: column; justify-content: center; text-align: center; }
        .sidebar-collapsed .sidebar-text { display: block !important; font-size: 0.75rem; }
        .sidebar-collapsed .submenu { display: none !important; }
        .header-bar { background-color: #007a33; color: white; padding: 10px; display: flex; justify-content: space-between; align-items: center; }
        .sidebar-toggler { background: none; border: none; color: white; font-size: 20px; margin-bottom: 10px; }
        .sidebar-logo { width: 120px; margin-bottom: 10px; }
        .sidebar-collapsed .sidebar-logo, .sidebar-collapsed .user-info { display: none; }
        .sidebar hr { border-top: 1px solid #ffffff40; }
        thead th { background-color: #ffc107 !important; color: black !important; }
    </style>
</head>
<body>
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
        <h3 class="mb-4 text-success">Asistencias</h3>

        <form method="get" action="${pageContext.request.contextPath}/AsistenciasServlet" class="row g-2 align-items-center mb-4">
            <div class="col-auto"><input type="date" name="fecha" class="form-control" value="<%= fecha != null ? fecha : "" %>"></div>
            <div class="col-auto"><input type="text" name="dni" class="form-control" placeholder="DNI" value="<%= dni != null ? dni : "" %>"></div>
            <div class="col-auto">
                <select name="estado" class="form-select">
                    <option value="">Estado</option>
                    <option value="Puntual" <%= "Puntual".equals(estado) ? "selected" : "" %>>Puntual</option>
                    <option value="Tardanza" <%= "Tardanza".equals(estado) ? "selected" : "" %>>Tardanza</option>
                    <option value="Falta" <%= "Falta".equals(estado) ? "selected" : "" %>>Falta</option>
                    <option value="Salida Anticipada" <%= "Salida Anticipada".equals(estado) ? "selected" : "" %>>Salida Anticipada</option>
                </select>
            </div>
            <div class="col-auto">
                <button type="submit" class="btn" style="background-color: rgb(255, 199, 32); color: black;">Buscar</button>
                <a href="${pageContext.request.contextPath}/AsistenciasServlet" class="btn" style="background-color: rgb(86, 94, 100); color: white;">Limpiar Filtros</a>
            </div>
        </form>

        <table class="table table-bordered text-center">
            <thead>
                <tr>
                    <th>ID</th><th>FECHA</th><th>Nombre</th><th>DNI</th><th>Horario</th>
                    <th>HORA ENTRADA</th><th>HORA SALIDA</th><th>ESTADO</th><th>Observaciones</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<AsistenciaVisual> asistencias = (List<AsistenciaVisual>) request.getAttribute("asistencias");
                    if (asistencias != null && !asistencias.isEmpty()) {
                        for (AsistenciaVisual a : asistencias) {
                %>
                <tr>
                    <td><%= a.getIdAsistencia() %></td>
                    <td><%= a.getFecha() %></td>
                    <td><%= a.getNombreCompleto() %></td>
                    <td><%= a.getDni() %></td>
                    <td><%= a.getHorario() %></td>
                    <td><%= a.getHoraEntrada() != null ? a.getHoraEntrada() : "-" %></td>
                    <td><%= a.getHoraSalida() != null ? a.getHoraSalida() : "-" %></td>
                    <td><%= a.getEstado() %></td>
                    <td><%= a.getObservaciones() != null ? a.getObservaciones().replace("|", "<br>") : "-" %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr><td colspan="9">No hay asistencias registradas.</td></tr>
                <% } %>
            </tbody>
        </table>

       <div class="d-flex justify-content-center mb-3">
            <%
                int paginaActual = (int) request.getAttribute("paginaActual");
                int totalPaginas = (int) request.getAttribute("totalPaginas");
                StringBuilder queryString = new StringBuilder();
                if (fecha != null) queryString.append("&fecha=").append(fecha);
                if (dni != null) queryString.append("&dni=").append(dni);
                if (estado != null) queryString.append("&estado=").append(estado);
            %>
            <nav>
                <ul class="pagination">
                    <% if (paginaActual > 1) { %>
                        <li class="page-item"><a class="page-link" href="AsistenciasServlet?pagina=<%= paginaActual - 1 %><%= queryString %>">&laquo;</a></li>
                    <% }
                    for (int i = 1; i <= totalPaginas; i++) { %>
                        <li class="page-item <%= (i == paginaActual) ? "active" : "" %>">
                            <a class="page-link" href="AsistenciasServlet?pagina=<%= i %><%= queryString %>"><%= i %></a>
                        </li>
                    <% }
                    if (paginaActual < totalPaginas) { %>
                        <li class="page-item"><a class="page-link" href="AsistenciasServlet?pagina=<%= paginaActual + 1 %><%= queryString %>">&raquo;</a></li>
                    <% } %>
                </ul>
            </nav>
        </div>

        <div class="d-flex gap-2 mb-3">
            <form method="post" action="${pageContext.request.contextPath}/ExportarAsistenciasServlet">
                <input type="hidden" name="formato" value="pdf">
                <input type="hidden" name="fecha" value="<%= request.getAttribute("fecha") != null ? request.getAttribute("fecha") : "" %>">
                <input type="hidden" name="dni" value="<%= request.getAttribute("dni") != null ? request.getAttribute("dni") : "" %>">
                <input type="hidden" name="estado" value="<%= request.getAttribute("estado") != null ? request.getAttribute("estado") : "" %>">
                <button type="submit" class="btn btn-danger fw-bold">EXPORTAR PDF</button>
            </form>

            <form method="post" action="${pageContext.request.contextPath}/ExportarAsistenciasServlet">
                <input type="hidden" name="formato" value="excel">
                <input type="hidden" name="fecha" value="<%= request.getAttribute("fecha") != null ? request.getAttribute("fecha") : "" %>">
                <input type="hidden" name="dni" value="<%= request.getAttribute("dni") != null ? request.getAttribute("dni") : "" %>">
                <input type="hidden" name="estado" value="<%= request.getAttribute("estado") != null ? request.getAttribute("estado") : "" %>">
                <button type="submit" class="btn btn-success fw-bold">EXPORTAR EXCEL</button>
            </form>
        </div>

        <p>Hora Entrada: Tolerancia 10min</p>
   </div>
</div>
<script>
    function toggleSidebar() {
        document.getElementById("sidebar").classList.toggle("sidebar-collapsed");
    }
    function toggleSubmenu(id) {
        const submenu = document.getElementById('submenu-' + id);
        submenu.classList.toggle("show");
    }
</script>
</body>
</html>
