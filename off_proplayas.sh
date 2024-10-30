#!/bin/bash

# Función para liberar un puerto o un rango de puertos si están en uso
function liberar_puertos() {
  local start_port=$1
  local end_port=$2

  for port in $(seq "$start_port" "$end_port"); do
    PID=$(lsof -t -i tcp:"$port")
    if [ -n "$PID" ]; then
      echo "Cerrando el proceso en el puerto $port (PID: $PID)..."
      kill -9 "$PID"
      echo "Puerto $port liberado."
    else
      echo "El puerto $port ya está libre."
    fi
  done
}

# 1. Cerrar la aplicación de Symfony
echo "Cerrando la aplicación de Symfony..."
pkill -f "symfony server:start"

# 2. Cerrar el frontend (npm)
echo "Cerrando el frontend..."
pkill -f "npm run dev"

# 3. Liberar los puertos 8000 y el rango 3000-3010
echo "Liberando los puertos..."
liberar_puertos 8000 8000
liberar_puertos 3000 3005

# 4. Detener y eliminar contenedores de Docker solo si existen
echo "Deteniendo y eliminando los contenedores de Docker..."
cd ~/Desktop/dev/proplayas4t/ || exit

# Verificar si el contenedor está en ejecución antes de intentar detenerlo y eliminarlo
if docker-compose ps | grep -q "proplayas4t"; then
  docker-compose down
  echo "Contenedor de Docker detenido y eliminado."
else
  echo "No hay contenedores de Docker activos para detener o eliminar."
fi

# 5. Opción para cerrar Docker Desktop solo si realmente necesitas liberarlo
# Si quieres cerrar Docker Desktop solo cuando sea estrictamente necesario, puedes comentar o descomentar esta parte.

# echo "Cerrando Docker Desktop..."
# osascript -e 'quit app "Docker"'

echo "Todos los procesos asociados a la aplicación han sido cerrados correctamente."
