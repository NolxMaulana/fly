# Pakai Node.js 22 (Debian Bookworm)
FROM node:22

# 1. Install dependensi sistem yang lengkap
RUN apt-get update && apt-get install -y \
    git \
    curl \
    python3 \
    python3-pip \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 2. Ambil kode OpenClaw lewat Git Clone
WORKDIR /opt/openclaw
RUN git clone https://github.com/openclaw/openclaw.git .

# 3. Install & Build secara internal (Lebih stabil)
RUN npm install
RUN npm run build

# 4. Hubungkan ke perintah sistem (Global Link)
RUN npm link

# 5. Siapkan folder kerja aplikasi
WORKDIR /app

# 6. Jalankan OpenClaw
CMD ["openclaw", "gateway", "start", "--foreground"]
