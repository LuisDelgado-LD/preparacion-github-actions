#!/bin/bash
# saludo-action/entrypoint.sh

NOMBRE=$1
APELLIDO=$2

MENSAJE_SALUDO="Saludos, $NOMBRE $APELLIDO. ¡Bienvenido desde un script!"

echo "mensaje_final=$MENSAJE_SALUDO" >> $GITHUB_OUTPUT