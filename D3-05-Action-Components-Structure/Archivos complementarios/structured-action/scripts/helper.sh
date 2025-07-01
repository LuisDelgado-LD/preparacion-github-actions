#!/bin/bash
# structured-action/scripts/helper.sh

TEXTO_A_PROCESAR=$1
# Simula una operación compleja
RESULTADO="$(echo $TEXTO_A_PROCESAR | rev)"

echo $RESULTADO