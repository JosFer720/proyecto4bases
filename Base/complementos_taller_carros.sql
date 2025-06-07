-- 1. Trigger para disminuir el stock del repuesto al agregarlo a una orden
CREATE OR REPLACE FUNCTION restar_stock_repuesto()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE repuesto
  SET stock = stock - NEW.cantidad
  WHERE id_repuesto = NEW.id_repuesto;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_restar_stock
AFTER INSERT ON repuesto_orden
FOR EACH ROW
EXECUTE FUNCTION restar_stock_repuesto();

-- 2. Trigger para registrar cambios en ordenes en la bitácora
CREATE OR REPLACE FUNCTION registrar_cambio_orden()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO bitacora_cambio(tabla_afectada, id_registro, accion)
  VALUES ('orden_reparacion', NEW.id_orden, TG_OP);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_bitacora_orden
AFTER UPDATE ON orden_reparacion
FOR EACH ROW
EXECUTE FUNCTION registrar_cambio_orden();

-- 3. Trigger para evitar facturación de órdenes no finalizadas
CREATE OR REPLACE FUNCTION validar_factura_finalizada()
RETURNS TRIGGER AS $$
DECLARE
  estado_actual TEXT;
BEGIN
  SELECT estado INTO estado_actual FROM orden_reparacion WHERE id_orden = NEW.id_orden;
  IF estado_actual <> 'Finalizada' THEN
    RAISE EXCEPTION 'No se puede facturar una orden que no esté finalizada';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_factura_estado
BEFORE INSERT ON factura
FOR EACH ROW
EXECUTE FUNCTION validar_factura_finalizada();

-- FUNCIONES SQL

-- 1. Función para calcular el total estimado de una orden (servicios + repuestos)
CREATE OR REPLACE FUNCTION calcular_total_estimado(p_id_orden INTEGER)
RETURNS NUMERIC AS $$
DECLARE
  total_servicios NUMERIC := 0;
  total_repuestos NUMERIC := 0;
BEGIN
  SELECT COALESCE(SUM(subtotal), 0) INTO total_servicios
  FROM orden_servicio WHERE id_orden = p_id_orden;

  SELECT COALESCE(SUM(cantidad * precio), 0) INTO total_repuestos
  FROM repuesto_orden ro
  JOIN repuesto r ON ro.id_repuesto = r.id_repuesto
  WHERE id_orden = p_id_orden;

  RETURN total_servicios + total_repuestos;
END;
$$ LANGUAGE plpgsql;

-- 2. Función para obtener el total facturado en un mes
CREATE OR REPLACE FUNCTION total_facturado_mes(anio INTEGER, mes INTEGER)
RETURNS NUMERIC AS $$
DECLARE
  total NUMERIC;
BEGIN
  SELECT COALESCE(SUM(total_facturado), 0) INTO total
  FROM factura
  WHERE EXTRACT(YEAR FROM fecha_emision) = anio
    AND EXTRACT(MONTH FROM fecha_emision) = mes;
  RETURN total;
END;
$$ LANGUAGE plpgsql;


-- VISTAS SQL

-- 1. Vista de órdenes con detalle de cliente y vehículo
CREATE OR REPLACE VIEW vista_ordenes_detalle AS
SELECT o.id_orden, c.nombre AS cliente, v.placa, o.estado, o.total_estimado
FROM orden_reparacion o
JOIN vehiculo v ON o.id_vehiculo = v.id_vehiculo
JOIN cliente c ON v.id_cliente = c.id_cliente;

-- 2. Vista de repuestos con stock bajo
CREATE OR REPLACE VIEW vista_repuestos_bajos AS
SELECT * FROM repuesto
WHERE stock < 5;

-- 3. Vista de facturas con datos de cliente y forma de pago
CREATE OR REPLACE VIEW vista_facturas_completas AS
SELECT f.id_factura, f.fecha_emision, f.total_facturado, f.forma_pago, c.nombre AS cliente, v.placa
FROM factura f
JOIN orden_reparacion o ON f.id_orden = o.id_orden
JOIN vehiculo v ON o.id_vehiculo = v.id_vehiculo
JOIN cliente c ON v.id_cliente = c.id_cliente;
