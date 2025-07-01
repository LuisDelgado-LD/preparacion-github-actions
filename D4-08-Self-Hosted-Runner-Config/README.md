# Concepto a Resolver: Configuración de Runners Auto-Alojados
La configuración de runners auto-alojados (self-hosted) implica instalar el software del runner en tu propia infraestructura (servidores físicos, VMs, contenedores), registrarlo en GitHub (a nivel de repositorio, organización o empresa) y mantenerlo. Esto te da control total sobre el entorno de ejecución, el hardware y el software, lo cual es esencial para tareas que requieren configuraciones específicas, acceso a recursos privados o cumplimiento de normativas estrictas.

---

## Desafío 1: Instalar y Registrar un Runner Auto-Alojado para un Repositorio
Instalarás el software del runner en tu máquina local y lo registrarás para que esté disponible exclusivamente para un repositorio específico.

**Instrucciones:**
1.  Navega a la configuración de tu repositorio (`Settings` > `Actions` > `Runners`).
2.  Haz clic en `New self-hosted runner`.
3.  Elige tu sistema operativo (ej. Linux) y copia los comandos proporcionados.
4.  En tu terminal local, crea una carpeta (ej. `actions-runner`).
5.  Ejecuta los comandos de `Download` para descargar el software del runner.
6.  Ejecuta el comando `Configure`, proporcionando la URL del repositorio y el token que te da GitHub. Cuando te pregunte por etiquetas, puedes presionar Enter para usar las predeterminadas.
7.  Inicia el runner con el comando `run.sh` (o `run.cmd` en Windows).
8.  Verifica en la UI de GitHub que tu runner aparece como "Idle" en la lista de runners del repositorio.

**Archivos a crear por el estudiante:**
-   `.github/workflows/repo-runner-check.yml`

**Instrucciones del workflow:**
Tu workflow debe:
-   Activarse con `workflow_dispatch`.
-   Contener un job que se ejecute específicamente en `self-hosted`.
-   El job debe imprimir un mensaje para confirmar que se está ejecutando en tu máquina.

```yaml
# .github/workflows/repo-runner-check.yml
name: Test Repository Runner
on: workflow_dispatch
jobs:
  test-job:
    runs-on: self-hosted
    steps:
      - name: Confirm execution
        run: echo "Job ejecutado en el runner del repositorio."
```

### Resultado Esperado:
-   El runner se instala, configura e inicia sin errores.
-   El runner aparece como activo en la configuración del repositorio.
-   El workflow se ejecuta y el job es recogido por tu runner local, completándose con éxito.

---

## Desafío 2: Usar un Runner Auto-Alojado en un Contenedor Docker
En lugar de instalar el runner directamente en tu SO, lo ejecutarás dentro de un contenedor Docker. Esto proporciona un entorno limpio y aislado para cada ejecución de job.

**Archivos de apoyo (proporcionados por ti):**
-   `Dockerfile`

**Contenido del Dockerfile:**
```Dockerfile
# Dockerfile
FROM ubuntu:20.04

# Evitar prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y curl sudo

# Crear un usuario no-root para el runner
RUN useradd -m github
RUN usermod -aG sudo github
RUN echo "github ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER github
WORKDIR /home/github

# Descargar e instalar el runner (la versión puede cambiar)
RUN curl -o actions-runner-linux-x64-2.317.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.317.0.tar.gz

# Script de inicio que configura y ejecuta el runner
COPY entrypoint.sh ./
RUN sudo chmod +x entrypoint.sh

ENTRYPOINT ["/home/github/entrypoint.sh"]
```

-   `entrypoint.sh`

**Contenido de entrypoint.sh:**
```bash
#!/bin/bash

# Configurar el runner
./config.sh --url $REPO_URL --token $RUNNER_TOKEN --unattended --replace

# Ejecutar el runner
./run.sh
```

**Instrucciones:**
1.  Obtén un token de registro de runner para tu repositorio (como en el Desafío 1).
2.  Construye la imagen de Docker: `docker build -t my-actions-runner .`
3.  Ejecuta el contenedor, pasando la URL del repositorio y el token como variables de entorno:
    ```bash
    docker run -e REPO_URL="https://github.com/tu-usuario/tu-repo" -e RUNNER_TOKEN="TU_TOKEN" my-actions-runner
    ```
4.  Verifica que el runner contenedorizado aparezca como activo en GitHub.
5.  Ejecuta el mismo workflow del Desafío 1.

### Resultado Esperado:
-   La imagen de Docker se construye correctamente.
-   El contenedor se inicia y el runner se registra con éxito en GitHub.
-   El workflow `repo-runner-check.yml` se ejecuta en el runner que está dentro del contenedor Docker.

---

## Desafío 3: Resolución de Problemas - Permisos de Ficheros en Runner Auto-Alojado
Un workflow que funciona en runners alojados por GitHub falla en tu nuevo runner auto-alojado con errores de "Permiso denegado".

**Archivos de apoyo (proporcionados por ti):**
-   `.github/workflows/permission-error-workflow.yml`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/permission-error-workflow.yml
name: Debugging Permission Issues
on: workflow_dispatch
jobs:
  build:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v4

      - name: Create a build directory
        # Falla si el usuario del runner no tiene permisos en /opt
        run: mkdir /opt/build_output

      - name: Write to build directory
        run: echo "build artifact" > /opt/build_output/artifact.txt
```

**Contexto del Problema:**
El runner auto-alojado se está ejecutando como un usuario sin privilegios (lo cual es una buena práctica de seguridad). El workflow intenta escribir en un directorio del sistema (`/opt`) donde este usuario no tiene permisos de escritura, causando el fallo del job.

**Instrucciones:**
1.  Ejecuta el workflow y observa el error `mkdir: cannot create directory ‘/opt/build_output’: Permission denied`.
2.  Analiza el workflow y el entorno del runner para entender la causa del problema.
3.  Modifica el workflow para que utilice el directorio de trabajo del runner (`${{ github.workspace }}`), que es un lugar seguro para escribir archivos.

**Pistas:**
-   ¿Con qué usuario se está ejecutando el proceso del runner en tu máquina?
-   ¿Tiene ese usuario permiso para escribir en cualquier lugar del sistema de archivos?
-   GitHub Actions proporciona una variable de entorno, `github.workspace`, que apunta a una ruta segura y garantizada para la escritura dentro del runner.

### Resultado Esperado:
-   Identificas que el error se debe a un intento de escritura en un directorio protegido.
-   Modificas el workflow para que los comandos de creación y escritura de directorios operen dentro de `${{ github.workspace }}`. Por ejemplo:
    ```yaml
    - name: Create a build directory
      run: mkdir ${{ github.workspace }}/build_output
    - name: Write to build directory
      run: echo "build artifact" > ${{ github.workspace }}/build_output/artifact.txt
    ```
-   El workflow corregido se ejecuta con éxito en el runner auto-alojado.
