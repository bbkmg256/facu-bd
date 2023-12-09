
/*
  NOTA: NO MODIFICAR, FICHERO PARA PRACTICAR!
*/

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: db
-- Tiempo de generación: 09-12-2023 a las 08:14:19
-- Versión del servidor: 8.2.0
-- Versión de PHP: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `MIBD`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `AVION`
--

CREATE TABLE `AVION` (
  `codAvion` int NOT NULL,
  `tipo` int DEFAULT NULL,
  `capacidad` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `AVION`
--

INSERT INTO `AVION` (`codAvion`, `tipo`, `capacidad`) VALUES
(1, 1, 148),
(2, 1, 215),
(3, 2, 81),
(4, 3, 458),
(5, 1, 540),
(6, 3, 890),
(7, 1, 622),
(8, 3, 684),
(9, 3, 775),
(10, 2, 327),
(11, 3, 842),
(12, 2, 650),
(13, 2, 74),
(14, 2, 889),
(15, 2, 853),
(16, 1, 69),
(17, 3, 497),
(18, 2, 94),
(19, 3, 87),
(20, 1, 204);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `AVION_BASE`
--

CREATE TABLE `AVION_BASE` (
  `id` int NOT NULL,
  `idAvion` int DEFAULT NULL,
  `idBase` int DEFAULT NULL,
  `fechaHoraIngreso` datetime DEFAULT NULL,
  `fechaHoraSalida` datetime DEFAULT NULL,
  `detalle` char(50) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `nrMant` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `AVION_BASE`
--

INSERT INTO `AVION_BASE` (`id`, `idAvion`, `idBase`, `fechaHoraIngreso`, `fechaHoraSalida`, `detalle`, `nrMant`) VALUES
(1, 8, 18, '2022-09-27 14:30:00', '2022-09-30 15:30:00', '', 62632),
(2, 3, 15, '2022-11-04 23:45:00', '2022-11-09 00:45:00', '', 33139),
(3, 13, 10, '2025-12-23 09:00:00', '2025-12-28 09:00:00', '', 74622),
(4, 2, 15, '2024-04-12 10:15:00', '2024-04-17 10:15:00', '', 10660),
(5, 12, 18, '2025-07-13 12:00:00', '2025-07-18 12:00:00', '', 49561),
(6, 4, 5, '2024-06-09 15:30:00', '2024-06-14 15:30:00', '', 70509),
(7, 18, 20, '2025-07-18 20:45:00', '2025-07-23 20:45:00', '', 17276),
(8, 13, 5, '2023-07-09 08:45:00', '2023-07-14 08:45:00', '', 67127),
(9, 9, 2, '2022-12-03 17:00:00', '2022-12-08 17:00:00', '', 78307),
(10, 12, 1, '2022-12-04 06:00:00', '2022-12-09 06:00:00', '', 53891),
(11, 11, 4, '2023-10-08 11:45:00', '2023-10-13 11:45:00', '', 15926),
(12, 20, 20, '2024-11-05 16:30:00', '2024-11-10 16:30:00', '', 64037),
(13, 12, 20, '2022-05-08 18:00:00', '2022-05-13 18:00:00', '', 32430),
(14, 11, 1, '2022-12-09 07:30:00', '2022-12-14 07:30:00', '', 42317),
(15, 2, 20, '2024-10-25 09:15:00', '2024-10-26 09:15:00', '', 45149),
(16, 8, 5, '2023-07-05 10:10:00', '2023-07-10 10:10:00', '', 55263),
(17, 10, 13, '2025-06-04 22:15:00', '2025-06-09 22:15:00', '', 44910),
(18, 6, 6, '2025-08-08 01:06:00', '2025-08-13 01:06:00', '', 42241),
(19, 12, 10, '2025-12-16 16:30:00', '2025-12-21 16:30:00', '', 60583),
(20, 19, 6, '2025-02-08 17:00:00', '2025-02-13 17:00:00', '', 17344);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `BASE`
--

CREATE TABLE `BASE` (
  `numMant` int NOT NULL,
  `ubicacion` char(20) COLLATE utf8mb3_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `BASE`
--

INSERT INTO `BASE` (`numMant`, `ubicacion`) VALUES
(1, 'Norteamérica'),
(2, 'Centroamérica'),
(3, 'Sudamérica'),
(4, 'Europa'),
(5, 'Asia'),
(6, 'África'),
(7, 'Oceanía'),
(8, 'África del Norte'),
(9, 'África Occidental'),
(10, 'África Central'),
(11, 'África Oriental'),
(12, 'África Austral'),
(13, 'Europa Occidental'),
(14, 'Europa Central'),
(15, 'Europa del Este'),
(16, 'Europa del Norte'),
(17, 'Europa del Sur'),
(18, 'Ártico'),
(19, 'Antártida'),
(20, 'Atlántida');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PILOTO`
--

CREATE TABLE `PILOTO` (
  `codPiloto` int NOT NULL,
  `nombre` char(20) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `apellido` char(20) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `horasVuelo` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `PILOTO`
--

INSERT INTO `PILOTO` (`codPiloto`, `nombre`, `apellido`, `horasVuelo`) VALUES
(1, 'Gabe', 'Newell', 3000),
(2, 'steve', 'wozniak', 800),
(3, 'steve', 'jobs', 20),
(4, 'willi', 'wonka', 10),
(5, 'hanzo', 'hasashi', 150),
(6, 'Juan', 'Perez', 123),
(7, 'Maria', 'Gonzalez', 7),
(8, 'Pedro', 'Rodriguez', 432),
(9, 'Ana', 'Martinez', 76),
(10, 'Luis', 'Sanchez', 75),
(11, 'Camila', 'Alonso', 4),
(12, 'David', 'Lopez', 43),
(13, 'Laura', 'Flores', 2),
(14, 'Daniel', 'Garcia', 321),
(15, 'Valentina', 'Martin', 210),
(16, 'Pablo', 'Torres', 9),
(17, 'Sofia', 'Castro', 97),
(18, 'Alejandro', 'Romero', 7),
(19, 'Mia', 'Perez', 76),
(20, 'Lucas', 'Gonzalez', 654),
(21, 'Emma', 'Martinez', 543);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `TIPO_AVION`
--

CREATE TABLE `TIPO_AVION` (
  `tipoAv` int NOT NULL,
  `tipo` char(20) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `caracteristicas` char(50) COLLATE utf8mb3_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `TIPO_AVION`
--

INSERT INTO `TIPO_AVION` (`tipoAv`, `tipo`, `caracteristicas`) VALUES
(1, 'Transporte', 'Color azul, perteneciente a div. A'),
(2, 'Viaje', 'Color morado, perteneciente a div. B'),
(3, 'Militar', 'Color gris, perteneciente a div. C');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `TRIPULACION`
--

CREATE TABLE `TRIPULACION` (
  `cod_trip` int NOT NULL,
  `nombre` char(20) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `apellido` char(20) COLLATE utf8mb3_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `TRIPULACION`
--

INSERT INTO `TRIPULACION` (`cod_trip`, `nombre`, `apellido`) VALUES
(1, 'Felipe', 'Garcia'),
(2, 'Lucia', 'Lopez'),
(3, 'Diego', 'Rodriguez'),
(4, 'Andrea', 'Martinez'),
(5, 'Esteban', 'Sanchez'),
(6, 'Valentina', 'Alonso'),
(7, 'Santiago', 'Castro'),
(8, 'Paula', 'Flores'),
(9, 'Martin', 'Molina'),
(10, 'Sol', 'Torres'),
(11, 'Nicolas', 'Romero'),
(12, 'Belen', 'Perez'),
(13, 'Ariana', 'Gonzalez'),
(14, 'Tomas', 'Alvarez'),
(15, 'Clara', 'Fernandez'),
(16, 'Daniela', 'Gutierrez');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `VUELO`
--

CREATE TABLE `VUELO` (
  `idVuelo` int NOT NULL,
  `origen` char(20) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `destino` char(20) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `fechaHoraSalida` datetime DEFAULT NULL,
  `fechaHoraLlegada` datetime DEFAULT NULL,
  `codAv` int DEFAULT NULL,
  `codPil` int DEFAULT NULL,
  `duracion` int DEFAULT NULL,
  `tarifa` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `VUELO`
--

INSERT INTO `VUELO` (`idVuelo`, `origen`, `destino`, `fechaHoraSalida`, `fechaHoraLlegada`, `codAv`, `codPil`, `duracion`, `tarifa`) VALUES
(1, 'Japón', 'Chile', '2022-06-10 16:30:00', '2022-06-16 17:30:00', 14, 4, 6, 2170),
(2, 'Argentina', 'EE.UU', '2021-02-06 23:15:00', '2021-02-12 00:15:00', 14, 13, 20, 7138),
(3, 'Argentina', 'Alemania', '2026-11-02 15:00:00', '2026-11-08 16:00:00', 2, 11, 9, 1116),
(4, 'China', 'Inglaterra', '2024-03-27 18:45:00', '2024-03-30 19:45:00', 2, 12, 16, 9241),
(5, 'Huganda', 'Moldavia', '2020-01-15 17:00:00', '2020-01-21 18:00:00', 9, 1, 8, 3180),
(6, 'Ucrania', 'Rusia', '2022-01-24 23:00:00', '2022-01-30 00:00:00', 15, 11, 22, 3052),
(7, 'Rusia', 'Ucrania', '2020-08-21 19:00:00', '2020-08-27 20:00:00', 15, 2, 15, 6772),
(8, 'Italia', 'Uruguay', '2026-12-11 17:00:00', '2026-12-17 18:00:00', 10, 2, 7, 7021),
(9, 'Chile', 'Perú', '2022-03-01 18:00:00', '2022-03-07 19:00:00', 9, 15, 15, 1347),
(10, 'Indonesia', 'México', '2023-12-02 18:30:00', '2023-12-08 19:30:00', 10, 5, 21, 8760),
(11, 'Somalia', 'Nicaragua', '2025-05-02 17:00:00', '2025-05-08 18:00:00', 1, 18, 14, 3072),
(12, 'El Salvador', 'Argentina', '2026-10-25 23:00:00', '2026-10-31 00:00:00', 15, 19, 11, 3875),
(13, 'Argentina', 'El Salvador', '2021-04-26 23:00:00', '2021-04-30 00:00:00', 2, 8, 11, 6660),
(14, 'Argentina', 'Japón', '2021-07-20 17:00:00', '2021-07-26 18:00:00', 8, 11, 23, 6324),
(15, 'Dinamarca', 'Brasil', '2021-12-13 20:00:00', '2021-12-19 21:00:00', 4, 20, 15, 4416),
(16, 'Noruega', 'España', '2024-12-28 21:00:00', '2024-12-29 22:00:00', 18, 9, 10, 7826),
(17, 'Bolivia', 'Venezuela', '2025-05-13 19:00:00', '2025-05-19 20:00:00', 3, 20, 14, 9367),
(18, 'Venezuela', 'Rusia', '2025-01-12 18:00:00', '2025-01-18 19:00:00', 19, 19, 8, 3556),
(19, 'EE.UU', ' Rusia', '2024-11-26 20:00:00', '2024-11-28 21:00:00', 16, 20, 18, 6696),
(20, 'EE.UU', 'Argentina', '2021-07-24 16:00:00', '2021-07-24 17:00:00', 16, 6, 21, 8433);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `VUELO_TRIPULACION`
--

CREATE TABLE `VUELO_TRIPULACION` (
  `id` int NOT NULL,
  `idVuelo` int DEFAULT NULL,
  `idTripulacion` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `VUELO_TRIPULACION`
--

INSERT INTO `VUELO_TRIPULACION` (`id`, `idVuelo`, `idTripulacion`) VALUES
(1, 7, 5),
(2, 4, 9),
(3, 3, 14),
(4, 2, 1),
(5, 16, 13),
(6, 1, 10),
(7, 13, 8),
(8, 4, 1),
(9, 3, 4),
(10, 12, 7),
(11, 3, 16),
(12, 11, 7),
(13, 1, 11),
(14, 8, 2),
(15, 19, 13),
(16, 10, 4),
(17, 17, 12),
(18, 13, 6),
(19, 20, 13),
(20, 15, 14);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `AVION`
--
ALTER TABLE `AVION`
  ADD PRIMARY KEY (`codAvion`),
  ADD KEY `fk_AVION_TIPO_AVION_idx` (`tipo`);

--
-- Indices de la tabla `AVION_BASE`
--
ALTER TABLE `AVION_BASE`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_AVION_BASE_AVION_idx` (`idAvion`),
  ADD KEY `fk_AVION_BASE_BASE_idx` (`idBase`);

--
-- Indices de la tabla `BASE`
--
ALTER TABLE `BASE`
  ADD PRIMARY KEY (`numMant`);

--
-- Indices de la tabla `PILOTO`
--
ALTER TABLE `PILOTO`
  ADD PRIMARY KEY (`codPiloto`);

--
-- Indices de la tabla `TIPO_AVION`
--
ALTER TABLE `TIPO_AVION`
  ADD PRIMARY KEY (`tipoAv`);

--
-- Indices de la tabla `TRIPULACION`
--
ALTER TABLE `TRIPULACION`
  ADD PRIMARY KEY (`cod_trip`);

--
-- Indices de la tabla `VUELO`
--
ALTER TABLE `VUELO`
  ADD PRIMARY KEY (`idVuelo`),
  ADD KEY `fk_VUELO_AVION_idx` (`codAv`),
  ADD KEY `fk_VUELO_PILOTO_idx` (`codPil`);

--
-- Indices de la tabla `VUELO_TRIPULACION`
--
ALTER TABLE `VUELO_TRIPULACION`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_VUELO_TRIPULACION_VUELO_idx` (`idVuelo`),
  ADD KEY `fk_VUELO_TRIPULACION_TRIPULACION_idx` (`idTripulacion`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `AVION`
--
ALTER TABLE `AVION`
  MODIFY `codAvion` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT de la tabla `AVION_BASE`
--
ALTER TABLE `AVION_BASE`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `BASE`
--
ALTER TABLE `BASE`
  MODIFY `numMant` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `PILOTO`
--
ALTER TABLE `PILOTO`
  MODIFY `codPiloto` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `TIPO_AVION`
--
ALTER TABLE `TIPO_AVION`
  MODIFY `tipoAv` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `TRIPULACION`
--
ALTER TABLE `TRIPULACION`
  MODIFY `cod_trip` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `VUELO`
--
ALTER TABLE `VUELO`
  MODIFY `idVuelo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `VUELO_TRIPULACION`
--
ALTER TABLE `VUELO_TRIPULACION`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `AVION`
--
ALTER TABLE `AVION`
  ADD CONSTRAINT `fk_AVION_TIPO_AVION` FOREIGN KEY (`tipo`) REFERENCES `TIPO_AVION` (`tipoAv`);

--
-- Filtros para la tabla `AVION_BASE`
--
ALTER TABLE `AVION_BASE`
  ADD CONSTRAINT `fk_AVION_BASE_AVION` FOREIGN KEY (`idAvion`) REFERENCES `AVION` (`codAvion`),
  ADD CONSTRAINT `fk_AVION_BASE_BASE` FOREIGN KEY (`idBase`) REFERENCES `BASE` (`numMant`);

--
-- Filtros para la tabla `VUELO`
--
ALTER TABLE `VUELO`
  ADD CONSTRAINT `fk_VUELO_AVION` FOREIGN KEY (`codAv`) REFERENCES `AVION` (`codAvion`),
  ADD CONSTRAINT `fk_VUELO_PILOTO` FOREIGN KEY (`codPil`) REFERENCES `PILOTO` (`codPiloto`);

--
-- Filtros para la tabla `VUELO_TRIPULACION`
--
ALTER TABLE `VUELO_TRIPULACION`
  ADD CONSTRAINT `fk_VUELO_TRIPULACION_TRIPULACION` FOREIGN KEY (`idTripulacion`) REFERENCES `TRIPULACION` (`cod_trip`),
  ADD CONSTRAINT `fk_VUELO_TRIPULACION_VUELO` FOREIGN KEY (`idVuelo`) REFERENCES `VUELO` (`idVuelo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
