-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-06-2025 a las 07:56:12
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd_mibanco`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asistencia`
--

CREATE TABLE `asistencia` (
  `ID_Asistencia` int(11) NOT NULL,
  `ID_Trabajador` int(11) DEFAULT NULL,
  `Fecha` date NOT NULL,
  `HoraEntrada` time DEFAULT NULL,
  `HoraSalida` time DEFAULT NULL,
  `Estado` varchar(100) NOT NULL,
  `Observaciones` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `asistencia`
--

INSERT INTO `asistencia` (`ID_Asistencia`, `ID_Trabajador`, `Fecha`, `HoraEntrada`, `HoraSalida`, `Estado`, `Observaciones`) VALUES
(1, 12, '2025-05-01', '08:03:00', '16:01:00', 'Puntual', NULL),
(2, 11, '2025-05-02', '09:17:00', '17:45:00', 'Tardanza | Salida Anticipada', 'Llegó 17 min tarde | Se retiró a las 17:45:00, antes de las 18:00:00'),
(3, 13, '2025-05-03', '09:17:00', '17:32:00', 'Tardanza', 'Llegó 47 min tarde'),
(4, 12, '2025-05-05', NULL, NULL, 'Falta', 'No justificada'),
(5, 11, '2025-05-06', '09:09:00', '17:32:00', 'Puntual | Salida Anticipada', 'Se retiró a las 17:32:00, antes de las 18:00:00'),
(6, 14, '2025-05-07', '09:07:00', '16:03:00', 'Tardanza', 'Llegó 67 min tarde'),
(7, 15, '2025-05-08', NULL, NULL, 'Falta', 'No justificada'),
(8, 1, '2025-05-09', NULL, NULL, 'Falta', 'No justificada'),
(9, 16, '2025-05-10', '09:01:00', '17:20:00', 'Puntual | Salida Anticipada', 'Se retiró a las 17:20:00, antes de las 18:00:00'),
(10, 1, '2025-05-12', '08:12:00', '15:33:00', 'Tardanza | Salida Anticipada', 'Llegó 12 min tarde | Se retiró a las 15:33:00, antes de las 16:00:00'),
(11, 17, '2025-05-13', '10:04:00', '19:05:00', 'Puntual', NULL),
(12, 10, '2025-05-14', NULL, NULL, 'Falta', 'No justificada'),
(13, 2, '2025-05-15', NULL, NULL, 'Falta', 'No justificada'),
(14, 12, '2025-05-16', '08:51:00', '16:41:00', 'Tardanza', 'Llegó 51 min tarde'),
(15, 1, '2025-05-16', '08:11:00', '16:17:00', 'Tardanza', 'Llegó 11 min tarde'),
(16, 11, '2025-05-17', '09:02:00', '18:27:00', 'Puntual', NULL),
(17, 13, '2025-05-19', '08:33:00', '15:01:00', 'Puntual | Salida Anticipada', 'Se retiró a las 15:01:00, antes de las 15:30:00'),
(18, 15, '2025-05-20', '08:44:00', '15:53:00', 'Tardanza | Salida Anticipada', 'Llegó 44 min tarde | Se retiró a las 15:53:00, antes de las 16:00:00'),
(19, 14, '2025-05-21', NULL, NULL, 'Falta', 'No justificada'),
(20, 16, '2025-05-22', '09:20:00', '17:30:00', 'Tardanza | Salida Anticipada', 'Llegó 20 min tarde | Se retiró a las 17:30:00, antes de las 18:00:00'),
(21, 17, '2025-05-23', '10:14:00', '18:03:00', 'Tardanza | Salida Anticipada', 'Llegó 14 min tarde | Se retiró a las 18:03:00, antes de las 19:00:00'),
(22, 11, '2025-05-24', NULL, NULL, 'Falta', 'No justificada'),
(23, 10, '2025-05-26', '08:09:00', '16:13:00', 'Puntual', NULL),
(24, 2, '2025-05-27', NULL, NULL, 'Falta', 'No justificada'),
(25, 1, '2025-05-28', '08:01:00', '15:47:00', 'Puntual | Salida Anticipada', 'Se retiró a las 15:47:00, antes de las 16:00:00'),
(26, 12, '2025-05-29', NULL, NULL, 'Falta', 'No justificada'),
(27, 14, '2025-05-30', '08:05:00', '15:12:00', 'Puntual | Salida Anticipada', 'Se retiró a las 15:12:00, antes de las 16:00:00'),
(28, 11, '2025-05-31', '09:50:00', '17:40:00', 'Tardanza | Salida Anticipada', 'Llegó 50 min tarde | Se retiró a las 17:40:00, antes de las 18:00:00'),
(29, 13, '2025-06-02', '08:51:00', '15:20:00', 'Tardanza | Salida Anticipada', 'Llegó 21 min tarde | Se retiró a las 15:20:00, antes de las 15:30:00'),
(30, 15, '2025-06-02', '08:03:00', '16:41:00', 'Puntual', NULL),
(31, 12, '2025-06-03', '08:06:00', '16:11:00', 'Puntual', NULL),
(32, 1, '2025-06-04', '08:57:00', '16:01:00', 'Tardanza', 'Llegó 57 min tarde'),
(33, 10, '2025-06-04', '08:44:00', '15:31:00', 'Tardanza | Salida Anticipada', 'Llegó 44 min tarde | Se retiró a las 15:31:00, antes de las 16:00:00'),
(34, 17, '2025-06-04', '10:57:00', '18:13:00', 'Tardanza | Salida Anticipada', 'Llegó 57 min tarde | Se retiró a las 18:13:00, antes de las 19:00:00'),
(35, 16, '2025-06-04', '09:17:00', '18:05:00', 'Tardanza', 'Llegó 17 min tarde'),
(36, 14, '2025-06-05', '08:04:00', '16:00:00', 'Puntual', NULL),
(37, 1, '2025-06-05', NULL, NULL, 'Falta', 'No justificada'),
(38, 12, '2025-06-05', '08:30:00', '16:19:00', 'Tardanza', 'Llegó 30 min tarde'),
(39, 2, '2025-06-06', '08:02:00', '15:42:00', 'Puntual | Salida Anticipada', 'Se retiró a las 15:42:00, antes de las 16:00:00'),
(40, 11, '2025-06-06', '09:06:00', '17:21:00', 'Puntual | Salida Anticipada', 'Se retiró a las 17:21:00, antes de las 18:00:00'),
(41, 13, '2025-06-06', '08:56:00', '15:33:00', 'Tardanza', 'Llegó 26 min tarde'),
(42, 16, '2025-06-07', NULL, NULL, 'Falta', 'No justificada'),
(43, 11, '2025-06-07', '09:57:00', '18:06:00', 'Tardanza', 'Llegó 57 min tarde');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `justificacion`
--

CREATE TABLE `justificacion` (
  `ID_Justificacion` int(11) NOT NULL,
  `ID_Trabajador` int(11) DEFAULT NULL,
  `Fecha` date NOT NULL,
  `Tipo` enum('Tardanza','Falta','Retiro Anticipado') NOT NULL,
  `Motivo` text NOT NULL,
  `Estado` enum('Pendiente','Aprobado','Rechazado') DEFAULT 'Pendiente',
  `RutaArchivo` varchar(255) DEFAULT NULL,
  `ObservacionesAdmin` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reporte`
--

CREATE TABLE `reporte` (
  `ID_Reporte` int(11) NOT NULL,
  `TipoReporte` enum('General','PorTrabajador') NOT NULL,
  `FechaGeneracion` date NOT NULL,
  `Periodo` varchar(50) NOT NULL,
  `RutaArchivo` varchar(255) NOT NULL,
  `ID_Trabajador` int(11) DEFAULT NULL,
  `GeneradoPor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `ID_Rol` int(11) NOT NULL,
  `NombreRol` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`ID_Rol`, `NombreRol`) VALUES
(1, 'Administrador'),
(2, 'Trabajador'),
(3, 'Seguridad');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trabajador`
--

CREATE TABLE `trabajador` (
  `ID_Trabajador` int(11) NOT NULL,
  `ID_Usuario` int(11) DEFAULT NULL,
  `Area` varchar(100) DEFAULT NULL,
  `Cargo` varchar(100) DEFAULT NULL,
  `TipoTurno` varchar(50) NOT NULL,
  `Horario` varchar(100) DEFAULT NULL,
  `Observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `trabajador`
--

INSERT INTO `trabajador` (`ID_Trabajador`, `ID_Usuario`, `Area`, `Cargo`, `TipoTurno`, `Horario`, `Observaciones`) VALUES
(1, 3, 'Comercial y Ventas', 'Coordinador comercial', 'Regular', 'Lunes - Viernes 08:00:00 - 16:00:00', ''),
(2, 4, 'Atencion al Cliente', 'Cajero', 'Regular', 'Lunes - Viernes 08:00:00 - 16:00:00', ''),
(3, NULL, 'Marketing y Comunicación', 'Community manager', 'Regular', 'Lunes - Viernes 08:00:00 - 16:00:00', NULL),
(4, NULL, 'Marketing y Comunicación', 'Diseñador gráfico', 'Rotativo', 'Lunes - Sabado 09:00:00 - 18:00:00', NULL),
(5, NULL, 'Comercial y Ventas', 'Ejecutivo de ventas', 'Regular', 'Lunes - Viernes 08:00:00 - 16:00:00', NULL),
(6, NULL, 'Comercial y Ventas', 'Coordinador comercial', 'Rotativo', 'Lunes - Viernes 13:00:00 - 21:00:00', NULL),
(7, NULL, 'Finanzas y Contabilidad', 'Contador', 'Regular', 'Lunes - Viernes 08:00:00 - 16:00:00', NULL),
(8, NULL, 'Finanzas y Contabilidad', 'Analista financiero', 'Rotativo', 'Lunes - Sabado 09:00:00 - 18:00:00', NULL),
(9, NULL, 'Finanzas y Contabilidad', 'Tesorero', 'Regular', 'Lunes - Viernes 08:00:00 - 16:00:00', NULL),
(10, 5, 'Marketing y Comunicacion', 'Community manager', 'Regular', 'Lunes - Viernes 08:00:00 - 16:00:00', ''),
(11, 7, 'Atencion al Cliente', 'Asesor', 'Regular', 'Lunes - Sabado 09:00:00 - 18:00:00', ''),
(12, 2, 'Administración', 'Administrador General', 'Regular', 'Lunes - Viernes 08:00:00 - 16:00:00', 'Rol administrador que tmb registra asistencia'),
(13, 8, 'Tecnologia de la Informacion(TI)', 'Soporte Tecnico', 'Rotativo', 'Lunes - Viernes 08:30:00 - 15:30:00', ''),
(14, 9, 'Tecnologia de la Informacion(TI)', 'Desarrolladores', 'Regular', 'Lunes - Viernes 08:00:00 - 16:00:00', ''),
(15, 10, 'Finanzas y Contabilidad', 'Analista financiero', 'Regular', 'Lunes - Viernes 08:00:00 - 16:00:00', ''),
(16, 11, 'Finanzas y Contabilidad', 'Coordinador comercial', 'Regular', 'Lunes - Sabado 09:00:00 - 18:00:00', ''),
(17, 12, 'Marketing y Comunicacion', 'Diseñador grafico', 'Rotativo', 'Lunes - Viernes 10:00:00 - 19:00:00', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `ID_Usuario` int(11) NOT NULL,
  `Nombre_Completo` varchar(100) NOT NULL,
  `DNI` char(8) NOT NULL,
  `Correo` varchar(100) NOT NULL,
  `Telefono` varchar(15) DEFAULT NULL,
  `Contraseña` varchar(255) NOT NULL,
  `ID_Rol` int(11) DEFAULT NULL,
  `Estado` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`ID_Usuario`, `Nombre_Completo`, `DNI`, `Correo`, `Telefono`, `Contraseña`, `ID_Rol`, `Estado`) VALUES
(2, 'Jose Prieto Huertas', '73739553', 'JoseP@mibanco.com', '904501243', '123456', 1, 'Activo'),
(3, 'Karla Lopez Velez', '76544909', 'karla.lopez@gmail.com', '953672248', '123456', 2, 'Activo'),
(4, 'Jorge Quispe Llanos', '54547981', 'JorgeQl.123@mibanco.com', '976412963', '123456', 2, 'Activo'),
(5, 'Diego Perez Yañez', '67812094', 'DiegoPY@mibanco.com', '954365231', '123456', 2, 'Activo'),
(6, 'Joseph Taype', '12345678', 'seguridad@mibanco.com', '987654321', '123456', 3, 'Activo'),
(7, 'Pablo Yalico guevara', '87654321', 'PabloYG@mibanco.com', '912345643', '123456', 2, 'Activo'),
(8, 'Marcelo Yañez Quiñones', '10101010', 'MarceloYQ@mibanco.com', '923785627', '123456', 2, 'Activo'),
(9, 'Moises Calderon Trejo', '20202020', 'MoisesCT@mibanco.com', '917856482', '123456', 2, 'Activo'),
(10, 'Santos Melgarejo Inga', '30303030', 'SantosMI@mibanco.com', '942378562', '123456', 2, 'Activo'),
(11, 'Gino Palomino Leon', '40404040', 'GinoPL@mibanco.com', '912948791', '123456', 2, 'Activo'),
(12, 'Carlos Yupac Quispe', '50505050', 'CarlosYQ@mibanco.com', '932154987', '123456', 2, 'Activo');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD PRIMARY KEY (`ID_Asistencia`),
  ADD KEY `ID_Trabajador` (`ID_Trabajador`);

--
-- Indices de la tabla `justificacion`
--
ALTER TABLE `justificacion`
  ADD PRIMARY KEY (`ID_Justificacion`),
  ADD KEY `ID_Trabajador` (`ID_Trabajador`);

--
-- Indices de la tabla `reporte`
--
ALTER TABLE `reporte`
  ADD PRIMARY KEY (`ID_Reporte`),
  ADD KEY `ID_Trabajador` (`ID_Trabajador`),
  ADD KEY `GeneradoPor` (`GeneradoPor`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`ID_Rol`);

--
-- Indices de la tabla `trabajador`
--
ALTER TABLE `trabajador`
  ADD PRIMARY KEY (`ID_Trabajador`),
  ADD KEY `ID_Usuario` (`ID_Usuario`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`ID_Usuario`),
  ADD UNIQUE KEY `DNI` (`DNI`),
  ADD KEY `ID_Rol` (`ID_Rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `asistencia`
--
ALTER TABLE `asistencia`
  MODIFY `ID_Asistencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT de la tabla `justificacion`
--
ALTER TABLE `justificacion`
  MODIFY `ID_Justificacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reporte`
--
ALTER TABLE `reporte`
  MODIFY `ID_Reporte` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `ID_Rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `trabajador`
--
ALTER TABLE `trabajador`
  MODIFY `ID_Trabajador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `ID_Usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`ID_Trabajador`) REFERENCES `trabajador` (`ID_Trabajador`);

--
-- Filtros para la tabla `justificacion`
--
ALTER TABLE `justificacion`
  ADD CONSTRAINT `justificacion_ibfk_1` FOREIGN KEY (`ID_Trabajador`) REFERENCES `trabajador` (`ID_Trabajador`);

--
-- Filtros para la tabla `reporte`
--
ALTER TABLE `reporte`
  ADD CONSTRAINT `reporte_ibfk_1` FOREIGN KEY (`ID_Trabajador`) REFERENCES `trabajador` (`ID_Trabajador`),
  ADD CONSTRAINT `reporte_ibfk_2` FOREIGN KEY (`GeneradoPor`) REFERENCES `usuario` (`ID_Usuario`);

--
-- Filtros para la tabla `trabajador`
--
ALTER TABLE `trabajador`
  ADD CONSTRAINT `trabajador_ibfk_1` FOREIGN KEY (`ID_Usuario`) REFERENCES `usuario` (`ID_Usuario`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`ID_Rol`) REFERENCES `rol` (`ID_Rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
