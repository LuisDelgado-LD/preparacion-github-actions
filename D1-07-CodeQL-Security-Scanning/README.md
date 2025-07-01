# Concepto a Resolver: Escaneo Básico de CodeQL

Este concepto se centra en la configuración e integración inicial de CodeQL para realizar análisis de seguridad estático en tu código, detectando vulnerabilidades comunes directamente en tus flujos de trabajo de GitHub Actions.

-----

## Desafío 1: Primer Escaneo de CodeQL para Python

Configura un flujo de trabajo para ejecutar un escaneo básico de CodeQL en un proyecto Python, detectando vulnerabilidades de seguridad comunes.

**Archivos a crear:**

  - `.github/workflows/codeql-python.yml` (TÚ DEBES CREARLO)
  - `vulnerable_app.py` (proporcionado)

**Archivos de apoyo proporcionados:**

```python
# vulnerable_app.py - Una aplicación Python simple con una vulnerabilidad conocida
import os

def process_user_input(data):
    # Vulnerabilidad: Uso de os.system() con entrada de usuario no sanitizada
    # Esto es susceptible a Command Injection
    command = "echo 'Processing data: ' " + data
    os.system(command)
    print(f"Executed command: {command}")

if __name__ == "__main__":
    user_input = input("Enter some data: ")
    process_user_input(user_input)

    # Otra posible vulnerabilidad: SQL Injection (si fuera una base de datos)
    # Ejemplo: user_id = input("Enter user ID: ")
    # query = "SELECT * FROM users WHERE id = " + user_id # Vulnerable
```

**Instrucciones del workflow:**
Tu workflow debe:

  - Activarse en el evento `push` a la rama `main`.
  - Realizar el checkout del código.
  - Configurar un entorno para ejecutar el análisis de CodeQL.
  - Utilizar la acción **CodeQL-Action** para inicializar y construir la base de datos de CodeQL para Python.
  - Realizar un escaneo de CodeQL para buscar vulnerabilidades en el código Python.
  - Mostrar los resultados del escaneo en la pestaña de Seguridad del repositorio (Code scanning alerts).

### Resultado Esperado:

  - El workflow se ejecuta exitosamente en cada `push` a `main`.
  - El log del trabajo muestra que CodeQL ha construido una base de datos para Python.
  - Se detecta al menos una alerta de seguridad relacionada con la vulnerabilidad en `vulnerable_app.py` en la pestaña "Security \> Code scanning alerts" de tu repositorio.

-----

## Desafío 2: Escaneo de CodeQL en Múltiples Lenguajes (Bash y Python)

Extiende el escaneo de CodeQL para incluir tanto código Python como scripts Bash, asegurando que se analice una variedad más amplia de archivos en tu repositorio.

**Archivos a crear:**

  - `.github/workflows/codeql-multi-language.yml` (TÚ DEBES CREARLO)
  - `vulnerable_app.py` (proporcionado, el mismo que en el desafío anterior)
  - `vulnerable_script.sh` (proporcionado)

**Archivos de apoyo proporcionados:**

```python
# vulnerable_app.py - Mismo archivo del desafío anterior
import os

def process_user_input(data):
    command = "echo 'Processing data: ' " + data
    os.system(command)
    print(f"Executed command: {command}")

if __name__ == "__main__":
    user_input = input("Enter some data: ")
    process_user_input(user_input)
```

```bash
# vulnerable_script.sh - Un script Bash con una vulnerabilidad simple
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

# Otra vulnerabilidad común: uso de comandos sin comillas
# Ejemplo: touch $HOME/my file.txt # Fallaría si el nombre tiene espacios sin comillas
```

**Instrucciones del workflow:**
Tu workflow debe:

  - Activarse en `schedule` cada 24 horas (ej. a medianoche UTC).
  - Realizar el checkout del código.
  - Configurar CodeQL para analizar **múltiples lenguajes**, específicamente `python` y `bash`.
  - Inicializar y construir la base de datos de CodeQL para ambos lenguajes.
  - Ejecutar el escaneo de CodeQL.
  - Mostrar las alertas de seguridad para ambos tipos de vulnerabilidades.

### Resultado Esperado:

  - El workflow se activa según lo programado.
  - El log del trabajo muestra que CodeQL ha inicializado y construido bases de datos para Python y Bash.
  - Se detectan alertas de seguridad tanto para la vulnerabilidad en `vulnerable_app.py` como en `vulnerable_script.sh` en la pestaña "Security \> Code scanning alerts".

-----

# Concepto a Resolver: Resolución de Problemas/Debugging en Escaneo de CodeQL

Este concepto aborda la identificación y corrección de errores comunes que pueden surgir al configurar y ejecutar escaneos de CodeQL, incluyendo problemas de sintaxis, configuración de lenguajes, o pasos de construcción faltantes.

-----

## Desafío 3: Depuración de Escaneo de CodeQL con Errores

Debes identificar y corregir los errores en un workflow existente que intenta configurar un escaneo de CodeQL, pero falla debido a problemas de configuración.

**Archivos a crear:**

  - `.github/workflows/debug-codeql.yml` (NO LO CREES, YA ESTÁ PROPORCIONADO CON ERRORES)
  - `simple_app.py` (proporcionado)

**Archivos de apoyo proporcionados:**

```yaml
# .github/workflows/debug-codeql.yml (CON ERRORES INTENCIONALES)
name: Debug CodeQL Scan

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  analyze:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      contents: read

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3 # Usando una versión antigua intencionalmente

    - name: Initialize CodeQL
      uses: github/codeql-action/init@v3 # Usando una versión antigua intencionalmente
      with:
        languages: 'javascript' # Lenguaje incorrecto intencionalmente

    - name: Autobuild # Paso de construcción faltante o incorrecto para Python
      run: echo "No build command needed for simple Python scripts, right?"

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v3 # Usando una versión antigua intencionalmente
```

```python
# simple_app.py - Un script Python simple (sin vulnerabilidades obvias, el foco es el workflow)
def hello_world():
    print("Hello, CodeQL debug!")

if __name__ == "__main__":
    hello_world()
```

**Instrucciones del workflow:**
Tu objetivo es **corregir** el workflow `.github/workflows/debug-codeql.yml` proporcionado para que el escaneo de CodeQL se ejecute exitosamente para el proyecto Python `simple_app.py`.

**Pistas sutiles:**

  - Presta mucha atención a las **versiones de las acciones** utilizadas. Las versiones desactualizadas a menudo no son compatibles con las últimas características o pueden causar problemas inesperados.
  - El **lenguaje configurado** para CodeQL debe coincidir con el lenguaje del código que quieres analizar. ¿Qué lenguaje es `simple_app.py`?
  - CodeQL necesita "construir" el código para algunos lenguajes, incluso si no es una compilación tradicional. Para Python, ¿es necesario un paso de "autobuild" o cómo se maneja la extracción del código? Revisa la documentación de CodeQL para Python.
  - Los logs de GitHub Actions suelen dar pistas claras sobre los errores de configuración, busca mensajes como "unsupported language", "missing build command", o "action not found for version".

### Resultado Esperado:

  - El workflow corregido se ejecuta exitosamente.
  - El log del trabajo muestra que CodeQL ha inicializado y analizado el proyecto Python correctamente.
  - No hay errores en el workflow y el escaneo finaliza sin fallos.