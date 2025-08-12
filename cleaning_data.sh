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


# Eliminar backups de iPhone si existen
backup_path="$HOME/Library/Application Support/MobileSync/Backup"
if [ -d "$backup_path" ]; then
  echo "📱 Eliminando backup de iPhone en $backup_path"
  rm -rf "$backup_path"
fi

# Eliminar contenedor de Slack si existe
slack_path="$HOME/Library/Containers/com.tinyspeck.slackmacgap"
if [ -d "$slack_path" ]; then
  echo "💬 Eliminando datos de Slack"
  rm -rf "$slack_path"
fi


# Reindexar Spotlight para liberar índice viejo (opcional)
echo "🧠 Reindexando Spotlight..."
sudo mdutil -E /


# Limpiar temporales del sistema (sin sudo)
echo "🧹 Limpiando archivos temporales..."
rm -rf /private/var/folders/* 2>/dev/null
rm -rf /private/var/tmp/* 2>/dev/null


# Mostrar espacio libre actual
echo "📦 Espacio libre después de limpieza:"
df -h /

# Notificar sobre acciones manuales opcionales
echo "⚠️  Acciones adicionales recomendadas (ejecutar manualmente con sudo si lo deseas):"
echo "    sudo rm -rf /private/var/vm/*               # Eliminar archivos de swap"
echo "    sudo mdutil -E /                             # Reindexar Spotlight"
echo "    Revisa snapshots de APFS con: diskutil apfs list"

echo "✅ Limpieza completada."

