FROM python:3.11-slim AS base

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y build-essential curl && apt-get clean

# Instalar Poetry
ENV POETRY_VERSION=1.8.2
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"
WORKDIR /app

# Copiar dependencias
COPY pyproject.toml poetry.lock* ./
RUN poetry config virtualenvs.create false \
 && poetry install --no-root --no-interaction --no-ansi

# Copiar el código
COPY . .

# Exponer el puerto para la app
EXPOSE 8000

# Usar gunicorn + uvicorn worker para producción
CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "main:app", "--bind", "0.0.0.0:8000"]
