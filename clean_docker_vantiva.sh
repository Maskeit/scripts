#!/bin/bash

# Nombre base del proyecto
PROJECT_NAME="fastapi-vantichat"
PROJECT_PATH="/Users/miguelalejandrearreola/Desktop/dev/vantiva/fastapi-vantichat"

echo "🧹 Iniciando limpieza para $PROJECT_NAME..."

# Borrar contenedores relacionados
echo "🧹 Eliminando contenedores relacionados con $PROJECT_NAME..."
docker ps -a --filter "name=${PROJECT_NAME}" --format "{{.ID}}" | xargs -r docker rm -f

# Borrar imágenes relacionadas
echo "🧼 Eliminando imágenes relacionadas con $PROJECT_NAME..."
docker images --format "{{.Repository}} {{.ID}}" | grep "$PROJECT_NAME" | awk '{print $2}' | xargs -r docker rmi -f

# Borrar red personalizada
echo "🌐 Eliminando red personalizada 'vantichat_network' si existe..."
docker network rm vantichat_network 2>/dev/null || echo "ℹ️  La red no existía o ya fue eliminada."

# Borrar volúmenes nombrados específicos
echo "🗃️  Eliminando volúmenes nombrados relacionados con $PROJECT_NAME..."
docker volume ls --format '{{.Name}}' | grep "vantichat_" | xargs -r docker volume rm

# Pregunta para limpieza total
read -p "❓ ¿Deseas eliminar TODOS los volúmenes de Docker? Esto podría borrar datos de otros proyectos. (s/N): " confirm_all
if [[ "$confirm_all" == "s" || "$confirm_all" == "S" ]]; then
    echo "⚠️ Eliminando TODOS los volúmenes de Docker..."
    docker volume prune -f
else
    echo "🛑 Conservando los volúmenes no relacionados."
fi

# Preguntar si quiere construir después de limpiar
read -p "🔨 ¿Deseas construir el proyecto ahora desde $PROJECT_PATH? (y/N): " confirm_build
if [[ "$confirm_build" == "y" || "$confirm_build" == "Y" ]]; then
    echo "🏗️ Construyendo proyecto..."
    cd "$PROJECT_PATH" || { echo "❌ Ruta no encontrada: $PROJECT_PATH"; exit 1; }
    docker compose build && echo "✅ Build completado."
else
    echo "📦 Saltando construcción. Puedes hacerla manualmente después."
fi

echo "✅ Limpieza finalizada."
