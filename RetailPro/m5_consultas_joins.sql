-- PRE-ENTREGA 5: CONSULTAS CON JOINS
-- Base de datos: Ventas_Tech_DB

-- CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN)
-- Proposito: reunir la informacion de ventas,
-- clientes, productos y categorias para Power BI.

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS Cliente,
    c.ciudad AS Ciudad,
    p.nombre_producto AS Producto,
    cat.nombre_categoria AS Categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS Total_Venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria;

    -- Hallazgo: En marzo de 2024 se registraron 10 ventas,
-- con una facturacion total de 6444.00.
-- La informacion permite analizar las ventas
-- por ciudad del cliente y categoria del producto.

-- CONSULTA 2: CLIENTES SIN VENTAS (LEFT JOIN)
-- Proposito: identificar clientes sin compras para
-- que el area de CRM pueda realizar acciones comerciales.

SELECT
    c.nombre AS Cliente,
    c.email AS Email,
    c.fecha_registro AS Fecha_Registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: Los 5 clientes registrados realizaron al menos
-- una compra. Actualmente, CRM no tiene clientes sin ventas
-- para incorporar a una campaña de primera compra.

-- CONSULTA 3: PRODUCTOS SIN VENTAS (LEFT JOIN)
-- Proposito: identificar productos sin movimiento
-- para que el area comercial revise el catalogo.

SELECT
    p.nombre_producto AS Producto,
    cat.nombre_categoria AS Categoria,
    p.precio AS Precio
FROM productos p
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: Los 6 productos del catalogo registran
-- al menos una venta. El area de producto no detecta
-- articulos sin movimiento en el periodo analizado.

-- CONSULTA 4: CONSOLIDADO POR PERIODO (UNION ALL)
-- Proposito: comparar la facturacion de dos periodos
-- utilizando una columna de origen creada en la consulta.

SELECT
    canal AS Periodo,
    SUM(total) AS Total_Facturado
FROM (
    SELECT
        cantidad * precio_unitario AS total,
        'Del 5 al 10 de marzo' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-05' AND '2024-03-10'

    UNION ALL

    SELECT
        cantidad * precio_unitario AS total,
        'Del 11 al 15 de marzo' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-11' AND '2024-03-15'
) AS consolidado
GROUP BY canal
ORDER BY Total_Facturado DESC;

-- Hallazgo: Del 5 al 10 de marzo se facturaron
-- 3620.00, frente a 2824.00 del 11 al 15.
-- El primer periodo genero 796.00 mas en ventas.
