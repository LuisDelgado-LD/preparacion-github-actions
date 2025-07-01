# Concepto a Resolver: Plantillas de Workflow Organizacionales
Las plantillas de workflow permiten a una organización definir workflows estándar que pueden ser utilizados por los repositorios de la organización. Esto promueve la consistencia, las mejores prácticas y la reutilización de código. Las plantillas se almacenan en un repositorio especial `.github` a nivel de organización y se ofrecen a los desarrolladores cuando crean nuevos workflows.

**Nota:** Para estos desafíos, simularás el comportamiento, ya que requieren la configuración de una organización de GitHub.

---

## Desafío 1: Creación de una Plantilla de Workflow Reutilizable
**Objetivo:** Crear un workflow que sirva como plantilla para otros workflows, utilizando `workflow_call` para hacerlo reutilizable.

**Archivos a crear por el estudiante:**
- `.github/workflows/reusable-template.yml`
- `.github/workflows/caller-workflow.yml`

**Instrucciones del workflow `reusable-template.yml`:**
-   Debe activarse con `workflow_call`.
-   Debe definir dos `inputs`: `environment` (tipo string, requerido) y `run-tests` (tipo boolean, por defecto `true`).
-   Debe definir un `secret`: `deploy-token` (requerido).
-   Tendrá un job `execute-template`.
-   El job imprimirá un mensaje: `Deploying to ${{ inputs.environment }}`.
-   El job tendrá un paso de "Run tests" que solo se ejecutará `if: inputs.run-tests == true`.
-   El job tendrá un paso que simula el uso del secret: `echo "Using token..."`.

**Instrucciones del workflow `caller-workflow.yml`:**
-   Debe activarse en `workflow_dispatch`.
-   Tendrá un job `call-reusable`.
-   Este job llamará al workflow reutilizable usando `uses: ./.github/workflows/reusable-template.yml`.
-   Pasará `environment: 'staging'` y `run-tests: true` como `inputs`.
-   Pasará un secret del repositorio (`MY_REPO_SECRET`) como el `deploy-token`.

### Resultado Esperado:
-   Necesitarás crear un secret en tu repositorio llamado `MY_REPO_SECRET` con cualquier valor.
-   Al ejecutar `caller-workflow.yml` manualmente, este invoca a `reusable-template.yml`.
-   El log muestra "Deploying to staging" y "Running tests...".
-   El workflow se ejecuta sin errores de secrets.

---

## Desafío 2: Simulación de una Plantilla Organizacional
**Objetivo:** Entender cómo se estructuraría y se usaría una plantilla a nivel de organización.

**Instrucciones:**
1.  Imagina que tienes una organización de GitHub llamada `my-org`.
2.  Crearías un repositorio público llamado `.github` dentro de esa organización.
3.  Dentro de ese repositorio, crearías una carpeta `workflow-templates`.
4.  Dentro de `workflow-templates`, colocarías tu archivo de plantilla, por ejemplo, `standard-ci.yml`.
5.  También necesitarías un archivo de metadatos, `standard-ci.properties.json`, para describir la plantilla.

**Archivos a crear por el estudiante (simulación):**
- `my-org-repo/.github/workflow-templates/standard-ci.yml`
- `my-org-repo/.github/workflow-templates/standard-ci.properties.json`

**Contenido de `standard-ci.yml`:**
```yaml
name: Standard CI Template
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Running standard build process..."
```

**Contenido de `standard-ci.properties.json`:**
```json
{
    "name": "Standard CI for My-Org",
    "description": "A basic CI template for all projects in the organization.",
    "iconName": "example-icon",
    "categories": [
        "CI",
        "Build"
    ]
}
```

### Resultado Esperado:
-   Comprendes la estructura de archivos necesaria para una plantilla organizacional.
-   Si estuvieras en la organización `my-org`, al crear un nuevo workflow en cualquier otro repositorio, verías "Standard CI for My-Org" como una de las plantillas sugeridas por GitHub.

---

## Desafío 3: Debugging de un Workflow Reutilizable
**Objetivo:** Diagnosticar por qué un workflow que llama a otro reutilizable está fallando.

**Archivos de apoyo (proporcionados por ti):**

**Workflow reutilizable (`.github/workflows/reusable-debug.yml`):**
```yaml
name: Reusable Workflow with Outputs
on:
  workflow_call:
    inputs:
      version: 
        required: true
        type: string
    outputs:
      build-id:
        description: "The ID of the build"
        value: ${{ jobs.build.outputs.id }}

jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      id: ${{ steps.build_step.outputs.build_id }}
    steps:
      - id: build_step
        run: echo "build_id=build-$(date +%s)" >> $GITHUB_OUTPUT
```

**Workflow que llama (`.github/workflows/caller-debug.yml`):**
```yaml
name: Debug Reusable Caller
on: workflow_dispatch

jobs:
  call-and-use:
    uses: ./.github/workflows/reusable-debug.yml
    with:
      version: 1.2.3

  deploy:
    runs-on: ubuntu-latest
    needs: call-and-use
    steps:
      - run: echo "Deploying build ${{ needs.call-and-use.outputs.build_id }}"
```

**Instrucciones:**
1.  Crea ambos archivos en tu repositorio.
2.  Ejecuta el workflow `Debug Reusable Caller`.
3.  Observa que el job `deploy` falla o no muestra el ID del build.

**Pistas:**
-   ¿Cómo se pasan los `outputs` de un workflow reutilizable al workflow que lo llama? ¿Están disponibles automáticamente para otros jobs?
-   Revisa la sintaxis para acceder a los `outputs` de un job que usa `workflow_call`.
-   El job `deploy` necesita los `outputs` del job `call-and-use`. ¿El job `call-and-use` está definiendo algún `output` que el job `deploy` pueda consumir?

### Resultado Esperado:
-   Identificas que el job `call-and-use` no tiene una sección de `outputs` para pasar el `build-id` al siguiente job.
-   Corriges el workflow `caller-debug.yml` añadiendo una sección `outputs` al job `call-and-use` para que exponga el `output` del workflow reutilizable.
    ```yaml
    # En el job call-and-use
    outputs:
      build-id: ${{ jobs.call-reusable.outputs.build-id }} # El nombre del job interno del workflow reutilizable es `build`
    ```
    *Corrección*: La sintaxis correcta para acceder a los outputs de un workflow reutilizable es a través de `needs.<job_id>.outputs.<output_name>`. El problema es que el job `call-and-use` en sí mismo no está propagando el output. El job `deploy` está intentando acceder a un output de un job (`call-and-use`) que no lo ha declarado.
-   La corrección final es que el job `deploy` puede acceder directamente al output. El error está en cómo se referencia. El workflow reutilizable se trata como un solo job en el `needs` context. La sintaxis correcta en el job `deploy` es `needs.call-and-use.outputs.build-id`.
-   El verdadero error es que el workflow que llama (`caller-debug.yml`) no está pasando el `output` del workflow reutilizable a los jobs posteriores. El job `call-and-use` necesita definir sus propios `outputs` que tomen el valor de los `outputs` del workflow que llamó.
-   **Solución Final:** El job `call-and-use` debe ser modificado para tener `outputs` y el job `deploy` debe referenciarlos correctamente.
