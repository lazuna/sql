-- /scripts/chapter01/secure-table-creation.sql
-- Create table with built-in security constraints
CREATE TABLE user_accounts (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL CHECK (
        username ~ '^[a-zA-Z0-9_]{3,50}$'
    ),
    email VARCHAR(255) NOT NULL CHECK (
        email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    ),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    failed_login_attempts INTEGER DEFAULT 0 CHECK (
        failed_login_attempts >= 0 AND failed_login_attempts <= 10
    ),
    account_locked BOOLEAN DEFAULT FALSE
);

-- Create unique index for performance and integrity
CREATE UNIQUE INDEX idx_username_lower ON user_accounts (LOWER(username));
CREATE UNIQUE INDEX idx_email_lower ON user_accounts (LOWER(email));
