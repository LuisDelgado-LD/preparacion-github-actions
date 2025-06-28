#!/bin/bash
LOGFILE=error.log
> "$LOGFILE"

for file in src/*.py; do
    python -m py_compile "$file" 2>> "$LOGFILE"
done

if [[ -s "$LOGFILE" ]]; then
    echo "Errores detectados."
    exit 1
else
    echo "Validación exitosa."
fi