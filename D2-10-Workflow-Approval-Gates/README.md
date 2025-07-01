# Concepto a Resolver: Puertas de Aprobación y Despliegues Manuales
Las puertas de aprobación son mecanismos de control en los workflows que pausan la ejecución hasta que se cumple una condición, como una revisión manual. Esto es crucial para los despliegues en entornos sensibles, asegurando que solo el código verificado y aprobado llegue a producción.

---

## Desafío 1: Despliegue con Aprobación Manual usando `workflow_dispatch`
Tu primer desafío es crear un workflow que solo se pueda ejecutar manualmente y que requiera la selección de un entorno de despliegue.

**Archivos a crear por el estudiante:**
- `.github/workflows/manual-deployment.yml`
- `scripts/notify.sh`

**Contenido de los archivos de apoyo (proporcionados por ti):**
```bash
# scripts/notify.sh
#!/bin/bash
TARGET_ENV=$1
echo "🔔 Notificación: Preparando despliegue manual al entorno '${TARGET_ENV}'."
sleep 3
echo "✅ Simulación de despliegue en '${TARGET_ENV}' completada."
```

**Instrucciones del workflow:**
Tu workflow `.github/workflows/manual-deployment.yml` debe:
- Activarse únicamente a través de `workflow_dispatch`.
- Definir una entrada (`input`) llamada `environment` que permita al usuario elegir entre `staging` y `production`. La opción por defecto debe ser `staging`.
- Contener un único job llamado `deploy`.
- El job debe ejecutarse en `ubuntu-latest`.
- Incluir un paso de checkout.
- Incluir un paso que dé permisos de ejecución al script `notify.sh`.
- Ejecutar el script `notify.sh`, pasándole el valor de la entrada `environment` como argumento.

### Resultado Esperado:
- El workflow no se ejecuta automáticamente con un `push`.
- En la pestaña "Actions", puedes ver un botón "Run workflow".
- Al hacer clic, se muestra un menú desplegable para seleccionar el entorno (`staging` o `production`).
- Al ejecutarlo, el log del workflow muestra el mensaje de notificación con el nombre del entorno que seleccionaste.

---

## Desafío 2: Job de Aprobación con `environment`
Ahora, implementarás una puerta de aprobación real. El workflow se detendrá y esperará una aprobación manual antes de ejecutar un job de despliegue crítico.

**Instrucciones:**
1.  En la configuración de tu repositorio (`Settings > Environments`), crea un nuevo entorno llamado `production`.
2.  Añade una regla de protección (`protection rule`) a este entorno: "Required reviewers" y asígnate a ti mismo como revisor.
3.  Crea un workflow que utilice este entorno protegido.

**Archivos a crear por el estudiante:**
- `.github/workflows/gated-deployment.yml`

**Archivos de apoyo (proporcionados por ti):**
- (Puedes reutilizar `scripts/notify.sh` del desafío anterior)

**Instrucciones del workflow:**
Tu workflow `.github/workflows/gated-deployment.yml` debe:
- Activarse en un `push` a la rama `main`.
- Contener dos jobs: `build` y `deploy-to-production`.
- El job `build` simplemente simula una compilación con un comando `echo`.
- El job `deploy-to-production` debe depender (`needs`) del job `build`.
- El job `deploy-to-production` debe estar asociado al entorno `production`.
- El job `deploy-to-production` debe ejecutar el script `notify.sh` para simular el despliegue en `production`.

### Resultado Esperado:
- Al hacer `push` a `main`, el workflow se inicia.
- El job `build` se completa con éxito.
- El job `deploy-to-production` se pone en estado de "Waiting" (Esperando).
- Recibes una notificación de GitHub para que revises y apruebes el despliegue.
- El job `deploy-to-production` solo se ejecuta y completa después de que apruebes la ejecución.

---

## Desafío 3: Puerta de Enlace con `workflow_run`
Un patrón común es tener un workflow de despliegue que solo se ejecuta si otro workflow (por ejemplo, el de CI) ha finalizado con éxito. Tu desafío es implementar esto usando el trigger `workflow_run`.

**Archivos a crear por el estudiante:**
- `.github/workflows/ci-workflow.yml`
- `.github/workflows/deployment-trigger.yml`

**Archivos de apoyo (proporcionados por ti):**
- (Ninguno)

**Instrucciones de los workflows:**
1.  **`ci-workflow.yml`:**
    -   Debe llamarse `CI Checks`.
    -   Debe activarse en `push` a cualquier rama que no sea `main`.
    -   Debe contener un job `test` que simule pruebas (por ejemplo, con `echo "Running tests..."`).

2.  **`deployment-trigger.yml`:**
    -   Debe activarse cuando el workflow `CI Checks` se complete con éxito (`completed` y `success`).
    -   Debe ejecutarse solo en la rama `main`.
    -   Debe contener un job `deploy` que imprima un mensaje como "CI finalizado, iniciando despliegue.".

### Resultado Esperado:
- Un `push` a una rama de feature (ej: `feature/test`) solo activa el workflow `CI Checks`.
- Un `push` a `main` activa el workflow `CI Checks`.
- Solo después de que `CI Checks` se complete con éxito en la rama `main`, el workflow `deployment-trigger.yml` se inicia automáticamente.

---

## Desafío 4: Debugging de una Puerta de Aprobación Rota
Se te proporciona un workflow diseñado para tener una puerta de aprobación, pero el job de despliegue se ejecuta sin esperar la aprobación. Debes encontrar el error.

**Archivos a crear por el estudiante:**
- (Ninguno, debes corregir el workflow proporcionado)

**Archivos de apoyo (proporcionados por ti):**
```yaml
# .github/workflows/debug-gate.yml
name: Debug Approval Gate
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building the project..."

  approve-deployment:
    runs-on: ubuntu-latest
    environment: production # El entorno 'production' requiere un revisor
    steps:
      - run: echo "Aprobación requerida para este paso."

  deploy:
    runs-on: ubuntu-latest
    needs: [build]
    steps:
      - run: echo "Desplegando sin piedad..."
```

**Instrucciones:**
1.  Asegúrate de que tu entorno `production` todavía requiere un revisor.
2.  Crea el archivo `.github/workflows/debug-gate.yml` con el contenido anterior y súbelo a tu repositorio.
3.  Observa el comportamiento en la pestaña "Actions". Verás que el job `deploy` se ejecuta inmediatamente después de `build`.

**Pistas:**
- La dependencia (`needs`) del job `deploy` es correcta, pero ¿es suficiente?
- ¿Dónde está definida la puerta de aprobación (el `environment`)? ¿En qué job?
- ¿Cómo fluye la ejecución entre los jobs? ¿El job `deploy` tiene alguna relación con el job `approve-deployment`?
- Para que una puerta de aprobación proteja un despliegue, el job que realiza el despliegue debe ser el que está asociado al entorno protegido.

### Resultado Esperado:
- Identificas que el job `deploy` no tiene ninguna dependencia del job `approve-deployment` y por eso se ejecuta en paralelo (o solo después de `build`).
- Te das cuenta de que la protección del entorno solo afecta al job donde se declara (`approve-deployment`), que no tiene ningún efecto sobre el job `deploy`.
- Corriges el workflow moviendo la clave `environment: production` al job `deploy` y ajustando la dependencia `needs` para que `deploy` dependa de `approve-deployment` (o simplemente de `build`, ya que la protección está ahora en el lugar correcto).
- Después de la corrección, el job `deploy` espera la aprobación manual antes de ejecutarse.
