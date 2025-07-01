# Concepto a Resolver: Alcance y Gestión de Secretos a Nivel de Empresa y Organización
Este módulo se enfoca en cómo GitHub Enterprise y las organizaciones gestionan los secretos de forma centralizada, permitiendo un acceso controlado a los repositorios y definiendo políticas de acceso para mejorar la seguridad y la eficiencia.

---

## Desafío 1: Acceso a Secretos de Organización en un Workflow
Este desafío consiste en crear un workflow que acceda a un secreto definido a nivel de organización para autenticarse en un servicio simulado.

**Archivos a crear por el estudiante:**
- `.github/workflows/org-secrets-access.yml`

**Archivos de apoyo (proporcionados por ti):**
- `scripts/verify_api_key.sh`

**Contenido de los archivos de apoyo:**
```bash
#!/bin/bash
# scripts/verify_api_key.sh

API_KEY="$1"

if [ -z "$API_KEY" ]; then
  echo "Error: No se proporcionó API_KEY."
  exit 1
fi

# Simula la verificación de la clave
if [[ "$API_KEY" == "super-secret-org-key" ]]; then
  echo "Autenticación exitosa con la clave de organización."
else
  echo "Error: Clave de API no válida."
  exit 1
fi
```

**Instrucciones del workflow:**
1.  **Prerrequisito:** Asegúrate de que un administrador de la organización haya creado un secreto llamado `ORG_API_KEY` con el valor `super-secret-org-key` y haya concedido acceso a este repositorio.
2.  Tu workflow debe activarse con un `workflow_dispatch`.
3.  Debe contener un job llamado `authenticate`.
4.  El job debe hacer checkout del código.
5.  Añade un paso para dar permisos de ejecución al script `verify_api_key.sh`.
6.  El paso final debe ejecutar el script `verify_api_key.sh`, pasándole el secreto de la organización como un argumento.

### Resultado Esperado:
- El workflow se ejecuta correctamente.
- El script `verify_api_key.sh` se ejecuta y muestra el mensaje "Autenticación exitosa con la clave de organización.".
- El secreto nunca se expone en los logs del workflow.

---

## Desafío 2: Anulación de Secretos de Organización con Secretos de Repositorio
Este desafío demuestra cómo un secreto a nivel de repositorio puede anular a uno definido a nivel de organización, permitiendo configuraciones específicas por proyecto.

**Archivos a crear por el estudiante:**
- `.github/workflows/override-secret.yml`

**Archivos de apoyo (proporcionados por ti):**
- `scripts/check_deployment_env.sh`

**Contenido de los archivos de apoyo:**
```bash
#!/bin/bash
# scripts/check_deployment_env.sh

DEPLOY_ENV="$1"

echo "El entorno de despliegue es: $DEPLOY_ENV"

if [[ "$DEPLOY_ENV" == "staging" ]]; then
  echo "Desplegando a STAGING."
elif [[ "$DEPLOY_ENV" == "production" ]]; then
  echo "Desplegando a PRODUCTION."
else
  echo "Entorno no reconocido."
fi
```

**Instrucciones del workflow:**
1.  **Prerrequisito:**
    - Un administrador de la organización ha creado un secreto `DEPLOYMENT_TARGET` con el valor `production` y ha concedido acceso a este repositorio.
    - Crea un secreto a nivel de repositorio llamado `DEPLOYMENT_TARGET` con el valor `staging`.
2.  El workflow debe activarse con un `push` a la rama `main`.
3.  Debe tener un job `deploy` que se ejecute en `ubuntu-latest`.
4.  El job debe hacer checkout del código.
5.  Añade un paso para dar permisos de ejecución al script `check_deployment_env.sh`.
6.  El workflow debe ejecutar el script `check_deployment_env.sh`, pasándole el valor del secreto `DEPLOYMENT_TARGET`.

### Resultado Esperado:
- El workflow se ejecuta tras un push a `main`.
- El log del workflow muestra "El entorno de despliegue es: staging" y "Desplegando a STAGING.".
- Esto confirma que el secreto del repositorio (`staging`) tuvo prioridad sobre el de la organización (`production`).

---

## Desafío 3: Resolución de Problemas - Acceso Denegado a Secretos
En este desafío, te enfrentarás a un workflow que falla porque no puede acceder a un secreto de organización. Tu tarea es diagnosticar y corregir el problema.

**Archivos a crear por el estudiante:**
- Ninguno. El workflow ya está creado.

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/debug-org-secrets.yml`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/debug-org-secrets.yml
name: Debug Organization Secrets
on: workflow_dispatch

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Use Organization Secret
        run: |
          if [ -z "${{ secrets.NON_EXISTENT_SECRET }}" ]; then
            echo "El secreto no está disponible."
            exit 1
          else
            echo "Secreto encontrado."
          fi
```

**Instrucciones del desafío:**
1.  **Contexto:** Un administrador de la organización ha creado un secreto llamado `CRITICAL_API_TOKEN` y lo ha asignado a un conjunto de repositorios, pero el workflow sigue fallando.
2.  Analiza el archivo `.github/workflows/debug-org-secrets.yml`.
3.  Identifica las posibles causas del fallo.
4.  Corrige el workflow para que acceda al secreto correcto y se ejecute exitosamente.

**Pistas:**
- ¿El nombre del secreto en el workflow coincide exactamente con el nombre del secreto en la configuración de la organización?
- ¿Se ha concedido acceso a este repositorio específico o a un grupo que lo incluya? Revisa la política de acceso del secreto.
- La lógica del script dentro del workflow es simple, pero ¿qué pasa si el secreto está vacío o no se encuentra?

### Resultado Esperado:
- El workflow, una vez corregido, se ejecuta sin errores.
- El log del workflow muestra "Secreto encontrado.".
- Comprendes la importancia de la coincidencia de nombres y las políticas de acceso para los secretos de organización.
