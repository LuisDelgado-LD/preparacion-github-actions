#!/bin/bash
# scripts/welcome.sh

TEAM_NAME="$1"

if [ -z "$TEAM_NAME" ]; then
  echo "Error: Nombre del equipo no proporcionado."
  exit 1
fi

echo "Bienvenido, equipo '$TEAM_NAME'. Este es un mensaje seguro."
