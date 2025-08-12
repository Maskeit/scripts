#!/bin/bash

# Función para verificar y liberar un puerto o un rango de puertos si están en uso#!/bin/bash

# Iniciar la API con Docker Compose
echo "Iniciando API con Docker Compose..."
cd /Users/miguelalejandrearreola/proplayasAPI || { echo "No se pudo acceder a la carpeta de la API"; exit 1; }
docker compose up -d

# Iniciar el frontend con npm run dev en segundo plano
echo "Iniciando frontend con npm run dev..."
cd /Users/miguelalejandrearreola/Desktop/dev/vue-proplayas || { echo "No se pudo acceder a la carpeta del frontend"; exit 1; }
npm run dev &

echo "La aplicación ProPlayas se ha iniciado correctamente."