-- /examples/chapter01/vulnerable-login.sql
-- Vulnerable code (NEVER use this approach)
SELECT user_id, username, role 
FROM users 
WHERE username = '" + userInput + "' 
  AND password = '" + passwordInput + "'
