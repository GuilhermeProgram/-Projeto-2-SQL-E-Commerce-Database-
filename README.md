# E-Commerce Database 🗄️

Schema completo de banco de dados para sistema de loja virtual, com queries avançadas e otimizações.

## Tecnologias
- SQL padrão ANSI (compatível com SQLite, PostgreSQL e MySQL)
- Modelagem relacional com 6 tabelas normalizadas
- Triggers, Views e Índices

## Como rodar (SQLite)

```bash
sqlite3 ecommerce.db < ecommerce.sql
sqlite3 ecommerce.db "SELECT * FROM vw_order_summary;"
```

## Modelo de dados

```
customers ──┐
            ├── orders ──── order_items ──── products ──── categories
            │                                    │
            └── reviews ───────────────────────┘
```

## Queries incluídas

| # | Query | Técnica |
|---|-------|---------|
| Q1 | Receita por categoria | GROUP BY + JOIN |
| Q2 | Top clientes | Agregação + HAVING |
| Q3 | Produtos mais vendidos + avaliação | LEFT JOIN múltiplo |
| Q4 | Relatório mensal | strftime + CASE |
| Q5 | Alertas de estoque | CASE + COALESCE |
| Q6 | Análise cross-selling | GROUP_CONCAT + HAVING |
| Q7 | View painel de pedidos | CREATE VIEW |
| Q8 | Trigger de estoque | CREATE TRIGGER |

## Conceitos demonstrados
- Normalização (1NF, 2NF, 3NF)
- Chaves estrangeiras e integridade referencial
- JOINs (INNER, LEFT)
- Window functions / Aggregate functions
- Views e Triggers
- Índices para otimização de queries
- Constraints (CHECK, UNIQUE, NOT NULL)
