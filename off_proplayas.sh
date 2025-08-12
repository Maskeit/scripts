#!/bin/bash

FRONT_PATH="/Users/miguelalejandrearreola/Desktop/dev/vue-proplayas"
BACK_PATH="/Users/miguelalejandrearreola/proplayasAPI"

stop_front() {
  echo "Deteniendo frontend..."
  # Buscar el proceso de npm run dev y matarlo
  pkill -f "npm run dev" && echo "Frontend detenido." || echo "No se encontró el proceso del frontend."
}

stop_back() {
  echo "Deteniendo API (Docker Compose)..."
  cd "$BACK_PATH" || { echo "No se pudo acceder a la carpeta de la API"; exit 1; }
  docker compose down
}

case "$1" in
  front)
    stop_front
    ;;
  back)
    stop_back
    ;;
  "" )
    stop_front
    stop_back
    ;;
  *)
    echo "Uso: $0 [front|back]"
    ;;
esac