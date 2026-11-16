FROM python:3.12-slim

# No .pyc files; logs go straight to stdout (visible with docker logs)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Dependencies first: cached while requirements.txt does not change
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Do not run as root inside the container
RUN useradd --create-home appuser
USER appuser

EXPOSE 5000

# Gunicorn imports app.py (module "app", object "app"): the __main__ block with debug=True never runs
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--access-logfile", "-", "app:app"]
