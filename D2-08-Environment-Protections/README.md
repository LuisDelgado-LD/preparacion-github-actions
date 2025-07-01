# Concepto a Resolver: Protecciones de Entorno y Aprobaciones
Las protecciones de entorno en GitHub Actions permiten configurar reglas para controlar los despliegues. Se puede requerir la aprobación manual de revisores específicos, establecer temporizadores de espera o restringir las ramas que pueden desplegar en un entorno, añadiendo una capa crucial de seguridad y control al proceso de CI/CD.

---

## Desafío 1: Configuración de un Entorno de Despliegue
Tu objetivo es crear un workflow que despliegue una aplicación simulada a un entorno llamado `staging`. Esto te familiarizará con la sintaxis básica para definir entornos en los jobs.

**Archivos a crear por el estudiante:**
- `.github/workflows/deployment-staging.yml`
- `scripts/deploy.sh`

**Contenido de los archivos de apoyo (proporcionados por ti):**
```bash
# scripts/deploy.sh
#!/bin/bash
echo "🚀 Desplegando la aplicación al entorno..."
sleep 5
echo "✅ Despliegue completado."
```

**Instrucciones del workflow:**
Tu workflow `.github/workflows/deployment-staging.yml` debe:
- Activarse manually con `workflow_dispatch`.
- Contener un job llamado `deploy-staging`.
- El job `deploy-staging` debe ejecutarse en un `ubuntu-latest`.
- Especificar que el job se ejecuta en el entorno `staging`.
- Incluir un paso para hacer checkout del código.
- Incluir un paso para dar permisos de ejecución al script `deploy.sh`.
- Ejecutar el script `scripts/deploy.sh` para simular el despliegue.

### Resultado Esperado:
- El workflow se ejecuta sin errores al ser activado manualmente.
- En la página de la ejecución del workflow, se visualiza que el job `deploy-staging` se ha ejecutado correctamente dentro del entorno `staging`.
- El log del workflow muestra los mensajes "🚀 Desplegando la aplicación al entorno..." y "✅ Despliegue completado.".

---

## Desafío 2: Requerir Aprobación Manual
Ahora, asegurarás el entorno `staging` para que requiera la aprobación de un revisor antes de que el despliegue pueda continuar.

**Instrucciones:**
1.  Ve a la configuración de tu repositorio (`Settings > Environments`).
2.  Crea o edita el entorno `staging`.
3.  Activa la regla de protección "Required reviewers".
4.  Añádete a ti mismo como revisor.
5.  Activa de nuevo el workflow del desafío anterior.

**Archivos a crear por el estudiante:**
- (Ninguno, se modifica la configuración del repositorio)

**Archivos de apoyo (proporcionados por ti):**
- (Ninguno)

### Resultado Esperado:
- Al ejecutar el workflow, la ejecución se pausa en el job `deploy-staging`.
- GitHub te muestra una notificación o un banner pidiendo tu aprobación para continuar.
- El job solo se ejecuta y completa después de que hayas aprobado el despliegue.

---

## Desafío 3: Añadir un Temporizador de Espera (Wait Timer)
Para evitar despliegues accidentales o demasiado rápidos, añadirás un retraso programado al entorno `production`.

**Instrucciones:**
1.  Crea un nuevo entorno en tu repositorio llamado `production`.
2.  Configura una regla de protección de "Wait timer" y establece un tiempo de espera de 1 minuto.
3.  Crea un nuevo workflow que despliegue en este entorno.

**Archivos a crear por el estudiante:**
- `.github/workflows/deployment-production.yml`

**Archivos de apoyo (proporcionados por ti):**
- (Puedes reutilizar el script `scripts/deploy.sh` del primer desafío)

**Instrucciones del workflow:**
Tu workflow `.github/workflows/deployment-production.yml` debe:
- Activarse en `workflow_dispatch`.
- Contener un job `deploy-production` que se ejecute en el entorno `production`.
- Utilizar el mismo script `deploy.sh` para simular el despliegue.

### Resultado Esperado:
- Al ejecutar el workflow, la ejecución se pausa.
- La interfaz de GitHub muestra un contador que indica el tiempo de espera restante.
- Una vez transcurrido el minuto, el job de despliegue se ejecuta automáticamente.

---

## Desafío 4: Debugging de un Workflow de Despliegue Protegido
Se te proporciona un workflow que intenta desplegar en un entorno protegido, pero falla. Tu misión es encontrar y corregir los errores.

**Archivos a crear por el estudiante:**
- (Ninguno, debes corregir el workflow proporcionado)

**Archivos de apoyo (proporcionados por ti):**
```yaml
# .github/workflows/debug-deployment.yml
name: Debug Protected Deployment
on:
  push:
    branches:
      - 'feature/*'

jobs:
  deploy:
    runs-on: ubuntu-latest
    enviroment: name: production # El entorno 'production' requiere aprobación
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Simulate Deployment
        run: echo "Deploying to production..."
```

**Instrucciones:**
1.  Crea el archivo `.github/workflows/debug-deployment.yml` con el contenido anterior.
2.  Asegúrate de que tu entorno `production` (del desafío anterior) sigue teniendo al menos una regla de protección (revisores o temporizador).
3.  Crea una rama llamada `feature/new-deploy-logic` y sube el workflow.
4.  Observa el fallo en la pestaña "Actions".
5.  Identifica y corrige los errores en el archivo.

**Pistas:**
- Revisa cuidadosamente la sintaxis de la clave que define el entorno en el job. ¿Es `enviroment` la palabra correcta?
- ¿La forma en que se define el nombre del entorno (`name: production`) es la adecuada para un job?
- ¿El workflow se está activando en la rama correcta para desplegar a producción según las buenas prácticas? El entorno `production` está configurado para permitir despliegues desde cualquier rama, pero ¿es eso seguro?

### Resultado Esperado:
- Identificas que la clave `enviroment` está mal escrita y la corriges a `environment`.
- Te das cuenta de que la sintaxis `environment: name: production` es incorrecta y la ajustas a la forma correcta: `environment: production`.
- (Opcional) Reconoces que desplegar a producción desde ramas de feature no es ideal y ajustas el trigger, por ejemplo, a `main`.
- Después de las correcciones, el workflow se ejecuta y se detiene correctamente para la aprobación o el temporizador de espera configurado en el entorno `production`.
