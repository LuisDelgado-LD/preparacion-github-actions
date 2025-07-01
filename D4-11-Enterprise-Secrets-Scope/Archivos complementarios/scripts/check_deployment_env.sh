#!/bin/bash
# scripts/check_deployment_env.sh

DEPLOY_ENV="$1"

echo "El entorno de despliegue es: $DEPLOY_ENV"

if [[ "$DEPLOY_ENV" == "staging" ]]; then
  echo "Desplegando a STAGING."
elif [[ "$DEPLOY_ENV" == "production" ]]; then
  echo "Desplegando a PRODUCTION."
else
  echo "Entorno no reconocido."
fi
