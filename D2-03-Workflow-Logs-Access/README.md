# Concepto a Resolver: Acceso y Gestión de Logs de Workflow

Este concepto se centra en cómo acceder, descargar y gestionar los logs generados por las ejecuciones de workflows en GitHub Actions, una habilidad crucial para la auditoría y el diagnóstico de problemas.

---

## Desafío 1: Descargar Logs de un Workflow mediante la API de GitHub

Crea un workflow que, después de completar un job, utilice la API de GitHub para descargar los logs de su propia ejecución y los suba como un artefacto.

**Archivos a crear por el estudiante:**
- `.github/workflows/download-logs.yml`

**Archivos de apoyo (proporcionados por ti):**
- `simple_script.sh`

**Contenido de los archivos de apoyo:**
```bash
# simple_script.sh
#!/bin/bash
echo "Este es un script simple."
echo "Generando algo de salida para los logs..."
for i in {1..5}; do
  echo "Línea de log número $i"
done
echo "Script finalizado."
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse en el evento `push`.
- Tener un primer job (`build_job`) que ejecute el script `simple_script.sh`.
- Tener un segundo job (`log_archiver_job`) que dependa de la finalización del primero (`needs: build_job`).
- En `log_archiver_job`, utilizar `curl` y la API de GitHub para descargar el archivo zip de los logs del workflow actual.
  - La URL de la API es: `https://api.github.com/repos/${{ github.repository }}/actions/runs/${{ github.run_id }}/logs`
- Usar el `GITHUB_TOKEN` para autenticarse en la API.
- Subir el archivo de logs descargado (`logs.zip`) como un artefacto del workflow usando `actions/upload-artifact`.

### Resultado Esperado:
- El workflow se ejecuta con éxito.
- El job `log_archiver_job` descarga un archivo `logs.zip`.
- Un artefacto llamado "workflow-logs" que contiene el `logs.zip` está disponible para su descarga en la página de resumen del workflow.

---

## Desafío 2: Limpieza Automática de Logs mediante Políticas de Retención

Este desafío no requiere crear un workflow, sino configurar el repositorio para gestionar la retención de logs y artefactos, una tarea común de administración.

**Instrucciones:**
- El estudiante debe navegar a la configuración del repositorio (`Settings > Actions > General`).
- En la sección "Artifact and log retention", cambiar el período de retención por defecto.
- Establecer un período de retención personalizado muy corto, como `1` día, para los artefactos y logs.
- **Pregunta para el estudiante:** ¿Cómo podrías anular esta configuración a nivel de un workflow individual si necesitaras conservar los logs de un despliegue crítico por más tiempo?

### Resultado Esperado:
- El estudiante localiza y cambia la configuración de retención de logs y artefactos del repositorio.
- El estudiante puede explicar que se puede usar la propiedad `retention-days` en la acción `actions/upload-artifact` o a nivel de workflow para anular la configuración del repositorio.

---

## Desafío de Debugging: Corregir un Workflow que Falla al Purgar Logs

Debes identificar y corregir los errores en un workflow que intenta usar una acción de la comunidad para purgar los logs de ejecuciones antiguas, pero falla debido a problemas de permisos y configuración.

**Archivos a crear por el estudiante:**
- (Ninguno, debes corregir el archivo proporcionado)

**Archivos de apoyo (proporcionados por ti):**
```yaml
# .github/workflows/debug-purge-logs.yml (CON ERRORES INTENCIONALES)
name: Debug Log Purging

on:
  schedule:
    - cron: '0 2 * * *' # Se ejecuta diariamente a las 2 AM

jobs:
  purge_old_logs:
    runs-on: ubuntu-latest
    # Faltan permisos para eliminar logs de actions

    steps:
      - name: Purge Old Workflow Runs
        uses: Mattraks/delete-workflow-runs@v2
        with:
          token: GITHUB_TOKEN # Error: El token debe ser pasado como un secreto
          repository: ${{ github.repository }}
          retain_days: 7
          keep_minimum_runs: 3 # Error: La propiedad está mal escrita
```

**Pistas sutiles:**
- Las acciones que realizan tareas administrativas en el repositorio, como eliminar logs, necesitan permisos elevados. Revisa la sección `permissions` y asegúrate de que la acción tenga el permiso `actions: write`.
- El `GITHUB_TOKEN` es un secreto. ¿Cómo se referencia correctamente en un campo `with`? La sintaxis `${{ secrets.GITHUB_TOKEN }}` es la forma estándar.
- Las acciones de la comunidad tienen sus propios inputs específicos. Revisa la documentación de `Mattraks/delete-workflow-runs`. ¿La propiedad para mantener un número mínimo de ejecuciones se llama `keep_minimum_runs` o `keep_min_runs`?

### Resultado Esperado:
- El workflow se ejecuta sin errores de sintaxis ni de permisos.
- Al ejecutarse (manualmente o por schedule), la acción purga correctamente los logs de las ejecuciones de workflows que tienen más de 7 días, pero siempre conserva las 3 más recientes.
- El log de la acción muestra un resumen de cuántas ejecuciones de workflow se han eliminado.
