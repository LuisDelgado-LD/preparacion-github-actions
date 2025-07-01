# Concepto a Resolver: Selección de Runners para Cargas de Trabajo
La selección eficiente de runners es clave para optimizar los workflows. Consiste en dirigir los jobs al tipo de runner (alojado por GitHub o auto-alojado) y con las características (sistema operativo, hardware, software, etiquetas) adecuadas para la tarea, asegurando rendimiento, seguridad y rentabilidad.

---

## Desafío 1: Ejecutar Jobs en Múltiples Sistemas Operativos
Crearás un workflow que ejecuta jobs en paralelo en diferentes sistemas operativos para simular una prueba de compatibilidad multiplataforma.

**Archivos a crear por el estudiante:**
- `.github/workflows/multi-os-test.yml`

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse en un `push` a la rama `main`.
- Contener dos jobs que se ejecuten en paralelo:
  1. `build-on-windows`: Debe ejecutarse en el último runner de Windows disponible.
  2. `build-on-ubuntu`: Debe ejecutarse en el último runner de Ubuntu disponible.
- Cada job debe ejecutar un paso que imprima el sistema operativo en el que se está ejecutando para confirmación.

**Ejemplo de paso de confirmación:**
```yaml
- name: Check OS
  run: echo "Este job se está ejecutando en ${{ runner.os }}"
```

### Resultado Esperado:
- El workflow se activa correctamente tras un push a `main`.
- Ambos jobs, `build-on-windows` y `build-on-ubuntu`, se ejecutan y completan con éxito.
- Los logs de cada job muestran el sistema operativo correcto (Windows para uno, Linux para el otro).

---

## Desafío 2: Dirigir un Job a un Runner Auto-Alojado con Etiquetas
Simularás un escenario donde una tarea de despliegue debe ejecutarse en un servidor específico dentro de tu infraestructura. Para ello, dirigirás un job a un runner auto-alojado usando una etiqueta personalizada.

**Requisitos previos:**
- Tener un runner auto-alojado configurado y en línea, con una etiqueta personalizada como `production-server`.

**Archivos a crear por el estudiante:**
- `.github/workflows/deploy-to-prod.yml`

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse manualmente con `workflow_dispatch`.
- Contener un job llamado `deploy`.
- El job `deploy` debe requerir un runner que sea `self-hosted` y que además tenga la etiqueta `production-server`.
- El job debe contener un paso que simule un despliegue, como `echo "Desplegando la aplicación en el servidor de producción..."`.

### Resultado Esperado:
- El workflow se activa manualmente.
- El job `deploy` espera hasta que el runner auto-alojado con la etiqueta `production-server` esté disponible.
- El job se ejecuta con éxito en el runner designado, y el log muestra el mensaje de despliegue.

---

## Desafío 3: Resolución de Problemas - Job Atascado por Combinación de Etiquetas Imposible
Un workflow ha sido configurado para ejecutarse, pero el job `test-and-deploy` nunca comienza. Está atascado en estado "Queued". Tu misión es encontrar y corregir el error de configuración en la selección del runner.

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/debugging-labels-workflow.yml`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/debugging-labels-workflow.yml
name: Debugging Runner Selection
on: workflow_dispatch

jobs:
  test-and-deploy:
    # Este job intenta encontrar un runner que sea alojado por GitHub y a la vez auto-alojado.
    runs-on: [ubuntu-latest, self-hosted]
    steps:
      - name: Run tests
        run: echo "Ejecutando pruebas..."
      - name: Deploy
        run: echo "Desplegando a producción..."
```

**Contexto del Problema:**
El job `test-and-deploy` no se ejecuta porque GitHub Actions no puede encontrar un runner que satisfaga **todas** las etiquetas especificadas. Un runner es o alojado por GitHub (como `ubuntu-latest`) o es auto-alojado (`self-hosted`), pero no puede ser ambos a la vez.

**Instrucciones:**
1. Analiza la línea `runs-on` del workflow.
2. Identifica la combinación de etiquetas lógicamente imposible.
3. Asume que la intención era separar las tareas: las pruebas en un runner de GitHub y el despliegue en uno auto-alojado.
4. Refactoriza el workflow para que utilice dos jobs separados, cada uno con la selección de runner correcta para su tarea.

**Pistas:**
- ¿Puede un solo runner tener la etiqueta `ubuntu-latest` (que es de GitHub) y `self-hosted` (que es tuya) al mismo tiempo?
- La solución a menudo implica dividir un job con responsabilidades mixtas en varios jobs que dependen uno del otro.

### Resultado Esperado:
- Identificas que la combinación `[ubuntu-latest, self-hosted]` es inválida.
- Modificas el workflow para tener dos jobs:
  - Un job `test` que se ejecuta en `ubuntu-latest`.
  - Un job `deploy` que `needs: test` y se ejecuta en `self-hosted`.
- El workflow corregido se ejecuta con éxito, con cada job utilizando el tipo de runner apropiado.
