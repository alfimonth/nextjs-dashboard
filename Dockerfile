# 1. Gunakan image Node.js berbasis Alpine yang ringan
FROM node:22-alpine AS builder

# 2. Set working directory di dalam container
WORKDIR /app

# 3. Install pnpm secara global
RUN npm install -g pnpm

# 3. Salin file package.json dan package-lock.json
COPY package.json pnpm-lock.yaml ./

# 4. Install dependencies
RUN pnpm install
RUN pnpm rebuild bcrypt

# 5. Salin semua file proyek ke dalam container
COPY . .

# 6. Build aplikasi Next.js (hasilnya ada di .next/)
RUN pnpm run build

# 7. Gunakan image runtime yang lebih kecil untuk menjalankan aplikasi
FROM node:22-alpine AS runner

# 8. Set working directory
WORKDIR /app

RUN npm install -g pnpm

# Salin hasil build
COPY --from=builder /app .

# Jalankan aplikasi
CMD ["pnpm", "run", "start"]

