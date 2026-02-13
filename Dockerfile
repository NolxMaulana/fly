FROM node:20

# Install dependensi sistem yang dibutuhkan OpenClaw
RUN apt-get update && apt-get install -y \
    git \
    curl \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw Gateway secara global
RUN npm install -g @openclaw/gateway

# Tentukan folder kerja
WORKDIR /app

# Buka port 8080 untuk akses (opsional)
EXPOSE 8080

# Jalankan gateway OpenClaw dalam mode foreground biar Fly.io bisa baca lognya
CMD ["openclaw", "gateway", "start", "--foreground"]
