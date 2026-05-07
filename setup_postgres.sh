#!/bin/bash
# Script para configurar PostgreSQL no Arch Linux

echo "Instalando PostgreSQL..."
sudo pacman -S postgresql

echo "Inicializando o banco de dados..."
sudo -u postgres initdb -D /var/lib/postgres/data

echo "Iniciando o serviço PostgreSQL..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

echo "Criando usuário e banco de dados para o projeto..."
sudo -u postgres psql -c "CREATE USER myagenda_user WITH PASSWORD 'MyAgenda_Str0ngP@ss_2026!';"
sudo -u postgres psql -c "CREATE DATABASE myagenda OWNER myagenda_user;"

echo "Configurando arquivo .env..."
cat > .env << EOF
# Configurações Django
DJANGO_SECRET_KEY=$(python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())")
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1

# Configurações PostgreSQL
DB_ENGINE=django.db.backends.postgresql
DB_NAME=myagenda
DB_USER=myagenda_user
DB_PASSWORD=MyAgenda_Str0ngP@ss_2026!
DB_HOST=localhost
DB_PORT=5432
EOF

echo "Instalando dependências Python..."
source venv/bin/activate
pip install psycopg2-binary python-dotenv

echo "Configuração concluída!"
echo "Edite o arquivo .env e ajuste a senha e domínios."
echo "Depois execute: source venv/bin/activate && python manage.py migrate"
