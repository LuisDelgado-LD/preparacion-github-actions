# Concepto a Resolver: Uso de Acciones en Workflows
Las acciones son el pilar de los workflows de GitHub Actions. Permiten empaquetar funcionalidades reutilizables. Se referencian con la palabra clave `uses`, y se pueden personalizar con entradas (`with`). Es crucial saber cómo encontrar acciones en el Marketplace, cómo usar sus diferentes versiones y cómo integrarlas correctamente en los jobs.

---

## Desafío 1: Uso Básico de una Acción (`actions/checkout`)
**Objetivo:** Aprender a usar una de las acciones más comunes y fundamentales, `actions/checkout`, para acceder al código de tu repositorio dentro de un job.

**Archivos a crear por el estudiante:**
- `.github/workflows/use-checkout.yml`
- `hello.txt` (un archivo simple en la raíz del repo)

**Contenido de `hello.txt`:**
```
Hola Mundo
```

**Instrucciones del workflow:**
Tu workflow `.github/workflows/use-checkout.yml` debe:
- Activarse en `workflow_dispatch`.
- Contener un job `read-file` que se ejecute en `ubuntu-latest`.
- El primer paso del job debe usar la acción `actions/checkout@v4`.
- El segundo paso debe usar `run` para ejecutar el comando `cat hello.txt`.

### Resultado Esperado:
- Al ejecutar el workflow, el job se completa con éxito.
- El log del segundo paso muestra "Hola Mundo", confirmando que la acción `checkout` clonó el repositorio y el archivo `hello.txt` está disponible.

---

## Desafío 2: Uso de una Acción con Entradas (`actions/setup-python`)
**Objetivo:** Aprender a pasar entradas a una acción usando la palabra clave `with` para configurar una herramienta específica.

**Archivos a crear por el estudiante:**
- `.github/workflows/setup-python-action.yml`

**Instrucciones del workflow:**
Tu workflow `.github/workflows/setup-python-action.yml` debe:
- Activarse en `workflow_dispatch`.
- Contener un job `setup-and-run` en `ubuntu-latest`.
- Usar la acción `actions/checkout@v4`.
- Usar la acción `actions/setup-python@v5` para configurar Python.
- Proporcionar una entrada (`with`) a la acción `setup-python` para especificar `python-version: '3.10'`.
- Incluir un paso final que ejecute `python --version` para verificar que la versión correcta fue instalada.

### Resultado Esperado:
- El workflow se ejecuta correctamente.
- El log del último paso muestra una salida que contiene "Python 3.10.x", confirmando que la entrada `python-version` fue procesada correctamente por la acción.

---

## Desafío 3: Especificar la Versión de una Acción
**Objetivo:** Comprender la importancia de fijar (pinning) la versión de una acción para la estabilidad del workflow. Usarás una acción de terceros del Marketplace.

**Archivos a crear por el estudiante:**
- `.github/workflows/versioned-action.yml`

**Instrucciones del workflow:**
Tu workflow `.github/workflows/versioned-action.yml` debe:
- Activarse en `workflow_dispatch`.
- Contener un job `use-cowsay-action`.
- El job debe usar la acción `mowmit/cowsay-action@v1`.
- Debes pasarle la entrada `message` con el texto "¡Las acciones son geniales!".

**Instrucciones Adicionales:**
- Investiga en el GitHub Marketplace la acción `mowmit/cowsay-action`.
- Observa las diferentes versiones disponibles y cómo se recomienda usarla.
- Ejecuta el workflow. Luego, modifica el workflow para usar una versión principal diferente si existe, o un commit SHA específico, y observa si el comportamiento cambia.

### Resultado Esperado:
- El workflow se ejecuta y el log muestra una vaca ASCII diciendo "¡Las acciones son geniales!".
- Eres capaz de cambiar la referencia de la versión en la línea `uses:` (por ejemplo, a `@v1.4.0` o a un hash de commit) y el workflow sigue funcionando, demostrando tu comprensión de cómo se versionan las acciones.

---

## Desafío 4: Debugging de un Uso Incorrecto de Acción
**Objetivo:** Diagnosticar y corregir un workflow que falla porque una acción está mal referenciada o configurada.

**Archivos de apoyo (proporcionados por ti):**
```yaml
# .github/workflows/debug-action-usage.yml
name: Debug Action Usage
on: workflow_dispatch

jobs:
  lint-code:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node_version: 18 # La entrada es 'node-version', no 'node_version'

      - name: Install dependencies
        run: npm install

      - name: Lint files
        uses: github/super-linter@v5 # Repositorio incorrecto y falta de variables de entorno
        env:
          DEFAULT_BRANCH: main
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Instrucciones:**
1.  Crea el archivo `.github/workflows/debug-action-usage.yml` con el contenido anterior.
2.  Crea un archivo `.eslintrc.json` simple para que el linter tenga algo que hacer.
3.  Ejecuta el workflow y observa los errores.

**Pistas:**
-   El error en el paso "Setup Node.js" puede ser sutil. Revisa la documentación de la acción `actions/setup-node` y compara el nombre de la entrada (`input`) que usaste con el nombre que requiere la acción.
-   El paso "Lint files" falla al intentar descargar la acción. ¿Es `github/super-linter` la ruta correcta? Busca "super-linter" en el Marketplace. ¿Cuál es el repositorio correcto?
-   Una vez corregida la ruta, el linter podría fallar por falta de configuración. La documentación de Super-linter menciona variables de entorno (`env`) que son necesarias para funcionar correctamente en el contexto de un `pull_request` o `push`.

### Resultado Esperado:
-   Identificas que la entrada para `setup-node` es `node-version`, no `node_version`, y la corriges.
-   Descubres que la acción correcta es `github/super-linter/slim` o la versión completa, pero la ruta es `super-linter/super-linter` (o similar, depende de la versión que elijas) y la corriges en la línea `uses:`.
-   Añades las variables de entorno necesarias (`DEFAULT_BRANCH`, `GITHUB_TOKEN`) al paso del linter para que pueda ejecutarse correctamente.
-   El workflow se completa con éxito, y el linter analiza el código.
