# Concepto a Resolver: Almacenamiento en Caché de Dependencias (Caching Dependencies)
La velocidad de los workflows es crucial para una integración continua eficiente. Este módulo se enfoca en el uso de la acción `actions/cache` para almacenar y restaurar dependencias y otros archivos generados por el build, reduciendo drásticamente los tiempos de ejecución al evitar la descarga o construcción repetitiva de los mismos artefactos en cada ejecución.

---

## Desafío 1: Caché Básica de Dependencias de Python
Tu objetivo es acelerar un workflow de Python que tiene varias dependencias. Implementarás un caché para el directorio de paquetes de `pip` que se invalidará solo cuando las dependencias cambien.

**Archivos a crear por el estudiante:**
- `.github/workflows/python-caching.yml`

**Archivos de apoyo (proporcionados por ti):**
- `requirements.txt`
- `app.py`

**Contenido de los archivos de apoyo:**
```python
# app.py
import pandas as pd
import numpy as np

print("Librerías importadas correctamente.")
print(f"Versión de pandas: {pd.__version__}")
print(f"Versión de numpy: {np.__version__}")

df = pd.DataFrame(np.random.randint(0,100,size=(5, 4)), columns=list('ABCD'))
print("DataFrame creado:")
print(df.head())
```
```text
# requirements.txt
pandas==2.2.2
numpy==1.26.4
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse en cada `push` a la rama `main`.
- Configurar un entorno de Python 3.10.
- Usar la acción `actions/cache` para almacenar en caché las dependencias de `pip`.
- La clave de caché (`key`) debe ser única y basarse en el sistema operativo del runner, la versión de Python y un hash del archivo `requirements.txt`.
- Incluir un paso para instalar las dependencias usando `pip install -r requirements.txt`.
- Ejecutar el script `app.py` para verificar que las librerías están disponibles.

### Resultado Esperado:
- La primera ejecución del workflow tomará más tiempo, ya que descarga e instala las dependencias y luego las guarda en el caché. El log del paso de caché mostrará "Cache saved successfully".
- Las ejecuciones posteriores (sin cambios en `requirements.txt`) serán significativamente más rápidas. El log del paso de caché mostrará "Cache hit" y el paso de instalación de dependencias será casi instantáneo.
- Si modificas `requirements.txt` (ej: cambiando una versión), la siguiente ejecución debe generar un nuevo caché.

---

## Desafío 2: Estrategia de Caché con `restore-keys`
A veces, una clave de caché exacta no encuentra correspondencia. En esos casos, una clave de restauración (`restore-keys`) puede encontrar un caché parcialmente útil. En este desafío, configurarás un workflow de Node.js que usa una clave principal precisa y una clave de restauración más genérica.

**Archivos a crear por el estudiante:**
- `.github/workflows/npm-restore-keys.yml`

**Archivos de apoyo (proporcionados por ti):**
- `package.json`
- `app.js`

**Contenido de los archivos de apoyo:**
```javascript
// app.js
const express = require('express');
console.log('Express importado correctamente.');
console.log(`Versión de Express: ${require('express/package.json').version}`);
```
```json
{
  "name": "my-app",
  "version": "1.0.0",
  "description": "",
  "main": "app.js",
  "scripts": {
    "test": "echo "Error: no test specified" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "express": "4.19.2"
  }
}
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse en `push`.
- Configurar un entorno de Node.js (versión 20).
- Usar `actions/cache` para el directorio `node_modules`.
- La `key` principal debe ser muy específica: `llave-exacta-${{ runner.os }}-${{ hashFiles('**/package-lock.json') }}`.
- Añadir `restore-keys` con una clave más genérica: `llave-parcial-${{ runner.os }}-`.
- Ejecutar `npm install` para instalar las dependencias.
- Ejecutar el script `app.js`.

### Resultado Esperado:
- La primera ejecución crea un caché con la `llave-exacta`.
- Si actualizas una dependencia (lo que cambia `package-lock.json`), la `key` principal no encontrará un caché.
- Sin embargo, la `restore-keys` encontrará el caché anterior (parcial), acelerando el `npm install` en comparación con una instalación desde cero. El log de `actions/cache` mostrará que se restauró un caché usando una de las `restore-keys`.

---

## Desafío 3: Resolución de Problemas - El Caché Nunca se Invalida
Te encuentras con un workflow que debería ser rápido, pero cada ejecución parece descargar las dependencias desde cero, a pesar de que el paso de caché informa que se guardó correctamente. Tu misión es diagnosticar y arreglar el problema.

**Archivos a crear por el estudiante:**
- El estudiante debe **corregir** el siguiente archivo.

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/debug-cache-invalidation.yml`
- `requirements.txt` (el mismo del Desafío 1)

**Contenido del workflow con errores:**
```yaml
# .github/workflows/debug-cache-invalidation.yml
name: Debugging Cache Invalidation
on: push

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.10'

      # El problema está en la configuración de este paso
      - name: Cache pip dependencies
        uses: actions/cache@v4
        id: cache-pip
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}

      # Este paso está mal configurado
      - name: Install dependencies
        run: pip install --no-cache-dir -r requirements.txt

      - name: Run script
        run: python -c "import pandas; print('Pandas importado')"
```

**El Problema:**
El workflow está diseñado para usar el caché de `pip`. La clave de caché parece correcta y se basa en el hash del archivo `requirements.txt`. Sin embargo, el paso `Install dependencies` es lento en cada ejecución, incluso cuando no hay cambios en los archivos.

**Pistas:**
1.  Revisa los logs del paso `Install dependencies`. ¿Ves alguna indicación de que se están descargando paquetes de internet?
2.  Observa los argumentos pasados al comando `pip install`. ¿Alguno de ellos podría estar indicándole a `pip` que ignore cualquier caché local?
3.  La documentación de `pip` puede ser útil. ¿Qué hace la bandera `--no-cache-dir`?

### Resultado Esperado:
- Identificas que la bandera `--no-cache-dir` en el comando `pip install` es la causa del problema, ya que fuerza a `pip` a ignorar el directorio de caché que `actions/cache` ha restaurado.
- Corriges el workflow eliminando la bandera `--no-cache-dir` del paso `Install dependencies`.
- Después de la corrección, la primera ejecución guarda el caché, y las siguientes ejecuciones son rápidas, utilizando el caché restaurado de manera efectiva.
