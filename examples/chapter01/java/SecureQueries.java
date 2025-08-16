// /examples/chapter01/java/SecureQueries.java
public List<Order> getUserOrders(Connection conn, int userId, String status) 
    throws SQLException {
    
    String query = """
        SELECT order_id, product_name, quantity, total_amount, order_date
        FROM orders 
        WHERE user_id = ? 
          AND status = ? 
          AND order_date >= CURRENT_DATE - INTERVAL '90 days'
        ORDER BY order_date DESC
        """;
    
    try (PreparedStatement stmt = conn.prepareStatement(query)) {
        stmt.setInt(1, userId);
        stmt.setString(2, status);
        
        try (ResultSet rs = stmt.executeQuery()) {
            // Process results...
        }
    }
}
