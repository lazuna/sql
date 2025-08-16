-- /labs/chapter01/setup/hello-world-database.sql
-- Create a secure "Hello World" database that demonstrates
-- fundamental security principles from the start

-- Create database with secure defaults
CREATE DATABASE secure_hello_world
    WITH ENCODING 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE template0;

\c secure_hello_world

-- Create application users with principle of least privilege
CREATE ROLE app_connect_role;
CREATE USER hello_app WITH PASSWORD 'generate_strong_password_here' IN ROLE app_connect_role;

-- Create secure hello_messages table
CREATE TABLE hello_messages (
    message_id SERIAL PRIMARY KEY,
    user_name VARCHAR(50) NOT NULL CHECK (
        user_name ~ '^[a-zA-Z0-9_\s]{1,50}$'
    ),
    message_text VARCHAR(500) NOT NULL CHECK (
        LENGTH(TRIM(message_text)) > 0
    ),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address INET,
    is_active BOOLEAN DEFAULT true
);

-- Grant minimal permissions
GRANT SELECT, INSERT ON hello_messages TO hello_app;
GRANT USAGE ON SEQUENCE hello_messages_message_id_seq TO hello_app;

-- Create secure view that limits data exposure
CREATE VIEW public_messages AS
SELECT 
    message_id,
    user_name,
    message_text,
    created_at
FROM hello_messages 
WHERE is_active = true 
  AND created_at >= CURRENT_DATE - INTERVAL '30 days';

GRANT SELECT ON public_messages TO app_connect_role;
