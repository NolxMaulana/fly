# 1. Pakai Node.js 22 sesuai syarat OpenClaw terbaru
FROM node:22-bookworm

# 2. Install dependensi sistem untuk kompilasi modul native
RUN apt-get update && apt-get install -y \
    git \
    curl \
    python3 \
    python3-pip \
    build-essential \
    bash \
    && rm -rf /var/lib/apt/lists/*

# 3. Install pnpm versi 10 secara global (Solusi untuk error 'pnpm not found')
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable && corepack prepare pnpm@10.23.0 --activate

# 4. Ambil kode sumber dari GitHub
WORKDIR /opt/openclaw
RUN git clone https://github.com/openclaw/openclaw.git .

# 5. Install & Build menggunakan pnpm
RUN pnpm install --frozen-lockfile
RUN pnpm run build

# 6. Registrasikan perintah 'openclaw' agar bisa dipanggil sistem
RUN pnpm link --global

# 7. Setup folder kerja (tempat simpan memori & script kamu)
WORKDIR /app

# 8. Jalankan OpenClaw Gateway
# --foreground agar Fly.io bisa terus memantau statusnya
CMD ["openclaw", "gateway", "start", "--foreground"]
