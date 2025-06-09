<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.ReporteGeneral" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/vista/login.jsp");
        return;
    }

    String tipoReporte = request.getAttribute("tipoReporte") != null
        ? (String) request.getAttribute("tipoReporte")
        : request.getParameter("tipoReporte");

    if (tipoReporte == null || tipoReporte.isEmpty()) tipoReporte = "general";

    String areaFiltro = request.getAttribute("area") != null
        ? (String) request.getAttribute("area")
        : request.getParameter("area");

    List<ReporteGeneral> reporteGeneral = (List<ReporteGeneral>) request.getAttribute("reporteGeneral");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reportes</title>
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
        .chart-container { height: 300px; }
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
                    <%= new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy", new java.util.Locale("es", "ES")).format(new java.util.Date()) %>
                </small>
            </div>
            <span><%= usuario.getNombreCompleto() %></span>
        </div>

        <div class="container-fluid mt-4">
            <h3 class="mb-4 text-success">Reportes</h3>

            <form method="get" action="${pageContext.request.contextPath}/ReporteGeneralServlet" class="row g-2 align-items-center mb-4">
                <div class="col-auto">
                    <select class="form-select" name="tipoReporte" onchange="this.form.submit()">
                        <option value="general" <%= "general".equals(tipoReporte) ? "selected" : "" %>>Reporte General</option>
                        <option value="trabajador" <%= "trabajador".equals(tipoReporte) ? "selected" : "" %>>Reporte por Trabajador</option>
                    </select>
                </div>
                <div class="col-auto">
                    <input type="text" name="area" class="form-control" placeholder="Área" value="<%= areaFiltro != null ? areaFiltro : "" %>">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-warning">Buscar</button>
                    <a href="${pageContext.request.contextPath}/ReporteGeneralServlet?tipoReporte=general" class="btn btn-dark text-white">Limpiar Filtros</a>
                </div>
            </form>

            <% if ("general".equals(tipoReporte)) { %>
            <table class="table table-bordered text-center">
                <thead>
                    <tr>
                        <th>Área</th>
                        <th>Total Trabajadores</th>
                        <th>Asistencias</th>
                        <th>Tardanzas</th>
                        <th>Faltas</th>
                        <th>Salidas Anticipadas</th>
                    </tr>
                </thead>
                <tbody>
                <% if (reporteGeneral != null && !reporteGeneral.isEmpty()) {
                    for (ReporteGeneral rg : reporteGeneral) { %>
                    <tr>
                        <td><%= rg.getArea() %></td>
                        <td><%= rg.getTotalTrabajadores() %></td>
                        <td><%= rg.getAsistencias() %></td>
                        <td><%= rg.getTardanzas() %></td>
                        <td><%= rg.getFaltas() %></td>
                        <td><%= rg.getSalidasAnticipadas() %></td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="6">No se encontraron resultados.</td></tr>
                <% } %>
                </tbody>
            </table>

            <div class="row mt-4">
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header text-center fw-bold">Asistencias semanales por área</div>
                        <div class="card-body chart-container"><canvas id="asistenciasPorArea"></canvas></div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header text-center fw-bold">Trabajadores por área</div>
                        <div class="card-body chart-container"><canvas id="trabajadoresPorArea"></canvas></div>
                    </div>
                </div>
            </div>
            <% } else if ("trabajador".equals(tipoReporte)) { %>
            <div class="alert alert-info">Aquí se mostrará el reporte por trabajador.</div>
            <% } %>

            <div class="d-flex gap-2 mb-3">
                <button class="btn btn-danger fw-bold">EXPORTAR PDF</button>
                <button class="btn btn-success fw-bold">EXPORTAR EXCEL</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    function toggleSidebar() {
        document.getElementById("sidebar").classList.toggle("sidebar-collapsed");
    }
    function toggleSubmenu(id) {
        document.getElementById('submenu-' + id).classList.toggle("show");
    }

    <% if ("general".equals(tipoReporte)) { %>
    const labels = [<% for (int i = 0; i < reporteGeneral.size(); i++) { %>"<%= reporteGeneral.get(i).getArea() %>"<%= (i < reporteGeneral.size() - 1) ? "," : "" %><% } %>];
    const asistencias = [<% for (int i = 0; i < reporteGeneral.size(); i++) { %><%= reporteGeneral.get(i).getAsistencias() %><%= (i < reporteGeneral.size() - 1) ? "," : "" %><% } %>];
    const trabajadores = [<% for (int i = 0; i < reporteGeneral.size(); i++) { %><%= reporteGeneral.get(i).getTotalTrabajadores() %><%= (i < reporteGeneral.size() - 1) ? "," : "" %><% } %>];

    new Chart(document.getElementById("asistenciasPorArea"), {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Asistencias semanales por área',
                data: asistencias,
                backgroundColor: 'rgba(54, 162, 235, 0.5)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: { y: { beginAtZero: true } }
        }
    });

    new Chart(document.getElementById("trabajadoresPorArea"), {
        type: 'pie',
        data: {
            labels: labels,
            datasets: [{
                label: 'Trabajadores por área',
                data: trabajadores,
                backgroundColor: ['#007bff', '#dc3545', '#ffc107', '#28a745', '#6f42c1', '#17a2b8', '#fd7e14']
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
    <% } %>
</script>
</body>
</html>
