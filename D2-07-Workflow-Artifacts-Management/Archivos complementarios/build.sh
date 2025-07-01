#!/bin/bash
echo "Iniciando el proceso de build..."
mkdir -p dist
echo "Creando un archivo de paquete simulado..."
cp main.py dist/
echo "Build completado. El artefacto está en la carpeta 'dist'."