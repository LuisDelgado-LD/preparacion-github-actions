# Concepto a Resolver: Navegación y Ubicación de Workflows
Entender dónde se almacenan los workflows (`.github/workflows`), cómo se nombran y cómo GitHub los descubre y los muestra en la pestaña "Actions" es fundamental. También es importante saber cómo referenciar y reutilizar workflows dentro de una organización.

---

## Desafío 1: Creación y Ubicación de un Workflow Básico
**Objetivo:** Crear un workflow en la ubicación correcta para que GitHub lo reconozca y lo ejecute.

**Archivos a crear por el estudiante:**
- `.github/workflows/first-workflow.yml`

**Instrucciones del workflow:**
Tu workflow `.github/workflows/first-workflow.yml` debe:
-   Tener un `name` descriptivo, como `Mi Primer Workflow`.
-   Activarse con el evento `workflow_dispatch`.
-   Contener un job `greeting` que se ejecute en `ubuntu-latest`.
-   El job debe tener un solo paso que imprima "¡Hola desde mi primer workflow!".

### Resultado Esperado:
-   Después de hacer `push` del archivo a tu repositorio, navegas a la pestaña "Actions".
-   Ves "Mi Primer Workflow" en la lista de workflows a la izquierda.
-   Puedes ejecutar el workflow manualmente y ver el mensaje de saludo en los logs.

---

## Desafío 2: Renombrar un Workflow y Observar el Cambio
**Objetivo:** Entender cómo el campo `name` dentro del archivo YML controla cómo se muestra el workflow en la UI de GitHub, independientemente del nombre del archivo.

**Archivos a crear por el estudiante:**
- (Modificar `.github/workflows/first-workflow.yml`)

**Instrucciones:**
1.  Edita el archivo `.github/workflows/first-workflow.yml`.
2.  Cambia el valor del campo `name` a `Workflow de Saludo Principal`.
3.  Haz `commit` y `push` de los cambios.

### Resultado Esperado:
-   Vas a la pestaña "Actions".
-   El workflow que antes se llamaba "Mi Primer Workflow" ahora aparece como "Workflow de Saludo Principal" en la lista.
-   El nombre del archivo (`first-workflow.yml`) no ha cambiado, demostrando que el `name` interno tiene prioridad para la visualización.

---

## Desafío 3: Workflow Desactivado (Ubicación Incorrecta)
**Objetivo:** Comprender que los workflows solo se descubren si están exactamente en el directorio `.github/workflows/`.

**Archivos a crear por el estudiante:**
- (Mover el archivo de workflow a una nueva ubicación)

**Instrucciones:**
1.  En tu repositorio local, crea un nuevo directorio: `.github/actions/`.
2.  Mueve el archivo `first-workflow.yml` desde `.github/workflows/` a `.github/actions/`.
3.  Haz `commit` y `push` de este cambio.

### Resultado Esperado:
-   Navegas a la pestaña "Actions" de tu repositorio.
-   El "Workflow de Saludo Principal" ha desaparecido de la lista de workflows.
-   GitHub ya no reconoce el archivo como un workflow ejecutable porque no está en la carpeta esperada.
-   (Para restaurar, mueve el archivo de vuelta a `.github/workflows/`).

---

## Desafío 4: Debugging - Workflow No Encontrado
**Objetivo:** Diagnosticar por qué un workflow que parece estar en el lugar correcto no aparece en la pestaña "Actions".

**Archivos de apoyo (proporcionados por ti):**
Imagina que un colega te pide ayuda. Te dice que ha creado el siguiente workflow pero no le aparece en GitHub. Te pasa el nombre del archivo y su contenido.

**Nombre del archivo:** `.github/workflow/important-workflow.yml` (¡Presta atención a la ruta!)

```yaml
# .github/workflow/important-workflow.yml
name: Workflow Super Importante
on:
  push:
    branches: [ main ]

jobs:
  process:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Procesando datos importantes."
```

**Instrucciones:**
1.  Analiza la ruta del archivo proporcionada por tu colega.
2.  Analiza el contenido del archivo YML.
3.  Identifica la causa raíz del problema.

**Pistas:**
-   La sintaxis del YML parece perfectamente válida.
-   El nombre del evento y del job son correctos.
-   Compara la ruta del archivo `.github/workflow/` con la ruta requerida por GitHub. ¿Notas alguna diferencia sutil?

### Resultado Esperado:
-   Identificas que el problema es un error tipográfico en el nombre del directorio: `workflow` en lugar de `workflows` (falta la 's').
-   Explicas que la única ubicación válida para los archivos de workflow es el directorio `.github/workflows/`.
-   Al corregir el nombre del directorio a `.github/workflows/`, el "Workflow Super Importante" aparecerá correctamente en la pestaña "Actions".
