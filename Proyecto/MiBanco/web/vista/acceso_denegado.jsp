<%-- 
    Document   : acceso_denegado
    Created on : 14 may. 2025, 16:47:32
    Author     : AlonsoPC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Acceso Denegado</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            display: flex;
            height: 100vh;
            background-color: #ffffff;
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

        .tarjeta-denegado {
            width: 450px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            overflow: hidden;
        }

        .tarjeta-denegado .header {
            background-color: #007A33;
            padding: 15px;
        }

        .tarjeta-denegado .header img {
            height: 50px;
        }

        .tarjeta-denegado .body {
            padding: 30px;
        }

        .tarjeta-denegado h2 {
            color: #007A33;
            margin-bottom: 10px;
        }

        .tarjeta-denegado p {
            font-size: 16px;
            margin-bottom: 20px;
        }

        .tarjeta-denegado a {
            display: inline-block;
            background-color: #FFCC00;
            color: black;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
        }

        .tarjeta-denegado a:hover {
            background-color: #e6b800;
        }
    </style>
</head>
<body>
    <div class="panel-verde">
        <img src="../img/mibanco_logo1.png" alt="MiBanco">
        <p>¿Dudas o consultas?<br>Comunícate o acércate a la agencia más cercana.<br>(01) 319-9999</p>
    </div>

    <div class="contenido-central">
        <div class="tarjeta-denegado">
            <div class="header">
                <img src="../img/mibanco_logo1.png" alt="Logo">
            </div>
            <div class="body">
                <h2>Acceso Denegado</h2>
                <p>No tienes permisos para acceder a esta sección del sistema.</p>
                <a href="login.jsp">Volver al Login</a>
            </div>
        </div>
    </div>

    <div class="panel-verde">
        <img src="../img/mibanco_logo1.png" alt="MiBanco">
        <p>¿Dudas o consultas?<br>Comunícate o acércate a la agencia más cercana.<br>(01) 319-9999</p>
    </div>
</body>
</html>
