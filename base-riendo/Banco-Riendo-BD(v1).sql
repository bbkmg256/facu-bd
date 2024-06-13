-- Base de datos para banco "Riendo" (v1)

-- NOTA: Hay que agregar algunos datos para ejecutar las consultas realizadas
-- posterior a la creación de la BD.


-- Ejecutar en psql --
-- Creacion de la BD:
-- CREATE DATABASE BANCO_RIENDO WITH OWNER lolwoman; -- Modificar propietario de la BD

-- Ejecutar en pgadmin o psql estando en la BD --
-- Creacion de las tablas:
-- EMPLEADOS --
CREATE TABLE empleado(
	leg_emp SERIAL PRIMARY KEY NOT NULL,
	apellido VARCHAR(10),
	
	nr_suc_afectado INT -- FK de sucursal
);

-- CLIENTES --
CREATE TABLE cliente(
	dni SERIAL PRIMARY KEY NOT NULL,
	apellido VARCHAR(30),
	ciudad VARCHAR(30)
);

-- SUCURSALES --
CREATE TABLE sucursal(
	num_suc SERIAL PRIMARY KEY NOT NULL,
	ciudad VARCHAR(30)
);

-- CUENTAS --
CREATE TABLE cuenta(
	nr_cuenta SERIAL PRIMARY KEY NOT NULL,
	saldo MONEY,

	cliente_dni INT, -- FK de cliente
	nr_suc INT -- FK de sucursal
);

-- MOVIMIENTOS --
CREATE TABLE movimiento(
	num_mov SERIAL PRIMARY KEY NOT NULL,
	monto MONEY,
	fecha DATE,

	num_cuenta INT -- FK de cuenta
);

-- Relacion de las tablas:
-- EMPLEADO X SUCURSAL --
ALTER TABLE empleado
ADD CONSTRAINT fk_empleado_sucursal
FOREIGN KEY (nr_suc_afectado) REFERENCES sucursal(num_suc);

-- CUENTA X CLIENTE y SUCURSAL --
ALTER TABLE cuenta
ADD CONSTRAINT fk_cuenta_cliente
FOREIGN KEY (cliente_dni) REFERENCES cliente(dni),
ADD CONSTRAINT fk_cuenta_sucursal
FOREIGN KEY (nr_suc) REFERENCES sucursal(num_suc);

-- MOVIMIENTO X CUENTA --
ALTER TABLE movimiento
ADD CONSTRAINT fk_movimiento_cuenta
FOREIGN KEY (num_cuenta) REFERENCES cuenta(nr_cuenta);


-- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 --


-- Consultas auxiliares para rellenar al BD de datos:
-- Ingreso datos sucursal --
INSERT INTO sucursal(ciudad)
VALUES
('Apostoles'), -- 1
('Posadas'), -- 2
('Obera'), -- 3
('Eldorado'), -- 4
('Iguazu'); -- 5

-- Ingreso datos empleado --
INSERT INTO empleado(apellido, nr_suc_afectado)
VALUES
('Pérez', 1),
('Gómez', 2),
('López', 3),
('García', 4),
('Martínez', 5),
('Díaz', 3),
('Rodríguez', 2),
('Romero', 1),
('Álvarez', 1),
('Flores', 1),
('Castro', 5),
('Vega', 3),
('Arias', 3),
('Gutiérrez', 4),
('Blanco', 5),
('Fernández', 5);

-- Ingreso datos cliente --
INSERT INTO cliente(apellido, ciudad)
VALUES
('Pérez', 'Apostoles'),
('Gómez', 'Rosario'),
('López', 'Posadas'),
('García', 'Rosario'),
('Martínez', 'Posadas'),
('Díaz', 'Apostoles'),
('Rodríguez', 'Apostoles'),
('Romero', 'Rosario'),
('Álvarez', 'Posadas'),
('Flores', 'Rosario'),
('Castro', 'Apostoles'),
('Vega', 'Apostoles'),
('Arias', 'Posadas'),
('Gutiérrez', 'Apostoles'),
('Blanco', 'Rosario'),
('Fernández', 'Rosario'),
('Ojeda', 'Posadas'),
('Ramírez', 'Apostoles'),
('Vera', 'Posadas'),
('Domínguez', 'Posadas');

-- Ingreso datos cuenta --
INSERT INTO cuenta(saldo, cliente_dni, nr_suc)
VALUES
(1500, 1, 1), -- 1
(5678.90, 2, 2), -- 2
(9012.34, 3, 3), -- 3
(2345.67, 4, 3), -- 4
(6789.01, 5, 1), -- 5
(85214, 8, 2), -- 6
(4567.89, 4, 5), -- 7
(8901.23, 8, 4), -- 8
(3345.67, 4, 5), -- 9
(7789.01, 2, 1), -- 10
(8000, 11, 3), -- 11
(1534.56, 20, 1); -- 12

-- Ingreso datos movimiento --
INSERT INTO movimiento(monto, fecha, num_cuenta)
VALUES
(10, '2013-01-25', 5),
(567.89, '2013-01-24', 5),
(901.23, '2013-02-23', 4),
(234.56, '2013-02-22', 3),
(567.89, '2013-02-21', 2),
(901.23, '2013-02-20', 1),
(234.56, '2013-02-19', 10),
(567.89, '2014-02-18', 9),
(902, '2014-04-17', 8),
(567.89, '2014-04-15', 6),
(901.23, '2014-04-14', 5),
(234.56, '2014-04-13', 4),
(234.56, '2014-12-16', 7),
(567.89, '2016-06-12', 3),
(9000, '2016-06-11', 2),
(234.56, '2016-06-10', 11),
(567.89, '2016-06-09', 10),
(901.23, '2016-06-08', 9),
(234, '2016-06-07', 8),
(517.89, '2016-11-06', 7),
(567.89, '2016-11-06', 12),
(667, '2018-10-09', 1),
(567.89, '2024-10-09', 2),
(111, '2024-10-09', 4),
(2, '2024-10-09', 1);
