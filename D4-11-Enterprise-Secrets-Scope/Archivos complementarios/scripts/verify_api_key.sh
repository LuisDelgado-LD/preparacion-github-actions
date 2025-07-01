#!/bin/bash
# scripts/verify_api_key.sh

API_KEY="$1"

if [ -z "$API_KEY" ]; then
  echo "Error: No se proporcionó API_KEY."
  exit 1
fi

# Simula la verificación de la clave
if [[ "$API_KEY" == "super-secret-org-key" ]]; then
  echo "Autenticación exitosa con la clave de organización."
else
  echo "Error: Clave de API no válida."
  exit 1
fi
