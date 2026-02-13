# 1. Pakai Node.js 22 sesuai syarat package.json
FROM node:22-bookworm

# 2. Install dependensi sistem untuk kompilasi modul native (WAJIB)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    python3 \
    python3-pip \
    build-essential \
    bash \
    && rm -rf /var/lib/apt/lists/*

# 3. Setup pnpm versi 10 (sesuai packageManager di package.json)
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable && corepack prepare pnpm@10.23.0 --activate

# 4. Ambil kode sumber
WORKDIR /opt/openclaw
RUN git clone https://github.com/openclaw/openclaw.git .

# 5. Install & Build (Jalur pnpm agar sesuai dengan hanyaBuiltDependencies)
# --frozen-lockfile memastikan instalasi sesuai dengan versi developer
RUN pnpm install --frozen-lockfile
RUN pnpm run build

# 6. Registrasikan perintah 'openclaw' ke sistem secara global
RUN pnpm link --global

# 7. Setup folder kerja aplikasi (tempat simpan memori/script)
WORKDIR /app

# 8. Jalankan OpenClaw Gateway
# --foreground agar Fly.io bisa terus memantau prosesnya
CMD ["openclaw", "gateway", "start", "--foreground"]
