-- /examples/chapter01/sql-injection-attack.sql
SELECT user_id, username, role 
FROM users 
WHERE username = 'admin' OR '1'='1' --' 
  AND password = 'anything'
