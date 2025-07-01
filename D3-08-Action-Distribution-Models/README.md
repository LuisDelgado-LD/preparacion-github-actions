# Concepto a Resolver: Modelos de Distribución de Actions
Este módulo se enfoca en cómo puedes compartir y consumir actions dentro de tu organización o públicamente. Cubre la diferencia entre publicar en el Marketplace de GitHub y mantener actions en repositorios internos para uso privado.

---

## Desafío 1: Consumir una Action Pública desde el Marketplace
Este desafío te enseñará a encontrar y utilizar una action publicada por la comunidad en el Marketplace de GitHub para realizar una tarea común.

**Archivos a crear por el estudiante:**
- `.github/workflows/public-action-linter.yml`

**Archivos de apoyo (proporcionados por ti):**
- `src/app.py`

**Contenido de los archivos de apoyo:**
```python
# src/app.py
import os

def main():
    print("Este es un script de Python simple.")
    unused_variable = "esto debería ser detectado por un linter"
    print("Workflow ejecutado exitosamente.")

if __name__ == "__main__":
    main()
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse con un `push` a la rama `main`.
- Utilizar la action `psf/black` del Marketplace para formatear el código Python en el repositorio.
- Añadir un paso para confirmar que el formateador se ejecutó.

### Resultado Esperado:
- El workflow se ejecuta correctamente en cada push a `main`.
- La action `psf/black` se ejecuta y formatea el archivo `src/app.py`.
- Un mensaje "Black action executed" se muestra en los logs del workflow.

---

## Desafío 2: Utilizar una Action Privada dentro de la Organización
Este desafío simula el uso de una action que no está publicada en el Marketplace, sino que reside en otro repositorio privado dentro de la misma organización.

**Archivos a crear por el estudiante:**
- `.github/workflows/private-action-consumer.yml`
- `internal-action/action.yml` (simulación de la action interna)
- `internal-action/entrypoint.sh` (simulación del script de la action)

**Archivos de apoyo (proporcionados por ti):**
No se proporcionan archivos de apoyo. Debes crear la "action interna" tú mismo.

**Contenido de los archivos a crear:**
```yaml
# internal-action/action.yml
name: 'Internal Greeting Action'
description: 'Una action interna que imprime un saludo.'
runs:
  using: 'docker'
  image: 'Dockerfile'
```
*Nota: Para este desafío, como no podemos usar un repositorio separado, la action vivirá en un subdirectorio. La sintaxis para llamarla es `uses: ./path/to/action/dir`.*

```bash
# internal-action/entrypoint.sh
#!/bin/sh -l
echo "Hola desde la action interna!"
```

```docker
# internal-action/Dockerfile
FROM alpine:3.11
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
```

**Instrucciones del workflow:**
Tu workflow (`private-action-consumer.yml`) debe:
- Activarse manualmente con un `workflow_dispatch`.
- Utilizar la action local ubicada en el directorio `internal-action`.
- La sintaxis para usar una action local es `uses: ./path/to/your/action`.

### Resultado Esperado:
- El workflow se ejecuta correctamente al ser disparado manualmente.
- El log del workflow muestra el mensaje "Hola desde la action interna!".

---

## Desafío 3: Debugging - Error al Referenciar una Action
En este desafío, se te proporciona un workflow que intenta usar una action de un repositorio, pero la referencia es incorrecta. Tu tarea es identificar y corregir el error.

**Archivos a crear por el estudiante:**
- Ninguno. Debes corregir el workflow proporcionado.

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/broken-action-reference.yml`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/broken-action-reference.yml
name: Broken Action Reference
on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Check out code
        uses: actions/checkout@v3

      - name: Run a broken action reference
        # Pista: La forma de referenciar una action pública es {owner}/{repo}@{version}.
        # ¿Está completa esta referencia?
        uses: actions/checkout
        with:
          version: v3 # Esto no es un parámetro válido para checkout

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.x'

      - name: Fail step
        # Pista: ¿Cómo se referencia una action que está en un subdirectorio de otro repositorio?
        # La sintaxis es {owner}/{repo}/{path}@{ref}.
        uses: actions/super-linter
```

**Instrucciones del desafío:**
1.  Analiza el archivo `.github/workflows/broken-action-reference.yml`.
2.  Identifica por qué los pasos "Run a broken action reference" y "Fail step" fallan.
3.  Corrige la sintaxis en la propiedad `uses` para que apunten a actions válidas y se ejecuten correctamente. La primera debería ser `actions/checkout@v3` y la segunda `github/super-linter/slim@v5`.

### Resultado Esperado:
- El workflow se completa exitosamente después de corregir las referencias a las actions.
- La action `checkout` se ejecuta sin errores.
- La action `super-linter` (en su versión `slim`) se inicia correctamente (aunque podría no encontrar archivos para linting, el paso en sí no debe fallar por una referencia incorrecta).
