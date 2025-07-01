#!/bin/bash
# structured-action/entrypoint.sh

INPUT_STRING=$1

# Llama al script auxiliar usando la ruta relativa a la acción
HELPER_SCRIPT_PATH="${GITHUB_ACTION_PATH}/scripts/helper.sh"

# Asegúrate de que el helper sea ejecutable
chmod +x $HELPER_SCRIPT_PATH

REVERSE_STRING=$($HELPER_SCRIPT_PATH "$INPUT_STRING")

echo "processed-string=El reverso de '$INPUT_STRING' es '$REVERSE_STRING'" >> $GITHUB_OUTPUT