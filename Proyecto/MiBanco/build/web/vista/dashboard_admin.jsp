<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="DAO.DashboardDAO" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    DashboardDAO dashboardDAO = new DashboardDAO();
    int totalTrabajadores = dashboardDAO.contarTrabajadores();
    int totalAsistencias = dashboardDAO.contarAsistenciasHoy();
    int totalTardanzas = dashboardDAO.contarTardanzasHoy();
    int totalSalidasAnticipadas = dashboardDAO.contarSalidasAnticipadasHoy();
    int totalFaltas = dashboardDAO.contarFaltasHoy();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Administrador</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        .metric-card {
            background-color: #ffc107; padding: 1rem; border-radius: 0.5rem;
            color: black; text-align: center; font-weight: bold;
        }
        .graph-card {
            background-color: #e9ecef; padding: 1rem; border-radius: 0.5rem;
        }
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
    </style>
</head>
<body>
<div class="d-flex">
    <!-- Sidebar -->
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

    <!-- Contenido Principal -->
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

        <div class="container-fluid mt-5">
            <!-- MÉTRICAS -->
            <div class="row g-3 mb-5">
                <div class="col-md-2"><div class="metric-card"><%= totalTrabajadores %><br>Trabajadores Registrados</div></div>
                <div class="col-md-2"><div class="metric-card"><%= totalAsistencias %><br>Asistencias Registradas Hoy</div></div>
                <div class="col-md-2"><div class="metric-card"><%= totalTardanzas %><br>Tardanzas Hoy</div></div>
                <div class="col-md-3"><div class="metric-card"><%= totalSalidasAnticipadas %><br>Salidas Anticipadas</div></div>
                <div class="col-md-3"><div class="metric-card"><%= totalFaltas %><br>Faltas Hoy</div></div>
            </div>

            <!-- GRÁFICOS -->
            <div class="row g-4 mb-5">
                <div class="col-md-6">
                    <div class="graph-card">
                        <p class="fw-bold">Asistencias de los Últimos 7 Días</p>
                        <canvas id="graficoAsistencias"></canvas>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="graph-card">
                        <p class="fw-bold">Resumen Diario: Tardanzas, Faltas y Salidas</p>
                        <canvas id="graficoResumenDiario"></canvas>
                    </div>
                </div>
            </div>

            <p class="text-center mt-4 mb-5">Bienvenido al sistema de control MiBanco</p>
        </div>
    </div>
</div>

<!-- Scripts -->
<script>
    function toggleSidebar() {
        document.getElementById("sidebar").classList.toggle("sidebar-collapsed");
    }

    function toggleSubmenu(id) {
        const submenu = document.getElementById('submenu-' + id);
        submenu.classList.toggle("show");
    }

    // Gráfico de asistencias diarias (últimos 7 días)
    fetch('${pageContext.request.contextPath}/DashboardDataServlet?tipo=asistencias')
        .then(response => response.json())
        .then(data => {
            const labels = Object.keys(data);
            const values = Object.values(data);
            new Chart(document.getElementById('graficoAsistencias').getContext('2d'), {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Asistencias',
                        data: values,
                        backgroundColor: '#007a33'
                    }]
                },
                options: {
                    responsive: true
                }
            });
        });

    // Gráfico de resumen diario
    fetch('${pageContext.request.contextPath}/DashboardDataServlet?tipo=resumen')
        .then(response => response.json())
        .then(data => {
            const labels = Object.keys(data);
            const values = Object.values(data);
            new Chart(document.getElementById('graficoResumenDiario').getContext('2d'), {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Hoy',
                        data: values,
                        backgroundColor: ['#ffcc00', '#dc3545', '#17a2b8']
                    }]
                },
                options: {
                    responsive: true
                }
            });
        });
</script>
</body>
</html>