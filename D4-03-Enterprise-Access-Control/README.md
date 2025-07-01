# Concepto a Resolver: Control de Acceso a Nivel Empresarial
Este módulo se enfoca en cómo GitHub Enterprise y las organizaciones gestionan el acceso a los recursos de Actions, como runners, secretos y entornos. El objetivo es asegurar que solo los repositorios y usuarios autorizados puedan utilizar recursos compartidos y sensibles.

---

## Desafío 1: Restringir el Acceso de un Runner de Organización a Repositorios Específicos
Los runners a nivel de organización son eficientes, pero por seguridad, a menudo querrás limitar qué repositorios pueden usarlos. Este desafío simula la configuración de esta política de acceso.

**Archivos a crear por el estudiante:**
- `.github/workflows/org-runner-access.yml`

**Archivos de apoyo (proporcionados por ti):**
- Ninguno.

**Instrucciones del desafío:**
1.  **Simulación de la configuración de la organización:** Ve a la configuración de tu organización (o simúlalo en tu cuenta personal si no tienes una). Navega a `Settings` > `Actions` > `Runners`.
2.  Imagina que tienes un grupo de runners llamado `production-runners`.
3.  Haz clic en el grupo y, en la sección `Repository access`, selecciona `Selected repositories`.
4.  Añade un repositorio imaginario (o uno real si tienes varios) a la lista de permitidos. **No añadas el repositorio en el que estás trabajando actualmente.**
5.  Ahora, en tu repositorio actual, crea el workflow `org-runner-access.yml`.
6.  Este workflow debe intentar ejecutarse en el grupo de runners restringido (`runs-on: production-runners`).

### Resultado Esperado:
- El workflow falla al intentar iniciarse.
- El error en la interfaz de GitHub indica que el workflow no puede ejecutarse porque el repositorio no tiene acceso al grupo de runners `production-runners`.
- El estudiante comprende cómo se configura el acceso de los runners a nivel de organización/repositorio.

---

## Desafío 2: Limitar la Ejecución de Workflows a Usuarios con Permisos Específicos
No todos los que pueden hacer push a un repositorio deberían poder ejecutar workflows que despliegan a producción. Este desafío explora cómo usar los permisos de repositorio para controlar la ejecución de workflows.

**Archivos a crear por el estudiante:**
- `.github/workflows/protected-deployment.yml`

**Archivos de apoyo (proporcionados por ti):**
- Ninguno.

**Instrucciones del desafío:**
1.  **Simulación de la configuración del entorno:** En tu repositorio, ve a `Settings` > `Environments` y crea un nuevo entorno llamado `production`.
2.  En la configuración del entorno, añade una regla de protección: `Required reviewers`. Añade a un colaborador (o a ti mismo) como revisor requerido.
3.  Crea el workflow `protected-deployment.yml`.
4.  El workflow debe activarse con `workflow_dispatch`.
5.  Debe contener un job que se despliegue al entorno `production` (`environment: production`).
6.  El job debe simplemente imprimir un mensaje como "Desplegando a producción".

### Resultado Esperado:
- Al intentar ejecutar el workflow manualmente, este no se ejecuta inmediatamente.
- El workflow entra en un estado de "espera" (waiting).
- El revisor designado recibe una notificación para aprobar o rechazar el despliegue.
- El job solo continúa si el despliegue es aprobado, demostrando el control de acceso basado en roles.

---

## Desafío 3: Debugging - Permisos de Token Insuficientes para Acceder a Recursos
Un workflow falla porque el `GITHUB_TOKEN` no tiene los permisos necesarios para realizar una operación, como escribir en las discusiones (discussions) o crear un release. Tu tarea es diagnosticar y corregir el problema de permisos.

**Archivos a crear por el estudiante:**
- Ninguno. Debes corregir el workflow proporcionado.

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/insufficient-permissions.yml`

**Contenido del workflow con errores:**
```yaml
name: Insufficient Token Permissions
on:
  workflow_dispatch:

# Pista: Por defecto, el GITHUB_TOKEN tiene permisos restringidos.
# Si una action necesita escribir en un recurso del repositorio, ¿dónde se configuran esos permisos?

jobs:
  create-issue:
    runs-on: ubuntu-latest
    steps:
      - name: Create issue using an action
        # Esta action necesita el permiso 'issues: write'
        uses: actions-ecosystem/action-create-issue@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          title: Automated issue from workflow
          body: This issue was created by a GitHub Action.
```

**Instrucciones del desafío:**
1.  Ejecuta el workflow y observa que falla en el paso "Create issue using an action".
2.  Revisa los logs del workflow. El error indicará un problema de "Forbidden" o de permisos insuficientes.
3.  La causa es que el `GITHUB_TOKEN` no tiene el permiso `issues: write` por defecto.
4.  Corrige el workflow añadiendo una sección `permissions` a nivel de workflow o de job para otorgar el permiso necesario.
    ```yaml
    permissions:
      issues: write
    ```

### Resultado Esperado:
- Después de añadir el bloque `permissions` correcto, el workflow se ejecuta exitosamente.
- Un nuevo issue se crea en el repositorio, demostrando que el token ahora tiene los permisos adecuados.
- El estudiante aprende a diagnosticar y resolver problemas de permisos del `GITHUB_TOKEN`.
