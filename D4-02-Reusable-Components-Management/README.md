# Concepto a Resolver: Gestión de Componentes Reutilizables
Este módulo se enfoca en cómo crear, gestionar y utilizar componentes reutilizables como los workflows reutilizables (reusable workflows) y las plantillas de workflow (workflow templates) para estandarizar y escalar las prácticas de CI/CD en una organización.

---

## Desafío 1: Crear y Consumir un Workflow Reutilizable
Un workflow reutilizable te permite invocar un workflow desde otro, evitando la duplicación de código. En este desafío, crearás un workflow reutilizable y otro que lo llame.

**Archivos a crear por el estudiante:**
- `.github/workflows/reusable-deploy.yml` (El workflow que será llamado)
- `.github/workflows/caller.yml` (El workflow que llama)

**Archivos de apoyo (proporcionados por ti):**
- Ninguno.

**Instrucciones del workflow reutilizable (`reusable-deploy.yml`):
- Debe activarse con `on: workflow_call`.
- Debe aceptar una entrada (input) de tipo `string` llamada `environment`.
- Debe contener un job que imprima un mensaje como "Desplegando en el entorno: ${{ inputs.environment }}".

**Instrucciones del workflow que llama (`caller.yml`):
- Debe activarse con un `push` a la rama `main`.
- Debe contener un job que llame al workflow reutilizable (`.github/workflows/reusable-deploy.yml`).
- Debe pasar el valor `staging` para la entrada `environment`.

### Resultado Esperado:
- Al hacer push a `main`, el workflow `caller.yml` se ejecuta.
- El workflow `caller.yml` invoca exitosamente a `reusable-deploy.yml`.
- En los logs del workflow reutilizable, se muestra el mensaje "Desplegando en el entorno: staging".

---

## Desafío 2: Pasar Secretos a un Workflow Reutilizable
Pasar secretos a un workflow reutilizable requiere una declaración explícita para mantener la seguridad. Este desafío consiste en pasar un secreto de un workflow que llama a uno reutilizable.

**Archivos a crear por el estudiante:**
- `.github/workflows/reusable-publish.yml`
- `.github/workflows/caller-with-secrets.yml`

**Archivos de apoyo (proporcionados por ti):**
- Ninguno.

**Instrucciones del workflow reutilizable (`reusable-publish.yml`):
- Debe activarse con `on: workflow_call`.
- Debe declarar que puede recibir un secreto llamado `NPM_TOKEN` usando la clave `secrets`.
- Debe contener un job que simule la publicación, imprimiendo un mensaje como "Publicando paquete con el token: ***".

**Instrucciones del workflow que llama (`caller-with-secrets.yml`):
- Debe activarse con `workflow_dispatch`.
- Debe definir un job que llame a `reusable-publish.yml`.
- Debe pasar un secreto llamado `NPM_TOKEN` al workflow reutilizable. Puedes usar un secreto del repositorio o pasarlo directamente con `secrets: inherit`.

### Resultado Esperado:
- El workflow `caller-with-secrets.yml` se ejecuta manualmente.
- El secreto `NPM_TOKEN` se pasa de forma segura al workflow `reusable-publish.yml`.
- El workflow reutilizable se ejecuta correctamente, demostrando que recibió el secreto.

---

## Desafío 3: Debugging - Error en la Herencia de Secretos y Entradas
Se te proporciona un conjunto de workflows (llamador y reutilizable) que no funcionan debido a una configuración incorrecta en la forma en que se pasan las entradas y los secretos.

**Archivos a crear por el estudiante:**
- Ninguno. Debes corregir los workflows proporcionados.

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/buggy-caller.yml`
- `.github/workflows/buggy-reusable.yml`

**Contenido del workflow con errores (`buggy-caller.yml`):
```yaml
name: Buggy Caller
on: workflow_dispatch

jobs:
  call-workflow:
    uses: ./.github/workflows/buggy-reusable.yml
    # Pista: ¿El nombre de la entrada coincide con lo que el workflow reutilizable espera?
    with:
      artifact_name: 'my-app'
    # Pista: ¿Cómo se pasan los secretos? ¿Es 'secrets: true' una sintaxis válida?
    secrets: true
```

**Contenido del workflow con errores (`buggy-reusable.yml`):
```yaml
name: Buggy Reusable Workflow
on:
  workflow_call:
    inputs:
      package_name:
        description: 'The name of the package'
        required: true
        type: string
    secrets:
      REGISTRY_TOKEN:
        description: 'Token for the registry'
        required: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building ${{ inputs.package_name }}"
      - run: echo "Token starts with ${{ secrets.REGISTRY_TOKEN }}" # Esto fallará
```

**Instrucciones del desafío:**
1.  Analiza ambos workflows. El `buggy-caller.yml` falla al intentar invocar al `buggy-reusable.yml`.
2.  Identifica el error en la sección `with`. El nombre de la entrada en el llamador (`artifact_name`) no coincide con el esperado en el reutilizable (`package_name`).
3.  Identifica el error en la sección `secrets`. La sintaxis `secrets: true` es incorrecta. Debes usar `secrets: inherit` o mapear el secreto explícitamente (`REGISTRY_TOKEN: ${{ secrets.SOME_SECRET }}`).
4.  Corrige ambos problemas en `buggy-caller.yml`.

### Resultado Esperado:
- El workflow `buggy-caller.yml` se ejecuta exitosamente tras las correcciones.
- La entrada `package_name` se pasa correctamente y se imprime en el log.
- El secreto se hereda correctamente y el workflow reutilizable puede acceder a él.
