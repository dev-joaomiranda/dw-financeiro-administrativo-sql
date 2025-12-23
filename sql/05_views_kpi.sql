-- 05_views_kpi.sql
-- Views de relatórios (camada de KPIs para BI)
-- Fluxo de caixa, despesas por centro de custo e aging de contas

-----------------------------------------
-- 1. Fluxo de caixa mensal (realizado)
-----------------------------------------

-- Soma entradas, saídas e saldo por mês (usando fato_lancamento).

-- Exemplo genérico (ajuste funções de data pro seu banco):

-- CREATE VIEW vw_fluxo_caixa_mensal AS
-- SELECT
--     t.ano_mes,
--     SUM(CASE WHEN f.tipo = 'Entrada' THEN f.valor ELSE 0 END) AS receita,
--     SUM(CASE WHEN f.tipo = 'Saída'   THEN f.valor ELSE 0 END) AS despesa,
--     SUM(CASE WHEN f.tipo = 'Entrada' THEN f.valor ELSE -f.valor END) AS saldo
-- FROM fato_lancamento f
-- JOIN dim_tempo t ON t.id_tempo = f.id_tempo
-- GROUP BY t.ano_mes
-- ORDER BY t.ano_mes;

-------------------------------------------------
-- 2. Despesa por centro de custo / departamento
-------------------------------------------------

-- Mostra quanto cada centro de custo gastou no período.

-- CREATE VIEW vw_despesa_por_centro AS
-- SELECT
--     cc.nome AS centro_custo,
--     SUM(f.valor) AS total_despesa
-- FROM fato_lancamento f
-- JOIN dim_categoria_financeira c ON c.id_categoria = f.id_categoria
-- JOIN dim_centro_custo cc        ON cc.id_centro    = f.id_centro
-- WHERE f.tipo = 'Saída'
-- GROUP BY cc.nome
-- ORDER BY total_despesa DESC;

-------------------------------
-- 3. Aging de contas (P/R)
-------------------------------

-- Agrupa contas a pagar/receber por faixa de atraso.
-- A função DATEDIFF/CURRENT_DATE depende do banco (ex.: SQL Server, MySQL, PostgreSQL).

-- CREATE VIEW vw_aging_contas AS
-- SELECT
--     CASE WHEN f.tipo = 'Pagar' THEN 'Pagar' ELSE 'Receber' END AS tipo,
--     CASE
--         WHEN DATEDIFF(day, t_venc.data, CURRENT_DATE) <= 0  THEN '0-Em dia'
--         WHEN DATEDIFF(day, t_venc.data, CURRENT_DATE) <= 30 THEN '1-30 dias'
--         WHEN DATEDIFF(day, t_venc.data, CURRENT_DATE) <= 60 THEN '31-60 dias'
--         ELSE '60+ dias'
--     END AS faixa_atraso,
--     SUM(f.valor) AS total
-- FROM fato_conta f
-- JOIN dim_tempo t_venc ON t_venc.id_tempo = f.id_tempo_venc
-- WHERE f.id_tempo_pagto IS NULL   -- ainda em aberto
-- GROUP BY tipo, faixa_atraso
-- ORDER BY tipo, faixa_atraso;
