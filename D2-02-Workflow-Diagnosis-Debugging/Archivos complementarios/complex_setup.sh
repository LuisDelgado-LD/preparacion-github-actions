#!/bin/bash
set -e
echo "Creando una estructura de archivos compleja..."
mkdir -p /tmp/my-app/data

# Se crea un archivo en una ubicación inesperada
echo "Contenido del log" > ./debug.log

echo "La configuración ha finalizado, pero falta un archivo clave."
