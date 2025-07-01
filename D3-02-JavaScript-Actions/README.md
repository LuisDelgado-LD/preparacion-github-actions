# Concepto a Resolver: Creación de Acciones con JavaScript
Las acciones de JavaScript son rápidas y se ejecutan directamente en la máquina del runner (Linux, macOS, Windows). Utilizan Node.js y el toolkit de acciones de GitHub (`@actions/core`, `@actions/github`) para interactuar con el entorno del workflow, obtener entradas, establecer salidas y comunicarse con la API de GitHub.

---

## Desafío 1: Acción de JavaScript Básica con Entradas y Salidas
**Objetivo:** Crear una acción de JavaScript que tome un nombre como entrada y produzca un saludo como salida.

**Archivos a crear por el estudiante:**
- `js-action/action.yml`
- `.github/workflows/test-js-action.yml`

**Contenido de los archivos de apoyo (proporcionados por ti):**

**`js-action/package.json`:**
```json
{
  "name": "js-action",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "@actions/core": "^1.10.0"
  }
}
```

**`js-action/index.js`:**
```javascript
const core = require('@actions/core');

try {
  // Obtener la entrada 'who-to-greet'
  const nameToGreet = core.getInput('who-to-greet');
  console.log(`Hello ${nameToGreet}!`);

  // Establecer la salida 'greeting-message'
  const message = `Hello again, ${nameToGreet}!`;
  core.setOutput('greeting-message', message);
} catch (error) {
  core.setFailed(error.message);
}
```

**Instrucciones del workflow (`test-js-action.yml`):**
-   Activar en `workflow_dispatch`.
-   Tener un job `test-action`.
-   El job debe hacer checkout del código.
-   El job debe instalar las dependencias de la acción con `npm install` en el directorio `js-action`.
-   El job debe tener un paso que use la acción local: `uses: ./js-action` con `id: greet_step` y `with: { who-to-greet: 'Mona' }`.
-   Un paso final debe imprimir la salida de la acción: `run: echo "La salida fue: ${{ steps.greet_step.outputs.greeting-message }}"`.

### Resultado Esperado:
-   El workflow se ejecuta correctamente.
-   El log del paso que usa la acción muestra "Hello Mona!".
-   El log del paso final muestra "La salida fue: Hello again, Mona!".

---

## Desafío 2: Interactuar con el Contexto de GitHub
**Objetivo:** Modificar la acción para que use el paquete `@actions/github` para acceder al contexto del workflow, como el nombre del actor que inició el evento.

**Archivos a crear por el estudiante:**
- (Modificar `js-action/index.js` y `js-action/package.json`)

**Instrucciones:**
1.  Añade `@actions/github` a las dependencias en `package.json`.
2.  Modifica `index.js` para que, si no se proporciona la entrada `who-to-greet`, salude al `github.context.actor`.

**Contenido de `js-action/index.js` modificado:**
```javascript
const core = require('@actions/core');
const github = require('@actions/github');

try {
  let nameToGreet = core.getInput('who-to-greet');
  if (!nameToGreet) {
    nameToGreet = github.context.actor;
  }
  console.log(`Hello ${nameToGreet}!`);

  const message = `Hello again, ${nameToGreet}!`;
  core.setOutput('greeting-message', message);
} catch (error) {
  core.setFailed(error.message);
}
```

**Instrucciones del workflow:**
-   Modifica el workflow `test-js-action.yml` para que el paso que usa la acción ya no pase la entrada `who-to-greet`.

### Resultado Esperado:
-   Al ejecutar el workflow, la acción saluda a tu nombre de usuario de GitHub (el `actor`).
-   El log muestra "Hello [tu-usuario]!".

---

## Desafío 3: Debugging de una Acción de JavaScript
**Objetivo:** Encontrar y corregir un error común en una acción de JavaScript.

**Archivos de apoyo (proporcionados por ti):**

**`debug-js-action/action.yml`:**
```yaml
name: 'Debug JS Action'
description: 'An action with a bug'
inputs:
  input-data:
    required: true
outputs:
  processed-data:
    description: 'Processed data'
runs:
  using: 'node20'
  main: 'dist/index.js' # Apunta a un archivo que no existe todavía
```

**`debug-js-action/index.js`:**
```javascript
const core = require('@actions/core');

const data = core.getInput('input-data');
const processed = data.toUpperCase(); // Esto funcionará
core.setOutput('processed-data', processed);
```

**`debug-js-action/package.json`:**
```json
{
  "name": "debug-js-action",
  "dependencies": {
    "@actions/core": "^1.10.0"
  }
}
```

**Workflow de prueba (`.github/workflows/test-debug-action.yml`):**
```yaml
name: Test Debug JS Action
on: workflow_dispatch
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm install
        working-directory: debug-js-action
      - uses: ./debug-js-action
        with:
          input-data: 'some data'
```

**Instrucciones:**
1.  Crea la estructura de archivos y el workflow.
2.  Ejecuta el workflow y observa el error.

**Pistas:**
-   El error del workflow dirá que no puede encontrar `dist/index.js`.
-   Las acciones de JavaScript a menudo se "empaquetan" en un solo archivo para mejorar el rendimiento y no tener que incluir la carpeta `node_modules`.
-   Una herramienta común para esto es `ncc` de Vercel. ¿Falta un paso de compilación o empaquetado?
-   El `action.yml` apunta a `dist/index.js`, pero el código fuente está en `index.js`.

### Resultado Esperado:
-   Identificas que el `main` en `action.yml` apunta a un archivo en `dist/`, pero no hay ningún paso de compilación para crearlo.
-   **Solución 1 (Simple):** Cambias el `main` en `action.yml` para que apunte directamente a `index.js`.
-   **Solución 2 (Mejor Práctica):** Añades `ncc` a tu `package.json` (`npm i -g @vercel/ncc`), añades un script de compilación (`"build": "ncc build index.js --license licenses.txt"`) y modificas el workflow para que ejecute `npm run build` antes de usar la acción. Esto creará el archivo `dist/index.js` necesario.
-   Después de la corrección, el workflow se ejecuta con éxito.
