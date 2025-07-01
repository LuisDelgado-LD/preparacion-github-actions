# Concepto a Resolver: Interpretación de los Efectos de un Workflow

Este concepto se centra en cómo los workflows de GitHub Actions interactúan con el repositorio, afectando las protecciones de rama, los status checks y la gestión de ejecuciones concurrentes.

---

## Desafío 1: Workflow como Verificación de Estado Requerida (Required Status Check)

Configura un workflow que actúe como una verificación de estado (status check) obligatoria para proteger la rama `main`, impidiendo que se fusionen pull requests si el título no cumple con un formato específico.

**Archivos a crear por el estudiante:**
- `.github/workflows/pr-title-check.yml`
- `check_pr_title.sh`

**Contenido de los archivos de apoyo (proporcionados por ti):**
```bash
# check_pr_title.sh
#!/bin/bash
set -e

TITLE="$1"
echo "Verificando el título del Pull Request: '$TITLE'"

if [[ "$TITLE" =~ ^(feat|fix|docs|chore): ]]; then
  echo "El título cumple con el formato requerido."
  exit 0
else
  echo "Error: El título del PR debe comenzar con 'feat:', 'fix:', 'docs:', o 'chore:'."
  exit 1
fi
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse en eventos `pull_request` dirigidos a la rama `main`.
- Realizar el checkout del código.
- Dar permisos de ejecución al script `check_pr_title.sh`.
- Ejecutar el script, pasándole el título del pull request como argumento (`${{ github.event.pull_request.title }}`).
- **Acción manual requerida:** El estudiante deberá ir a la configuración del repositorio, a la sección de "Branches", y añadir una regla de protección para `main` que requiera que la verificación de estado de este job pase antes de poder fusionar.

### Resultado Esperado:
- El workflow se ejecuta en cada PR a `main`.
- Si el título del PR no sigue el formato, el job falla y bloquea la fusión del PR.
- Si el título es correcto, el job pasa, permitiendo la fusión (si otras condiciones se cumplen).
- La configuración de protección de rama en el repositorio refleja este requisito.

---

## Desafío 2: Gestión de Concurrencia para Evitar Ejecuciones Redundantes

Crea un workflow que demuestre el uso de `concurrency` para cancelar ejecuciones obsoletas en una rama de feature, asegurando que solo se complete el workflow del commit más reciente.

**Archivos a crear por el estudiante:**
- `.github/workflows/concurrent-build.yml`

**Archivos de apoyo (proporcionados por ti):**
- `long_running_script.sh`

**Contenido de los archivos de apoyo:**
```bash
# long_running_script.sh
#!/bin/bash
echo "Iniciando un proceso de construcción largo..."
echo "Commit: $1"
sleep 30
echo "Proceso de construcción finalizado."
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse en el evento `push` a cualquier rama que siga el patrón `feature/**`.
- Contener un job que ejecute el script `long_running_script.sh`, pasándole el SHA del commit.
- Configurar la propiedad `concurrency` para agrupar las ejecuciones por el nombre del workflow y la rama (`github.ref`).
- Establecer `cancel-in-progress: true` para que las ejecuciones anteriores en la misma rama se cancelen.
- Para probarlo, el estudiante deberá hacer varios pushes rápidos a una rama (ej. `feature/new-login`).

### Resultado Esperado:
- Al hacer un push a una rama `feature/new-login`, el workflow se inicia.
- Si se hace un segundo push a la misma rama mientras el primero aún se está ejecutando, el primer workflow se cancela automáticamente.
- Solo el workflow correspondiente al último commit en la rama `feature/new-login` se completa con éxito.

---

## Desafío de Debugging: Corregir Condiciones `if` en los Jobs

Debes identificar y corregir los errores en un workflow que utiliza condicionales `if` para controlar la ejecución de los pasos, pero que no se comporta como se espera debido a errores de sintaxis y lógica.

**Archivos a crear por el estudiante:**
- (Ninguno, debes corregir el archivo proporcionado)

**Archivos de apoyo (proporcionados por ti):**
```yaml
# .github/workflows/debug-conditions.yml (CON ERRORES INTENCIONALES)
name: Debug Conditional Logic

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  conditional_job:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Step for push to main
        # Error: La condición es demasiado simple y se ejecutará también en PRs
        if: github.ref == 'refs/heads/main'
        run: echo "This should only run on a direct push to main"

      - name: Step for pull requests
        # Error de sintaxis en el operador de comparación
        if: github.event_name = 'pull_request'
        run: echo "This should run on any pull request to main"

      - name: Step that should always run
        # Error: La condición usa una función de status check de forma incorrecta
        if: always
        run: echo "This step should run regardless of previous failures."

      - name: Step that depends on a variable
        # Error: La variable de entorno no se está evaluando correctamente en la condición
        if: env.SHOULD_RUN == 'true'
        env:
          SHOULD_RUN: "true"
        run: echo "This step should run because SHOULD_RUN is true."
```

**Pistas sutiles:**
- Un `push` a `main` y un `pull_request` a `main` pueden compartir el mismo `github.ref`. ¿Cómo puedes distinguir inequívocamente entre un evento `push` y un `pull_request`?
- Los operadores de comparación en las expresiones de GitHub Actions son importantes. Un solo `=` no es lo mismo que `==`.
- La función `always()` es la forma correcta de asegurar que un paso se ejecute. Usar la palabra `always` directamente no funciona.
- Para acceder a variables de entorno en una condición `if`, la sintaxis es diferente a cuando se accede en un `run` script. Revisa cómo se referencia el contexto `env`.

### Resultado Esperado:
- El workflow se ejecuta sin errores de sintaxis.
- El paso "Step for push to main" se ejecuta **únicamente** cuando se hace un push directo a `main`, y no en pull requests.
- El paso "Step for pull requests" se ejecuta en cualquier pull request dirigido a `main`.
- El paso "Step that should always run" se ejecuta siempre, incluso si un paso anterior fallara.
- El paso "Step that depends on a variable" se ejecuta correctamente al evaluar la variable de entorno.
