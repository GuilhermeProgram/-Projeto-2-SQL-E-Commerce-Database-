-- ============================================================
--  E-COMMERCE DATABASE — Sistema de Loja Virtual
--  Banco: PostgreSQL / MySQL / SQLite compatível
--  Autor: Seu Nome
-- ============================================================


-- ─────────────────────────────────────────────────────────────
--  1. SCHEMA — CRIAÇÃO DAS TABELAS
-- ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS customers (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    name         TEXT    NOT NULL,
    email        TEXT    NOT NULL UNIQUE,
    phone        TEXT,
    city         TEXT,
    state        TEXT,
    created_at   TEXT    DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS categories (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    slug TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS products (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id INTEGER NOT NULL,
    name        TEXT    NOT NULL,
    sku         TEXT    NOT NULL UNIQUE,
    price       REAL    NOT NULL CHECK (price >= 0),
    stock       INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    active      INTEGER NOT NULL DEFAULT 1,  -- 1=ativo, 0=inativo
    created_at  TEXT    DEFAULT (datetime('now')),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE IF NOT EXISTS orders (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    status      TEXT    NOT NULL DEFAULT 'pending',
    -- pending | confirmed | shipped | delivered | cancelled
    total       REAL    NOT NULL DEFAULT 0,
    created_at  TEXT    DEFAULT (datetime('now')),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE IF NOT EXISTS order_items (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id   INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity   INTEGER NOT NULL CHECK (quantity > 0),
    unit_price REAL    NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(id)   ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE IF NOT EXISTS reviews (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id  INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    rating      INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment     TEXT,
    created_at  TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (product_id)  REFERENCES products(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    UNIQUE (product_id, customer_id)  -- 1 review por cliente por produto
);


-- ─────────────────────────────────────────────────────────────
--  2. DADOS DE EXEMPLO (SEED)
-- ─────────────────────────────────────────────────────────────

INSERT INTO categories (name, slug) VALUES
    ('Eletrônicos',  'eletronicos'),
    ('Livros',       'livros'),
    ('Vestuário',    'vestuario'),
    ('Casa e Cozinha','casa-cozinha');

INSERT INTO customers (name, email, phone, city, state) VALUES
    ('Ana Silva',      'ana@email.com',    '11999990001', 'São Paulo',    'SP'),
    ('Bruno Costa',    'bruno@email.com',  '21999990002', 'Rio de Janeiro','RJ'),
    ('Carla Mendes',   'carla@email.com',  '31999990003', 'Belo Horizonte','MG'),
    ('Diego Ramos',    'diego@email.com',  '41999990004', 'Curitiba',     'PR'),
    ('Elisa Ferreira', 'elisa@email.com',  '51999990005', 'Porto Alegre', 'RS'),
    ('Fábio Lima',     'fabio@email.com',  '61999990006', 'Brasília',     'DF'),
    ('Gabriela Nunes', 'gabi@email.com',   '71999990007', 'Salvador',     'BA');

INSERT INTO products (category_id, name, sku, price, stock) VALUES
    (1, 'Smartphone Galaxy A54',   'SAMSGA54',  1899.90, 50),
    (1, 'Notebook Dell Inspiron',  'DELLINS15', 3499.00, 20),
    (1, 'Fone Bluetooth JBL',      'JBLBT500',   299.90, 80),
    (1, 'Smart TV 50"',            'SMTV50',    2299.00, 15),
    (2, 'Clean Code - Robert Martin','BK-CC',     89.90, 100),
    (2, 'O Programador Pragmático', 'BK-PP',      79.90, 80),
    (2, 'Design Patterns',          'BK-DP',      94.90, 60),
    (3, 'Camiseta Dev Mode',        'TSH-DEV',    59.90, 120),
    (3, 'Moletom Programador',      'HOD-PROG',  129.90, 70),
    (4, 'Caneca Código Bom',        'MUG-CODE',   39.90, 200);

INSERT INTO orders (customer_id, status, total) VALUES
    (1, 'delivered',  1989.80),
    (1, 'shipped',    3499.00),
    (2, 'confirmed',   369.80),
    (3, 'delivered',   169.80),
    (4, 'pending',    2299.00),
    (5, 'cancelled',   299.90),
    (6, 'delivered',   264.70),
    (7, 'shipped',    3628.90);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (1, 1,  1, 1899.90), (1, 10, 1,   39.90),  -- Ana: smartphone + caneca
    (2, 2,  1, 3499.00),                         -- Ana: notebook
    (3, 3,  1,  299.90), (3, 8,  1,   59.90),  -- Bruno: fone + camiseta
    (4, 8,  1,   59.90), (4, 9,  1,  129.90),  -- Carla: camiseta + moletom
    (5, 4,  1, 2299.00),                         -- Diego: TV
    (6, 3,  1,  299.90),                         -- Elisa: fone (cancelado)
    (7, 5,  1,   89.90), (7, 6,  1,   79.90), (7, 10, 1, 94.90), -- Fábio: livros
    (8, 2,  1, 3499.00), (8, 1,  1, 1899.90), (8, 8, 1,  59.90); -- Gabi: notebook+smatphone+camiseta

INSERT INTO reviews (product_id, customer_id, rating, comment) VALUES
    (1, 1, 5, 'Excelente celular, câmera incrível!'),
    (2, 7, 4, 'Ótimo notebook, só demorou a entrega.'),
    (3, 2, 5, 'Som perfeito, valeu cada centavo.'),
    (5, 6, 5, 'Livro essencial para qualquer dev.'),
    (8, 3, 4, 'Boa qualidade, algodão macio.'),
    (1, 4, 3, 'Bom mas esquenta um pouco.');


-- ─────────────────────────────────────────────────────────────
--  3. QUERIES AVANÇADAS
-- ─────────────────────────────────────────────────────────────

-- [Q1] Receita total por categoria (apenas pedidos entregues)
SELECT
    c.name                              AS categoria,
    COUNT(DISTINCT o.id)                AS pedidos,
    SUM(oi.quantity * oi.unit_price)    AS receita_total,
    ROUND(AVG(oi.unit_price), 2)        AS ticket_medio
FROM categories c
JOIN products p  ON p.category_id = c.id
JOIN order_items oi ON oi.product_id = p.id
JOIN orders o    ON o.id = oi.order_id
WHERE o.status = 'delivered'
GROUP BY c.name
ORDER BY receita_total DESC;


-- [Q2] Top 5 clientes por valor gasto (com número de pedidos)
SELECT
    cu.name                                 AS cliente,
    cu.city || '/' || cu.state             AS localidade,
    COUNT(DISTINCT o.id)                    AS total_pedidos,
    SUM(oi.quantity * oi.unit_price)        AS total_gasto,
    ROUND(AVG(oi.unit_price * oi.quantity), 2) AS ticket_medio
FROM customers cu
JOIN orders o      ON o.customer_id = cu.id
JOIN order_items oi ON oi.order_id = o.id
WHERE o.status != 'cancelled'
GROUP BY cu.id
ORDER BY total_gasto DESC
LIMIT 5;


-- [Q3] Produtos mais vendidos com avaliação média
SELECT
    p.name                              AS produto,
    cat.name                            AS categoria,
    SUM(oi.quantity)                    AS unidades_vendidas,
    SUM(oi.quantity * oi.unit_price)    AS receita,
    ROUND(AVG(r.rating), 1)             AS avaliacao_media,
    COUNT(r.id)                         AS num_avaliacoes,
    p.stock                             AS estoque_atual
FROM products p
JOIN categories cat  ON cat.id = p.category_id
JOIN order_items oi  ON oi.product_id = p.id
JOIN orders o        ON o.id = oi.order_id AND o.status != 'cancelled'
LEFT JOIN reviews r  ON r.product_id = p.id
GROUP BY p.id
ORDER BY unidades_vendidas DESC;


-- [Q4] Relatório mensal de vendas (simulado com datas geradas)
SELECT
    strftime('%Y-%m', o.created_at)     AS mes,
    COUNT(DISTINCT o.id)                AS pedidos_totais,
    COUNT(DISTINCT CASE WHEN o.status = 'delivered' THEN o.id END) AS entregues,
    COUNT(DISTINCT CASE WHEN o.status = 'cancelled' THEN o.id END) AS cancelados,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS faturamento
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
GROUP BY mes
ORDER BY mes;


-- [Q5] Produtos com estoque crítico (< 30 unidades) e alto volume de vendas
SELECT
    p.name,
    p.sku,
    p.stock                         AS estoque,
    COALESCE(SUM(oi.quantity), 0)   AS vendidos,
    p.price,
    CASE
        WHEN p.stock = 0       THEN '🔴 ESGOTADO'
        WHEN p.stock < 20      THEN '🟠 CRÍTICO'
        ELSE                        '🟡 BAIXO'
    END AS alerta
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.id
LEFT JOIN orders o ON o.id = oi.order_id AND o.status != 'cancelled'
WHERE p.stock < 30
GROUP BY p.id
ORDER BY p.stock ASC;


-- [Q6] Clientes que compraram em mais de uma categoria (cross-selling)
SELECT
    cu.name,
    COUNT(DISTINCT cat.id)  AS categorias_diferentes,
    GROUP_CONCAT(DISTINCT cat.name) AS categorias
FROM customers cu
JOIN orders o       ON o.customer_id = cu.id AND o.status != 'cancelled'
JOIN order_items oi ON oi.order_id = o.id
JOIN products p     ON p.id = oi.product_id
JOIN categories cat ON cat.id = p.category_id
GROUP BY cu.id
HAVING categorias_diferentes > 1
ORDER BY categorias_diferentes DESC;


-- [Q7] View — Painel de pedidos (últimos pedidos com detalhe)
CREATE VIEW IF NOT EXISTS vw_order_summary AS
SELECT
    o.id                            AS pedido_id,
    o.status,
    o.created_at,
    cu.name                         AS cliente,
    cu.city || '/' || cu.state      AS localidade,
    COUNT(oi.id)                    AS itens,
    SUM(oi.quantity * oi.unit_price) AS valor_total
FROM orders o
JOIN customers cu    ON cu.id = o.customer_id
JOIN order_items oi  ON oi.order_id = o.id
GROUP BY o.id
ORDER BY o.created_at DESC;

-- Uso da view:
-- SELECT * FROM vw_order_summary WHERE status = 'pending';


-- [Q8] Stored procedure simulada — Atualizar estoque após venda
-- (Trigger equivalente — SQLite syntax)
CREATE TRIGGER IF NOT EXISTS trg_reduce_stock
AFTER INSERT ON order_items
BEGIN
    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE id = NEW.product_id;
END;


-- ─────────────────────────────────────────────────────────────
--  4. ÍNDICES PARA PERFORMANCE
-- ─────────────────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_orders_customer   ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_status     ON orders(status);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_prod  ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_sku      ON products(sku);
CREATE INDEX IF NOT EXISTS idx_reviews_product   ON reviews(product_id);
