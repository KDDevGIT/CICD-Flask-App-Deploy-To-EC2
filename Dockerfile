# Use a small base image for faster pulls.
FROM python:3.12-slim

# Avoid interactive prompts during package installs.
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000

# System deps (only if you need gcc, etc. Keep minimal)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Create app user and workdir
RUN useradd -m -u 10001 appuser
WORKDIR /app

# Install Python deps first for better Docker layer caching
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy source
COPY app /app/app

# Switch to non-root
USER appuser

# Expose container port (mapped to 80 on the host in deploy step)
EXPOSE 8000

# Use Gunicorn for prod serving
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8000", "app.wsgi:app"]
