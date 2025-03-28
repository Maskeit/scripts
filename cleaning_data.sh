#!/bin/bash

echo "🔧 Iniciando limpieza del sistema..."

# Carpeta de Application Support a limpiar
apps=(
  "pyinstaller"
  "TabNine"
  "Notion"
  "tlauncher"
  "Postman"
  "BraveSoftware"
  "zoom.us"
  "Spotify"
)

# Eliminar Application Support de apps innecesarias
for app in "${apps[@]}"; do
  path="$HOME/Library/Application Support/$app"
  if [ -d "$path" ]; then
    echo "🧹 Eliminando $path"
    rm -rf "$path"
  fi
done

# Limpiar cachés del usuario
echo "🧹 Limpiando cachés de usuario..."
rm -rf ~/Library/Caches/*

# Limpiar logs del usuario
echo "🧹 Limpiando logs de usuario..."
rm -rf ~/Library/Logs/*

# Reindexar Spotlight para liberar índice viejo (opcional)
echo "🧠 Reindexando Spotlight..."
sudo mdutil -E /

# Mostrar espacio libre actual
echo "📦 Espacio libre después de limpieza:"
df -h /

echo "✅ Limpieza completada."
