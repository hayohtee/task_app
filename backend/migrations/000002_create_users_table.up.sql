CREATE TABLE IF NOT EXISTS users(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    email citext UNIQUE NOT NULL,
    password_hash BYTEA NOT NULL,
    created_at TIMESTAMP(0) WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP(0) WITH TIME ZONE DEFAULT now(),
    version INTEGER NOT NULL DEFAULT 1
);