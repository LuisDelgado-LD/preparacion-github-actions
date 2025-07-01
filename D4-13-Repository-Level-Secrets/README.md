# Concepto a Resolver: Gestión de Secretos a Nivel de Repositorio
Este módulo aborda la creación, gestión y uso de secretos a nivel de repositorio, que son la forma más común de manejar datos sensibles como tokens, claves de API y credenciales dentro de un único repositorio de GitHub.

---

## Desafío 1: Crear y Usar un Secreto de Repositorio
El objetivo es simple: crear un secreto en tu repositorio y usarlo en un workflow para imprimir un mensaje.

**Archivos a crear por el estudiante:**
- `.github/workflows/simple-secret.yml`

**Archivos de apoyo (proporcionados por ti):**
- `scripts/greet.sh`

**Contenido de los archivos de apoyo:**
```bash
#!/bin/bash
# scripts/greet.sh

SECRET_MESSAGE="$1"

if [ -z "$SECRET_MESSAGE" ]; then
  echo "Error: No se ha proporcionado un mensaje secreto."
  exit 1
fi

echo "El mensaje secreto es: $SECRET_MESSAGE"
```

**Instrucciones del workflow:**
1.  **Prerrequisito:** Ve a la configuración de tu repositorio (`Settings > Secrets and variables > Actions`) y crea un nuevo secreto llamado `MY_FIRST_SECRET` con el valor `¡Hola, GitHub Actions!`.
2.  Crea un workflow que se active con `workflow_dispatch`.
3.  El workflow debe tener un job llamado `read-secret`.
4.  El job debe hacer checkout del código, dar permisos de ejecución al script `greet.sh` y luego ejecutarlo, pasándole el secreto `MY_FIRST_SECRET`.

### Resultado Esperado:
- El workflow se ejecuta correctamente.
- El log del workflow muestra "El mensaje secreto es: ¡Hola, GitHub Actions!".
- El valor del secreto no debe ser visible directamente en la definición del workflow ni en los logs de configuración.

---

## Desafío 2: Usar Secretos en un Entorno (Environment)
Este desafío introduce el concepto de entornos para proteger secretos. Crearás un entorno, le asignarás un secreto y luego lo usarás en un job.

**Archivos a crear por el estudiante:**
- `.github/workflows/environment-secret.yml`

**Archivos de apoyo (proporcionados por ti):**
- `scripts/deploy.sh`

**Contenido de los archivos de apoyo:**
```bash
#!/bin/bash
# scripts/deploy.sh

API_TOKEN="$1"

if [[ "$API_TOKEN" == "prod-token-secure-value" ]]; then
  echo "Despliegue en producción autorizado."
else
  echo "Error: Token de despliegue no válido."
  exit 1
fi
```

**Instrucciones del workflow:**
1.  **Prerrequisito:**
    - En la configuración de tu repositorio, ve a `Settings > Environments` y crea un nuevo entorno llamado `production`.
    - Dentro del entorno `production`, crea un secreto llamado `PROD_API_TOKEN` con el valor `prod-token-secure-value`.
2.  Crea un workflow que se active con un `push` a la rama `main`.
3.  El workflow debe tener un job llamado `deploy-to-prod`.
4.  Asigna este job para que se ejecute en el entorno `production`.
5.  El job debe hacer checkout, dar permisos de ejecución a `deploy.sh` y ejecutarlo con el secreto `PROD_API_TOKEN`.

### Resultado Esperado:
- El workflow se ejecuta tras un push a `main`.
- El log del job muestra "Despliegue en producción autorizado.".
- El workflow tiene una referencia clara al entorno `production`, demostrando una capa adicional de seguridad.

---

## Desafío 3: Resolución de Problemas - Sintaxis Incorrecta de Secretos
En este desafío, se te proporciona un workflow con un error común de sintaxis al intentar acceder a un secreto. Tu tarea es encontrar y corregir el error.

**Archivos a crear por el estudiante:**
- Ninguno. El workflow con errores se proporciona a continuación.

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/debug-secret-syntax.yml`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/debug-secret-syntax.yml
name: Debug Secret Syntax
on: workflow_dispatch

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Attempt to use secret
        # Prerrequisito: Un secreto llamado `API_KEY` debe existir en el repo.
        run: echo "La clave de API es $API_KEY"
        env:
          API_KEY: ${{ secret.API_KEY }}
```

**Instrucciones del desafío:**
1.  **Prerrequisito:** Asegúrate de que exista un secreto de repositorio llamado `API_KEY` con cualquier valor (por ejemplo, `12345`).
2.  Ejecuta el workflow y observa que falla o no se comporta como se espera. El log probablemente mostrará "La clave de API es" seguido de nada.
3.  Analiza el archivo `.github/workflows/debug-secret-syntax.yml` y encuentra el error.

**Pistas:**
- Presta mucha atención a la sintaxis para acceder a los contextos en GitHub Actions.
- ¿El contexto `secret` es correcto o debería ser `secrets` (plural)?
- Compara la sintaxis con la documentación oficial o con los desafíos anteriores.

### Resultado Esperado:
- Corriges el error de sintaxis en el workflow (de `secret.API_KEY` a `secrets.API_KEY`).
- Al volver a ejecutar el workflow, el log muestra "La clave de API es ***", ocultando automáticamente el valor del secreto.
- Comprendes la importancia de la sintaxis `contexto.propiedad` en los workflows.
