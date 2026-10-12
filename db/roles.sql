-- Roles for the business-assets database. Locally a superuser runs this; on Neon
-- `business-assets-db provision` creates the same roles through the migrator.
--
-- business_assets_migrator  owns the schema and runs migrations only.
-- business_assets_api       the API at runtime: no superuser, no BYPASSRLS, owns nothing.
-- business_assets_publisher sweeps and marks the outbox across workspaces; nothing else.

DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'business_assets_migrator') THEN
        CREATE ROLE business_assets_migrator LOGIN NOSUPERUSER NOCREATEROLE NOBYPASSRLS;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'business_assets_api') THEN
        CREATE ROLE business_assets_api LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS NOINHERIT;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'business_assets_publisher') THEN
        CREATE ROLE business_assets_publisher LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS NOINHERIT;
    END IF;
END
$$;
