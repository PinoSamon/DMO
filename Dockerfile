# =========================
# Base image
# =========================
FROM python:3.11-slim

# =========================
# System dependencies (GDAL / rasterio)
# =========================
RUN apt-get update && apt-get install -y \
    gdal-bin \
    libgdal-dev \
    libexpat1 \
    libproj-dev \
    libgeos-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# =========================
# Environment variables for GDAL
# =========================
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# =========================
# Set working directory
# =========================
WORKDIR /app

# =========================
# Install Python dependencies
# =========================
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# =========================
# Copy project files
# =========================
COPY . .

# =========================
# Expose port
# =========================
EXPOSE 8000

# =========================
# Run FastAPI
# =========================
CMD ["sh", "-c", "uvicorn backend.api:app --host 0.0.0.0 --port ${PORT:-8000}"]

