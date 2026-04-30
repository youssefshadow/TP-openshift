# Étape 1 : Build de l'application Angular
FROM node:18-alpine AS build
WORKDIR /app

# Définition de l'environnement
ENV NODE_ENV=production

# Installation des dépendances (optimisée avec le cache Docker)
COPY package.json package-lock.json* ./
RUN npm ci --silent --include=dev

# Copie du code source et build
COPY . .
# Note : on build dans le dossier /app/dist
RUN npx ng build --output-path=dist --configuration production

# Étape 2 : Serveur Nginx pour servir le contenu statique
FROM nginxinc/nginx-unprivileged:1.25-alpine

# 1. Copie de ta configuration Nginx personnalisée (Reverse Proxy /api)
# Comme le Dockerfile est à la racine, on pointe vers le sous-dossier docker/frontend/
COPY docker/frontend/nginx.conf /etc/nginx/conf.d/default.conf

# 2. Copie des fichiers compilés Angular
# ATTENTION : Si ton build Angular crée un sous-dossier (ex: dist/browser), 
# ajuste le chemin ci-dessous. Ici, on prend tout le contenu de /app/dist.
COPY --from=build /app/dist /usr/share/nginx/html

# 3. Configuration réseau et sécurité pour OpenShift
EXPOSE 8080
USER 101

# Lancement de Nginx
CMD ["nginx", "-g", "daemon off;"]