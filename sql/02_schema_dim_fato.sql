-- 02_schema_dim_fato.sql
-- Dimensões e Fatos do Data Warehouse Administrativo-Financeiro

-------------------------
-- 1. Dimensões
-------------------------

-- Dimensão de tempo (calendário)
CREATE TABLE dim_tempo (
    id_tempo    INT PRIMARY KEY,
    data        DATE,
    ano         INT,
    mes         INT,
    dia         INT,
    nome_mes    VARCHAR(20),
    ano_mes     VARCHAR(7)    -- ex: '2025-12'
);

-- Dimensão de centros de custo / departamentos
CREATE TABLE dim_centro_custo (
    id_centro   INT PRIMARY KEY,
    nome        VARCHAR(100),   -- Administrativo, Operações, Comercial, etc.
    responsavel VARCHAR(150)
);

-- Dimensão de categorias financeiras
CREATE TABLE dim_categoria_financeira (
    id_categoria INT PRIMARY KEY,
    nome        VARCHAR(100),   -- Salários, Aluguel, Vendas, etc.
    tipo_padrao VARCHAR(10)     -- 'Receita' ou 'Despesa'
);

-- Dimensão de pessoas (clientes / fornecedores)
CREATE TABLE dim_pessoa (
    id_pessoa   INT PRIMARY KEY,
    nome        VARCHAR(150),
    tipo        VARCHAR(20)     -- 'Cliente' ou 'Fornecedor'
);

-------------------------
-- 2. Tabelas Fato
-------------------------

-- Fato de lançamentos financeiros (caixa realizado)
CREATE TABLE fato_lancamento (
    id              INT PRIMARY KEY,
    id_tempo        INT,
    id_categoria    INT,
    id_centro       INT,
    tipo            VARCHAR(10),      -- Entrada / Saída
    valor           DECIMAL(10,2),

    FOREIGN KEY (id_tempo)     REFERENCES dim_tempo(id_tempo),
    FOREIGN KEY (id_categoria) REFERENCES dim_categoria_financeira(id_categoria),
    FOREIGN KEY (id_centro)    REFERENCES dim_centro_custo(id_centro)
);

-- Fato de contas (pagar/receber, fluxo futuro + atrasos)
CREATE TABLE fato_conta (
    id              INT PRIMARY KEY,
    id_tempo_venc   INT,
    id_tempo_pagto  INT NULL,
    id_categoria    INT,
    id_centro       INT,
    id_pessoa       INT,
    tipo            VARCHAR(10),      -- Pagar / Receber
    valor           DECIMAL(10,2),

    FOREIGN KEY (id_tempo_venc)  REFERENCES dim_tempo(id_tempo),
    FOREIGN KEY (id_tempo_pagto) REFERENCES dim_tempo(id_tempo),
    FOREIGN KEY (id_categoria)   REFERENCES dim_categoria_financeira(id_categoria),
    FOREIGN KEY (id_centro)      REFERENCES dim_centro_custo(id_centro),
    FOREIGN KEY (id_pessoa)      REFERENCES dim_pessoa(id_pessoa)
);
