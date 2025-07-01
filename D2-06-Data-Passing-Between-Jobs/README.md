
# Concepto a Resolver: Paso de Datos Entre Trabajos (Data Passing Between Jobs)
En workflows complejos, es común que un trabajo necesite utilizar la salida o los resultados generados por otro trabajo anterior. Este módulo se centra en la técnica de utilizar `outputs` para pasar datos de manera estructurada y fiable entre trabajos que dependen unos de otros, permitiendo construir cadenas de ejecución más dinámicas y acopladas.

---

## Desafío 1: Pasar un Identificador Simple Entre Trabajos
En este escenario, un primer trabajo generará un ID de despliegue único, y un segundo trabajo consumirá ese ID para simular un despliegue. Este es el caso de uso más fundamental para los `outputs`.

**Archivos a crear por el estudiante:**
- `.github/workflows/simple-data-passing.yml`

**Archivos de apoyo (proporcionados por ti):**
- `generate_id.sh`

**Contenido de los archivos de apoyo:**
```bash
# generate_id.sh
# Este script genera un ID único y lo imprime a la salida estándar.
UUID=$(uuidgen | cut -c1-8)
echo "Generated ID: $UUID"
echo "DEPLOYMENT_ID=$UUID" >> $GITHUB_OUTPUT
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse manualmente con `workflow_dispatch`.
- Contener dos trabajos: `generate_deployment_id` y `deploy`.
- El trabajo `generate_deployment_id` debe:
    - Ejecutar el script `generate_id.sh`.
    - Capturar el ID generado y definirlo como un `output` del trabajo con el nombre `deployment_id`.
- El trabajo `deploy` debe:
    - Depender del primer trabajo (`needs: generate_deployment_id`).
    - Acceder al `output` del trabajo anterior usando el contexto `needs`.
    - Imprimir en un paso: "Deploying with ID: ${{ needs.generate_deployment_id.outputs.deployment_id }}".

### Resultado Esperado:
- Al ejecutar el workflow, el primer trabajo genera un ID (ej: `a1b2c3d4`).
- El segundo trabajo se inicia y muestra el mensaje "Deploying with ID: a1b2c3d4" en sus logs, confirmando que recibió el dato correctamente.

---

## Desafío 2: Pasar un Objeto JSON Entre Trabajos
A menudo, necesitas pasar datos más complejos que una simple cadena. En este desafío, un trabajo construirá un objeto JSON, lo convertirá a una cadena, lo pasará como `output`, y el siguiente trabajo lo analizará y utilizará sus valores.

**Archivos a crear por el estudiante:**
- `.github/workflows/json-data-passing.yml`

**Archivos de apoyo (proporcionados por ti):**
- `build_info.py`

**Contenido de los archivos de apoyo:**
```python
# build_info.py
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
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse en `push` a `main`.
- Tener dos trabajos: `build` y `report`.
- El trabajo `build` debe:
    - Ejecutar el script `build_info.py` para generar la información.
    - Definir la cadena JSON generada como un `output` llamado `build_data`.
- El trabajo `report` debe:
    - Depender de `build` (`needs: build`).
    - Acceder al `output` `build_data`.
    - Usar la función `fromJSON()` para convertir la cadena de vuelta a un objeto JSON.
    - Imprimir un resumen: "Build Report - Version: ${{ fromJSON(needs.build.outputs.build_data).version }}, Commit: ${{ fromJSON(needs.build.outputs.build_data).commit_sha }}".

### Resultado Esperado:
- El trabajo `build` se ejecuta y produce una cadena JSON como `output`.
- El trabajo `report` recibe la cadena, la parsea correctamente y muestra el mensaje "Build Report - Version: 1.2.3, Commit: [sha_del_commit]", demostrando el uso de `fromJSON`.

---

## Desafío 3: Resolución de Problemas - Datos de Salida Mal Formateados
Un compañero ha creado un workflow para pasar datos, pero el trabajo consumidor no los recibe correctamente. El valor llega vacío o como una cadena inesperada. Tu tarea es depurar el workflow y arreglar el paso de datos.

**Archivos a crear por el estudiante:**
- El estudiante debe **corregir** el siguiente archivo.

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/debug-outputs.yml`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/debug-outputs.yml
name: Debugging Outputs
on: workflow_dispatch

jobs:
  producer:
    runs-on: ubuntu-latest
    outputs:
      # La definición del output está mal aquí
      result: steps.set_result.output.result_value
    steps:
      - id: set_result
        run: echo "result_value=hello-world" >> $GITHUB_OUTPUT

  consumer:
    runs-on: ubuntu-latest
    needs: producer
    steps:
      - name: Use the output
        run: echo "The value from producer is: ${{ needs.producer.outputs.result }}"
```

**El Problema:**
El trabajo `consumer` imprime "The value from producer is: " pero el valor está en blanco. El `output` del trabajo `producer` no se está asignando correctamente.

**Pistas:**
1.  Revisa la sintaxis para definir los `outputs` de un trabajo. ¿Dónde se debe hacer referencia al `id` del paso?
2.  La sintaxis `steps.set_result.output.result_value` es incorrecta en el nivel de `jobs.producer.outputs`. La forma correcta es `steps.set_result.outputs.result_value` (con `outputs` en plural).
3.  Compara la sección `outputs` del trabajo `producer` con la documentación oficial de GitHub Actions. ¿Notas alguna discrepancia en la forma en que se referencia el `output` de un paso?

### Resultado Esperado:
- Identificas que la sintaxis en la sección `outputs` del trabajo `producer` es incorrecta.
- Corriges `output` a `outputs` en la referencia `steps.set_result.output.result_value`.
- Al ejecutar el workflow corregido, el trabajo `consumer` imprime correctamente "The value from producer is: hello-world".
