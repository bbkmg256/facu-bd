
-- [TP 2] --

-- NOTA: Tp todavía no terminado!

-- Resolucion del tp 2 (Consultas varias):
-- B.1
-- Vista "Carga cliente" (2.1)
CREATE OR REPLACE VIEW vista_carga_cliente
AS
	INSERT INTO cliente(dni, apellido, cod_ciudad)
	VALUES (15333888, 'Fernández', 'Obera');

-- Vista "Carga cuenta" (2.2)
CREATE OR REPLACE VIEW vista_cargar_cuenta
AS
	INSERT INTO cuenta(nr_cuenta, saldo, cliente_dni, nr_suc)
	VALUES (512, 1000, 15333888, 3);

-- Vista "Cargar movimiento" (2.3)
CREATE OR REPLACE VIEW vista_cargar_mov
AS
	INSERT INTO movimiento(monto, fecha, num_cuenta, cod_op_tip)
	VALUES (1000, NOW(), 528);

-- Vista "Incrementar saldo a cuenta" (2.4)
CREATE OR REPLACE VIEW vista_increm_saldo_cuenta
AS
	UPDATE cuenta SET saldo += 300
	WHERE nr_cuenta = 410;

-- Vista "Descontar saldo de cuenta" (2.5)
CREATE OR REPLACE VIEW vista_descont_saldo_cuenta
AS
	UPDATE cuenta SET saldo -= 700
	WHERE nr_cuenta = 325 AND saldo >= 700;

-- Vista "Listado de cuentas de suc 2 y 3" (2.6)
CREATE OR REPLACE VIEW vista_cuentas_suc
AS
	SELECT * FROM cuenta
	WHERE nr_suc BETWEEN 2 AND 3
	ORDER BY nr_suc;

-- Vista "Listar cantidad de cuentas con saldo menor a" (2.7)
CREATE OR REPLACE VIEW vista_cuentas_saldo_menor
AS
	SELECT nr_suc, COUNT(nr_cuenta) AS cuentas
	FROM cuenta
	WHERE saldo < 700
	GROUP BY nr_suc
	ORDER BY nr_suc;

-- Vista "Sumatoria de saldo de cuentas de suc 2 y 3" (2.8)
CREATE OR REPLACE VIEW vista_saldo_sum_cuentas_suc
AS
	SELECT nr_suc, SUM(saldo) AS sueldo_cuentas
	FROM cuenta
	WHERE nr_suc BETWEEN 2 AND 3
	GROUP BY nr_suc;

-- Vista "Lista cuentas con mas de 3 movimientos entre A y B fechas" (2.9)
CREATE OR REPLACE VIEW vista_cuentas_mov_x3 
AS 
	SELECT *
	FROM cuenta
	WHERE nr_cuenta IN (
		SELECT num_cuenta
		FROM movimiento
		WHERE fecha BETWEEN '2013-03-16' AND '2018-02-20'
		GROUP BY num_cuenta
		HAVING COUNT(num_cuenta) > 3
	);

-- Vista "Cantidad de clientes correspondientes a ciudades que no empiezan con letra A y tienen mas de 3 clientes" (2.10)
CREATE OR REPLACE VIEW vista_cant_cli_ciud
AS
	SELECT ciudad, COUNT(dni) AS cant_cli
	FROM cliente
	INNER JOIN ciudad ON cod_ciud = cod_ciudad
	WHERE ciudad NOT LIKE 'A%'
	GROUP BY ciudad
	HAVING COUNT(dni) >= 3;

-- Vista "Listas cuentas de sucursal 4 con movs. entre A y B fechas" (2.11)
CREATE OR REPLACE VIEW vista_cuent_suc_movs_fech
AS
	SELECT *
	FROM cuenta
	WHERE nr_suc = 4 AND nr_cuenta IN (
		SELECT num_cuenta
		FROM movimiento
		WHERE fecha BETWEEN '2013-02-20' AND '2016-06-11'
	); -- Las fechas están tomadas al azar (Ya que no se especificaba en el tp anterior)

-- Vista "Listar clientes con cunetas en x sucursal y saldo mayor a 1000" (2.12)
CREATE OR REPLACE VIEW vista_cli_cuent_suc
AS
	SELECT *
	FROM cliente
	WHERE dni IN (
		SELECT cliente_dni
		FROM cuenta
		WHERE nr_suc = 7 AND saldo > 1000
	);

-- Vista "Listar cuentas con clientes residentes de Apóstoles" (2.13)
CREATE OR REPLACE VIEW vista_cuent_cli_ubic
AS
	SELECT *
	FROM cuenta
	WHERE cliente_dni IN (
		SELECT dni
		FROM cliente
		WHERE cod_ciudad IN (
			SELECT cod_ciud
			FROM ciudad
			WHERE ciudad = 'Apostoles'
		)
	);

-- Vistas punto 2.14 (JOINS para 2.11 - 2.12 - 2.13)
CREATE OR REPLACE VIEW vista_obtener_cuent_suc_mov_join
AS
	SELECT cuenta.*
	FROM cuenta
	INNER JOIN movimiento ON num_cuenta = nr_cuenta
	WHERE nr_suc = 4 AND fecha BETWEEN '2013-02-20' AND '2016-06-11'; -- Las fechas están tomadas al azar (Ya que no se especificaba en el tp anterior)

CREATE OR REPLACE VIEW vista_obtener_cli_cuent_suc_sal_mayor_join
AS
	SELECT cliente.*
	FROM cliente
	INNER JOIN cuenta on cliente_dni = dni
	WHERE nr_suc = 7 AND saldo > 1000;

CREATE OR REPLACE VIEW vista_obtener_cli_ciud_join
AS
	SELECT cuenta.*
	FROM cuenta
	INNER JOIN cliente on dni = cliente_dni
	WHERE ciudad = 'Apóstoles';

-- Vista "Seleccionar los movimientos de las cuentas de mayor saldo en sucursal 4" (2.15)
CREATE OR REPLACE VIEW vista_obtener_mov_max_saldo_suc
AS
	SELECT movimiento.* FROM movimiento
	INNER JOIN cuenta
	ON cuenta.nr_cuenta = movimiento.num_cuenta
	INNER JOIN (
		SELECT cuenta.nr_suc, MAX(cuenta.saldo) AS saldo_max FROM cuenta
		WHERE cuenta.nr_suc = 4 GROUP BY cuenta.nr_suc
	) AS cuent_saldo_max
	ON cuent_saldo_max.nr_suc = cuenta.nr_suc
	WHERE cuenta.saldo >= cuent_saldo_max.saldo_max;

-- Vista "Seleccionar clientes con cuentas en sucursal de Posadas" (2.16)
CREATE OR REPLACE VIEW vista_obtener_cli_con_cuenta_en
AS
	SELECT cliente.* FROM cliente
	INNER JOIN cuenta
	ON cuenta.cliente_dni = cliente.dni
	INNER JOIN sucursal
	ON sucursal.num_suc = cuenta.nr_suc
	WHERE sucursal.cod_ciudad = (SELECT cod_ciud FROM ciudad WHERE ciudad = 'Posadas' LIMIT 1)
	GROUP BY cliente.dni;


-- B.2 (Vistas)
-- 2.a

-- 2.b
-- Muestra la cantidad cuentas que tiene cada cliente
CREATE OR REPLACE VIEW vista_cliente_count
AS
	SELECT cliente.dni, COUNT(cuenta.nr_cuenta)
	FROM cliente
	INNER JOIN cuenta ON cliente_dni = dni
	GROUP BY dni;

-- Muestra cuantos movimientos son de tipo haber y debe
CREATE OR REPLACE VIEW vista_movimiento_count
AS
	SELECT op_cod, COUNT(num_mov)
	FROM movimiento
	INNER JOIN operacion ON cod_op = op_cod
	GROUP BY op_cod;

-- Muestra cuantos departamentos tiene Misiones
CREATE OR REPLACE VIEW vista_ciudad_count
AS
	SELECT provincia.provincia, COUNT(ciudad.cod_ciud)
	FROM ciudad
	INNER JOIN provincia ON cod_prov = cod_provincia
	WHERE provincia.provincia = 'Misiones'
	GROUP BY provincia.provincia;

-- 2.c
-- Muestra el monto total de los movimiento realizados por
-- los clientes con apellidos empezados por R
CREATE OR REPLACE VIEW vista_movimientos_sub
AS
	SELECT monto
	FROM movimiento
	WHERE num_cuenta IN (
		SELECT nr_cuenta
		FROM cuenta
		WHERE cliente_dni IN (
			SELECT dni
			FROM cliente
			WHERE apellido LIKE 'R%' -- Apellido que comienza con R
		)
	);

-- Muestra la o las sucursales con mas empleados
CREATE OR REPLACE VIEW vista_sucursal_max
AS
	SELECT suc.num_suc AS num_sucursal, COUNT(emp.leg_emp) AS num_empleado
	FROM sucursal suc
	INNER JOIN empleado emp ON nr_suc_afectado = num_suc
	GROUP BY num_sucursal
	HAVING COUNT(emp.leg_emp) = (
		SELECT MAX(emp_max) -- Selecciona la cantidad maxima de empleados encontrada en las sucs.
		FROM (
			SELECT nr_suc_afectado, COUNT(leg_emp) AS emp_max -- Cuenta todos los empleados por suc
			FROM empleado
			GROUP BY nr_suc_afectado
		)
	);

-- Muestra los clientes que no son de una ciudad que contenga la letra e y que no tienen una cuenta
CREATE OR REPLACE VIEW vista_clientes_not_in
AS
	SELECT *
	FROM cliente
	WHERE dni NOT IN (
		SELECT cliente_dni
		FROM cuenta
	)
	AND cod_ciudad IN (
		SELECT cod_ciud
		FROM ciudad
		WHERE ciudad NOT LIKE '%e%' -- Ciudades que no contienen e.
	);

-- C.1
-- Cliente ABM
CREATE OR REPLACE FUNCTION abm_cargar_cliente(apellido_cli VARCHAR(30), ciudad_cod INT)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO cliente(apellido, cod_ciudad)
		VALUES (apellido_cli, ciudad_cod);
		RAISE NOTICE '(ÉXITO) Cliente cargado';
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION abm_modificar_cliente(apellido_cli VARCHAR(30), ciudad_cod INT, dni_cli INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE cliente
		SET apellido = apellido_cli,
		cod_ciudad = ciudad_cod
		WHERE dni = dni_cli;
		RAISE NOTICE '(ÉXITO) Cliente % modificado', dni_cli;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION abm_eliminar_cliente(dni_cli INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM cliente
		WHERE dni = dni_cli;
		RAISE NOTICE '(ÉXITO) Cliente % eliminado', dni_cli;
	END
$$ LANGUAGE 'plpgsql';

-- Cuenta ABM
CREATE OR REPLACE FUNCTION abm_cargar_cuenta(valor_saldo MONEY, cli_dni INT, suc_nr INT, tipo_cuenta INT)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO cuenta(saldo, cliente_dni, nr_suc, tip_cuent)
		VALUES (valor_saldo, cli_dni, suc_nr, tipo_cuenta);
		RAISE NOTICE '(ÉXITO) Cuenta cargada!';
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION abm_modificar_cuenta(valor_saldo MONEY, cli_dni INT, suc_nr INT, tipo_cuenta INT, id_cuenta INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE cuenta
		SET saldo = valor_saldo,
		cliente_dni = cli_dni,
		nr_suc = suc_nr,
		tip_cuent = tipo_cuenta
		WHERE nr_cuenta = id_cuenta;
		RAISE NOTICE '(ÉXITO) Cuenta % modificada', id_cuenta;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION abm_eliminar_cuenta(id_cuenta INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM cuenta
		WHERE nr_cuenta = id_cuenta;
		RAISE NOTICE '(ÉXITO) Cuenta % eliminada', id_cuenta;
	END
$$ LANGUAGE 'plpgsql';

-- Sucursal ABM
CREATE OR REPLACE FUNCTION abm_cargar_sucursal(cod_ciud VARCHAR(30))
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO sucursal(cod_ciudad)
		VALUES (cod_ciud);
		RAISE NOTICE '(ÉXITO) Sucursal cargada!';
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION abm_modificar_sucursal(cod_ciud VARCHAR(30), suc_num INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE sucursal
		SET cod_ciudad = cod_ciud
		WHERE num_suc = suc_num;
		RAISE NOTICE '(ÉXITO) Sucursal % modificada', suc_num;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION abm_eliminar_sucursal(suc_num INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM sucursal
		WHERE num_suc = suc_num;
		RAISE NOTICE '(ÉXITO) Sucursal % eliminada', suc_num;
	END
$$ LANGUAGE 'plpgsql';

-- Empleado ABM
CREATE OR REPLACE FUNCTION abm_cargar_empleado(emp_nomb VARCHAR(30), emp_apell VARCHAR(30), ingreso_fecha DATE, categ_cod INT, ciudad_cod INT)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO empleado(nombre, apellido, fecha_ingreso, cod_categ, cod_ciudad)
		VALUES (emp_nomb , emp_apell, ingreso_fecha, categ_cod, ciudad_cod);
		RAISE NOTICE '(ÉXITO) Empleado cargado!'
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION abm_modificar_empleado(emp_nomb VARCHAR(30), emp_apell VARCHAR(30), ingreso_fecha DATE, categ_cod INT, ciudad_cod INT, id_emp INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE empleado
		SET nombre = emp_nomb,
		apellido = emp_apell,
		fecha_ingreso = ingreso_fecha,
		cod_categ = categ_cod,
		cod_ciudad = ciudad_cod,
		WHERE emp_leg = id_emp;
		RAISE NOTICE '(ÉXITO) Empleado % modificado', id_emp;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION abm_eliminar_empleado(id_emp INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM empleado
		WHERE leg_emp = id_emp;
		RAISE NOTICE '(ÉXITO) Empleado % eliminado', id_emp;
	END
$$ LANGUAGE 'plpgsql';

-- Ciudad ABM
CREATE OR REPLACE FUNCTION abm_cargar_ciudad(nomb_ciudad VARCHAR(30), cod_prov INT)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO ciudad(ciudad, cod_provincia)
		VALUES (nomb_ciudad, cod_prov);
		RAISE NOTICE '(ÉXITO) Ciudad cargada';
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION abm_modificar_ciudad(nomb_ciudad VARCHAR(30), cod_prov INT, id_ciudad INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE ciudad
		SET ciudad = nomb_ciudad,
		cod_provincia = cod_prov
		WHERE cod_ciud = id_ciudad;
		RAISE NOTICE '(ÉXITO) Ciudad % modificada', id_ciudad;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION abm_eliminar_ciudad(id_ciudad INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM ciudad
		WHERE cod_ciud = id_ciudad;
		RAISE NOTICE '(ÉXITO) Ciudad % eliminada', id_ciudad;
	END
$$ LANGUAGE 'plpgsql';

-- Provincia ABM
CREATE OR REPLACE FUNCTION abm_cargar_provincia(nomb_prov VARCHAR(30))
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO provincia(provincia)
		VALUES (nomb_prov);
		RAISE NOTICE '(ÉXITO) Provincia cargada';
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION abm_modificar_provincia(nombre_prov VARCHAR(30), id_prov INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE provincia
		SET provincia = nombre_prov
		WHERE cod_prov = id_prov;
		RAISE NOTICE '(ÉXITO) Provincia % modificada', id_prov;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION abm_eliminar_provincia(id_prov INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM provincia
		WHERE cod_prov = id_prov;
		RAISE NOTICE '(ÉXITO) Provincia % eliminada', id_prov;
	END
$$ LANGUAGE 'plpgsql';

-- C.2

-- C.3
-- ABM cliente --
-- Alta
CREATE OR REPLACE FUNCTION cargar_cliente(cli_dni INT, apell VARCHAR(30), cod_ciud INT)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO cliente(dni, apellido, cod_ciudad)
		VALUES (cli_dni, apell, cod_ciud)
	END
$$ LANGUAGE 'plpgsql';

-- Modificación (apellido, cod_ciudad)
CREATE OR REPLACE FUNCTION modificar_apellido_cli(dato_nuevo VARCHAR(30), cli_id INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE cliente
		SET apellido = dato_nuevo
		WHERE dni = cli_id;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_ciudad_cli(dato_nuevo INT, cli_id INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE cliente
		SET cod_ciudad = dato_nuevo
		WHERE dni = cli_id; 
	END
$$ LANGUAGE 'plpgsql';

-- Baja
CREATE OR REPLACE FUNCTION eliminar_cliente(cli_dni INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM cliente
		WHERE dni = cli_dni
	END
$$ LANGUAGE 'plpgsql';

-- ABM cuenta --
-- Alta
CREATE OR REPLACE FUNCTION cargar_cuenta(num_cuent INT, monto_sald MONEY, cli_dni INT, num_suc INT, tipo_cuenta INT)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO cuenta(nr_cuenta, saldo, cliente_dni, nr_suc, tip_cuent)
		VALUES (num_cuent, monto_sald, cli_dni, num_suc, tipo_cuenta)
	END
$$ LANGUAGE 'plpgsql';

-- Modificacion (saldo, cliente_dni, nr_suc, tip_cuent)
CREATE OR REPLACE FUNCTION modificar_saldo_cuenta(dato_nuevo MONEY, cuenta_id INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE cuenta
		SET saldo = dato_nuevo
		WHERE nr_cuenta = cuenta_id;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_cliente_cuenta(dato_nuevo INT, cuenta_id INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE cuenta
		SET cliente_dni = dato_nuevo
		WHERE nr_cuenta = cuenta_id;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_sucursal_cuenta(dato_nuevo INT, cuenta_id INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE cuenta
		SET nr_suc = dato_nuevo
		WHERE nr_cuenta = cuenta_id;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_tipo_cuenta_cuenta(dato_nuevo INT, cuenta_id INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE cuenta
		SET tip_cuent = dato_nuevo
		WHERE nr_cuenta = cuenta_id;
	END
$$ LANGUAGE 'plpgsql';

-- Baja
CREATE OR REPLACE FUNCTION eliminar_cuenta(num_cuent INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM cuenta
		WHERE nr_cuenta = num_cuent
	END
$$ LANGUAGE 'plpgsql';

-- ABM sucursal --
-- Alta
CREATE OR REPLACE FUNCTION cargar_sucursal(cod_suc INT, cod_ciud INT)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO sucursal(num_suc, cod_ciudad)
		VALUES (cod_suc, cod_ciud)
	END
$$ LANGUAGE 'plpgsql';

-- Modificación (cod_ciudad)
CREATE OR REPLACE FUNCTION modificar_ciudad_sucursal(dato_nuevo INT, suc_id INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE sucursal
		SET cod_ciudad = dato_nuevo
		WHERE num_suc = suc_id;
	END
$$ LANGUAGE 'plpgsql';

-- Baja
CREATE OR REPLACE FUNCTION eliminar_sucursal(cod_suc INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM sucursal
		WHERE num_suc = cod_suc
	END
$$ LANGUAGE 'plpgsql';

-- ABM empleado --
-- Alta
CREATE OR REPLACE FUNCTION cargar_empleado(legajo INT, nomb VARCHAR(30), apell VARCHAR(30), nr_suc INT, fech_ingreso DATE, categ INT, ciudad INT)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO empleado(leg_emp, nombre, apellido, nr_suc_afectado, fecha_ingreso, cod_categ, cod_ciudad)
		VALUES (legajo, nomb, apell, nr_suc, fech_ingreso, categ, ciudad)
	END
$$ LANGUAGE 'plpgsql';

-- Modificación (nombre, apellido, nr_suc_afectado, fecha_ingreso, cod_categ, cod_ciudad)
CREATE OR REPLACE FUNCTION modificar_nombre_empleado(dato_nuevo VARCHAR(30), empleado_id INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE empleado
		SET nombre = dato_nuevo
		WHERE leg_emp = empleado_id
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_apellido_empleado(dato_nuevo VARCHAR(30), empleado_id INT
RETURNS VOID
AS $$
	BEGIN
		UPDATE empleado
		SET apellido = dato_nuevo
		WHERE leg_emp = empleado_id
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_suc_empleado(dato_nuevo INT, empleado_id INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE empleado
		SET nr_suc_afectado = dato_nuevo
		WHERE leg_emp = empleado_id
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_fecha_ingreso_empleado(dato_nuevo DATE, empleado_id INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE empleado
		SET fecha_ingreso = dato_nuevo
		WHERE leg_emp = empleado_id
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_categoria_empleado(dato_nuevo INT, empleado_id INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE empleado
		SET cod_categ = dato_nuevo
		WHERE leg_emp = empleado_id
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_ciudad_empleado(dato_nuevo INT, empleado_id INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE empleado
		SET cod_ciudad = dato_nuevo
		WHERE leg_emp = empleado_id
	END
$$ LANGUAGE 'plpgsql';

-- Baja
CREATE OR REPLACE FUNCTION eliminar_empleado(legajo INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM empleado
		WHERE leg_emp = legajo
	END
$$ LANGUAGE 'plpgsql';

-- ABM ciudad --
-- Alta
CREATE OR REPLACE FUNCTION cargar_ciudad(id_ciudad INT, nombre_ciudad VARCHAR(30), id_provincia INT)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO ciudad(cod_ciud, ciudad, cod_provincia)
		VALUES (id_ciudad, nombre_ciudad, id_provincia
	END
$$ LANGUAGE 'plpgsql';

-- Modificacón (ciudad, cod_provincia)
CREATE OR REPLACE FUNCTION modificar_ciudad_ciudad(dato_nuevo VARCHAR(30), id_ciudad INT) -- Refiriendo a el nombre
RETURNS VOID
AS $$
	BEGIN
		UPDATE ciudad
		SET ciudad = dato_nuevo
		WHERE cod_ciud = id_ciudad
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_provincia_ciudad(dato_nuevo INT, id_ciudad INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE ciudad
		SET cod_provincia = dato_nuevo
		WHERE cod_ciud = id_ciudad
	END
$$ LANGUAGE 'plpgsql';

-- Baja
CREATE OR REPLACE FUNCTION eliminar_ciudad(id_ciudad INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM ciudad
		WHERE cod_ciud = id_ciudad
	END
$$ LANGUAGE 'plpgsql';

-- ABM provincia --
-- Alta
CREATE OR REPLACE FUNCTION cargar_provincia(id_prov INT, nombre_prov VARCHAR(30))
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO provincia(cod_prov, provincia)
		VALUES (id_prov, nombre_prov
	END
$$ LANGUAGE 'plpgsql';

-- Modificación (provincia)
CREATE OR REPLACE FUNCTION modificar_provincia_provincia(dato_nuevo VARCHAR(30), id_prov INT) -- Refiriendo al nombre de provincia
RETURNS VOID
AS $$
	BEGIN
		UPDATE provincia
		SET provincia = dato_nuevo
		WHERE cod_prov = id_prov
	END
$$ LANGUAGE 'plpgsql';

-- Baja
CREATE OR REPLACE FUNCTION eliminar_provincia(id_prov INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM provincia
		WHERE cod_prov = id_prov
	END
$$ LANGUAGE 'plpgsql';

-- ABM movimiento --
-- Alta
CREATE OR REPLACE FUNCTION cargar_movimiento(id_mov INT, valor_monto MONEY, fecha_mov DATE, id_op_tip INT, id_cuenta INT)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO movimiento(num_mov, monto, fecha, cod_op_tip, num_cuenta)
		VALUES (id_mov, valor_monto, fecha_mov, id_op_tip, id_cuenta)
	END
$$ LANGUAGE 'plpgsql';

-- Movimiento (monto, fecha, cod_op_tip, num_cuenta)
CREATE OR REPLACE FUNCTION modificar_monto_movimiento(dato_nuevo MONEY, id_mov INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE movimiento
		SET monto
		WHERE num_mov = id_mov
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_fecha_movimiento(dato_nuevo DATE, id_mov INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE movimiento
		SET fecha = dato_nuevo
		WHERE num_mov = id_mov
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_tipo_operacion_movimiento(dato_nuevo INT, id_mov INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE movimiento
		SET cod_op_tip = dato_nuevo
		WHERE num_mov = id_mov
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_cuenta_movimiento(dato_nuevo INT, id_mov INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE movimiento
		SET num_cuenta = dato_nuevo
		WHERE num_mov = id_mov
	END
$$ LANGUAGE 'plpgsql';

-- Baja
CREATE OR REPLACE FUNCTION eliminar_movimiento(id_mov INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM movimiento
		WHERE num_mov = id_mov
	END
$$ LANGUAGE 'plpgsql';

-- ABM categoria --
-- Alta
CREATE OR REPLACE FUNCTION cargar_categoria(id_categ INT, categ VARCHAR(30), valor_sueldo MONEY)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO categoria(cod_categ, nombre_categ, sueldo)
		VALUES (id_categ, categ, valor_sueldo)
	END
$$ LANGUAGE 'plpgsql';

-- Modificacion (nombre_categ, sueldo)
CREATE OR REPLACE FUNCTION modificar_nombre_categoria(dato_nuevo VARCHAR(30), id_categ INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE categoria
		SET nombre_categ = dato_nuevo
		WHERE cod_categ = id_categ
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_sueldo_categoria(dato_nuevo MONEY, id_categ INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE categoria
		SET saldo = dato_nuevo
		WHERE cod_categ = id_categ
	END
$$ LANGUAGE 'plpgsql';

-- Baja
CREATE OR REPLACE FUNCTION eliminar_categoria(id_categ INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM categoria
		WHERE cod_categ = id_categ
	END
$$ LANGUAGE 'plpgsql';

-- ABM operacion --
-- Alta
CREATE OR REPLACE FUNCTION cargar_operacion(id_op INT, op_tipo CHAR(5), descrip_op_tipo VARCHAR(30))
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO operacion(cod_op, tipo_op, descrip_tipo_op)
		VALUES (id_op, op_tipo, descrip_op_tipo)
	END
$$ LANGUAGE 'plpgsql';

-- Modificacion (tipo_op, descrip_tipo_op)
CREATE OR REPLACE FUNCTION modificar_tipo_operacion(dato_nuevo CHAR(5), id_op INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE operacion
		SET tipo_op = dato_nuevo
		WHERE cod_op = id_op
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_descripcion_operacion(dato_nuevo varchar(30), id_op INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE operacion
		SET descrip_tipo_op = dato_nuevo
		WHERE cod_op = id_op
	END
$$ LANGUAGE 'plpgsql';

-- Baja
CREATE OR REPLACE FUNCTION eliminar_operacion(id_op INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM operacion
		WHERE cod_op = id_op
	END
$$ LANGUAGE 'plpgsql';

-- ABM tipo_operacion --
-- Alta
CREATE OR REPLACE FUNCTION cargar_tipo_operacion(id_tipo_op INT, oper VARCHAR(30), id_op INT)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO tipo_operacion(cod_tipo_op, operacion, codigo_op)
		VALUES (id_tipo_op, oper, id_op)
	END
$$ LANGUAGE 'plpgsql';

-- Modificacion (operacion, codigo_op)
CREATE OR REPLACE FUNCTION modificar_operacion_tipo_operacion(dato_nuevo VARCHAR(30), id_tipo_op INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE tipo_operacion
		SET tipo_operacion = dato_nuevo
		WHERE tipo_cod_tipo_op = id_tipo_op
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_cod_operacion_tipo_operacion(dato_nuevo INT, id_tipo_op INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE tipo_operacion
		SET tipo_codigo_op = dato_nuevo
		WHERE tipo_cod_tipo_op = id_tipo_op
	END
$$ LANGUAGE 'plpgsql';

-- Baja
CREATE OR REPLACE FUNCTION eliminar_tipo_operacion(id_tipo_op INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM tipo_operacion
		WHERE tipo_cod_tipo_op = id_tipo_op
	END
$$ LANGUAGE 'plpgsql';

-- ABM tipo_cuenta --
-- Alta
CREATE OR REPLACE FUNCTION cargar_tipo_cuenta(id_tipo_cuenta INT, descrip VARCHAR(30), valor_tasa DECIMAL)
RETURNS VOID
AS $$
	BEGIN
		INSERT INTO tipo_cuenta(tipo_cuenta, descripcion, tasa)
		VALUES (id_tipo_cuenta, descrip, valor_tasa)
	END
$$ LANGUAGE 'plpgsql';

-- Modificacion (descripcion, tasa)
CREATE OR REPLACE FUNCTION modificar_descripcion_tipo_cuenta(dato_nuevo VARCHAR(30), id_tipo_cuenta INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE tipo_cuenta
		SET tipo_descripcion = dato_nuevo
		WHERE tipo_tipo_cuenta = id_tipo_cuenta
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION modificar_tasa_tipo_cuenta(dato_nuevo DECIMAL, id_tipo_cuenta INT)
RETURNS VOID
AS $$
	BEGIN
		UPDATE tipo_cuenta
		SET tipo_tasa = dato_nuevo
		WHERE tipo_tipo_cuenta = id_tipo_cuenta
	END
$$ LANGUAGE 'plpgsql';

-- Baja
CREATE OR REPLACE FUNCTION eliminar_tipo_cuenta(id_tipo_cuenta INT)
RETURNS VOID
AS $$
	BEGIN
		DELETE FROM tipo_cuenta
		WHERE tipo_tipo_cuenta = id_tipo_cuenta;
	END
$$ LANGUAGE 'plpgsql';

-- C.4
-- PS cuenta
CREATE OR REPLACE FUNCTION insertar_cuenta(id_cuenta INT, valor_saldo MONEY, dni_cli INT, id_suc INT , cuenta_tipo INT)
RETURNS VOID
AS $$
	BEGIN		
		-- Comprueba que el id a ingresar no este ya cargado
		IF EXISTS (SELECT 1 FROM cuenta WHERE nr_cuenta = id_cuenta) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) La cuenta ya existe en la tabla!';
		END IF;

		-- Comprueba la existencia de cliente en la tabla cliente
		IF NOT EXISTS (SELECT 1 FROM cliente WHERE dni = dni_cli) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El dni de cliente no existe en la tabla cliente!'
		END IF;

		-- Comprueba la existencia de la sucursal en la tabla sucursal
		IF NOT EXISTS (SELECT 1 FROM sucursal WHERE num_suc = id_suc) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El número de sucursal no existe en la tabla sucursal!';
		END IF;

		IF NOT EXISTS (SELECT 1 FROM tipo_cuenta WHERE tipo_tipo_cuenta = cuenta_tipo) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El tipo de cuenta indicado no existe en la tabla tipo_cuenta!';
		END IF;
		
		INSERT INTO cuenta(nr_cuenta, saldo, cliente_dni, nr_suc, tip_cuent)
		VALUES (id_cuenta, valor_saldo, dni_cli, id_suc, cuenta_tipo);
	END
$$ LANGUAGE 'plpgsql';

-- PS cliente
CREATE OR REPLACE FUNCTION insertar_cliente(dni_cli INT, apellido_cli VARCHAR(30), ciudad_cli INT)
RETURNS VOID
AS $$
	BEGIN
		-- Comprueba cliente
		IF EXISTS (SELECT 1 FROM cliente WHERE dni = dni_cli) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El cliente ya existe en la tabla!';
		END IF;

		-- Comprueba ciudad
		IF NOT EXISTS (SELECT 1 FROM ciudad WHERE cod_ciud = ciudad_cli) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El codigo de ciudad no existe en la tabla ciudad!';
		END IF;

		INSERT INTO cliente(dni, apellido, cod_ciudad)
		VALUES (dni_cli, apellido_cli, ciudad_cli);
	END
$$ LANGUAGE 'plpgsql';

-- PS sucursal
CREATE OR REPLACE FUNCTION insertar_sucursal(id_suc INT, ciudad INT)
RETURNS VOID
AS $$
	BEGIN
		-- Comprueba la sucursal
		IF EXISTS (SELECT 1 FROM sucursal WHERE num_suc = id_suc) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) La sucursal ya existe en la tabla sucursal!';
		END IF;

		-- Comprueba la ciudad
		IF NOT EXISTS (SELECT 1 FROM ciudad WHERE cod_ciud = ciudad) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El codigo de ciudad  no existe en la tabla ciudad';
		END IF;

		INSERT INTO sucursal(num_suc, cod_ciudad)
		VALUES (id_suc, ciudad);
	END
$$ LANGUAGE 'plpgsql';

-- PS empleado
CREATE OR REPLACE FUNCTION insertar_empleado(id_emp INT, emp_nombre VARCHAR(30), emp_apellido VARCHAR(30), fech_ingreso DATE, categoria INT, ciudad INT, sucursal INT)
RETURNS VOID
AS $$
	BEGIN
		-- Comprueba empleado
		IF NOT EXISTS (SELECT 1 FROM empleado WHERE leg_emp = id_emp) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El empleado ya se encuentra en la tabla empleado!';
		END IF;

		-- Comprueba categoria
		IF EXISTS (SELECT 1 FROM categoria WHERE cod_categ = categoria) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) La categoria no se encuentra en la tabla categoria!';
		END IF;

		-- Comprueba ciudad
		IF EXISTS (SELECT 1 FROM ciudad WHERE cod_ciud = ciudad) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El codigo de ciudad no se encuentra en la tabla ciudad!';
		END IF;

		-- Comprueba sucursal
		IF EXISTS (SELECT 1 FROM sucursal WHERE num_suc = sucursal) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El codigo de sucursal no se encuentra en la tabla sucursal!';
		END IF;

		INSERT INTO empleado(leg_emp, nombre, apellido, fecha_ingreso, cod_categ, cod_ciudad, nr_suc_afectado)
		VALUES (id_emp, emp_nombre, emp_apellido, fech_ingreso, categoria, ciudad, sucursal);
	END
$$ LANGUAGE 'plpgsql';

-- PS provincia
CREATE OR REPLACE FUNCTION insertar_provincia(id_prov INT, prov VARCHAR(30))
RETURNS VOID
AS $$
	BEGIN
		-- Comprueba la provincia (no por nombre)
		IF EXISTS (SELECT 1 FROM provincia WHERE cod_prov = id_prov) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) La provincia ya existe el la tabla provincia!';
		END IF;

		INSERT INTO provincia(cod_prov, provincia)
		VALUES (id_prov, prov);
	END
$$ LANGUAGE 'plpgsql';

-- PS movimiento
CREATE OR REPLACE FUNCTION insertar_movimiento(id_mov INT, monto_mov MONEY, fecha_mov DATE, id_cuenta INT, id_op_cod INT)
RETURNS VOID
AS $$
	BEGIN
		-- Comprueba movimiento
		IF EXISTS (SELECT 1 FROM movimiento WHERE num_mov = id_mov) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El movimiento ya se encuentra en la tabla movimiento!';
		END IF;

		-- Comprueba cuenta
		IF NOT EXISTS (SELECT 1 FROM cuenta WHERE nr_cuenta = id_cuenta) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El id de cuenta no se encuentra en la tabla cuenta!';
		END IF;

		-- Comprueba operacion
		IF EXISTS (SELECT 1 FROM operacion WHERE cod_op = id_op_cod) THEN
			-- Comprueba que si la operacion es de tipo debe y si la cuenta no pose saldo suficiente
			IF (SELECT tipo_op FROM operacion WHERE cod_op = id_op_cod) = 'Debe' THEN
				IF (SELECT saldo FROM cuenta WHERE nr_cuenta = id_cuenta) < monto_mov THEN
					RAISE EXCEPTION USING MESSAGE = '(ERROR) La cuenta no posee el saldo suficiente para una transaccion del tipo debe!';
				END IF;
			END IF;
		ELSE
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El tipo de cuenta no se encuentra en la tabla tipo_cuenta!';
		END IF;

		INSERT INTO movimiento(num_mov, monto, fecha, num_cuenta, op_cod)
		VALUES (id_mov, monto_mov, fecha_mov, id_cuenta, id_op_cod);

		-- Para mov. Debe, decrementa saldo en cuenta
		IF (SELECT tipo_op FROM operacion WHERE cod_op = id_op_cod) = 'Debe' THEN
			UPDATE cuenta SET saldo = saldo - monto_mov
			WHERE nr_cuenta = id_cuenta;
		-- Para mov. Haber, incrementa saldo en cuenta
		ELSE
			UPDATE cuenta SET saldo = saldo + monto_mov
			WHERE nr_cuenta = id_cuenta;
		END IF;
	END
$$ LANGUAGE 'plpgsql';

-- PS tipo cuenta
CREATE OR REPLACE FUNCTION insertar_tipo_cuenta(id_tipo_cuenta INT, descrp VARCHAR(30), valor_tasa DECIMAL)
RETURNS VOID
AS $$
	BEGIN
		-- Comprueba tipo_cuenta
		IF EXISTS (SELECT 1 FROM tipo_cuenta WHERE tipo_tipo_cuenta = id_tipo_cuenta) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El tipo de cuenta ya existe en la tabla tipo_cuenta!';
		END IF;

		INSERT INTO tipo_cuenta(tipo_cuenta, descripcion, tasa)
		VALUES (id_tipo_cuenta, descrp, valor_tasa);
	END
$$ LANGUAGE 'plpgsql';

-- PS ciudad
CREATE OR REPLACE FUNCTION insertar_ciudad(id_ciudad INT, nombre_ciudad VARCHAR(30), id_prov INT)
RETURNS VOID
AS $$
	BEGIN
		-- Comprueba ciudad
		IF EXISTS (SELECT 1 FROM ciudad WHERE cod_ciud = id_ciudad) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) La ciudad ya existe en la tabla ciudad!';
		END IF;

		-- Comprueba provincia
		IF NOT EXISTS (SELECT 1 FROM provincia WHERE cod_prov = id_prov) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El codigo de provincia no existe en la tabla provincia!';
		END IF;

		INSERT INTO ciudad(cod_ciud, ciudad, cod_provincia)
		VALUES (id_ciudad, nombre_ciudad, id_prov);
	END
$$ LANGUAGE 'plpgsql';

-- PS tipo operacion
CREATE OR REPLACE FUNCTION insertar_tipo_operacion(id_tipo_op INT, oper VARCHAR(30), id_op INT)
RETURNS VOID
AS $$
	BEGIN
		-- Si el codigo o la operacion (texto) en si se encuentran en la tabla, exceptua.
		IF EXISTS (SELECT 1 FROM tipo_operacion WHERE tipo_cod_tipo_op = id_tipo_op) OR EXISTS (SELECT 1 FROM tipo_operacion WHERE tipo_operacion = oper) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El codigo o el tipo de operacion ya existe en la tabla tipo_operacion!';
		END IF;

		-- Compreba la operacion de la tabla operacion xd
		IF NOTT EXISTS (SELECT 1 FROM operacion WHERE cod_op = id_op) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) La operacion no existe en la tabla operacion!';
		END IF;

		INSERT INTO tipo_operacion(cod_tipo_op, operacion, codigo_op)
		VALUES (id_tipo_op, oper, id_op);
	END
$$ LANGUAGE 'plpgsql';

-- PS operacion
CREATE OR REPLACE FUNCTION insertar_operacion(id_op INT, op_tipo CHAR(5), tipo_op_descrip VARCHAR(30))
RETURNS VOID
AS $$
	BEGIN
		-- Comprueba el codigo y el tipo de operacion dentro de la tabla operacion xd
		IF EXISTS (SELECT 1 FROM operacion WHERE cod_op = id_op) || EXISTS (SELECT 1 FROM operacion WHERE tipo_op = op_tipo) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El codigo y/o el tipo de operacion ya se encuentra en la tabla operacion!';
		END IF;

		INSERT INTO operacion(cod_op, tipo_op, descrip_tipo_op)
		VALUES (id_op, op_tipo, tipo_op_descrip);
	END
$$ LANGUAGE 'plpgsql';

-- PS categoria
CREATE OR REPLACE FUNCTION insertar_categoria(id_categ INT, categ_nombre VARCHAR(30), valor_sueldo MONEY)
RETURNS VOID
AS $$
	BEGIN
		IF EXISTS (SELECT 1 FROM categoria WHERE cod_categ = id_categ) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) La categoria ya existe en la tabla categoria!';
		END IF;

		INSERT INTO categoria(cod_categ, nombre_categ, sueldo)
		VALUES (id_categ, categ_nombre, valor_sueldo);
	END
$$ LANGUAGE 'plpgsql';

-- D.1
-- Funciones
CREATE OR REPLACE FUNCTION exec_log_insert_cuenta() -- Se ejecuta post insert en cuenta
RETURNS TRIGGER
AS $$
	BEGIN
		INSERT INTO log_trigger_cuenta_insert(nr_cuenta, saldo, tip_cuent, cliente_dni, nr_suc, fecha_insercion)
		VALUES (NEW.nr_cuenta, NEW.saldo, NEW.tip_cuent, NEW.cliente_dni, NEW.nr_suc, NOW());
		RETURN NEW;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION exec_log_update_cuenta() -- Se ejecuta pre update en cuenta
RETURNS TRIGGER
AS $$
	BEGIN
		INSERT INTO log_trigger_cuenta_update(nr_cuenta, saldo, tip_cuent, cliente_dni, nr_suc, fecha_cambio)
		VALUES (OLD.nr_cuenta, OLD.saldo, OLD.tip_cuent, OLD.cliente_dni, OLD.nr_suc, NOW());
		RETURNS NEW;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION exec_log_insert_movimiento()
RETURNS TRIGGER
AS $$
	BEGIN
		INSERT INTO log_trigger_movimiento_insert(num_mov, monto, fecha, op_cod, num_cuenta, fecha_insercion)
		VALUES (NEW.num_mov, NEW.monto, NEW.fecha, NEW.op_cod, NEW.num_cuenta, NOW());
		RETURN NEW;
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION exec_log_update_movimiento()
RETURN TRIGGER
AS $$
	BEGIN
		INSERT INTO log_trigger_movimiento_update(num_mov, monto, fecha, op_cod, num_cuenta, fecha_insercion)
		VALUES (OLD.num_mov, OLD.monto, OLD.fecha, OLD.op_cod, OLD.num_cuenta, NOW());
		RETURN NEW;
	END
$$ LANGUAGE 'plpgsql';

-- Triggers
CREATE OR REPLACE TRIGGER tr_cuenta_insert
AFTER INSERT ON cuenta
FOR EACH ROW
EXECUTE PROCEDURE exec_log_insert_cuenta();

CREATE OR REPLACE TRIGGER tr_cuenta_update
BEFORE UPDATE ON cuenta
FOR EACH ROW
EXECUTE PROCEDURE exec_log_update_cuenta();

CREATE OR REPLACE TRIGGER tr_movimiento_insert
AFTER INSERT ON movimiento
FOR EACH ROW
EXECUTE PROCEDURE exec_log_insert_movimiento();

CREATE OR REPLACE TRIGGER tr_movimiento_update
BEFORE UPDATE ON movimiento
FOR EACH ROW
EXECUTE PROCEDURE exec_log_update_movimiento();

-- D.2
-- Funcion
CREATE OR REPLACE FUNCTION exec_aumentar_saldo_cuenta()
RETURNS TRIGGER
AS $$
	BEGIN
		-- Comprobar que el movimiento o el codigo de mov. no exista en la tabla
		IF EXISTS (SELECT 1 FROM movimiento WHERE num_mov = NEW.num_mov) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El movimiento o el codigo de mov. ya existe en la tabla!';
		END IF;

		-- Comprobar que el numero de cuenta no exista en tabla cuenta
		IF NOT EXISTS (SELECT 1 FROM cuenta WHERE nr_cuenta = NEW.num_cuenta) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El numero de cuenta no se encuentra en la tabla cuenta!';
		END IF;

		-- Comprobar operacion valida
		IF NOT EXISTS (SELECT 1 FROM operacion WHERE cod_op = NEW.op_cod) THEN
			RAISE EXCEPTION USING MESSAGE = '(ERROR) El codigo de operacion no existe en la tabla operacion!';
		END IF;

		-- Comprobar si es operacion debe o haber y si el usuario cuenta con el saldo suficiente
		IF (SELECT tipo_op FROM operacion WHERE cod_op = NEW.op_cod) = 'Debe' THEN
			IF (SELECT saldo FROM cuenta WHERE nr_cuenta = NEW.num_cuenta) < NEW.monto THEN
				RAISE EXCEPTION USING MESSAGE = '(ERROR) El saldo de la cuenta ingresada no es suficiente para la operacion!';
			END IF;
			UPDATE cuenta
			SET saldo = saldo - NEW.monto -- Para debitar
			WHERE nr_cuenta = NEW.num_cuenta;
		ELSE
			UPDATE cuenta
			SET saldo = saldo + NEW.monto -- Para acreditar
			WHERE nr_cuenta = NEW.num_cuenta;
		END IF;		
		RETURN NEW;
	END
$$ LANGUAGE 'plpgsql';

-- Trigger
CREATE OR REPLACE TRIGGER tr_movimiento_insert -- Mismo nombre pero diferente funcion a ejecutar...
BEFORE INSERT ON movimiento
FOR EACH ROW
EXECUTE PROCEDURE exec_aumentar_saldo_cuenta();