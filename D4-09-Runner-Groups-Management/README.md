# Concepto a Resolver: Gestión de Grupos de Runners
Los grupos de runners permiten gestionar el acceso a los runners auto-alojados a nivel de organización. En lugar de asignar runners directamente a repositorios, los asignas a un grupo y luego controlas qué repositorios (o todas las repositorios de la organización) pueden usar los runners de ese grupo. Esto simplifica la administración de permisos a gran escala.

---

## Desafío 1: Crear un Grupo de Runners y Asignarle un Runner
Crearás un nuevo grupo de runners en tu organización, le asignarás un runner auto-alojado y configurarás el acceso para un repositorio específico.

**Requisitos previos:**
-   Tener un runner auto-alojado registrado a nivel de organización.

**Instrucciones:**
1.  Navega a la configuración de tu organización (`Settings` > `Actions` > `Runner groups`).
2.  Haz clic en `New runner group`.
3.  Dale un nombre al grupo, por ejemplo, `development-runners`.
4.  En la política de acceso a repositorios, selecciona `Selected repositories` y añade tu repositorio de práctica a la lista.
5.  Guarda el grupo.
6.  Ahora, ve a la lista de `Runners` de la organización. Encuentra tu runner auto-alojado, haz clic en él para editarlo y asígnalo al grupo `development-runners` que acabas de crear.

**Archivos a crear por el estudiante:**
-   `.github/workflows/runner-group-test.yml`

**Instrucciones del workflow:**
Tu workflow debe:
-   Activarse con `workflow_dispatch`.
-   Contener un job que se ejecute en el grupo de runners que creaste. Para ello, se usa la etiqueta `runs-on` con el nombre del grupo.

```yaml
# .github/workflows/runner-group-test.yml
name: Test Runner Group
on: workflow_dispatch
jobs:
  test-job:
    runs-on: development-runners
    steps:
      - name: Confirm execution
        run: echo "Job ejecutado en un runner del grupo 'development-runners'."
```

### Resultado Esperado:
-   El grupo de runners se crea correctamente con la política de acceso definida.
-   El runner de la organización se asigna con éxito al nuevo grupo.
-   El workflow se ejecuta y el job es recogido por el runner perteneciente al grupo `development-runners`, completándose con éxito.

---

## Desafío 2: Permitir el Acceso de Todos los Repositorios a un Grupo
Modificarás la configuración de un grupo de runners para que todos los repositorios de la organización puedan utilizar los runners que contiene, simplificando el acceso para entornos de CI/CD generales.

**Instrucciones:**
1.  Vuelve a la configuración del grupo `development-runners` que creaste en el Desafío 1.
2.  Cambia la política de acceso a repositorios de `Selected repositories` a `Allow all repositories`.
3.  Guarda los cambios.
4.  (Opcional) Si tienes otro repositorio en la misma organización, crea un workflow similar al del Desafío 1 en ese otro repositorio para verificar que ahora también tiene acceso al grupo de runners.

**Archivos a crear por el estudiante:**
-   Ninguno, si se reutiliza el workflow del desafío anterior. El cambio es solo en la configuración de GitHub.

### Resultado Esperado:
-   La política del grupo de runners se actualiza correctamente.
-   Cualquier repositorio dentro de la organización ahora puede dirigir jobs al grupo `development-runners` y estos se ejecutarán con éxito.

---

## Desafío 3: Resolución de Problemas - Job No Asignado por Restricciones de Grupo
Un workflow en un repositorio recién creado no se ejecuta. El job permanece en cola, aunque sabes que hay runners disponibles en la organización.

**Archivos de apoyo (proporcionados por ti):**
-   `.github/workflows/debugging-group-access.yml`

**Contenido del workflow:**
```yaml
# .github/workflows/debugging-group-access.yml
name: Debugging Group Access
on: workflow_dispatch
jobs:
  build:
    runs-on: production-runners
    steps:
      - name: Build project
        run: echo "Building..."
```

**Contexto del Problema:**
-   Tu organización tiene un grupo de runners llamado `production-runners`.
-   Este grupo contiene varios runners activos y en estado "Idle".
-   Sin embargo, el workflow del repositorio `new-project` que intenta usar este grupo se queda atascado.
-   Otro repositorio, `legacy-project`, sí puede usar el grupo `production-runners` sin problemas.

**Instrucciones:**
1.  Analiza la configuración del workflow. La sintaxis es correcta.
2.  Revisa la configuración del grupo de runners `production-runners` en la UI de GitHub de la organización.
3.  Presta especial atención a la sección de "Repository access" del grupo.
4.  Identifica por qué el repositorio `new-project` no puede acceder a los runners del grupo.

**Pistas:**
-   Si un runner está disponible pero el job no se asigna, casi siempre es un problema de permisos o de etiquetas/grupos.
-   Compara los permisos de acceso del repositorio que funciona (`legacy-project`) con los del que no funciona (`new-project`).
-   ¿La política de acceso del grupo de runners está configurada para `Allow all repositories` o para `Selected repositories`?

### Resultado Esperado:
-   Identificas que el grupo `production-runners` está configurado para permitir el acceso solo a una lista selecta de repositorios.
-   Descubres que el repositorio `new-project` no ha sido añadido a esa lista de acceso.
-   La solución es editar la configuración del grupo de runners y añadir `new-project` a la lista de repositorios permitidos.
-   Tras el cambio, el workflow en `new-project` se ejecuta con éxito.
