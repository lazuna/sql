# /examples/chapter01/python/secure-queries.py
import psycopg2
from psycopg2 import sql

# Secure parameterized query
def get_user_orders(connection, user_id, status):
    cursor = connection.cursor()
    query = """
        SELECT order_id, product_name, quantity, total_amount, order_date
        FROM orders 
        WHERE user_id = %s 
          AND status = %s 
          AND order_date >= CURRENT_DATE - INTERVAL '90 days'
        ORDER BY order_date DESC
    """
    cursor.execute(query, (user_id, status))
    return cursor.fetchall()
