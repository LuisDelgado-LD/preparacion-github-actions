#!/bin/bash
echo "Ejecutando pruebas críticas..."
mkdir -p logs
# Simular un fallo
echo "Error: Una prueba crítica ha fallado. Detalles en error.log" > logs/error.log
exit 1