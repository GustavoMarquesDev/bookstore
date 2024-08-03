# Base Python image
FROM python:3.8.1-slim AS python-base

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.7.1 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/app/.venv" \
    PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# Install dependencies for building Python packages and Git
RUN apt-get update && apt-get install --no-install-recommends -y \
        curl build-essential libpq-dev gcc git \
    && pip install poetry==$POETRY_VERSION \
    && apt-get clean

# Set working directory
WORKDIR /app

# Copy project files and install dependencies
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-dev

# Copy the entire project
COPY . /app/

# Expose port and set the command
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
