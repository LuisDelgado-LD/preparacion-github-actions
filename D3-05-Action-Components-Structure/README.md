# Concepto a Resolver: Estructura y Componentes de una Acción
Este módulo aborda la anatomía de una acción de GitHub. Aprenderás sobre los componentes esenciales que conforman cualquier acción, incluyendo el archivo de metadatos `action.yml`, el código que se ejecuta (ya sea un script, un contenedor o un archivo JavaScript), y cómo organizar los archivos de soporte para crear acciones limpias y mantenibles.

---

## Desafío 1: La Anatomía del `action.yml`
**Descripción:** Tu tarea es crear un archivo `action.yml` desde cero basado en un conjunto de requisitos específicos. Este desafío se centra exclusivamente en la correcta definición de los metadatos de una acción, que es el corazón de cómo GitHub la interpreta.

**Archivos a crear por el estudiante:**
- `metadata-action/action.yml`
- `.github/workflows/test-metadata.yml`

**Archivos de apoyo (proporcionados por ti):**
No se necesitan. El objetivo es solo definir la estructura.

**Instrucciones para `metadata-action/action.yml`:**
Crea un `action.yml` para una acción **compuesta** con las siguientes propiedades:
- **`name`**: `Validador de Metadatos`
- **`description`**: `Una acción para validar la estructura de action.yml.`
- **`author`**: `Tu Nombre de GitHub`
- **`inputs`**:
  - `token`: requerido, sin valor por defecto, con descripción "Token de GitHub."
  - `strict-mode`: no requerido, con valor por defecto `false`, con descripción "Activa el modo estricto."
- **`outputs`**:
  - `is-valid`: con descripción "Será verdadero si los metadatos son válidos."
- **`branding`**:
  - `icon`: `shield`
  - `color`: `purple`
- **`runs`**: Debe ser de tipo `composite` y contener un único paso de ejemplo que simplemente imprima "Validando metadatos..."

**Instrucciones del workflow:**
Tu workflow (`.github/workflows/test-metadata.yml`) debe:
1.  Activarse con `workflow_dispatch`.
2.  Tener un job que se ejecute en `ubuntu-latest`.
3.  Hacer checkout del código.
4.  Utilizar la acción local (`./metadata-action`).
5.  Pasar un valor para el input `token` (puede ser `secrets.GITHUB_TOKEN`).
6.  Intentar imprimir el output `is-valid` (aunque estará vacío).

### Resultado Esperado:
- El workflow se ejecuta sin errores de sintaxis.
- En la UI de GitHub Actions, al ver la ejecución del workflow, la acción muestra el ícono y color de branding definidos.
- El log del workflow muestra el mensaje "Validando metadatos..."
- El workflow no falla al intentar acceder al output, demostrando que está correctamente definido en `action.yml`.

---

## Desafío 2: Organización de Scripts de Soporte
**Descripción:** Crea una acción compuesta que dependa de múltiples scripts de shell. El script principal (`metadata-action) llamará a un script auxiliar (`helper.sh`) ubicado en un subdirectorio. Este desafío te enseña a organizar y referenciar archivos dentro de la estructura de tu acción.

**Archivos a crear por el estudiante:**
- `structured-action/action.yml`
- `.github/workflows/test-structured-action.yml`

**Archivos de apoyo (proporcionados por ti):**

**`structured-action/scripts/helper.sh` (Contenido):**
```bash
#!/bin/bash
# structured-action/scripts/helper.sh

TEXTO_A_PROCESAR=$1
# Simula una operación compleja
RESULTADO="$(echo $TEXTO_A_PROCESAR | rev)"

echo $RESULTADO
```

**Instrucciones:**
1.  Crea el `entrypoint.sh` que recibirá un input y usará el `helper.sh` para procesarlo.
2.  Crea el `action.yml` que orquesta la ejecución.
3.  Crea el workflow para probar la acción.

**`structured-action/entrypoint.sh` (Plantilla):**
```bash
#!/bin/bash
# structured-action/entrypoint.sh

INPUT_STRING=$1

# Llama al script auxiliar usando la ruta relativa a la acción
HELPER_SCRIPT_PATH="${GITHUB_ACTION_PATH}/scripts/helper.sh"

# Asegúrate de que el helper sea ejecutable
chmod +x $HELPER_SCRIPT_PATH

REVERSE_STRING=$($HELPER_SCRIPT_PATH "$INPUT_STRING")

echo "processed-string=El reverso de '$INPUT_STRING' es '$REVERSE_STRING'" >> $GITHUB_OUTPUT
```


**Instrucciones del workflow:**
Tu workflow debe usar la acción `./structured-action`, pasarle la cadena "Hola Mundo" y luego imprimir el output `processed-string`.

### Resultado Esperado:
- El workflow se ejecuta con éxito.
- El paso final imprime: "El reverso de 'Hola Mundo' es 'odnuM aloH'".

---

## Desafío 3: Debugging de una Estructura de Acción Rota
**Descripción:** Se te proporciona una acción JavaScript y un workflow. La acción no se ejecuta debido a errores en la estructura de archivos y en cómo se la llama desde el `action.yml`. Tu misión es corregir la estructura y los metadatos.

**Archivos a crear por el estudiante:**
- Ninguno. Debes corregir los archivos existentes.

**Archivos de apoyo (proporcionados por ti con errores):**

**`.github/workflows/broken-js-action.yml`:**
```yaml
# .github/workflows/broken-js-action.yml
name: Broken JS Structure
on: workflow_dispatch

jobs:
  debug-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      # La acción JS necesita sus dependencias instaladas
      - name: Run broken JS action
        uses: ./action-js # La ruta es correcta
        with:
          nombre: 'GitHub'
```

**`action-js/action.yml`:**
```yaml
# action-js/action.yml
name: 'Broken JS Action'
description: 'Una acción JS con una estructura de archivos rota.'
inputs:
  nombre:
    description: 'Nombre a saludar'
    required: true
runs:
  using: 'node16'
  main: 'index.js' # ERROR: El archivo está en un subdirectorio
```

**`action-js/package.json`:**
```json
{
  "name": "broken-js-action",
  "version": "1.0.0",
  "main": "src/main.js",
  "dependencies": {
    "@actions/core": "^1.10.0"
  }
}
```

**`action-js/src/main.js`:**
```javascript
// action-js/src/main.js
const core = require('@actions/core');

try {
  const nombre = core.getInput('nombre');
  console.log(`¡Hola, ${nombre}!`);
} catch (error) {
  core.setFailed(error.message);
}
```

**Instrucciones:**
1.  Ejecuta el workflow y observa el error. Probablemente indicará que no puede encontrar el archivo `index.js`.
2.  Analiza la estructura de archivos y el `action.yml`.
3.  Una vez que corrijas la ruta en `action.yml`, surgirá un segundo problema: la acción intentará ejecutarse sin sus dependencias (`@actions/core`).
4.  Modifica el workflow para solucionar ambos problemas.

**Pistas:**
- La propiedad `main` en `action.yml` debe apuntar a la ruta del archivo JS relativa al `action.yml` mismo.
- Las acciones de JavaScript que tienen un `package.json` casi siempre requieren un paso de `npm install` o `npm ci` antes de poder ser utilizadas. ¿Dónde debería ir este paso en el workflow?

### Resultado Esperado:
- El workflow se ejecuta y finaliza con éxito.
- Se añade un paso en el workflow para instalar las dependencias de la acción (`npm install --prefix action-js`).
- El `action.yml` es corregido para apuntar a `src/main.js`.
- El log del workflow muestra el mensaje "¡Hola, GitHub!".
