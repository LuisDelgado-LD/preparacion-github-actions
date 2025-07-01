#!/bin/sh -l
# action/entrypoint.sh
echo "Hola, $1!"
echo "saludo=Hola, $1!" >> $GITHUB_OUTPUT