# Concepto a Resolver: Políticas de Uso de Acciones en la Organización
La capacidad de una organización para controlar qué Actions se pueden utilizar en sus repositorios es una característica de seguridad y gobernanza fundamental. Esto asegura que solo se ejecuten acciones de confianza, ya sean creadas por GitHub, por publicadores verificados, dentro de la propia organización o de una lista específica de acciones permitidas.

---

## Desafío 1: Restringir Acciones a las Creadas por GitHub
Configurarás una política a nivel de repositorio para permitir únicamente la ejecución de acciones creadas por GitHub y verificarás que cualquier otra acción pública sea bloqueada.

**Instrucciones:**
1.  Ve a la configuración de tu repositorio (`Settings` > `Actions` > `General`).
2.  En la sección "Actions permissions", selecciona "Allow select actions".
3.  Marca la casilla "Allow actions created by GitHub".
4.  Guarda los cambios.

**Archivos a crear por el estudiante:**
-   `.github/workflows/policy-check-workflow.yml`

**Instrucciones del workflow:**
Tu workflow debe:
-   Activarse con un `workflow_dispatch`.
-   Contener dos jobs:
    1.  `successful_job`: Debe usar una acción creada por GitHub (ej. `actions/checkout@v4`).
    2.  `failing_job`: Debe intentar usar una acción pública popular no creada por GitHub (ej. `peter-evans/is-core-changed@v4`).

### Resultado Esperado:
-   El workflow se activa correctamente.
-   El job `successful_job` se completa con éxito.
-   El job `failing_job` falla con un error indicando que la acción no está permitida por la política del repositorio.

---

## Desafío 2: Permitir una Lista Específica de Acciones
Ampliarás la política anterior para permitir, además de las acciones de GitHub, una acción específica de un tercero.

**Instrucciones:**
1.  Manteniendo la configuración del desafío anterior, vuelve a la sección "Actions permissions".
2.  En el campo "Allow specified actions", añade la acción `peter-evans/is-core-changed@v4` a la lista de acciones permitidas.
3.  Guarda los cambios.

**Archivos a crear por el estudiante:**
-   `.github/workflows/specific-action-allowed.yml` (puedes modificar el del desafío anterior).

**Instrucciones del workflow:**
Tu workflow debe:
-   Activarse con un `workflow_dispatch`.
-   Intentar usar las mismas dos acciones del desafío anterior: `actions/checkout@v4` y `peter-evans/is-core-changed@v4`.

### Resultado Esperado:
-   El workflow se ejecuta y ambos jobs (`successful_job` y `failing_job` del ejemplo anterior, o un único job con ambos pasos) se completan con éxito, demostrando que la acción específica ahora está permitida.

---

## Desafío 3: Resolución de Problemas - Workflow Bloqueado por Política
Te encuentras con un workflow que no se ejecuta como se espera. Tu tarea es diagnosticar y solucionar el problema, que está relacionado con las políticas de acciones de la organización.

**Archivos de apoyo (proporcionados por ti):**
-   `.github/workflows/debugging-policy-workflow.yml`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/debugging-policy-workflow.yml
name: Debugging Policy Workflow
on: push

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run security linter
        uses: some-random-community/super-linter@v5
        env:
          DEFAULT_BRANCH: main
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Contexto del Problema:**
La política de la organización está configurada para permitir únicamente acciones creadas por GitHub y acciones locales (dentro del repositorio). El workflow anterior está fallando.

**Instrucciones:**
1.  Analiza el archivo `debugging-policy-workflow.yml` y la política de la organización descrita.
2.  Identifica la causa raíz del fallo del workflow.
3.  Modifica el workflow para que cumpla con la política de la organización. Asume que no puedes cambiar la política, solo el workflow.

**Pistas:**
-   Revisa cuidadosamente los logs de ejecución del workflow. ¿Qué dice el error?
-   ¿De dónde viene la acción `some-random-community/super-linter@v5`? ¿Coincide con los creadores permitidos?
-   GitHub ofrece una acción oficial para Super Linter.

### Resultado Esperado:
-   Identificas que la acción `some-random-community/super-linter@v5` no está permitida.
-   Reemplazas la acción no permitida por la acción oficial de GitHub para la misma funcionalidad (`github/super-linter@v5`).
-   El workflow se ejecuta y se completa con éxito.
