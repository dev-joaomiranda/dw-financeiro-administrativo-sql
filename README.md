# Mini Data Warehouse Administrativo-Financeiro (SQL)

Projeto pessoal de **modelagem dimensional** e **ETL em SQL** para simular um pequeno
Data Warehouse da área administrativa/financeira de uma empresa de serviços.

O objetivo é consolidar dados de **lançamentos financeiros**, **contas a pagar/receber**
e **centros de custo** em uma camada única de relatórios, pronta para ser consumida
por ferramentas de BI (Excel, Power BI, etc.).

---

## Cenário de negócio

Empresa fictícia de serviços administrativos com:

- Lançamentos de caixa (entradas e saídas).
- Contas a pagar e a receber.
- Centros de custo / departamentos (Administrativo, Operações, Comercial).
- Clientes e fornecedores.

Perguntas que o DW ajuda a responder:

- Qual o **resultado mensal** (receita, despesa, saldo)?
- Quais **centros de custo** concentram mais despesas?
- Como está o **aging de contas** (contas em dia, 1–30, 31–60, 60+ dias)?
- Como preparar dados consolidados para dashboards financeiros?

## Estrutura do repositório
data/

lancamentos_raw_example.csv      # Exemplo de lançamentos de caixa (Entrada/Saída)

contas_raw_example.csv           # Exemplo de contas a pagar/receber

centros_custo_raw_example.csv    # Exemplo de centros de custo

sql/

01_schema_raw.sql         # Tabelas de estágio (dados operacionais)

02_schema_dim_fato.sql    # Dimensões e tabelas fato do DW

03_etl_dim.sql            # ETL das dimensões (tempo, centro de custo, categoria, pessoa)

04_etl_fato.sql           # ETL das tabelas fato (lançamentos, contas)

05_views_kpi.sql          # Views de KPIs (fluxo de caixa, despesas por centro, aging)

## Modelo dimensional

Principais tabelas:

### Dimensões

- `dim_tempo` – calendário completo (dia, mês, ano, ano-mês).
- `dim_centro_custo` – departamentos (Administrativo, Operações, Comercial…).
- `dim_categoria_financeira` – categorias de receita/despesa (Vendas, Salários, Aluguel…).
- `dim_pessoa` – clientes e fornecedores.

### Fatos

- `fato_lancamento` – lançamentos financeiros realizados (caixa).
- `fato_conta` – contas a pagar/receber (vencimento, pagamento, valor, pessoa).

---

## ETL em SQL

Os scripts em `sql/03_etl_dim.sql` e `sql/04_etl_fato.sql` implementam o fluxo:

1. Geração da dimensão de tempo (`dim_tempo`).
2. Carga das dimensões a partir das tabelas RAW:
   - centros de custo, categorias financeiras e pessoas.
3. Carga das tabelas fato:
   - `fato_lancamento` a partir de `lancamentos_raw` + dimensões.
   - `fato_conta` a partir de `contas_raw` + dimensões.

---

## Views de KPIs

O arquivo `sql/05_views_kpi.sql` define a camada de relatórios, com exemplos de:

- `vw_fluxo_caixa_mensal`  
  Resultado financeiro mensal (receita, despesa, saldo) usando `fato_lancamento`.

- `vw_despesa_por_centro`  
  Despesas agregadas por centro de custo (departamentos).

- `vw_aging_contas`  
  Aging de contas a pagar/receber por faixa de atraso (em dia, 1–30, 31–60, 60+ dias).

Essas views podem ser conectadas diretamente em ferramentas de BI.

## Tecnologias

- SQL (PostgreSQL / MySQL / SQL Server / SQLite).
- Conceitos de Data Warehouse:
  - Tabelas fato e dimensões.
  - Processo ETL (Extract, Transform, Load).
- Possível integração com:
  - Excel / Power BI para criação de dashboards financeiros.
