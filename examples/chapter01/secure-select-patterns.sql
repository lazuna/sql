-- /examples/chapter01/secure-select-patterns.sql
-- Good: Specific column selection
SELECT product_id, name, price, description 
FROM products 
WHERE category_id = $1 
  AND status = 'active'
LIMIT 100;

-- Bad: Wildcard selection (potential information disclosure)
SELECT * FROM products WHERE category_id = $1;
