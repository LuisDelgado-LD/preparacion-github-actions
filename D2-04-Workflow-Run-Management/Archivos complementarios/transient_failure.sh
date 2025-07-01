#!/bin/bash
echo "Intentando realizar una operación crítica..."
# Simular un fallo aleatorio. El script fallará si el número aleatorio es par.
RANDOM_NUM=$((RANDOM % 10))
if [ $((RANDOM_NUM % 2)) -eq 0 ]; then
  echo "Error: La operación falló debido a un problema transitorio (Número: $RANDOM_NUM)."
  exit 1
else
  echo "Éxito: La operación se completó correctamente (Número: $RANDOM_NUM)."
  exit 0
fi