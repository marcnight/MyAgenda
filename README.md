# 📅 MyAgenda

> A full-featured personal agenda and notes manager built with Django — designed to help users organize appointments, store notes, and stay productive.

![Django](https://img.shields.io/badge/Django-6.0-092E20?style=for-the-badge&logo=django)
![Python](https://img.shields.io/badge/Python-3.14-3776AB?style=for-the-badge&logo=python)
![SQLite](https://img.shields.io/badge/SQLite-Dev-003B57?style=for-the-badge&logo=sqlite)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Production-4169E1?style=for-the-badge&logo=postgresql)
![MaterializeCSS](https://img.shields.io/badge/MaterializeCSS-0.100-ee6e73?style=for-the-badge)

---

## ✨ Features

### 🔐 Authentication & Security
- **User registration** with strict password validation (minimum 8 characters, must include uppercase, lowercase, digits, and special characters)
- **Secure login/logout** using Django's built-in authentication system
- **Rate limiting** — brute-force protection on login (10 attempts/min) and registration (1 attempt/min) per IP
- **Protection against username enumeration** — generic error messages don't reveal whether a user exists
- **Session-based authentication** with HTTPOnly and secure cookie flags
- **CSRF protection** on all forms
- **Production-ready** — HSTS, HTTPS redirect, XSS filtering, clickjacking protection, content-type sniffing prevention

### 📆 Appointment Management
- Create appointments with title, description, and date
- Description field supports up to 2,000 characters
- Appointments are user-scoped — each user sees only their own entries
- Sorted chronologically on the dashboard

### 📝 Notes Management
- Create personal notes with title and text content
- Text field supports up to 5,000 characters
- Notes are user-scoped with reverse-chronological ordering

### 📊 Dashboard
- Personalized welcome message
- Consolidated view of all appointments and notes
- Quick-action buttons to create new entries
- Clean, responsive interface

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Backend** | Django 6.0.5 (Python 3.14) |
| **Database** | SQLite (development) / PostgreSQL (production) |
| **Frontend** | MaterializeCSS 0.100.2, jQuery 3.2.1 |
| **Icons** | Google Material Icons |
| **Authentication** | Django built-in auth |
| **Rate Limiting** | Django Cache Framework (LocMemCache) |
| **Configuration** | python-dotenv (.env file) |
| **Deployment** | WSGI & ASGI ready |

---

## 🚀 Quick Start

### Prerequisites
- Python 3.12+
- pip

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/marcnight/MyAgenda.git
cd MyAgenda

# 2. Create and activate a virtual environment
python -m venv venv
source venv/bin/activate   # Linux/macOS
# venv\Scripts\activate    # Windows

# 3. Install dependencies
pip install -r requirements.txt

# 4. Configure environment variables
cp .env.example .env
# Edit .env and set a strong DJANGO_SECRET_KEY
# For development, set DJANGO_DEBUG=True

# 5. Run database migrations
python manage.py migrate

# 6. Start the development server
python manage.py runserver
```

Visit **http://127.0.0.1:8000** in your browser.

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `DJANGO_SECRET_KEY` | ✅ Yes | — | Django secret key (generate with `python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'`) |
| `DJANGO_DEBUG` | No | `False` | Set to `True` for development |
| `DJANGO_ALLOWED_HOSTS` | No | `localhost,127.0.0.1` | Comma-separated allowed hosts |
| `DB_ENGINE` | No | SQLite | `django.db.backends.postgresql` for production |
| `DB_NAME` | No | `db.sqlite3` | Database name |
| `DB_USER` | No | — | PostgreSQL user |
| `DB_PASSWORD` | No | — | PostgreSQL password |
| `DB_HOST` | No | `localhost` | Database host |
| `DB_PORT` | No | — | Database port |

---

## 📂 Project Structure

```
MyAgenda/
├── config/                    # Project configuration
│   ├── __init__.py
│   ├── asgi.py                # ASGI entry point
│   ├── settings.py            # Django settings (162 lines)
│   ├── urls.py                # Root URL configuration
│   └── wsgi.py                # WSGI entry point
│
├── MyAgenda/                  # Main application
│   ├── migrations/            # Database migrations
│   ├── static/                # Static assets
│   │   ├── css/               # Custom stylesheets
│   │   │   ├── style.css
│   │   │   ├── style_anotacao.css
│   │   │   ├── style_cadastro.css
│   │   │   └── style_logado.css
│   │   └── img/               # Images (favicon, etc.)
│   ├── templates/             # HTML templates
│   │   ├── base.html          # Base layout with nav/footer
│   │   ├── MyAgenda.html      # Landing page & login
│   │   ├── Cadastro.html      # Registration form
│   │   ├── Logado.html        # Dashboard
│   │   ├── Compromisso.html   # Appointment creation
│   │   └── Anotacao.html      # Note creation
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py              # Compromisso & Anotacao models
│   ├── tests.py
│   ├── urls.py                # App route definitions
│   └── views.py               # All view logic
│
├── .env.example               # Environment variable template
├── .gitignore                 # Git ignore rules
├── manage.py                  # Django CLI entry point
├── postgres_schema.sql        # PostgreSQL schema (production)
├── requirements.txt           # Python dependencies
├── setup_postgres.sh          # PostgreSQL setup script (Arch Linux)
└── README.md                  # This file
```

---

## 🗄️ Models

### Compromisso (Appointment)
| Field | Type | Description |
|-------|------|-------------|
| `titulo` | `CharField(200)` | Appointment title |
| `descricao` | `TextField` | Detailed description |
| `data` | `DateField` | Appointment date |
| `usuario` | `ForeignKey(User)` | Owner (CASCADE on delete) |
| `criado_em` | `DateTimeField` | Auto-set creation timestamp |

### Anotacao (Note)
| Field | Type | Description |
|-------|------|-------------|
| `titulo` | `CharField(200)` | Note title |
| `texto` | `TextField` | Note content |
| `usuario` | `ForeignKey(User)` | Owner (CASCADE on delete) |
| `criado_em` | `DateTimeField` | Auto-set creation timestamp |

---

## 🔒 Security

This project follows Django security best practices:

- **Secret key** loaded exclusively from environment variables — never hardcoded
- **Debug mode** disabled by default in production
- **Comprehensive HTTPS/SSL**:
  - `SECURE_SSL_REDIRECT` — automatic HTTP→HTTPS redirect
  - `SECURE_HSTS_SECONDS` — 1-year HSTS policy with subdomains and preload
  - `SESSION_COOKIE_SECURE` / `CSRF_COOKIE_SECURE` — cookies sent over HTTPS only
- **Clickjacking protection** — `X-Frame-Options: DENY`
- **XSS protection** — `SECURE_BROWSER_XSS_FILTER` enabled
- **MIME sniffing prevention** — `SECURE_CONTENT_TYPE_NOSNIFF` enabled
- **HTTPOnly cookies** for both session and CSRF tokens
- **Rate limiting** on authentication endpoints
- **Password strength validation** — 4 validators including custom complexity rules

> All security settings activate automatically when `DEBUG=False`. In development (`DEBUG=True`), they are safely disabled to avoid HTTPS requirements on the local dev server.

---

## 🌐 Deployment

### Production Checklist
1. Set `DJANGO_DEBUG=False` in `.env`
2. Set a strong `DJANGO_SECRET_KEY`
3. Configure `DJANGO_ALLOWED_HOSTS` with your domain
4. Switch to PostgreSQL (`DB_ENGINE=django.db.backends.postgresql`)
5. Set up SSL/TLS certificate (e.g., Let's Encrypt)
6. Use a production WSGI server (Gunicorn, uWSGI) behind Nginx

### PostgreSQL Setup (Arch Linux)
A setup script is included for Arch Linux:
```bash
chmod +x setup_postgres.sh
./setup_postgres.sh
```

For other distributions, use `postgres_schema.sql` as a reference:
```bash
psql -U your_user -d your_database -f postgres_schema.sql
```

---

## 🧪 Testing

Test files are located at `MyAgenda/tests.py`. Run tests with:

```bash
python manage.py test
```

> Contributions to expand test coverage are welcome!

---

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 👨‍💻 Author

**Marcos Goncalves**

[![GitHub](https://img.shields.io/badge/GitHub-marcnight-181717?style=flat-square&logo=github)](https://github.com/marcnight)

---

*Built with Django 6.0 • Python 3.14 • MaterializeCSS*
