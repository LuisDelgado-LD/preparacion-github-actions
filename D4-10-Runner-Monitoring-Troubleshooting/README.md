# Concepto a Resolver: Monitorización y Solución de Problemas de Runners
La monitorización activa y la capacidad de diagnosticar problemas en los runners auto-alojados son esenciales para mantener la fiabilidad de los workflows. Esto incluye verificar el estado del runner, asegurarse de que el software esté actualizado, diagnosticar problemas de conectividad y resolver fallos en los jobs causados por el entorno del runner.

---

## Desafío 1: Verificar el Estado de los Runners con la API de GitHub
Crearás un workflow que utiliza la API de GitHub para obtener una lista de todos los runners auto-alojados de tu organización y reportar su estado, lo que es útil para la monitorización automatizada.

**Archivos a crear por el estudiante:**
-   `.github/workflows/monitor-runners.yml`

**Instrucciones del workflow:**
Tu workflow debe:
-   Activarse con `workflow_dispatch`.
-   Ejecutarse en un runner alojado por GitHub (`ubuntu-latest`).
-   Utilizar `curl` y un token con permisos de `admin:org` (almacenado en secrets) para hacer una llamada a la API de runners de la organización.
-   Imprimir la respuesta JSON, que contiene la lista de runners, su estado (`online`/`offline`) y sus etiquetas.

**Ejemplo de llamada a la API:**
```bash
curl -H "Authorization: Bearer ${{ secrets.ORG_ADMIN_PAT }}" \
     -H "Accept: application/vnd.github+json" \
     https://api.github.com/orgs/TU_ORGANIZACION/actions/runners
```
*Reemplaza `TU_ORGANIZACION` con el nombre de tu organización.*

### Resultado Esperado:
-   El workflow se ejecuta con éxito.
-   La salida del workflow muestra un objeto JSON que lista tus runners auto-alojados, su estado y otra metadata, permitiéndote verificar su salud de forma programática.

---

## Desafío 2: Diagnosticar un Runner Desactualizado
Un workflow comienza a fallar con errores inesperados en un runner auto-alojado, aunque no ha habido cambios en el código. Sospechas que el software del runner puede estar desactualizado.

**Instrucciones:**
1.  Accede a la máquina donde se está ejecutando tu runner auto-alojado.
2.  Detén el servicio del runner si se está ejecutando.
3.  Dentro del directorio del runner, busca un archivo que pueda indicar la versión (pista: busca archivos como `run.sh` o en los logs).
4.  Compara la versión que encuentres con la última versión disponible en la página de [lanzamientos del runner de GitHub](https://github.com/actions/runner/releases).
5.  Si está desactualizado, sigue las instrucciones de GitHub para descargar la última versión y reemplazar los archivos existentes.
6.  Reinicia el runner.

**Archivos a crear por el estudiante:**
-   Ninguno. Este es un desafío de diagnóstico y mantenimiento manual en la máquina del runner.

### Resultado Esperado:
-   Identificas la versión actual del software de tu runner.
-   Confirmas que hay una versión más nueva disponible.
-   Actualizas con éxito el software del runner a la última versión.
-   El workflow que antes fallaba ahora se ejecuta correctamente.

---

## Desafío 3: Resolución de Problemas - Software Faltante en el Runner
Un workflow que utiliza una herramienta de línea de comandos específica (`jq`) funciona perfectamente en los runners de GitHub, pero falla en tu runner auto-alojado con un error de "comando no encontrado".

**Archivos de apoyo (proporcionados por ti):**
-   `.github/workflows/missing-software-workflow.yml`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/missing-software-workflow.yml
name: Debugging Missing Software
on: workflow_dispatch
jobs:
  parse-json:
    runs-on: self-hosted
    steps:
      - name: Create JSON file
        run: echo '{"name":"Mona","job":"Octocat"}' > data.json

      - name: Parse JSON with jq
        # Este paso falla si jq no está instalado en el runner
        run: |
          JOB_TITLE=$(jq -r .job data.json)
          echo "El puesto es $JOB_TITLE"
```

**Contexto del Problema:**
El job `parse-json` falla en el segundo paso. El log de error muestra `/bin/bash: line 1: jq: command not found`.

**Instrucciones:**
1.  Ejecuta el workflow y confirma el error en los logs.
2.  Analiza el mensaje de error para entender qué comando específico está faltando.
3.  Conéctate a la máquina de tu runner auto-alojado.
4.  Instala el software faltante. Para `jq` en un sistema basado en Debian/Ubuntu, el comando sería `sudo apt-get update && sudo apt-get install -y jq`.
5.  Vuelve a ejecutar el workflow.

**Pistas:**
-   Los runners alojados por GitHub vienen con una gran cantidad de software preinstalado. Los runners auto-alojados, por defecto, solo tienen el software del sistema operativo base.
-   Tú eres responsable de instalar y mantener cualquier dependencia de software que tus jobs necesiten en tus runners auto-alojados.

### Resultado Esperado:
-   Identificas que el error es causado por la ausencia de la herramienta `jq` en el runner.
-   Instalas `jq` en la máquina del runner.
-   El workflow se vuelve a ejecutar y esta vez se completa con éxito, imprimiendo "El puesto es Octocat".
