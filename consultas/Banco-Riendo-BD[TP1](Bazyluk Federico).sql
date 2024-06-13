
-- [TP 1] --

-- Resolucion del tp 1 (Consultas varias):
-- 2.1
CREATE OR REPLACE FUNCTION cargar_cliente(dni INT, apell VARCHAR(30), ciud VARCHAR(30))
RETURNS INT
AS $$
	BEGIN
		INSERT INTO cliente(dni, apellido, ciudad)
		VALUES (dni, apell, ciud);
		RETURN 0;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM cargar_cliente(1234, 'Bazyluk', 'San Pedro');

-- 2.2
CREATE OR REPLACE FUNCTION cargar_cuenta(cuenta, sald, cliente, suc)
RETURNS INT
AS $$
	BEGIN
		INSERT INTO cuenta(nr_cuenta, saldo, cliente_dni, nr_suc)
		VALUES (cuenta, sald, cliente, suc);
		RETURN 0;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM cargar_cuenta(512, 1000, 15333888, 3);

-- 2.3
CREATE OR REPLACE FUNCTION cargar_movimiento(mont MONEY, fech DATE, cuent INT)
RETURNS INT
AS $$
	BEGIN
		INSERT INTO movimiento(monto, fecha, num_cuenta)
		VALUES (mont, fech, cuent);
		RETURN 0;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM cargar_movimiento(1000, NOW(), 528);

-- 2.4
CREATE OR REPLACE FUNCTION aumentar_saldo_cuenta(mont MONEY, num_cuent INT)
RETURNS INT
AS $$
	BEGIN
		UPDATE cuenta SET cuenta.saldo = cuenta.saldo + mont
		WHERE cuenta.nr_cuenta = num_cuent;
		RETURN 0;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM aumentar_saldo_cuenta(CAST(300 AS MONEY), 410);

-- 2.5
CREATE OR REPLACE FUNCTION descontar_saldo_cuenta(mont MONEY, num_cuent INT)
RETURNS INT
AS $$
	BEGIN
		UPDATE cuenta SET cuenta.saldo = cuenta.saldo - mont
		WHERE cuenta.nr_cuenta = num_cuent AND cuenta.saldo >= mont;
		RETURN 0;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM descontar_saldo_cuenta(CAST(700 AS MONEY), 325);

-- 2.6
CREATE OR REPLACE FUNCTION obtener_lista_cuentas(suc INT)
RETURNS TABLE(
	cuenta INT,
	val_saldo MONEY,
	cliente INT,
	sucursal INT
) AS $$
	BEGIN
		RETURN QUERY
		SELECT * FROM cuenta
		WHERE cuenta.nr_suc = suc
		ORDER BY cuenta.nr_suc;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM obtener_lista_cuentas(2); SELECT * FROM obtener_lista_cuentas(3);

-- 2.7
CREATE OR REPLACE FUNCTION cant_cuent_saldo_menor_a(monto MONEY)
RETURNS TABLE(
	cuenta INT,
	cantidad_cuentas INT
) AS $$
	BEGIN
		RETURN QUERY
		SELECT cuenta.nr_suc, COUNT(cuenta.nr_cuenta) AS cant_cuentas
		FROM cuenta
		WHERE cuenta.saldo < monto
		GROUP BY cuenta.nr_suc
		ORDER BY cuenta.nr_suc;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM cant_cuent_saldo_menor_a(CAST(2000 AS MONEY));

-- 2.8
CREATE OR REPLACE FUNCTION obtener_suma_saldo(suc INT)
RETURNS TABLE(
	num_suc INT,
	suma_saldo MONEY
) AS $$
	BEGIN
		RETURN QUERY
		SELECT cuenta.nr_suc, SUM(cuenta.saldo) FROM cuenta
		WHERE cuenta.nr_suc = suc
		GROUP BY cuenta.nr_suc;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM obtener_suma_saldo(2); SELECT * FROM obtener_suma_saldo(3);

-- 2.9
CREATE OR REPLACE FUNCTION obtener_cuent_mov(fecha_a DATE, fecha_b DATE, num_cuent INT)
RETURNS TABLE(
	cnt INT
) AS $$
	BEGIN
		RETURN QUERY
		SELECT movimiento.num_cuenta FROM movimiento
		WHERE movimiento.fecha BETWEEN fecha_a AND fecha_b
		GROUP BY movimiento.num_cuenta HAVING COUNT(movimiento.num_cuenta) >= num_cuent;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM obtener_cuentas_x3_mov('2013-03-16', '2018-02-20', 3);

-- 2.10
CREATE OR REPLACE FUNCTION obtener_cant_cli_ciudad_no_letr(letr VARCHAR(2), num_cli INT)
RETURNS TABLE(
	ciud VARCHAR(30),
	cant_cuents INT
) AS $$
	BEGIN
		RETURN QUERY
		SELECT cliente.ciudad, CAST(COUNT(cliente.dni) AS INT)
		FROM cliente
		WHERE cliente.ciudad NOT LIKE letr
		GROUP BY cliente.ciudad
		HAVING COUNT(cliente.dni) >= num_cli;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM obtener_cant_cli_ciudad_no_letr('A%', 3);

-- 2.11
CREATE OR REPLACE FUNCTION obtener_cuent_suc_mov(sucr INT, fecha_a VARCHAR(30), fecha_b VARCHAR(30))
RETURNS TABLE(
	cuent INT,
	sald MONEY,
	cli INT,
	suc INT
) AS $$
	DECLARE
		fech_A DATE;
		fech_B DATE;
	BEGIN
		fech_A := CAST(fecha_a AS DATE);
		fech_B := CAST(fecha_b AS DATE);
		
		RETURN QUERY
		SELECT cuenta.nr_cuenta, cuenta.saldo, cuenta.cliente_dni, cuenta.nr_suc FROM cuenta
		INNER JOIN (SELECT * FROM movimiento 
					WHERE movimiento.fecha BETWEEN fech_A AND fech_B)
		ON num_cuenta = cuenta.nr_cuenta WHERE cuenta.nr_suc = sucr;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
--SELECT * FROM obtener_cuent_suc_mov(4, '2013-02-05', '2016-01-02');

-- 2.12
CREATE OR REPLACE FUNCTION obtener_cli_cuent_suc_sal_mayor(sald MONEY, suc INT)
RETURNS TABLE(
	dni INT,
	apell VARCHAR(30),
	ciud VARCHAR(30)
) AS $$
	BEGIN
		RETURN QUERY
		SELECT cliente.dni, cliente.apellido, cliente.ciudad FROM cliente
		INNER JOIN (SELECT cuenta.cliente_dni FROM cuenta WHERE cuenta.nr_suc = suc AND cuenta.saldo > sald)
		ON cliente_dni = cliente.dni;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM obtener_cli_cuent_suc_sal_mayor(CAST(1000 AS MONEY), 7);

-- 2.13
CREATE OR REPLACE FUNCTION obtener_cli_ciud(ciud VARCHAR(30))
RETURNS TABLE(
	cuent INT,
	sald MONEY,
	cli INT,
	suc INT
) AS $$
	BEGIN
		RETURN QUERY
		SELECT cuenta.nr_cuenta, cuenta.saldo, cuenta.cliente_dni, cuenta.nr_suc FROM cuenta
		INNER JOIN (SELECT cliente.dni FROM cliente WHERE cliente.ciudad = ciud)
		ON dni = cuenta.cliente_dni; 
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM obtener_cli_ciud('Apóstoles');

-- 2.14 (INNER JOIN para "2.11", "2.12" y "2.13")
CREATE OR REPLACE FUNCTION obtener_cuent_suc_mov(sucr INT, fecha_a VARCHAR(30), fecha_b VARCHAR(30)) -- 2.11
RETURNS TABLE(
	cuent INT,
	sald MONEY,
	cli INT,
	suc INT	
) AS $$
	DECLARE
		a_fecha DATE;
		b_fecha DATE;
	BEGIN
		a_fecha := CAST(fecha_a TO DATE); b_fecha := CAST(fecha_b TO DATE);
		
		SELECT cuenta.*
		FROM cuenta
		INNER JOIN movimiento ON num_cuenta = nr_cuenta
		WHERE nr_suc = sucr AND fecha BETWEEN fecha_a AND fecha_b;
		RETURN QUERY;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION obtener_cli_cuent_suc_sal_mayor(sald MONEY, suc INT) -- 2.12
RETURNS TABLE(
	dni INT,
	apell VARCHAR(30),
	ciud VARCHAR(30)	
) AS $$
	BEGIN
		SELECT cliente.*
		FROM cliente
		INNER JOIN cuenta on cliente_dni = dni
		WHERE nr_suc = suc AND saldo > 1000;
		RETURN QUERY;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION obtener_cli_ciud(ciud VARCHAR(30)) -- 2.13
RETURNS TABLE(
	cuent INT,
	sald MONEY,
	cli INT,
	suc INT
) AS $$
	BEGIN
		SELECT cuenta.*
		FROM cuenta
		INNER JOIN cliente on dni = cliente_dni
		WHERE ciudad = ciud;
		RETURN QUERY;
	END
$$ LANGUAGE 'plpgsql';

-- 2.15
CREATE OR REPLACE FUNCTION obtener_mov_max_saldo_suc(suc INT)
RETURN TABLE(
	num_mov INT,
	monto_mov MONEY,
	fecha_mov DATE,
	num_cuent INT
) AS $$
	BEGIN
		RETURN QUERY
		SELECT movimiento.* FROM movimiento
		INNER JOIN cuenta
		ON cuenta.nr_cuenta = movimiento.num_cuenta
		INNER JOIN (
			SELECT cuenta.nr_suc, MAX(cuenta.saldo) AS saldo_max FROM cuenta
			WHERE cuenta.nr_suc = suc GROUP BY cuenta.nr_suc
		) AS cuent_saldo_max
		ON cuent_saldo_max.nr_suc = cuenta.nr_suc
		WHERE cuenta.saldo >= cuent_saldo_max.saldo_max;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM obtener_mov_max_saldo_suc(4);

-- 2.16
CREATE OR REPLACE FUNCTION obtener_cli_con_cuenta_en(lugar VARCHAR(30))
RETURNS TABLE(
	cli_dni INT,
	cli_apellido VARCHAR(30),
	cli_ciudad VARCHAR(30)
) AS $$
	BEGIN
		RETURN QUERY
		SELECT cliente.* FROM cliente
		INNER JOIN cuenta
		ON cuenta.cliente_dni = cliente.dni
		INNER JOIN sucursal
		ON sucursal.num_suc = cuenta.nr_suc
		WHERE sucursal.ciudad = lugar
		GROUP BY cliente.dni;
	END
$$ LANGUAGE 'plpgsql';
-- Llamada:
-- SELECT * FROM obtener_cli_con_cuenta_en('Posadas');

-- 2.17
-- Propuesta de enunciados:

-- UPDATE --
-- 1:
-- Descontar el saldo de todas las cuenta en la sucursal
-- número 4 a 10000 si su saldo actual es mayor a 3000.
UPDATE cuenta
SET cuenta.saldo = cuenta.saldo - 10000
WHERE cuenta.nr_suc = 4 AND cuenta.saldo > 3000;

-- 2:
-- Actualizar la fecha de movimiento de todas las movimiento
-- con numero de movimiento entre 5 y 10 a la fecha actual.
UPDATE movimiento
SET movimiento.fecha = NOW()
WHERE movimiento.num_mov BETWEEN 5 AND 10;

-- Operadores (LIKE, BETWEEN, GROUP, etc) --
-- 1:
-- Encontrar todas las cuentas con un saldo
-- mayor a 5000 y que pertenezcan a la sucursal número 3.
SELECT * FROM cuenta
WHERE saldo > 5000 AND nr_suc = 3;

-- 2:
-- Encontrar todas las movimiento donde la fecha de movimiento
-- esté entre '2013-02-01' y '2016-05-02'.
SELECT * FROM movimiento
WHERE movimiento.fecha BETWEEN '2013-02-01' AND '2016-05-02';

-- JOINS --
-- 1:
-- Obtener los movimientos de las cuentas de la sucursar 5:
SELECT movimiento.* FROM movimiento
INNER JOIN cuenta
ON cuenta.nr_cuenta = movimiento.num_cuenta
INNER JOIN (
	SELECT * FROM sucursal
	WHERE sucursal.num_suc = 5) AS sucal
ON sucal.num_suc = cuenta.nr_suc;