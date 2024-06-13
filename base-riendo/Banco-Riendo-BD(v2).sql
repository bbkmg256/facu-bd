-- Base de datos para banco "Riendo" (v2)

/*
Nota: modificar la carda de datos para la tabla movimiento,
ya que se asocia con operacion y no con tipo_operacion!
*/

-- Ejecutar en psql --
-- Creacion de la BD:
-- CREATE DATABASE BANCO_RIENDO WITH OWNER lolwoman; -- Modificar propietario de la BD

-- Ejecutar en pgadmin o psql estando en la BD --
-- Creacion de las tablas:
-- EMPLEADOS --
CREATE TABLE empleado(
	leg_emp SERIAL PRIMARY KEY NOT NULL, -- PK
	apellido VARCHAR(10),
	/*
	nombre
	fecha_ingreso
	cod_categ
	cod_ciudad
	*/
	
	nr_suc_afectado INT -- FK de sucursal
);

-- CLIENTES --
CREATE TABLE cliente(
	dni SERIAL PRIMARY KEY NOT NULL, -- PK
	apellido VARCHAR(30)
	-- ciudad VARCHAR(30) Ya no aplica
	-- cod_ciudad
);

-- SUCURSALES --
CREATE TABLE sucursal(
	num_suc SERIAL PRIMARY KEY NOT NULL -- PK
	-- ciudad VARCHAR(30) Ya no aplica
	-- cod_ciudad
);

-- CUENTAS --
CREATE TABLE cuenta(
	nr_cuenta SERIAL PRIMARY KEY NOT NULL, -- PK
	saldo MONEY,
	-- tip_cuent

	cliente_dni INT, -- FK de cliente
	nr_suc INT -- FK de sucursal
);

-- MOVIMIENTOS --
CREATE TABLE movimiento(
	num_mov SERIAL PRIMARY KEY NOT NULL, -- PK
	monto MONEY,
	fecha DATE,
	-- op_cod

	num_cuenta INT -- FK de cuenta
);

-- TIPO_CUENTA --
CREATE TABLE tipo_cuenta(
	tipo_cuenta SERIAL PRIMARY KEY NOT NULL, -- PK
	descripcion VARCHAR(30),
	tasa DECIMAL
);

-- TIPO_OPERACION --
CREATE TABLE tipo_operacion(
	cod_tipo_op SERIAL PRIMARY KEY NOT NULL, -- PK
	operacion VARCHAR(30),
	
	codigo_op INT -- FK de operacion
);

-- OPERACION --
CREATE TABLE operacion(
	cod_op SERIAL PRIMARY KEY NOT NULL, -- PK
	tipo_op CHAR(5),
	descrip_tipo_op VARCHAR(30)
);

CREATE TABLE categoria(
	cod_categ SERIAL PRIMARY KEY NOT NULL, --PK
	nombre_categ VARCHAR(30),
	sueldo MONEY
);

CREATE TABLE provincia(
	cod_prov SERIAL PRIMARY KEY NOT NULL, -- PK
	provincia VARCHAR(30)
);

CREATE TABLE ciudad(
	cod_ciud SERIAL PRIMARY KEY NOT NULL, -- PK
	ciudad VARCHAR(30),

	cod_provincia INT -- FK de provincia
);

-- Modificacione de algunas tablas:
-- Modif. empleado
ALTER TABLE empleado
ADD COLUMN nombre VARCHAR(30),
ADD COLUMN fecha_ingreso DATE,
ADD COLUMN cod_categ INT, -- FK de categoria
ADD COLUMN cod_ciudad INT; -- FK de ciudad

-- Modif. cuenta
ALTER TABLE cuenta
ADD COLUMN tip_cuent INT; -- FK de tipo_cuenta

-- Modif. de movimiento
ALTER TABLE movimiento
ADD COLUMN op_cod INT; -- FK de operacion

-- Modif. de sucursal
ALTER TABLE sucursal
ADD COLUMN cod_ciudad INT; -- FK de ciudad

-- Modif. cliente
ALTER TABLE cliente
ADD COLUMN cod_ciudad INT; -- FK de ciudad

-- Relacion de las tablas:
-- EMPLEADO X SUCURSAL --
ALTER TABLE empleado
ADD CONSTRAINT fk_empleado_sucursal
FOREIGN KEY (nr_suc_afectado) REFERENCES sucursal(num_suc) ON DELETE CASCADE;

-- CUENTA X CLIENTE, SUCURSAL y TIPO_CUENTA --
ALTER TABLE cuenta
ADD CONSTRAINT fk_cuenta_cliente
FOREIGN KEY (cliente_dni) REFERENCES cliente(dni) ON DELETE CASCADE,
ADD CONSTRAINT fk_cuenta_sucursal
FOREIGN KEY (nr_suc) REFERENCES sucursal(num_suc) ON DELETE CASCADE,
ADD CONSTRAINT fk_cuenta_tipo_cuenta
FOREIGN KEY (tip_cuent) REFERENCES tipo_cuenta(tipo_cuenta) ON DELETE CASCADE;

-- CIUDAD X PROVINCIA --
ALTER TABLE ciudad
ADD CONSTRAINT fk_ciudad_provincia
FOREIGN KEY (cod_provincia) REFERENCES provincia(cod_prov) ON DELETE CASCADE;

-- TIPO_OPERACION X OPERACION --
ALTER TABLE tipo_operacion
ADD CONSTRAINT fk_tipo_operacion_operacion
FOREIGN KEY (codigo_op) REFERENCES operacion(cod_op) ON DELETE CASCADE;

-- MOVIMIENTO X CUENTA y TIPO_OPERACION --
ALTER TABLE movimiento
ADD CONSTRAINT fk_movimiento_cuenta
FOREIGN KEY (num_cuenta) REFERENCES cuenta(nr_cuenta) ON DELETE CASCADE,
ADD CONSTRAINT fk_movimiento_operacion
FOREIGN KEY (op_cod) REFERENCES operacion(cod_op) ON DELETE CASCADE;

-- SUCURSAL X CIUDAD --
ALTER TABLE sucursal
ADD CONSTRAINT fk_sucursal_ciudad
FOREIGN KEY (cod_ciudad) REFERENCES ciudad(cod_ciud) ON DELETE CASCADE;

-- CLIENTE X CIUDAD --
ALTER TABLE cliente
ADD CONSTRAINT fk_cliente_ciudad
FOREIGN KEY (cod_ciudad) REFERENCES ciudad(cod_ciud) ON DELETE CASCADE;


-- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 --


-- Tablas logs. triggers:

-- Tabla log.insert para cuenta
CREATE TABLE log_trigger_cuenta_insert(
	nr_cuenta INT,
	saldo MONEY,
	tip_cuent INT,
	cliente_dni INT,
	nr_suc INT,
	fecha_insercion DATE
);

-- Tabla log.update para cuenta
CREATE TABLE log_trigger_cuenta_update(
	nr_cuenta INT,
	saldo MONEY,
	tip_cuent INT,
	cliente_dni INT,
	nr_suc INT,
	fecha_cambio DATE
);

-- Tabla log.insert para movimiento
CREATE TABLE log_trigger_movimiento_insert(
	num_mov INT,
	monto MONEY,
	fecha DATE,
	op_cod INT,
	num_cuenta INT,
	fecha_insercion DATE
);

-- Tabla log.update para movimiento
CREATE TABLE log_trigger_movimiento_update(
	num_mov INT,
	monto MONEY,
	fecha DATE,
	op_cod INT,
	num_cuenta INT,
	fecha_cambio DATE
);


-- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 -- 0 --


-- Consultas auxiliares para rellenar la BD de datos:

-- NOTA: En ningun ingreso de datos se especifica los PK,
-- ya que estos son de tipo SERIAL, por ende se generan
-- de forma autoincremental.

-- Ingreso datos tipo_cuenta --
INSERT INTO tipo_cuenta(descripcion, tasa)
VALUES
('Caja de ahorro', 12.5), -- 1
('Cta. corriente', 12.5), -- 2
('Cta. en dolares', 50), -- 3
('Cta. sueldo', 13.5), -- 4
('Cta. seguridad social', 0); -- 5
-- No se tire datos cualquiera

-- Ingreso datos operacion --
INSERT INTO operacion(tipo_op, descrip_tipo_op)
VALUES
('Debe', 'Cliente debe al banco'), -- 1
('Haber', 'Banco debe al cliente'); -- 2

-- Ingreso datos tipo_operacion --
INSERT INTO tipo_operacion(operacion, codigo_op)
VALUES
('Debito', 1),
('Credito', 2),
('Pago tarjeta', 1),
('Cobro sueldo', 2),
('Prestamo', 1),
('Deposito a plazo fijo', 2); -- Creo que el plazo fijo es haber
-- Faltan datos

-- Ingreso datos categoria --
INSERT INTO categoria(nombre_categ, sueldo)
VALUES
('Administrativo', 300.000), -- 1
('Gerente', 400.000), -- 2
('Seguridad', 228.000), -- 3
('Tecnico', 350.000), -- 4
('Sanidad', 120.000); -- 5
-- Metí cualquiera

-- Ingreso datos provincia --
INSERT INTO provincia(provincia)
VALUES
('Misiones'), -- 1
('Buenos Aires'), -- 2
('Tucuman'), -- 3
('Tierra del fuego'), -- 4
('Cordoba'), -- 5
('Entre rios'), -- 6
('Jujuy'), -- 7
('Santa Fe'); -- 8

-- Ingreso datos ciudad --
INSERT INTO ciudad(ciudad, cod_provincia)
VALUES
('Apóstoles', 1), -- 1
('Posadas', 1), -- 2
('Obera', 1), -- 3
('Eldorado', 1), -- 4
('Iguazu', 1), -- 5
('Rosario', 8); -- 6

-- Ingreso datos sucursal --
INSERT INTO sucursal(cod_ciudad) -- Nose si esto sería así, pero ponele xd
VALUES
(1), -- 1
(2), -- 2
(3), -- 3
(4), -- 4
(5); -- 5

-- Ingreso datos empleado --
INSERT INTO empleado(nombre, apellido, nr_suc_afectado, cod_ciudad, fecha_ingreso, cod_categ)
VALUES
('Jorge','Pérez', 1, 1, NOW(), 1), -- 1
('Joaquín','Gómez', 2, 4, NOW(), 1), -- 2
('Yohana','López', 3, 5, NOW(), 2), -- 3
('Yaquelín','García', 4, 1, NOW(), 3), -- 4
('Hernesto','Martínez', 5, 1, NOW(), 3), -- 5
('Germán','Díaz', 3, 3, NOW(), 3), -- 6
('Alejandro','Rodríguez', 2, 3, NOW(), 2), -- 7
('Germán','Romero', 1, 5, NOW(), 2), -- 8
('Javier','Álvarez', 1, 2, NOW(), 3), -- 9
('Samuel','Flores', 1, 1, NOW(), 5), -- 10
('Gimena','Castro', 5, 2, NOW(), 4), -- 11
('Federico','Vega', 3, 2, NOW(), 5), -- 12
('Alejandra','Arias', 3, 4, NOW(), 4), -- 13
('Gonzalo','Gutiérrez', 4, 4, NOW(), 1), -- 14
('Camila','Blanco', 5, 5, NOW(), 1), -- 15
('Belén','Fernández', 5, 5, NOW(), 5); -- 16

-- Ingreso datos cliente --
INSERT INTO cliente(apellido, cod_ciudad)
VALUES
('Pérez', 1), -- 1
('Gómez', 6), -- 2
('López', 2), -- 3
('García', 6), -- 4
('Martínez', 2), -- 5
('Díaz', 1), -- 6
('Rodríguez', 1), -- 7
('Romero', 6), -- 8
('Álvarez', 2), -- 9
('Flores', 6), -- 10
('Castro', 1), -- 11
('Vega', 1), -- 12
('Arias', 2), -- 13
('Gutiérrez', 1), -- 14
('Blanco', 6), -- 15
('Fernández', 6), -- 16
('Ojeda', 2), -- 17
('Ramírez', 1), -- 18
('Vera', 2), -- 19
('Domínguez', 2); -- 20

-- Ingreso datos cuenta --
INSERT INTO cuenta(saldo, cliente_dni, nr_suc, tip_cuent) -- Falta completar la tabla tipo_cuenta para agregar los tipos acá
VALUES
(1500, 1, 1, 1), -- 1
(5678.90, 2, 2, 1), -- 2
(9012.34, 3, 3, 4), -- 3
(2345.67, 4, 3, 3), -- 4
(6789.01, 5, 1, 5), -- 5
(85214, 8, 2, 2), -- 6
(4567.89, 4, 5, 2), -- 7
(8901.23, 8, 4, 2), -- 8
(3345.67, 4, 5, 3), -- 9
(7789.01, 2, 1, 4), -- 10
(8000, 11, 3 ,1), -- 11
(1534.56, 20, 1, 5); -- 12

-- Ingreso datos movimiento --
INSERT INTO movimiento(monto, fecha, num_cuenta, op_cod)
VALUES
(10, '2013-01-25', 5, 1),
(567.89, '2013-01-24', 5, 2),
(901.23, '2013-02-23', 4, 2),
(234.56, '2013-02-22', 3, 2),
(567.89, '2013-02-21', 2, 1),
(901.23, '2013-02-20', 1, 1),
(234.56, '2013-02-19', 10, 1),
(567.89, '2014-02-18', 9, 1),
(902, '2014-04-17', 8, 1),
(567.89, '2014-04-15', 6, 2),
(901.23, '2014-04-14', 5, 2),
(234.56, '2014-04-13', 4, 1),
(234.56, '2014-12-16', 7, 1),
(567.89, '2016-06-12', 3, 1),
(9000, '2016-06-11', 2, 2),
(234.56, '2016-06-10', 11, 2),
(567.89, '2016-06-09', 10, 2),
(901.23, '2016-06-08', 9, 1),
(234, '2016-06-07', 8, 2),
(517.89, '2016-11-06', 7, 2),
(567.89, '2016-11-06', 12, 1),
(17.80, '2016-11-06', 7, 1),
(667, '2018-10-09', 1, 2),
(567.89, '2024-10-09', 2, 1),
(111, '2024-10-09', 4, 2),
(2, '2024-10-09', 1, 2);

-- Pequeña revision --
-- SELECT * FROM cliente;
-- SELECT * FROM cuenta;
-- SELECT * FROM movimiento;
-- SELECT * FROM empleado;
-- SELECT * FROM sucursal;
-- SELECT * FROM ciudad;
-- SELECT * FROM provincia;
-- SELECT * FROM categoria;
-- SELECT * FROM tipo_operacion;
-- SELECT * FROM operacion;
-- SELECT * FROM tipo_cuenta;
