# Concepto a Resolver: Comandos de Workflow para la Comunicación con Acciones
Los comandos de workflow (`workflow commands`) son un mecanismo fundamental para que las acciones se comuniquen con el ejecutor de GitHub Actions. Permiten establecer variables de entorno, definir salidas, añadir rutas al sistema, agrupar logs y marcar pasos con errores o advertencias, todo desde el script de una acción.

---

## Desafío 1: Establecer Salidas y Variables de Entorno
Crea una acción compuesta que genere un ID de despliegue único y lo comunique de dos formas: como una salida (`output`) y como una variable de entorno para los pasos siguientes del mismo job.

**Archivos a crear por el estudiante:**
- `id-generator/action.yml`
- `.github/workflows/test-commands.yml`

**Instrucciones de la acción (`id-generator/action.yml`):**
- **`name`**: "Generador de ID Único"
- **`description`**: "Genera un ID único y lo expone como salida y variable de entorno."
- **`outputs`**:
  - `deployment-id`:
    - `description`: 'El ID de despliegue generado.'
- **`runs`**:
  - `using`: 'composite'
  - `steps`:
    - Un paso que:
      1.  Genere un ID combinando "deploy-" con un número aleatorio (ej. `deploy-$RANDOM`).
      2.  Use `echo "::set-output name=deployment-id::{ID_GENERADO}"` para establecer la salida.
      3.  Use `echo "{ID_GENERADO}={VALOR}" >> $GITHUB_ENV` para crear una variable de entorno llamada `DEPLOY_ID` con el mismo valor.

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse con `workflow_dispatch`.
- Usar la acción local `./id-generator`.
- En un paso posterior, imprimir tanto la salida de la acción (`steps.ID_DEL_PASO.outputs.deployment-id`) como la variable de entorno (`env.DEPLOY_ID`).

### Resultado Esperado:
- El workflow se ejecuta correctamente.
- Ambos comandos `echo` en el workflow imprimen el mismo ID de despliegue único.

---

## Desafío 2: Agrupación de Logs y Mensajes de Depuración
Crea una acción que simule un proceso de build con múltiples etapas, usando comandos de workflow para agrupar los logs de cada etapa y emitir mensajes de depuración que solo sean visibles cuando se habilita el debugging en el repositorio.

**Archivos a crear por el estudiante:**
- `build-simulator/action.yml`
- `.github/workflows/test-logging.yml`

**Instrucciones de la acción (`build-simulator/action.yml`):**
- **`runs`**:
  - `using`: 'composite'
  - `steps`:
    - Un paso que simule el proceso:
      1.  Inicia un grupo de logs con `echo "::group::Paso 1: Compilando código"`.
      2.  Imprime algunos mensajes dentro del grupo.
      3.  Cierra el grupo con `echo "::endgroup::"`.
      4.  Emite un mensaje de depuración con `echo "::debug::Versión del compilador: 1.2.3"`.
      5.  Inicia y cierra otro grupo para "Paso 2: Ejecutando pruebas".

**Instrucciones del workflow:**
- Crea un workflow que simplemente ejecute esta acción.
- Para ver el resultado completo, deberás habilitar el "Actions step debugging" en la configuración de secretos de tu repositorio (`ACTIONS_STEP_DEBUG` a `true`).

### Resultado Esperado:
- En los logs del workflow, verás dos grupos plegables: "Paso 1: Compilando código" y "Paso 2: Ejecutando pruebas".
- Si el debugging está activado, verás el mensaje "Versión del compilador: 1.2.3" en los logs del paso. Si no, estará oculto.

---

## Desafío 3: Resolución de Problemas - Comandos de Workflow Malformados
Un compañero ha creado una acción para anotar el código con advertencias, pero los mensajes no aparecen en la pestaña "Summary" del workflow ni junto al código. Debes encontrar y corregir el error en el comando de workflow.

**Archivos de apoyo (proporcionados por ti):**
- `code-annotator/action.yml`
- `code-annotator/main.py`
- `.github/workflows/debug-commands.yml`

**Contenido de `code-annotator/action.yml`:**
```yaml
# code-annotator/action.yml
name: 'Code Annotator'
description: 'Añade advertencias a archivos específicos.'
inputs:
  file:
    description: 'Archivo a anotar'
    required: true
  line:
    description: 'Línea a anotar'
    required: true
runs:
  using: "composite"
  steps:
    - run: python $GITHUB_ACTION_PATH/main.py
      env:
        INPUT_FILE: ${{ inputs.file }}
        INPUT_LINE: ${{ inputs.line }}
```

**Contenido de `code-annotator/main.py` (con errores):**
```python
# code-annotator/main.py
import os

file = os.getenv('INPUT_FILE')
line = os.getenv('INPUT_LINE')

# El comando de workflow tiene un error sutil.
print(f"::warning file={file},line={line}::Este es un método obsoleto.")
```

**Contenido de `.github/workflows/debug-commands.yml`:**
```yaml
# .github/workflows/debug-commands.yml
name: Debug Workflow Commands
on: push
jobs:
  annotate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Create dummy file
        run: echo "def old_function():" > src/legacy.py
      - name: Run annotator
        uses: ./code-annotator
        with:
          file: 'src/legacy.py'
          line: '1'
```

**Instrucciones del desafío:**
1.  Ejecuta el workflow y observa que no aparece ninguna anotación en la vista de resumen ni en los cambios del PR.
2.  Consulta la documentación de GitHub sobre el comando `warning`.
3.  Identifica la sintaxis incorrecta en el archivo `main.py` y corrígela.

**Pistas:**
- La sintaxis para los parámetros de un comando de workflow (`file`, `line`, `col`) es muy específica.
- ¿Cómo se separan los parámetros del mensaje principal?

### Resultado Esperado:
- Después de corregir el script, la ejecución del workflow muestra una advertencia en la pestaña "Summary".
- Si se ejecuta en un Pull Request, la anotación aparecerá directamente en la línea 1 del archivo `src/legacy.py`.
