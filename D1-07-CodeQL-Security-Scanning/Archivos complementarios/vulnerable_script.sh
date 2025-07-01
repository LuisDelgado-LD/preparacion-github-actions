#!/bin/bash

echo "Running vulnerable script..."

# Vulnerabilidad: Uso de eval con entrada no confiable
# Esto es susceptible a Command Injection o ejecución de código arbitrario
user_input="$1"
if [ -n "$user_input" ]; then
    echo "Evaluating input: $user_input"
    eval "$user_input" # ¡PELIGROSO!
else
    echo "No input provided."
fi
