-- Script para criar as tabelas do projeto MyAgenda no PostgreSQL
-- Execute este script no banco 'myagenda' usando: psql -U postgres -d myagenda -f postgres_schema.sql

-- Tabela de usuários (compatível com Django auth) - com aspas para preservar case
CREATE TABLE IF NOT EXISTS "auth_user" (
    id SERIAL PRIMARY KEY,
    password VARCHAR(128) NOT NULL,
    last_login TIMESTAMP WITH TIME ZONE NULL,
    is_superuser BOOLEAN NOT NULL,
    username VARCHAR(150) NOT NULL UNIQUE,
    first_name VARCHAR(150) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    email VARCHAR(254) NOT NULL,
    is_staff BOOLEAN NOT NULL,
    is_active BOOLEAN NOT NULL,
    date_joined TIMESTAMP WITH TIME ZONE NOT NULL
);

-- Tabela de grupos
CREATE TABLE IF NOT EXISTS "auth_group" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE
);

-- Tabela de permissões
CREATE TABLE IF NOT EXISTS "auth_permission" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    content_type_id INTEGER NOT NULL,
    codename VARCHAR(100) NOT NULL,
    UNIQUE (content_type_id, codename)
);

-- Tabela de compromissos (com maiúscula conforme Django espera)
CREATE TABLE IF NOT EXISTS "MyAgenda_compromisso" (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT NOT NULL,
    data DATE NOT NULL,
    usuario_id INTEGER NOT NULL REFERENCES "auth_user"(id) ON DELETE CASCADE,
    criado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Tabela de anotações (com maiúscula conforme Django espera)
CREATE TABLE IF NOT EXISTS "MyAgenda_anotacao" (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    texto TEXT NOT NULL,
    usuario_id INTEGER NOT NULL REFERENCES "auth_user"(id) ON DELETE CASCADE,
    criado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Tabelas adicionais do Django (sessões, migrations, etc.)
CREATE TABLE IF NOT EXISTS "django_migrations" (
    id SERIAL PRIMARY KEY,
    app VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    applied TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS "django_session" (
    session_key VARCHAR(40) NOT NULL PRIMARY KEY,
    session_data TEXT NOT NULL,
    expire_date TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS "django_content_type" (
    id SERIAL PRIMARY KEY,
    app_label VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    UNIQUE (app_label, model)
);

CREATE TABLE IF NOT EXISTS "django_admin_log" (
    id SERIAL PRIMARY KEY,
    action_time TIMESTAMP WITH TIME ZONE NOT NULL,
    object_id TEXT NULL,
    object_repr VARCHAR(200) NOT NULL,
    action_flag SMALLINT NOT NULL,
    change_message TEXT NOT NULL,
    content_type_id INTEGER NULL REFERENCES "django_content_type"(id) ON DELETE SET NULL,
    user_id INTEGER NOT NULL REFERENCES "auth_user"(id) ON DELETE CASCADE
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_compromisso_usuario ON "MyAgenda_compromisso"(usuario_id);
CREATE INDEX IF NOT EXISTS idx_compromisso_data ON "MyAgenda_compromisso"(data);
CREATE INDEX IF NOT EXISTS idx_anotacao_usuario ON "MyAgenda_anotacao"(usuario_id);
CREATE INDEX IF NOT EXISTS idx_anotacao_criado ON "MyAgenda_anotacao"(criado_em);

-- Inserir migrações aplicadas (para o Django reconhecer)
INSERT INTO "django_migrations" (app, name, applied) VALUES
('contenttypes', '0001_initial', NOW()),
('contenttypes', '0002_remove_content_type_name', NOW()),
('auth', '0001_initial', NOW()),
('auth', '0002_alter_permission_name_max_length', NOW()),
('auth', '0003_alter_user_email_max_length', NOW()),
('auth', '0004_alter_user_username_opts', NOW()),
('auth', '0005_alter_user_last_login_null', NOW()),
('auth', '0006_require_contenttypes_0002', NOW()),
('auth', '0007_alter_validators_add_error_messages', NOW()),
('auth', '0008_alter_user_username_max_length', NOW()),
('auth', '0009_alter_user_last_name_max_length', NOW()),
('auth', '0010_alter_group_name_max_length', NOW()),
('auth', '0011_update_proxy_permissions', NOW()),
('auth', '0012_alter_user_first_name_max_length', NOW()),
('sessions', '0001_initial', NOW()),
('admin', '0001_initial', NOW()),
('admin', '0002_logentry_remove_auto_add', NOW()),
('admin', '0003_logentry_add_action_flag_choices', NOW()),
('MyAgenda', '0001_initial', NOW())
ON CONFLICT DO NOTHING;

-- Comentários nas tabelas
COMMENT ON TABLE "MyAgenda_compromisso" IS 'Compromissos dos usuários';
COMMENT ON TABLE "MyAgenda_anotacao" IS 'Anotações dos usuários';
COMMENT ON TABLE "auth_user" IS 'Usuários do sistema (Django auth)';
