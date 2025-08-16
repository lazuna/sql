-- /scripts/chapter01/least-privilege-setup.sql
-- Create application-specific database user
CREATE USER app_reader WITH PASSWORD 'complex_random_password';
CREATE USER app_writer WITH PASSWORD 'another_complex_password';

-- Grant minimal necessary permissions
GRANT SELECT ON public.products TO app_reader;
GRANT SELECT, INSERT, UPDATE ON public.orders TO app_writer;
GRANT SELECT ON public.customers TO app_writer;

-- Explicitly deny sensitive operations
REVOKE ALL ON public.admin_users FROM app_reader, app_writer;
