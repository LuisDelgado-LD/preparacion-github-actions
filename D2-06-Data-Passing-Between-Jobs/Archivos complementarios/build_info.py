import json
import os
import datetime

# Construye un diccionario con información del build
build_data = {
    "version": "1.2.3",
    "commit_sha": os.getenv("GITHUB_SHA", "local")[:7],
    "build_timestamp": datetime.datetime.utcnow().isoformat(),
    "status": "success"
}

# Convierte el diccionario a una cadena JSON
json_string = json.dumps(build_data)

# Imprime para debugging y lo escribe a GITHUB_OUTPUT
print(f"Build info JSON: {json_string}")
with open(os.getenv('GITHUB_OUTPUT'), 'a') as f:
    f.write(f"build_data={json_string}\n")
