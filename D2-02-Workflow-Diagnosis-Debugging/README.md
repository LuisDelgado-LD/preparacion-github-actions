# Concepto a Resolver: Diagnóstico y Depuración de Workflows

Este concepto se enfoca en las técnicas y herramientas disponibles en GitHub Actions para diagnosticar, depurar y resolver problemas en los flujos de trabajo, incluyendo el uso de logs detallados y sesiones interactivas.

---

## Desafío 1: Habilitar Logging de Depuración para Diagnosticar un Error

Configura un workflow que falla silenciosamente y utiliza el logging de depuración de GitHub Actions para descubrir la causa raíz del problema.

**Archivos a crear por el estudiante:**
- `.github/workflows/debug-logging.yml`
- `failing_script.py`

**Contenido de los archivos de apoyo (proporcionados por ti):**
```python
# failing_script.py
import os

# Este script espera una variable de entorno que no estará configurada por defecto.
secret_value = os.environ['MY_APP_SECRET']

if secret_value:
    print("Secreto encontrado y procesado exitosamente.")
else:
    print("Error: No se encontró el secreto.")
    # El script no falla con un código de salida distinto de cero, ocultando el problema.
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse en el evento `push`.
- Configurar Python.
- Ejecutar el script `failing_script.py`.
- El workflow se completará "exitosamente" pero el script no funcionará como se espera.
- **Acción manual requerida:** Para diagnosticarlo, el estudiante debe ir a la configuración del repositorio (`Settings > Secrets and variables > Actions`), crear un nuevo secreto de repositorio llamado `ACTIONS_STEP_DEBUG` y asignarle el valor `true`.
- Al volver a ejecutar el workflow, los logs de depuración mostrarán información detallada que ayudará a identificar el problema (la falta de la variable de entorno `MY_APP_SECRET`).
- El desafío se completa cuando el estudiante modifica el workflow para pasar la variable de entorno requerida al script.

### Resultado Esperado:
- El workflow se ejecuta, pero la lógica del script no funciona.
- Después de habilitar `ACTIONS_STEP_DEBUG`, los logs del runner y de los pasos son mucho más detallados.
- El estudiante identifica la variable de entorno que falta y la añade al paso del script en el workflow (ej. `env: MY_APP_SECRET: ${{ secrets.SOME_SECRET }}`).
- El workflow final se ejecuta y el script confirma que encontró el secreto.

---

## Desafío 2: Depuración Interactiva con `tmate`

Utiliza la acción `tmate` para pausar la ejecución de un workflow y obtener una sesión de shell interactiva en el runner, permitiendo una depuración en tiempo real de un problema complejo.

**Archivos a crear por el estudiante:**
- `.github/workflows/interactive-debug.yml`
- `complex_setup.sh`

**Contenido de los archivos de apoyo (proporcionados por ti):**
```bash
# complex_setup.sh
#!/bin/bash
set -e
echo "Creando una estructura de archivos compleja..."
mkdir -p /tmp/my-app/data

# Se crea un archivo en una ubicación inesperada
echo "Contenido del log" > ./debug.log

echo "La configuración ha finalizado, pero falta un archivo clave."
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse manualmente con `workflow_dispatch`.
- Ejecutar el script `complex_setup.sh`.
- Incluir un paso posterior que falle porque no encuentra un archivo esperado (ej. `cat /tmp/my-app/data/debug.log`).
- El estudiante debe añadir un paso intermedio que utilice la acción `mxschmitt/action-tmate@v3` justo antes del paso que falla.
- Para que `tmate` funcione, el workflow debe ejecutarse solo si el actor es el dueño del repositorio (una medida de seguridad).
- Al ejecutar el workflow, la acción `tmate` pausará el job y mostrará en los logs una cadena de conexión SSH.
- El estudiante deberá conectarse al runner vía SSH, explorar el sistema de archivos (`ls -la`, `find / -name debug.log`), identificar dónde se creó realmente el archivo y proponer una corrección.

### Resultado Esperado:
- El workflow se pausa, mostrando la información de conexión SSH en los logs.
- El estudiante se conecta exitosamente al runner.
- Usando comandos de shell, el estudiante descubre que `debug.log` se creó en el directorio de trabajo (`/home/runner/work/...`) en lugar de en `/tmp/my-app/data`.
- El estudiante corrige el script `complex_setup.sh` o el workflow para que el archivo se cree o se mueva a la ubicación correcta, y el workflow finaliza con éxito.

---

## Desafío de Debugging: Corregir un Workflow con Múltiples Puntos de Falla

Debes diagnosticar y corregir un workflow que falla por una combinación de errores comunes: una acción mal configurada, un comando que no existe y un problema de permisos de archivo.

**Archivos a crear por el estudiante:**
- (Ninguno, debes corregir el archivo proporcionado)

**Archivos de apoyo (proporcionados por ti):**
```yaml
# .github/workflows/debug-multiple-failures.yml (CON ERRORES INTENCIONALES)
name: Debug Multiple Failures

on: push

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.9'
          cache: 'pip' # Error: La configuración de caché es incorrecta aquí

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt # Error: El archivo requirements.txt no existe

      - name: Run a non-existent command
        run: my_custom_linter --format # Error: Este comando no está instalado

      - name: Create a file in a protected directory
        run: echo "Final report" > /etc/report.txt # Error: Permisos insuficientes
```

**Pistas sutiles:**
- La documentación de `actions/setup-python` muestra que la gestión de la caché ha cambiado en versiones recientes. ¿Se configura como un input directo o requiere un paso separado con `actions/cache`?
- Antes de intentar usar un archivo como `requirements.txt`, asegúrate de que exista en el repositorio. Si no, ¿deberías crearlo o eliminar el paso?
- Los runners vienen con un software preinstalado, pero no con todas las herramientas del mundo. Si un comando no se encuentra, ¿necesitas instalarlo primero con `apt-get` o `pip`?
- Los runners de GitHub se ejecutan como un usuario sin privilegios (`runner`). ¿En qué directorios tiene permiso de escritura este usuario? Intenta usar el directorio de trabajo (`.`) o el directorio temporal (`/tmp`).

### Resultado Esperado:
- El estudiante corrige la configuración de `setup-python` (probablemente eliminando la línea `cache` para simplificar).
- El estudiante crea un archivo `requirements.txt` vacío o elimina el paso de instalación.
- El estudiante elimina el paso que ejecuta `my_custom_linter`.
- El estudiante modifica el último paso para que escriba en un directorio válido, como `echo "Final report" > report.txt`.
- El workflow corregido se ejecuta completamente y sin errores.
