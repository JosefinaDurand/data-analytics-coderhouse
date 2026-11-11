-- PRE-ENTREGA 4: CONSULTAS SQL DE NEGOCIO
-- Base de datos: Ventas_Tech_DB

-- CONSULTA 1: RESUMEN EJECUTIVO MENSUAL

SELECT
    MONTH(fecha_venta) AS Mes,
    SUM(cantidad * precio_unitario) AS Total_Facturado,
    COUNT(*) AS Cantidad_Pedidos,
    CAST(
        SUM(cantidad * precio_unitario) / COUNT(*)
        AS DECIMAL(12,2)
    ) AS Ticket_Promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

-- CONSULTA 2: RANKING DE PRODUCTOS

SELECT TOP 5
    id_producto AS Producto,
    SUM(cantidad) AS Unidades_Vendidas,
    SUM(cantidad * precio_unitario) AS Total_Facturado
FROM ventas
GROUP BY id_producto
ORDER BY Total_Facturado DESC;

-- CONSULTA 3: CLIENTES RECURRENTES

SELECT
    id_cliente AS Cliente,
    COUNT(*) AS Cantidad_Pedidos,
    SUM(cantidad * precio_unitario) AS Total_Gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY Total_Gastado DESC;

-- CONSULTA 4: PRODUCTOS POR ENCIMA O POR DEBAJO DEL PROMEDIO

;WITH FacturacionPorProducto AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS Total_Facturado
    FROM ventas
    GROUP BY id_producto
)

SELECT
    id_producto AS Producto,
    Total_Facturado,
    CASE
        WHEN Total_Facturado > (
            SELECT AVG(Total_Facturado)
            FROM FacturacionPorProducto
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS Comparacion_Promedio
FROM FacturacionPorProducto
ORDER BY Total_Facturado DESC;


-- =============================================
-- HALLAZGOS DEL ANALISIS
-- =============================================

-- 1. En marzo de 2024 se registraron 10 pedidos,
-- con una facturacion total de 6444.00 y un
-- ticket promedio de 644.40 por pedido.

-- 2. El producto 1 fue el de mayor facturacion:
-- genero 3600.00, equivalente al 55.87% del total.
-- Solo los productos 1 y 3 superaron el promedio
-- de facturacion por producto de 1074.00.

-- 3. Los cinco clientes realizaron dos pedidos
-- cada uno. El cliente 1 registro el mayor gasto
-- acumulado, con un total de 2640.00. 