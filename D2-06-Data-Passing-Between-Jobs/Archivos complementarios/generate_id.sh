#!/bin/bash
# Este script genera un ID único y lo imprime a la salida estándar.
UUID=$(uuidgen | cut -c1-8)
echo "Generated ID: $UUID"
echo "DEPLOYMENT_ID=$UUID" >> $GITHUB_OUTPUT
