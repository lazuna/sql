# /labs/chapter01/python/secure_hello_app.py
import psycopg2
import hashlib
import secrets
from datetime import datetime

class SecureHelloApp:
    def __init__(self, connection_string):
        self.connection = psycopg2.connect(connection_string)
    
    def add_hello_message(self, user_name, message_text, user_ip):
        """Securely add a hello message using parameterized queries"""
        try:
            cursor = self.connection.cursor()
            
            # Input validation
            if not user_name or len(user_name.strip()) == 0:
                raise ValueError("User name cannot be empty")
            
            if not message_text or len(message_text.strip()) == 0:
                raise ValueError("Message cannot be empty")
            
            # Parameterized query prevents SQL injection
            query = """
                INSERT INTO hello_messages (user_name, message_text, ip_address)
                VALUES (%s, %s, %s)
                RETURNING message_id
            """
            
            cursor.execute(query, (user_name.strip(), message_text.strip(), user_ip))
            message_id = cursor.fetchone()[0]
            self.connection.commit()
            
            return message_id
            
        except Exception as e:
            self.connection.rollback()
            raise e
    
    def get_public_messages(self, limit=10):
        """Retrieve public messages using secure view"""
        cursor = self.connection.cursor()
        
        query = """
            SELECT message_id, user_name, message_text, created_at
            FROM public_messages
            ORDER BY created_at DESC
            LIMIT %s
        """
        
        cursor.execute(query, (limit,))
        return cursor.fetchall()

# Example usage demonstrating security principles
if __name__ == "__main__":
    app = SecureHelloApp("postgresql://hello_app:password@localhost/secure_hello_world")
    
    # This will work - secure parameterized input
    message_id = app.add_hello_message("Alice", "Hello, secure world!", "192.168.1.100")
    print(f"Added secure message with ID: {message_id}")
    
    # This will fail due to input validation
    try:
        app.add_hello_message("", "Empty username test", "192.168.1.100")
    except ValueError as e:
        print(f"Security validation caught: {e}")
    
    # Retrieve and display messages
    messages = app.get_public_messages(5)
    for msg in messages:
        print(f"{msg[1]}: {msg[2]} ({msg[3]})")
