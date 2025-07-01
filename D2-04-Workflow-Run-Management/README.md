
# Concepto a Resolver: Gestión de Ejecuciones de Workflows (Workflow Run Management)
Este módulo se centra en cómo interactuar y gestionar las ejecuciones de tus workflows una vez que han sido activados. Aprenderás a cancelar ejecuciones, re-ejecutar trabajos fallidos y utilizar herramientas como la CLI de GitHub para administrar tus workflows de manera programática, habilidades clave para mantener un ciclo de CI/CD eficiente.

---

## Desafío 1: Cancelación Automática de Ejecuciones Redundantes
Cuando se hacen pushes consecutivos a una rama, se pueden acumular ejecuciones innecesarias. En este desafío, configurarás un workflow para que cancele automáticamente cualquier ejecución en progreso en la misma rama cuando se detecta un nuevo push.

**Archivos a crear por el estudiante:**
- `.github/workflows/cancel-previous-runs.yml`

**Archivos de apoyo (proporcionados por ti):**
- `long_running_script.sh`

**Contenido de los archivos de apoyo:**
```bash
# long_running_script.sh
echo "Iniciando un trabajo largo..."
echo "Este script simulará una tarea que toma tiempo, como un build o un set de pruebas complejo."
sleep 45
echo "Trabajo largo completado."
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse en cada `push` a cualquier rama que no sea `main`.
- Contener un único job que ejecute el script `long_running_script.sh`.
- Utilizar la clave `concurrency` para agrupar las ejecuciones por rama y permitir la cancelación automática.

### Resultado Esperado:
- Al hacer un primer push a una rama de feature (ej: `feat/test-cancel`), el workflow se inicia.
- Si haces un segundo push a la misma rama mientras el primer workflow sigue en ejecución, la primera ejecución se cancelará automáticamente.
- La segunda ejecución comenzará y (si no hay más pushes) se completará con éxito.

---

## Desafío 2: Re-ejecución Manual de Trabajos Fallidos
A veces, un trabajo falla por razones transitorias (ej: un problema de red al descargar una dependencia). En lugar de volver a ejecutar todo el workflow, es más eficiente re-ejecutar solo el trabajo que falló.

**Archivos a crear por el estudiante:**
- `.github/workflows/rerun-failed-jobs.yml`

**Archivos de apoyo (proporcionados por ti):**
- `transient_failure.sh`

**Contenido de los archivos de apoyo:**
```bash
# transient_failure.sh
echo "Intentando realizar una operación crítica..."
# Simular un fallo aleatorio. El script fallará si el número aleatorio es par.
RANDOM_NUM=$((RANDOM % 10))
if [ $((RANDOM_NUM % 2)) -eq 0 ]; then
  echo "Error: La operación falló debido a un problema transitorio (Número: $RANDOM_NUM)."
  exit 1
else
  echo "Éxito: La operación se completó correctamente (Número: $RANDOM_NUM)."
  exit 0
fi
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse manualmente con `workflow_dispatch`.
- Tener dos trabajos secuenciales: `build` y `deploy`.
- El trabajo `build` simplemente imprime un mensaje de éxito y siempre pasa.
- El trabajo `deploy` depende de `build` (`needs: build`) y ejecuta el script `transient_failure.sh`, que puede fallar.

### Resultado Esperado:
- Ejecutas el workflow manualmente. Es posible que el trabajo `deploy` falle.
- Si `deploy` falla, navegas a la página de la ejecución del workflow en la UI de GitHub.
- Utilizas la opción "Re-run jobs" para re-ejecutar únicamente el trabajo `deploy` fallido.
- La segunda vez, si el script tiene éxito, el workflow completo se marcará como exitoso sin haber re-ejecutado el trabajo `build`.

---

## Desafío 3: Resolución de Problemas - Workflow con Re-ejecución Defectuosa
Este desafío te presenta un workflow que intenta ser útil pero contiene un error sutil que afecta su comportamiento en las re-ejecuciones. Tu tarea es encontrar y corregir el problema.

**Archivos a crear por el estudiante:**
- El estudiante debe **corregir** el siguiente archivo.

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/debug-rerun.yml`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/debug-rerun.yml
name: Debugging Re-run Issues

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        default: 'staging'
        type: choice
        options:
        - staging
        - production

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ github.event.inputs.environment }}
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      # Este paso es intencionalmente frágil
      - name: Deploy to environment
        run: |
          echo "Deploying to ${{ github.event.inputs.environment }}"
          if [ "${{ github.event.inputs.environment }}" == "production" ]; then
            echo "Error: Despliegue a producción deshabilitado temporalmente."
            exit 1
          fi
          echo "Despliegue a staging exitoso."

      # Este paso solo debe correr si el despliegue a producción falla y se re-ejecuta
      - name: Notify on production re-run
        if: failure() && github.event.inputs.environment == 'production'
        run: |
          echo "Alerta: Se está intentando re-ejecutar un despliegue fallido a producción."
```

**El Problema:**
El workflow está diseñado para fallar si intentas desplegar a `production`. El último paso, `Notify on production re-run`, debería teóricamente activarse solo cuando el trabajo falla en el entorno de producción. Sin embargo, no se ejecuta como se espera durante una re-ejecución.

**Pistas:**
1.  ¿Cómo evalúa la función `failure()` el estado de un trabajo? ¿Considera los resultados de intentos anteriores?
2.  Revisa el contexto de `github.event`. ¿Cambia su contenido cuando re-ejecutas un trabajo?
3.  Quizás la condición `if` no es la adecuada para detectar una **re-ejecución** de un trabajo fallido. ¿Existe alguna otra forma de verificar el estado de los pasos anteriores dentro del mismo intento?

### Resultado Esperado:
- Identificas que la condición `if` del último paso es incorrecta para el escenario de re-ejecución.
- Corriges el workflow para que el paso de notificación se active de manera fiable cuando el trabajo `deploy` se re-ejecuta después de un fallo en el entorno de `production`.
- El workflow corregido se ejecuta, falla en `production`, y al re-ejecutar el trabajo fallido, el paso de notificación se muestra correctamente en los logs.
