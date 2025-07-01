#!/bin/bash
set -e

TITLE="$1"
echo "Verificando el título del Pull Request: '$TITLE'"

if [[ "$TITLE" =~ ^(feat|fix|docs|chore): ]]; then
  echo "El título cumple con el formato requerido."
  exit 0
else
  echo "Error: El título del PR debe comenzar con 'feat:', 'fix:', 'docs:', o 'chore:'."
  exit 1
fi
