# Concepto a Resolver: Configuración de Listas de Permisos de IP
Las listas de permisos de IP son una característica de seguridad a nivel de organización que permite restringir el acceso a los activos de la organización (repositorios, paquetes, etc.) a un conjunto específico de direcciones IP. Esto es fundamental para empresas que necesitan asegurar que solo se pueda acceder a su código y recursos desde redes corporativas de confianza.

---

## Desafío 1: Activar y Configurar una Lista de Permisos de IP
Configurarás una lista de permisos de IP para tu organización, añadiendo tu dirección IP actual para asegurar que no pierdas el acceso, y luego verificarás su funcionamiento.

**Instrucciones:**
1.  Navega a la configuración de tu organización (`Settings`).
2.  En la sección de seguridad, busca y haz clic en `IP allow list`.
3.  Marca la casilla `Enable IP allow list`.
4.  Antes de guardar, es **crucial** que añadas tu dirección IP pública actual a la lista. Puedes encontrarla buscando en Google "cuál es mi IP".
5.  Haz clic en `Add` para añadir tu IP, dale una descripción (ej. "Oficina Principal") y guárdala.
6.  Una vez que tu IP esté en la lista, guarda la configuración general de la lista de permisos.
7.  Intenta realizar una operación de `git` (como `git clone` o `git pull`) en un repositorio de la organización para confirmar que tu acceso sigue funcionando.

**Archivos a crear por el estudiante:**
-   Ninguno. Este desafío se realiza completamente en la interfaz de usuario de GitHub.

### Resultado Esperado:
-   La lista de permisos de IP está activada para tu organización.
-   Tu dirección IP actual está en la lista de IPs permitidas.
-   Puedes seguir interactuando con los repositorios de tu organización sin ser bloqueado.
-   (Opcional) Si intentas acceder desde una red no incluida en la lista (como una VPN o la red de tu móvil), el acceso debería ser denegado.

---

## Desafío 2: Automatizar la Adición de IPs mediante un Workflow
Simularás un escenario donde una nueva oficina necesita acceso. Crearás un workflow que, al ser activado manualmente, añade una nueva dirección IP a la lista de permisos de la organización utilizando la API de GitHub.

**Archivos a crear por el estudiante:**
-   `.github/workflows/add-ip-to-allowlist.yml`

**Instrucciones del workflow:**
Tu workflow debe:
-   Activarse con `workflow_dispatch`, solicitando la dirección IP y una descripción como entradas (`inputs`).
-   Utilizar un `GITHUB_TOKEN` con los permisos adecuados. Para esta operación, necesitarás un **Personal Access Token (PAT)** con el scope `admin:org`, guardado como un secret en el repositorio (ej. `ORG_ADMIN_PAT`).
-   Usar `curl` o un script para hacer una llamada a la API de GitHub y añadir la IP proporcionada a la lista de permisos.

**Ejemplo de llamada a la API con `curl`:**
```bash
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${{ secrets.ORG_ADMIN_PAT }}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/TU_ORGANIZACION/ip-allow-list \
  -d '{"value":"${{ github.event.inputs.ip_address }}","description":"${{ github.event.inputs.description }}"}'
```
*Reemplaza `TU_ORGANIZACION` con el nombre de tu organización.*

### Resultado Esperado:
-   El workflow se ejecuta correctamente tras ser activado con una IP y descripción.
-   La nueva dirección IP aparece en la lista de permisos de IP en la configuración de la organización.

---

## Desafío 3: Resolución de Problemas - Acceso Bloqueado por IP
Un desarrollador de tu equipo informa que no puede clonar un repositorio de la organización, recibiendo un error de acceso denegado, aunque sus credenciales son correctas. Sospechas que la lista de permisos de IP es la culpable.

**Archivos de apoyo (proporcionados por ti):**
-   No se necesitan archivos. Es un desafío de diagnóstico.

**Contexto del Problema:**
-   La organización tiene una lista de permisos de IP activada.
-   Un usuario con los permisos correctos sobre el repositorio no puede acceder.
-   El error que recibe es similar a: `fatal: unable to access 'https://github.com/org/repo.git/': The requested URL returned error: 403` o un mensaje indicando que la IP no está permitida.

**Instrucciones:**
1.  Pide al desarrollador que te proporcione su dirección IP pública actual.
2.  Navega a la configuración de la lista de permisos de IP de la organización.
3.  Verifica si la dirección IP del desarrollador está presente en la lista.
4.  Identifica la causa del problema y la solución.

**Pistas:**
-   Los errores 403 (Forbidden) a menudo están relacionados con permisos, pero en este contexto, también pueden ser causados por restricciones de red.
-   ¿La lista de permisos de IP está habilitada para la API además de para la UI y Git?
-   ¿El desarrollador se ha conectado recientemente desde una nueva ubicación, como su casa o una cafetería?

### Resultado Esperado:
-   Identificas que la dirección IP del desarrollador no se encuentra en la lista de permisos de la organización.
-   La solución es añadir su dirección IP a la lista.
-   Una vez añadida, el desarrollador confirma que puede acceder al repositorio con éxito.
