FROM python:3.11-slim

# ===== System deps for rasterio / gdal =====
RUN apt-get update && apt-get install -y \
    gdal-bin \
    libgdal-dev \
    libexpat1 \
    libproj-dev \
    libgeos-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# ===== Set workdir =====
WORKDIR /app

# ===== Copy & install deps =====
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# ===== Copy source code =====
COPY . .

# ===== Ensure Python can find /app =====
ENV PYTHONPATH=/app

# ===== Run FastAPI =====
CMD ["sh", "-c", "uvicorn backend.api:app --host 0.0.0.0 --port ${PORT:-8000}"]
