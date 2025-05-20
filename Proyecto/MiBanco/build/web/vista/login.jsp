<%-- 
    Document   : login
    Created on : 13 may. 2025, 10:43:31
    Author     : AlonsoPC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - MiBanco</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #ffffff;
            display: flex;
            height: 100vh;
        }

        .panel-verde {
            background-color: #007A33;
            width: 25%;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 20px;
            text-align: center;
        }

        .panel-verde img {
            width: 120px;
            margin-bottom: 20px;
        }

        .contenido-central {
            width: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .formulario {
            width: 450px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .form-header {
            background-color: #007A33;
            padding: 15px;
            text-align: center;
        }

        .form-header img {
            height: 50px;
        }

        .form-body {
            padding: 30px;
        }

        .form-body h2 {
            color: #007A33;
            text-align: center;
        }

        .form-body p {
            text-align: center;
            font-style: italic;
            margin: 10px 0;
        }

        .form-body input[type="text"],
        .form-body input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .form-body label {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .form-body button {
            background-color: #FFCC00;
            border: none;
            padding: 10px 20px;
            color: #000;
            cursor: pointer;
            font-weight: bold;
            border-radius: 4px;
            width: 100%;
        }

        .form-body .mensaje {
            display: flex;
            align-items: center;
            margin-top: 20px;
        }

        .form-body .mensaje span {
            display: inline-block;
            background-color: #e9e9e9;
            border: 1px solid #ccc;
            padding: 8px;
            border-radius: 4px;
            width: 100%;
        }

        .form-body .mensaje img {
            width: 20px;
            margin-right: 8px;
        }

        .form-body a {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: green;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="panel-verde">
        <img src="<%= request.getContextPath() %>/img/mibanco_logo1.png" alt="MiBanco">
        <p>¿Dudas o consultas?<br>Comunícate o acércate a la agencia más cercana.<br>(01) 319-9999</p>
    </div>

    <div class="contenido-central">
        <form action="<%= request.getContextPath() %>/LoginServlet" method="post" class="formulario">
            <div class="form-header">
                <img src="<%= request.getContextPath() %>/img/mibanco_logo1.png" alt="MiBanco">
            </div>
            <div class="form-body">
                <h2>Sistema de Asistencias MiBanco</h2>
                <p>Ingrese sus Credenciales</p>

                <input type="text" name="dni" placeholder="Ingrese tu número de documento" required autocomplete="off" />
                <input type="password" name="clave" placeholder="Ingrese su Contraseña" required autocomplete="off" />

                <button type="submit">Iniciar Sesión</button>

                <%
                    String mensaje = (String) request.getAttribute("mensaje");
                    if (mensaje != null && !mensaje.isEmpty()) {
                %>
                    <div class="mensaje">
                        <img src="https://cdn-icons-png.flaticon.com/512/561/561127.png" alt="Correo" width="18" />
                        <span><%= mensaje %></span>
                    </div>
                <% } %>

                <a href="#">¿Olvidó su Contraseña?</a>
            </div>
        </form>
    </div>

    <div class="panel-verde">
        <img src="<%= request.getContextPath() %>/img/mibanco_logo1.png" alt="MiBanco">
        <p>¿Dudas o consultas?<br>Comunícate o acércate a la agencia más cercana.<br>(01) 319-9999</p>
    </div>
</body>
</html>




