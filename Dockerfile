FROM node:22

# Install dependensi sistem
RUN apt-get update && apt-get install -y \
    git \
    curl \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw langsung dari GitHub (karena tidak ada di npm)
RUN npm install -g https://github.com/openclaw/openclaw

# Tentukan folder kerja
WORKDIR /app

# Buka port untuk gateway
EXPOSE 8080

# Jalankan gateway OpenClaw
CMD ["openclaw", "gateway", "start", "--foreground"]
