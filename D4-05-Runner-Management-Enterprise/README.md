# Concepto a Resolver: Gestión de Runners en GitHub Enterprise
La gestión de runners es crucial para controlar el entorno de ejecución de los workflows en una empresa. Esto incluye la configuración de runners auto-alojados (self-hosted) a nivel de organización o repositorio, asignando etiquetas para dirigir trabajos específicos y asegurando que los workflows se ejecuten en el hardware adecuado con el software necesario.

---

## Desafío 1: Registrar un Runner Auto-Alojado a Nivel de Organización
Configurarás un nuevo runner auto-alojado para tu organización y lo utilizarás para ejecutar un workflow, demostrando que los repositorios de la organización pueden acceder a él.

**Instrucciones:**
1.  Navega a la configuración de tu organización (`Settings`).
2.  En la barra lateral, ve a `Actions` y luego a `Runners`.
3.  Haz clic en `New self-hosted runner`.
4.  Elige el sistema operativo de tu máquina (ej. Linux, Windows).
5.  Sigue las instrucciones proporcionadas en la UI de GitHub para descargar el software del runner, configurarlo con la URL de tu organización y el token de registro, y finalmente iniciarlo.
6.  Verifica que el runner aparezca en la lista con un estado "Idle".

**Archivos a crear por el estudiante:**
-   `.github/workflows/org-runner-test.yml`

**Instrucciones del workflow:**
Tu workflow debe:
-   Activarse con `workflow_dispatch`.
-   Contener un único job que se ejecute en un runner auto-alojado.
-   El job debe imprimir el nombre del host de la máquina para verificar que se está ejecutando en tu runner.



**Instrucciones del workflow:**
Tu workflow debe:
- Activarse con `workflow_dispatch`.
- Especificar que el job debe correr en `self-hosted`.
- Ejecutar un comando simple como `hostname` o `echo "Hola desde mi runner!"`.

### Resultado Esperado:
-   El runner se registra correctamente y aparece como "online" en la configuración de la organización.
-   El workflow se ejecuta con éxito en tu runner auto-alojado, y el log del workflow muestra el resultado del comando ejecutado.

---

## Desafío 2: Uso de Etiquetas para Dirigir Jobs
Añadirás etiquetas personalizadas a tu runner auto-alojado para dirigir jobs específicos a él, permitiendo una gestión más granular de los recursos.

**Instrucciones:**
1.  En la configuración de tu runner (en la UI de GitHub o durante la configuración inicial con `./config.sh`), añade una etiqueta personalizada, por ejemplo, `gpu-enabled`.
2.  Si el runner ya está en funcionamiento, puedes detenerlo, reconfigurarlo con `config.sh --labels gpu-enabled` y volver a iniciarlo.

**Archivos a crear por el estudiante:**
-   `.github/workflows/runner-labels-test.yml`

**Instrucciones del workflow:**
Tu workflow debe:
-   Activarse con `workflow_dispatch`.
-   Tener dos jobs:
    1.  `standard_job`: Se ejecuta en un runner alojado por GitHub (`ubuntu-latest`).
    2.  `specialized_job`: Debe ejecutarse en un runner auto-alojado que tenga tanto la etiqueta `self-hosted` como la etiqueta `gpu-enabled`.

```yaml
# Ejemplo de cómo apuntar a un runner con múltiples etiquetas
runs-on: [self-hosted, gpu-enabled]
```

### Resultado Esperado:
-   El workflow se ejecuta correctamente.
-   El `standard_job` se completa en un runner de GitHub.
-   El `specialized_job` se completa en tu runner auto-alojado que tiene la etiqueta `gpu-enabled`.

---

## Desafío 3: Resolución de Problemas - Runner No Disponible
Te enfrentas a un workflow que permanece "en cola" (queued) indefinidamente y nunca se ejecuta. Tu tarea es diagnosticar por qué el job no es recogido por ningún runner.

**Archivos de apoyo (proporcionados por ti):**
-   `.github/workflows/debugging-runner-workflow.yml`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/debugging-runner-workflow.yml
name: Debugging Runner Issues
on: workflow_dispatch

jobs:
  build:
    # Este job requiere un runner con una combinación de etiquetas muy específica
    runs-on: [self-hosted, linux, docker, non-existent-label]
    steps:
      - name: Echo Message
        run: echo "Este job debería ejecutarse en un runner de producción con Docker."
```

**Contexto del Problema:**
Después de activar el workflow, el job `build` se queda en estado "Queued" y finalmente falla después de un tiempo de espera. Tienes un runner auto-alojado que está online y tiene las etiquetas `self-hosted`, `linux` y `docker`.

**Instrucciones:**
1.  Analiza la sección `runs-on` del workflow.
2.  Compara las etiquetas requeridas por el job con las etiquetas que tu runner realmente tiene.
3.  Identifica la discrepancia que impide que el job sea asignado.
4.  Corrige el archivo del workflow para que coincida con las etiquetas de un runner disponible.

**Pistas:**
-   Un job solo se ejecutará en un runner si **todas** las etiquetas especificadas en `runs-on` están presentes en el runner.
-   Revisa la configuración de tus runners en la UI de GitHub para ver sus etiquetas exactas. ¿Hay alguna etiqueta en el workflow que no exista en el runner?
-   ¿Hay algún error tipográfico en las etiquetas del workflow?

### Resultado Esperado:
-   Identificas que la etiqueta `non-existent-label` es la causa del problema, ya que ningún runner online tiene esa etiqueta.
-   Eliminas la etiqueta problemática del array `runs-on` en el archivo del workflow.
-   Tras la corrección, el workflow se activa y se ejecuta con éxito en tu runner auto-alojado.
