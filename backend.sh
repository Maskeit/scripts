# entramos al directorio donde esta el proyecto
cd fastapi-vantichat

# Una vez agregado el archivo .env, ejecutamos el siguiente comando para levantar el contenedor
docker compose build --no-cache

# levantamos el contenedor en segundo plano
docker compose up -d

# inicializamos la base de datos
docker compose exec -it fastapi-vantichat_api bash -c "python /app/core/redis_index_initializer.py"

# Si ya existe un respaldo de datos de redis en formato rdb, 
#lo importamos usando el script pasandole como argumento el nombre del archivo
# Por ejemplo, si el archivo se llama backup_vantivadb_20250801_
./restore_redis.sh backup_vantivadb_20250801_010109.rdb


# Entramos al directorio del proyecto del frontend
cd nextjs-vantichat
# Creamos el archivo .env con las variables de entorno necesarias
# Instalamos las dependencias del proyecto
npm install
# Construimos el proyecto
npm run build
# Iniciar el servicio usando pm2
pm2 start npm --name "nextjs-vantichat" -- run start
pm2 save


# Configuramos el proxy reverso de nginx
# Para que el frontend pueda comunicarse con el backend usando el nombre de dominio (y no localhost), 
# se debe configurar un proxy inverso con Nginx.

# Ejemplo de configuración básica /etc/nginx/sites-available/vantiva
server {
    listen 80;
    server_name mi-dominio.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    listen 80;
    server_name api.mi-dominio.com;

    location / {
        proxy_pass http://localhost:8000;  # puerto de FastAPI
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}