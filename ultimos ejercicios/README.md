
# GitHub Actions Certification - Desafíos Prácticos de Preparación

Este conjunto de ejercicios prácticos está diseñado para preparar a los estudiantes para el examen de certificación de GitHub Actions. Los desafíos están organizados por dominio, según el porcentaje de peso oficial del examen. Algunos desafíos mezclan múltiples conceptos dentro del mismo dominio para maximizar el aprendizaje.

---

## 🧠 Dominio 1: Fundamentos de GitHub Actions (40%)

### Concepto a Resolver: Eventos, Condiciones y Sintaxis de Workflow
Uso correcto de eventos de disparo, condicionales `if`, filtros `branches`, `paths`, contexto (`github`, `env`, `secrets`) y estructura general del workflow.

---

## Desafío 1: Automatización Condicional para Archivos Python

**Escenario:** Debes automatizar una validación de sintaxis de archivos `.py` dentro de la carpeta `src/`, pero solo si el secreto `VALIDATION_KEY` está definido. Además, si el script falla, debe subirse un log de error como artefacto.

**Archivos a crear:**
- `.github/workflows/python-validation.yml`
- `src/example.py` (modificable por el estudiante)
- `validate.sh` (proporcionado)

**Archivos de apoyo proporcionados:**
```bash
# validate.sh
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
````

**Instrucciones del workflow:**
Tu workflow debe:

* Activarse en `push` o `pull_request` sobre `main`
* Filtrar cambios solo en `src/*.py`
* Usar `if` para ejecutar solo si el secreto `VALIDATION_KEY` está presente
* Ejecutar `validate.sh` y, si falla, subir `error.log` como artefacto

### Resultado Esperado:

* El workflow se activa correctamente con los filtros
* Se ejecuta la validación si el secreto existe
* En caso de error, el archivo `error.log` queda disponible como artefacto

---

## 🛠 Dominio 3: Reutilización y Mantenimiento (25%)

### Concepto a Resolver: Reutilización de Workflows y Outputs entre Jobs

Combinar creación y uso de outputs, junto con invocación de workflows reutilizables mediante `workflow_call`

## Desafío 2: Validación Reutilizable con Outputs Compartidos

**Escenario:** Debes implementar un flujo donde un workflow reutilizable verifique un archivo Python y exponga como output si contiene la palabra `import`. Luego, el workflow principal debe leer ese output y registrar un mensaje diferente según el resultado.

**Archivos a crear:**

* `.github/workflows/principal.yml`
* `.github/workflows/reutilizable.yml`
* `analizador.py` (proporcionado)

**Archivos de apoyo proporcionados:**

```python
# analizador.py
with open("src/example.py") as f:
    contenido = f.read()

if "import" in contenido:
    print("::set-output name=tiene_import::true")
else:
    print("::set-output name=tiene_import::false")
```

**Instrucciones del workflow:**

* `reutilizable.yml` debe:

  * Activarse con `workflow_call`
  * Ejecutar el script y exponer el resultado `tiene_import` como output
* `principal.yml` debe:

  * Llamar a `reutilizable.yml`
  * Evaluar el output y ejecutar un mensaje distinto según el valor

### Resultado Esperado:

* El flujo principal llama al workflow reutilizable exitosamente
* Se evalúa el output y se registra el mensaje correcto

---

## 🐞 Desafío de Debugging (obligatorio)

### Concepto a Resolver: Resolución de errores en sintaxis, eventos, rutas y nombres de claves

## Desafío 3: Workflow Roto con Varias Fallas Comunes

**Escenario:** El siguiente workflow presenta errores típicos detectados en el examen. Tu tarea es encontrar y corregir al menos 3 errores críticos.

**Archivos a crear:**

* `.github/workflows/debug-me.yml` (proporcionado con errores)
* `main.py` (proporcionado)

**Archivos de apoyo proporcionados:**

```yaml
# debug-me.yml
name: Fallas comunes
on:
  push:
    branch: main

jobs:
  ejecutar:
    run-on: ubuntu-latest
    steps:
      - name: Obtener código
        user: actions/checkout@v2

      - name: Ejecutar script
        run: python3 main.py
```

```python
# main.py
print("Este script debería ejecutarse sin errores si el workflow está bien formado.")
```

### Instrucciones del desafío:

* Corrige todos los errores de sintaxis y configuración
* Verifica que el workflow se ejecute correctamente en `push` a `main`

### Pistas:

* Revisa claves mal escritas (`branch`, `run-on`, `user`)
* Verifica la indentación y los nombres esperados por GitHub Actions

### Resultado Esperado:

* El workflow corre exitosamente
* El script `main.py` imprime el mensaje sin errores

---

## ⚙️ Dominio 2: Workflows y Jobs (20%)

### Concepto a Resolver: Matrices, Condiciones y Cache

## Desafío 4: Matriz Controlada con Cache

**Escenario:** Crea un workflow con una matriz que use distintos sistemas operativos, pero solo se ejecute en `ubuntu-latest` y `macos-latest`. Además, cachea un directorio de resultados si existe.

**Archivos a crear:**

* `.github/workflows/matrix-cache.yml`
* `runme.sh` (proporcionado)

**Archivos de apoyo proporcionados:**

```bash
# runme.sh
#!/bin/bash
mkdir -p resultado
echo "Tiempo: $(date)" > resultado/info.txt
```

**Instrucciones del workflow:**

* Define una matriz con tres sistemas operativos (`ubuntu-latest`, `macos-latest`, `windows-latest`)
* Usa una condición para omitir Windows
* Ejecuta `runme.sh`
* Usa `actions/cache` para cachear `resultado/`

### Resultado Esperado:

* El job se ejecuta solo en Ubuntu y macOS
* Se crea y cachea correctamente la carpeta `resultado`

---

## 🔐 Dominio 4: Seguridad, permisos y secretos (15%)

### Concepto a Resolver: Uso seguro de secretos con condiciones y niveles de permiso

## Desafío 5: Control de Acceso a Secretos Sensibles

**Escenario:** Solo si el push se hace al branch `main`, un secreto sensible debe ser accedido. En otros casos, se debe prevenir su uso.

**Archivos a crear:**

* `.github/workflows/secure-secrets.yml`
* `token_reader.py` (proporcionado)

**Archivos de apoyo proporcionados:**

```python
# token_reader.py
import os
print("Token:", os.getenv("SENSITIVE_SECRET", "ACCESO DENEGADO"))
```

**Instrucciones del workflow:**

* Configura permisos mínimos globales para `GITHUB_TOKEN`
* Otorga permisos explícitos a `secrets` solo si la rama es `main`
* Ejecuta `token_reader.py`

### Resultado Esperado:

* El secreto se imprime solo si la rama es `main`
* En otros casos se imprime "ACCESO DENEGADO"

```