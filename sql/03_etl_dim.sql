-- 03_etl_dim.sql
-- ETL das dimensões do Data Warehouse Administrativo-Financeiro

--------------------------------
-- 1. Carga da dimensão de tempo
--------------------------------
-- Gera um calendário diário para o período que você quiser analisar.
-- Exemplo em PostgreSQL (ajuste se for outro banco).

-- LIMPAR dim_tempo (opcional, se for recarga)
-- TRUNCATE TABLE dim_tempo;

-- Exemplo PostgreSQL:
-- INSERT INTO dim_tempo (id_tempo, data, ano, mes, dia, nome_mes, ano_mes)
-- SELECT
--     ROW_NUMBER() OVER (ORDER BY d)::INT AS id_tempo,
--     d::DATE AS data,
--     EXTRACT(YEAR  FROM d) AS ano,
--     EXTRACT(MONTH FROM d) AS mes,
--     EXTRACT(DAY   FROM d) AS dia,
--     TO_CHAR(d, 'Mon')      AS nome_mes,
--     TO_CHAR(d, 'YYYY-MM')  AS ano_mes
-- FROM GENERATE_SERIES('2025-01-01'::DATE, '2026-12-31'::DATE, '1 day'::INTERVAL) AS g(d);

------------------------------------------
-- 2. Carga da dimensão de centros de custo
------------------------------------------
-- Pega os centros de custo do cadastro operacional.

-- TRUNCATE TABLE dim_centro_custo;

-- INSERT INTO dim_centro_custo (id_centro, nome, responsavel)
-- SELECT
--     id,
--     nome,
--     responsavel
-- FROM centros_custo_raw;

---------------------------------------------------
-- 3. Carga da dimensão de categorias financeiras
---------------------------------------------------
-- Cria uma lista única de categorias a partir das tabelas RAW.
-- Ajuste "tipo_padrao" (Receita/Despesa) conforme sua regra de negócio.

-- TRUNCATE TABLE dim_categoria_financeira;

-- Exemplo simples: pegar categorias distintas dos lançamentos e contas.

-- INSERT INTO dim_categoria_financeira (id_categoria, nome, tipo_padrao)
-- SELECT
--     ROW_NUMBER() OVER (ORDER BY nome_cat)::INT AS id_categoria,
--     nome_cat AS nome,
--     CASE
--         WHEN nome_cat IN ('Vendas', 'Serviços') THEN 'Receita'
--         ELSE 'Despesa'
--     END AS tipo_padrao
-- FROM (
--     SELECT DISTINCT categoria AS nome_cat FROM lancamentos_raw
--     UNION
--     SELECT DISTINCT categoria AS nome_cat FROM contas_raw
-- ) AS categorias;

-------------------------------
-- 4. Carga da dimensão pessoa
-------------------------------
-- Monta cadastro de pessoas (clientes/fornecedores) a partir de contas_raw.

-- TRUNCATE TABLE dim_pessoa;

-- INSERT INTO dim_pessoa (id_pessoa, nome, tipo)
-- SELECT
--     ROW_NUMBER() OVER (ORDER BY pessoa)::INT AS id_pessoa,
--     pessoa AS nome,
--     -- regra simples: ajustar conforme o cenário que você quiser
--     CASE
--         WHEN tipo = 'Receber' THEN 'Cliente'
--         ELSE 'Fornecedor'
--     END AS tipo
-- FROM contas_raw
-- GROUP BY pessoa, tipo;
