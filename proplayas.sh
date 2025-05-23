#!/bin/bash

# Función para verificar y liberar un puerto o un rango de puertos si están en uso
function liberar_puertos() {
  local start_port=$1
  local end_port=$2

  for port in $(seq "$start_port" "$end_port"); do
    PID=$(lsof -t -i tcp:"$port")
    if [ -n "$PID" ]; then
      echo "Liberando el puerto $port ocupado por el proceso $PID..."
      kill -9 "$PID"
      echo "Puerto $port liberado."
    else
      echo "El puerto $port está libre."
    fi
  done
}

# Función para esperar a que Docker Desktop esté completamente iniciado
function esperar_docker() {
  echo "Esperando a que Docker Desktop esté completamente listo..."
  while ! docker info > /dev/null 2>&1; do
    sleep 2
  done
  echo "Docker Desktop está listo."
}

# Verificar si Docker Desktop ya está en ejecución
if pgrep -x "Docker" > /dev/null; then
  echo "Docker Desktop ya está en ejecución."
else
  echo "Iniciando Docker Desktop..."
  open -a Docker
  sleep 5  # Esperar unos segundos antes de verificar
  esperar_docker  # Esperar hasta que Docker esté completamente listo
fi

# Verificar que Docker esté ejecutándose correctamente en segundo plano
if ! pgrep -x "com.docker.backend" > /dev/null; then
  echo "Docker Desktop no se ha iniciado correctamente. Por favor, verifica manualmente."
  exit 1
fi

# Habilitar la API
echo "Habilitando la API..."

# Navegar al directorio del contenedor y verificar el estado del contenedor
cd ~/proplayasAPI || exit
echo "Iniciando el contenedor de Docker..."
docker-compose up -d
sleep 5  # Esperar unos segundos para permitir que los contenedores inicien

# Verificar que el contenedor específico está en ejecución
if ! docker ps | grep -q "proplayasapi"; then
  echo "El contenedor de Docker no se ha iniciado correctamente."
  exit 1
else
  echo "El contenedor de Docker está en ejecución."
fi

# Liberar los puertos 8000 y el rango 3000-3010
liberar_puertos 8000 8000
liberar_puertos 5173 5174

# Iniciar el frontend
echo "Iniciando el frontend..."

# Navegar a la ruta del frontend
cd ~/Desktop/dev/vue-proplayas/ || exit

# Ejecutar la aplicación con npm en segundo plano
echo "Abriendo entorno de trabajo..."
(code .)
sleep 2

# Verificar que todos los servicios están en ejecución
echo "Verificando que todos los servicios estén en ejecución..."

# Verificar que Docker Desktop sigue ejecutándose
if ps aux | grep -i "[d]ocker.app/Contents/MacOS/Docker Desktop" > /dev/null && ps aux | grep -i "[c]om.docker.backend" > /dev/null; then
  echo "Docker Desktop está en ejecución."
else
  echo "Docker Desktop no está en ejecución."
  exit 1
fi

# Mensaje final
echo "Todo listo. La API y el frontend están en ejecución correctamente."
echo "Ejecuta ./off_proplayas para terminar todos los procesos."
