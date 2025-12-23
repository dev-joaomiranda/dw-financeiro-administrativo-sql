-- 01_schema_raw.sql
-- Tabelas de estágio (dados operacionais da empresa)

-- Lançamentos financeiros já realizados (caixa)
CREATE TABLE lancamentos_raw (
    id              INT PRIMARY KEY,
    data_movimento  DATE,
    tipo            VARCHAR(10),      -- 'Entrada' ou 'Saída'
    categoria       VARCHAR(100),     -- Venda, Salário, Aluguel, etc.
    centro_custo    VARCHAR(100),     -- Administrativo, Operações, Comercial, etc.
    descricao       VARCHAR(255),
    valor           DECIMAL(10,2)
);

-- Contas a pagar / receber (títulos futuros)
CREATE TABLE contas_raw (
    id              INT PRIMARY KEY,
    tipo            VARCHAR(10),      -- 'Pagar' ou 'Receber'
    pessoa          VARCHAR(150),     -- Cliente ou Fornecedor
    categoria       VARCHAR(100),
    centro_custo    VARCHAR(100),
    data_emissao    DATE,
    data_vencimento DATE,
    data_pagamento  DATE NULL,
    valor           DECIMAL(10,2)
);

-- Centros de custo / departamentos
CREATE TABLE centros_custo_raw (
    id          INT PRIMARY KEY,
    nome        VARCHAR(100),        -- Administrativo, Operações, Comercial, etc.
    responsavel VARCHAR(150)
);
