<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.text.*"%>
<%
    Calendar calendar = Calendar.getInstance();
    Date fechaActual = calendar.getTime();
    SimpleDateFormat sdfFecha = new SimpleDateFormat("yyyy-MM-dd");
    String fecha = sdfFecha.format(fechaActual);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>MiBanco - Registro Asistencia</title>
    <style>
        html, body {
            margin: 0; padding: 0; height: 100%;
            font-family: sans-serif;
            background-color: #008542;
        }
        .banner {
            background-color: white;
            text-align: center;
            padding: 10px;
        }
        .content {
            height: calc(100% - 100px);
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            width: 90%; max-width: 1400px; display: flex; height: 700px;
        }
        .left-panel {
            flex: 1; background-color: #26A269;
            display: flex; flex-direction: column; justify-content: center;
            align-items: center; color: white; padding: 40px;
            border: 2px solid black; border-right: none;
            border-radius: 10px 0 0 10px;
        }
        .left-panel img { max-width: 180px; margin-bottom: 20px; }

        .right-panel {
            flex: 1; background-color: white;
            border-radius: 0 10px 10px 0; border: 2px solid black;
            display: flex; flex-direction: column; align-items: center;
        }
        .form-header {
            width: 100%; background-color: #008542; color: white;
            padding: 18px 0; text-align: center;
            font-weight: bold; font-size: 18px;
            border-radius: 0 10px 0 0;
        }
        .form-box {
            width: 100%; max-width: 460px; padding: 40px 50px;
            display: flex; flex-direction: column; justify-content: space-between;
            height: 100%;
        }
        .form-content { display: flex; flex-direction: column; gap: 18px; }

        .clock {
            text-align: center; font-size: 48px;
            background: #ddd; padding: 16px;
        }
        .input-group {
            display: flex; align-items: center;
            border: 1px solid #ccc; border-radius: 4px;
            overflow: hidden; background: white;
        }
        .input-group span {
            padding: 10px; background-color: #f0f0f0;
            font-size: 18px; border-right: 1px solid #ccc;
        }
        .input-group select,
        .input-group input {
            border: none; padding: 12px; width: 100%;
            font-size: 16px; outline: none;
        }
        .form-box button {
            width: 100%; padding: 12px; font-weight: bold;
            font-size: 16px; cursor: pointer;
        }
        .btn-registrar { background-color: #FFEB3B; }
        .btn-salir { background-color: #D32F2F; color: white; }
        .btn-marcarfaltas { background-color: #ff5722; color: white; }

        .mensaje, #respuestaFaltas {
            background-color: #eee; padding: 12px;
            border: 1px solid #ccc; font-size: 14px;
            margin-top: 12px; text-align: center;
        }
        .olvide {
            text-align: right; font-size: 13px; margin-top: 10px;
        }
        .olvide a { color: green; text-decoration: none; }
    </style>

    <script>
        function actualizarHora() {
            const ahora = new Date();
            const hora = ahora.toLocaleTimeString('es-PE', { hour12: false });
            document.getElementById("horaActual").innerText = hora;
            document.getElementById("horaSistema").value = hora;
        }
        setInterval(actualizarHora, 1000);

        function marcarFaltas() {
            fetch("<%= request.getContextPath() %>/MarcarFaltasAutomaticamente")
                .then(response => response.text())
                .then(data => {
                    document.getElementById("respuestaFaltas").innerText = data;
                })
                .catch(() => {
                    document.getElementById("respuestaFaltas").innerText = "❌ Error al marcar faltas.";
                });
        }
    </script>
</head>
<body>

<div class="banner">
    <img src="${pageContext.request.contextPath}/img/banner_mibanco.png" alt="Banner MiBanco" style="max-height:80px;">
</div>

<div class="content">
    <div class="container">

        <!-- Panel izquierdo -->
        <div class="left-panel">
            <img src="${pageContext.request.contextPath}/img/mibanco_logo1.png" alt="MiBanco">
            <p>¿Dudas o consultas?<br>Comunícate al <br><strong>(01) 319-9999</strong></p>
        </div>

        <!-- Panel derecho -->
        <div class="right-panel">
            <div class="form-header">
                Registro de Asistencia / Salida<br><%= fecha %>
            </div>

            <div class="form-box">
                <div class="form-content">
                    <div id="horaActual" class="clock">--:--:--</div>

                    <p>Ingrese el DNI del Trabajador para registrar su asistencia</p>

                    <form method="post" action="${pageContext.request.contextPath}/RegistrarAsistencia" style="display: flex; flex-direction: column; gap: 15px;">
                        <input type="hidden" name="fecha" value="<%= fecha %>"/>
                        <input type="hidden" id="horaSistema" name="hora" value=""/>

                        <div class="input-group">
                            <span>⏰</span>
                            <select name="tipo" required>
                                <option value="">Seleccione "Hora de Entrada" o "Hora de Salida"</option>
                                <option value="Entrada">Hora de Entrada</option>
                                <option value="Salida">Hora de Salida</option>
                            </select>
                        </div>

                        <div class="input-group">
                            <span>🆔</span>
                            <input type="text" name="dni" placeholder="Ingrese el DNI" required/>
                        </div>

                        <button type="submit" class="btn-registrar">REGISTRAR</button>
                    </form>

                    <form action="${pageContext.request.contextPath}/CerrarSesion" method="get">
                        <button type="submit" class="btn-salir">SALIR</button>
                    </form>

                    <!-- Botón para marcar faltas automáticamente -->
                    <button onclick="marcarFaltas()" class="btn-marcarfaltas">Marcar Faltas Automáticamente</button>
                    <div id="respuestaFaltas"></div>
                </div>
                        
                <% String mensaje = request.getParameter("msg"); if (mensaje != null) { %>
                    <div class="mensaje"><%= mensaje %></div>
                <% } %>

                <p class="olvide"><a href="#">¿Olvidó su Contraseña?</a></p>
            </div>
        </div>

    </div>
</div>

</body>
</html>
