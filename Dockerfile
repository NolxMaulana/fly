# Pakai Node.js 22 sesuai syarat OpenClaw terbaru
FROM node:22-bookworm

# 1. Install dependensi sistem lengkap
RUN apt-get update && apt-get install -y \
    git curl python3 python3-pip build-essential bash \
    && rm -rf /var/lib/apt/lists/*

# 2. Install pnpm versi 10
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable && corepack prepare pnpm@10.23.0 --activate

# 3. Setup OpenClaw
WORKDIR /opt/openclaw
RUN git clone https://github.com/openclaw/openclaw.git .
RUN pnpm install --frozen-lockfile
RUN pnpm run build
RUN pnpm link --global

# 4. Folder kerja user
WORKDIR /app

# 5. Jalankan OpenClaw Gateway (PERBAIKAN: Hapus flag --foreground)
CMD ["openclaw", "gateway", "start"]
