# Concepto a Resolver: Distribución de Actions en GitHub Enterprise
Este módulo aborda las estrategias para gestionar y distribuir actions en un entorno de GitHub Enterprise Server o Cloud. Se enfoca en cómo las organizaciones pueden controlar qué actions se utilizan y cómo promover la reutilización de código interno de forma segura.

---

## Desafío 1: Habilitar Actions de un Repositorio Interno en la Organización
En un entorno Enterprise, es común restringir el uso de actions públicas y permitir únicamente las verificadas o las creadas internamente. Este desafío simula la configuración de una política a nivel de organización para permitir una action de un repositorio interno.

**Archivos a crear por el estudiante:**
- `.github/workflows/internal-action-policy.yml`
- `actions/internal-tool/action.yml`
- `actions/internal-tool/entrypoint.sh`

**Archivos de apoyo (proporcionados por ti):**
- Ninguno. Debes crear la estructura tú mismo.

**Contenido de los archivos a crear:**
```yaml
# actions/internal-tool/action.yml
name: 'Internal Enterprise Tool'
description: 'Una action interna aprobada para uso en la organización.'
runs:
  using: 'composite'
  steps:
    - run: echo "Ejecutando la herramienta interna de la empresa..."
      shell: bash
```

**Instrucciones del desafío:**
1.  **Simulación de la configuración de la organización:** Ve a la configuración de tu repositorio (`Settings` > `Actions` > `General`). En la sección `Actions permissions`, selecciona la opción "Allow select actions".
2.  En el cuadro de texto que aparece, añade la ruta a tu action interna: `TU_USUARIO/TU_REPOSITORIO/actions/internal-tool@main` (reemplaza con tu usuario y nombre de repo).
3.  Crea el workflow `internal-action-policy.yml` que intente usar dos actions:
    -   La action interna que acabas de permitir (`./actions/internal-tool`).
    -   Una action pública popular como `actions/setup-node@v3`.

### Resultado Esperado:
- Al ejecutar el workflow, el paso que usa la action interna (`./actions/internal-tool`) debería funcionar.
- El paso que intenta usar `actions/setup-node@v3` debería fallar con un error indicando que la action no está permitida por la política de la organización.
- El estudiante comprende cómo las políticas de la organización restringen el uso de actions.

---

## Desafío 2: Sincronizar una Action Pública para Uso Offline en Enterprise Server
Este desafío simula un escenario común en GitHub Enterprise Server (GHES), donde la instancia no tiene acceso a Internet. Para usar una action del Marketplace, primero debe ser "sincronizada" o clonada en un repositorio interno.

**Archivos a crear por el estudiante:**
- `.github/workflows/offline-action-usage.yml`

**Archivos de apoyo (proporcionados por ti):**
- Debes simular la sincronización clonando una action pública en un subdirectorio.

**Instrucciones del desafío:**
1.  Simula la sincronización: Clona el repositorio de una action simple, como `actions/checkout`, en un directorio dentro de tu repositorio. Por ejemplo, en `internal-actions/checkout`.
    ```bash
    git clone https://github.com/actions/checkout.git internal-actions/checkout
    ```
2.  Crea el workflow `offline-action-usage.yml`.
3.  En el workflow, en lugar de usar `actions/checkout@v3`, referencia la copia local que "sincronizaste": `uses: ./internal-actions/checkout`.

### Resultado Esperado:
- El workflow se ejecuta correctamente utilizando la copia local de la action `checkout`.
- El estudiante entiende el concepto de hacer que las actions públicas estén disponibles en un entorno Enterprise sin conexión a Internet.

---

## Desafío 3: Debugging - La Action Interna no está Sincronizada Correctamente
Se te proporciona un workflow que falla porque intenta usar una action interna que supuestamente fue sincronizada desde el Marketplace, pero el proceso de sincronización fue incompleto.

**Archivos a crear por el estudiante:**
- Ninguno. Debes corregir la "action sincronizada".

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/broken-sync.yml`
- `synced-actions/setup-python/action.yml` (con contenido faltante)

**Contenido del workflow:**
```yaml
# .github/workflows/broken-sync.yml
name: Broken Synced Action
on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Use incomplete synced action
        # Pista: El workflow falla aquí. Revisa la action en el directorio synced-actions/setup-python.
        # ¿Está completo el archivo action.yml? ¿Faltan los archivos que ejecuta?
        uses: ./synced-actions/setup-python
        with:
          python-version: '3.9'
```

**Contenido de la action incompleta:**
```yaml
# synced-actions/setup-python/action.yml
# Este archivo fue copiado, pero no los scripts que ejecuta.
name: 'Setup Python'
description: 'Instala una versión de Python y la añade al PATH.'
runs:
  using: 'node16'
  main: 'dist/index.js' # Pista: ¿Existe este archivo en el directorio?
```

**Instrucciones del desafío:**
1.  Observa que el workflow falla porque no puede encontrar el punto de entrada de la action (`dist/index.js`).
2.  El problema es que solo se copió el archivo `action.yml`, pero no el resto del repositorio de la action (incluido el directorio `dist`).
3.  Para solucionarlo, simula una sincronización completa: elimina el directorio `synced-actions/setup-python` y clona el repositorio `actions/setup-python` en esa ubicación.
    ```bash
    rm -rf synced-actions/setup-python
    git clone https://github.com/actions/setup-python.git synced-actions/setup-python
    ```
4.  Vuelve a ejecutar el workflow.

### Resultado Esperado:
- Después de clonar correctamente todo el repositorio de la action `setup-python` en el directorio local, el workflow se ejecuta exitosamente.
- El estudiante aprende que para sincronizar una action, se necesita el repositorio completo, no solo el archivo `action.yml`.
