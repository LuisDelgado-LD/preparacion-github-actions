#!/bin/bash
# scripts/greet.sh

SECRET_MESSAGE="$1"

if [ -z "$SECRET_MESSAGE" ]; then
  echo "Error: No se ha proporcionado un mensaje secreto."
  exit 1
fi

echo "El mensaje secreto es: $SECRET_MESSAGE"
