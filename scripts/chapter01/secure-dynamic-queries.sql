-- /scripts/chapter01/secure-dynamic-queries.sql
-- PostgreSQL function with dynamic filtering
CREATE OR REPLACE FUNCTION search_products(
    p_category_filter TEXT DEFAULT NULL,
    p_price_min DECIMAL DEFAULT NULL,
    p_price_max DECIMAL DEFAULT NULL,
    p_sort_by TEXT DEFAULT 'name',
    p_sort_direction TEXT DEFAULT 'ASC'
) RETURNS TABLE (
    product_id INTEGER,
    name TEXT,
    price DECIMAL,
    category TEXT
) AS $$
DECLARE
    query_text TEXT;
    sort_column TEXT;
BEGIN
    -- Validate sort column (whitelist approach)
    sort_column := CASE p_sort_by
        WHEN 'name' THEN 'name'
        WHEN 'price' THEN 'price' 
        WHEN 'category' THEN 'category'
        ELSE 'name'
    END;
    
    -- Validate sort direction
    IF p_sort_direction NOT IN ('ASC', 'DESC') THEN
        p_sort_direction := 'ASC';
    END IF;
    
    -- Build secure dynamic query
    query_text := 'SELECT product_id, name, price, category FROM products WHERE 1=1';
    
    IF p_category_filter IS NOT NULL THEN
        query_text := query_text || ' AND category = $1';
    END IF;
    
    IF p_price_min IS NOT NULL THEN
        query_text := query_text || ' AND price >= $2';
    END IF;
    
    IF p_price_max IS NOT NULL THEN
        query_text := query_text || ' AND price <= $3';
    END IF;
    
    query_text := query_text || ' ORDER BY ' || sort_column || ' ' || p_sort_direction;
    
    RETURN QUERY EXECUTE query_text USING p_category_filter, p_price_min, p_price_max;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
