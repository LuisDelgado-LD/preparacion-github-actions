# Concepto a Resolver: Propósitos Fundamentales de los Workflows

Un workflow de GitHub Actions es un proceso automatizado que se ejecuta en respuesta a eventos en tu repositorio. Aunque los usos son casi ilimitados, se centran en tres propósitos principales: la Integración Continua (CI) para construir y probar código, el Despliegue Continuo (CD) para publicar artefactos, y la Automatización de Tareas para gestionar el repositorio. Entender qué propósito resuelve cada workflow es clave para el examen.

---

## Desafío 1: Creación de un Workflow de Integración Continua (CI)

Este desafío se enfoca en el propósito más común de un workflow: ejecutar pruebas automáticamente cada vez que se actualiza el código para asegurar que los nuevos cambios no rompen la funcionalidad existente.

**Archivos a crear:**
- `.github/workflows/ci-analysis.yml`
- `src/calculator.py`
- `tests/test_calculator.py`

**Archivos de apoyo proporcionados:**

```python
# src/calculator.py
# Una calculadora simple para demostrar las pruebas.
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b
```

```python
# tests/test_calculator.py
# Pruebas unitarias para la calculadora.
# Nota: Este archivo requiere pytest para ejecutarse.
import sys
import os

# Añadir el directorio src al path para poder importar el módulo
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../src')))

from calculator import add, subtract

def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0

def test_subtract():
    assert subtract(5, 3) == 2
    assert subtract(10, 5) == 5
```

**Instrucciones del workflow:**

Tu workflow en `.github/workflows/ci-analysis.yml` debe:
- **Activarse** cada vez que se haga `push` a la rama `main`.
- **Contener un job** llamado `build-and-test` que se ejecute en el último runner de Ubuntu.
- **Pasos del job:**
    1. Hacer checkout del código del repositorio.
    2. Configurar el entorno de Python 3.9.
    3. Instalar las dependencias necesarias (en este caso, `pytest`).
    4. Ejecutar las pruebas usando el comando `pytest`.

### Resultado Esperado:
- El workflow se ejecuta automáticamente en cada push a `main`.
- El job `build-and-test` instala `pytest` correctamente.
- El paso de ejecución de pruebas finaliza con éxito, mostrando que todas las pruebas pasaron.

---

## Desafío 2: Creación de un Workflow de Automatización de Tareas

Este desafío se centra en usar un workflow para automatizar tareas de gestión del repositorio, como etiquetar nuevas issues para facilitar su clasificación.

**Archivos a crear:**
- `.github/workflows/triage-issues.yml`

**Archivos de apoyo proporcionados:**
- Ninguno. Este workflow utiliza el contexto del evento y una Action predefinida.

**Instrucciones del workflow:**

Tu workflow en `.github/workflows/triage-issues.yml` debe:
- **Activarse** cuando una `issue` es `opened` en el repositorio.
- **Contener un job** llamado `auto-label` que se ejecute en el último runner de Ubuntu.
- **Pasos del job:**
    1. Utilizar la action `actions/github-script@v6` para añadir una etiqueta a la issue que activó el workflow.
    2. El script debe añadir la etiqueta `needs-review` a la issue.
    3. Necesitarás proporcionar un `github-token` al job para permitir que modifique las etiquetas. Usa el secret `secrets.GITHUB_TOKEN`.

**Pista:** El script que se ejecuta con `actions/github-script` puede usar el objeto `github.rest.issues.addLabels` y obtener el número de la issue desde el contexto del evento (`github.context.issue.number`).

### Resultado Esperado:
- Al crear una nueva issue en el repositorio, el workflow se dispara.
- El job `auto-label` se ejecuta y añade la etiqueta `needs-review` a la issue recién creada.
- El workflow finaliza con éxito.

---

## Desafío 3: Resolución de Problemas en un Workflow de CI (Debugging)

Este es un desafío de debugging. Se te proporciona un workflow con errores intencionados que impiden su correcta ejecución. Tu tarea es identificar y corregir los problemas para que el workflow funcione como se espera.

**Archivos a crear:**
- `.github/workflows/broken-ci.yml` (con el contenido proporcionado)
- `check_version.sh` (con el contenido proporcionado)

**Archivos de apoyo proporcionados:**

```yaml
# .github/workflows/broken-ci.yml
# ESTE WORKFLOW CONTIENE ERRORES INTENCIONADOS
name: Broken CI Workflow

on: push

jobs:
  debug-me:
  runs-on: ubuntu-latest
  steps:
    - name: Check out code
      uses: actions/checkout@v2 # Versión antigua

    - name: Setup Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'

    - name: Run a script
      run: ./check_version.sh

    - name: This step will fail
      run: python -c "import non_existent_module"
```

```bash
# check_version.sh
#!/bin/bash
echo "Verificando la versión de Python..."
python --version
echo "Verificación completa."
```

**Instrucciones del desafío:**
1.  Crea los archivos `.github/workflows/broken-ci.yml` y `check_version.sh` con el contenido anterior.
2.  El script `check_version.sh` necesita permisos de ejecución. Añade un paso al workflow para dárselos.
3.  El workflow tiene al menos tres problemas (uno de configuración, uno de permisos y uno de lógica).
4.  Analiza los logs del workflow después de que falle al hacer un `push`.
5.  Corrige los errores en el archivo `broken-ci.yml` para que todos los pasos se ejecuten correctamente.

**Pistas:**
- ¿Qué pasa si un script no tiene permisos de ejecución en Linux?
- ¿La action `actions/checkout` está usando su versión más recomendada? Revisa el Marketplace.
- El último paso está diseñado para fallar. ¿Cómo manejarías un paso que sabes que puede fallar pero no quieres que detenga todo el job? Considera las opciones de `steps`.

### Resultado Esperado:
- El workflow `Broken CI Workflow` se completa exitosamente.
- El log del workflow muestra la versión de Python ejecutada por el script `check_version.sh`.
- El paso que importaba un módulo inexistente ya no causa que el job falle, aunque el error se registre en el log.
