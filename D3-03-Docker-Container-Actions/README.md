# Concepto a Resolver: Creación y Uso de Acciones de Contenedor Docker
Este módulo se enfoca en cómo construir, utilizar y distribuir acciones que se ejecutan dentro de contenedores Docker, una de las tres formas de crear acciones en GitHub Actions. Aprenderás a definir los metadatos de la acción, crear un Dockerfile, y configurar un workflow para que utilice tu acción de contenedor.

---

## Desafío 1: Mi Primera Acción Docker
**Descripción:** Crea una acción de contenedor Docker simple que recibe un nombre como entrada y genera un saludo como salida. Este desafío te introducirá en la estructura básica de una acción Docker.

**Archivos a crear por el estudiante:**
- `action/action.yml`
- `action/Dockerfile`
- `action/entrypoint.sh`
- `.github/workflows/test-docker-action.yml`

**Archivos de apoyo (proporcionados por ti):**
No se necesitan archivos de apoyo externos. Deberás crear los contenidos de la acción desde cero.

**Contenido de los archivos a crear:**

**`action/Dockerfile` (Plantilla):**
```dockerfile
# action/Dockerfile
FROM alpine:3.17
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
```

**`action/entrypoint.sh` (Plantilla):**
```bash
#!/bin/sh -l
# action/entrypoint.sh
echo "Hola, $1!"
echo "saludo=Hola, $1!" >> $GITHUB_OUTPUT
```

**Instrucciones del workflow:**
Tu workflow (`.github/workflows/test-docker-action.yml`) debe:
1.  Activarse con un `workflow_dispatch`.
2.  Tener un job que se ejecute en `ubuntu-latest`.
3.  Utilizar (hacer "checkout") el código de tu repositorio.
4.  Usar tu acción Docker local (`./action`) con un `id` para poder acceder a su salida.
5.  Pasar un nombre de tu elección al input `quien`.
6.  Imprimir el `saludo` generado por la acción en un paso posterior.

### Resultado Esperado:
- El workflow se ejecuta correctamente.
- El log del workflow muestra el mensaje "Hola, [tu-nombre]!" impreso desde el script `entrypoint.sh`.
- El log del workflow muestra el resultado del `echo` que imprime la salida de la acción.

---

## Desafío 2: Acción Docker con Múltiples Argumentos y Lógica
**Descripción:** Amplía la acción anterior para que acepte un segundo argumento y realice una operación simple. Esto te enseñará a manejar múltiples argumentos y a ejecutar lógica más compleja dentro del contenedor.

**Archivos a crear por el estudiante:**
- `.github/workflows/multi-arg-action.yml`
- Modificar los archivos de la acción del desafío anterior (`action/action.yml`, `action/entrypoint.sh`).

**Archivos de apoyo (proporcionados por ti):**
Utiliza los archivos del desafío anterior como base.

**Contenido de los archivos a modificar:**

**`action/entrypoint.sh` (Modificado):**
```bash
#!/bin/sh -l
# action/entrypoint.sh
NUM1=$1
NUM2=$2

SUMA=$(($NUM1 + $NUM2))

echo "La suma de $NUM1 y $NUM2 es $SUMA."
echo "resultado=$SUMA" >> $GITHUB_OUTPUT
```

**Instrucciones del workflow:**
Tu workflow (`.github/workflows/multi-arg-action.yml`) debe:
1.  Activarse con un `push` a la rama `main`.
2.  Utilizar tu acción Docker local (`./action`).
3.  Pasar dos números de tu elección a los inputs `num1` y `num2`.
4.  Imprimir el `resultado` de la acción en un paso final.

### Resultado Esperado:
- El workflow se ejecuta sin errores tras un `push` a `main`.
- El log del workflow muestra el mensaje "La suma de [num1] y [num2] es [suma]".
- El paso final del workflow imprime correctamente el valor numérico del resultado.

---

## Desafío 3: Debugging de una Acción Docker
**Descripción:** Se te proporciona un workflow y los archivos de una acción Docker que no funcionan correctamente. Tu tarea es identificar y corregir los errores para que el workflow se complete con éxito.

**Archivos a crear por el estudiante:**
- Ninguno. Debes corregir los archivos existentes.

**Archivos de apoyo (proporcionados por ti con errores):**

**`.github/workflows/broken-workflow.yml`:**
```yaml
# .github/workflows/broken-workflow.yml
name: Broken Docker Action Workflow
on: workflow_dispatch

jobs:
  debug-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run broken action
        id: broken-action
        uses: ./action-debug
        with:
          file-path: 'data.txt'
      - name: Check output
        run: echo "File content is ${{ steps.broken-action.outputs.content }}"
```

**`action-debug/action.yml`:**
```yaml
# action-debug/action.yml
name: 'Debug Action'
description: 'Reads a file from the workspace'
inputs:
  file_path: # Falta la propiedad 'required' y 'description'
    default: 'file.txt'
outputs:
  content:
    description: 'Content of the file'
runs:
  using: 'docker'
  image: 'Dockerfile'
  # Faltan los args para pasar el input al entrypoint
```

**`action-debug/Dockerfile`:**
```dockerfile
# action-debug/Dockerfile
FROM alpine:3.17
# Falta copiar el entrypoint.sh al contenedor
ENTRYPOINT ["/read_file.sh"]
```

**`action-debug/read_file.sh`:**
```bash
#!/bin/sh
# action-debug/read_file.sh
FILE_CONTENT=$(cat $1)
echo "file_content=$FILE_CONTENT" >> $GITHUB_OUTPUT # El nombre del output no coincide con action.yml
```

**`data.txt`:**
```
Este es el contenido de prueba.
```

**Instrucciones del workflow:**
1.  Analiza el error que produce el workflow al ejecutarse.
2.  Revisa los 3 archivos de la acción (`action.yml`, `Dockerfile`, `read_file.sh`) y el workflow (`broken-workflow.yml`) para encontrar las inconsistencias.
3.  Corrige los errores para que el workflow pueda leer el contenido de `data.txt` y mostrarlo correctamente.

**Pistas:**
- ¿El `action.yml` está pasando correctamente los `inputs` al contenedor?
- ¿El `Dockerfile` está configurado para incluir todos los scripts necesarios?
- ¿Los nombres de las variables y outputs coinciden entre `action.yml`, el script y el workflow?
- Observa con atención los nombres de los inputs y outputs en todos los archivos.

### Resultado Esperado:
- El workflow se ejecuta y finaliza con éxito.
- El último paso del workflow imprime: "File content is Este es el contenido de prueba.".
