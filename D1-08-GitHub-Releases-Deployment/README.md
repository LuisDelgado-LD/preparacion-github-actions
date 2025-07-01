¡Hola\! Como tu instructor experto en GitHub Actions, he preparado una serie de desafíos prácticos diseñados para el examen de certificación, centrándonos en el Dominio 8: GitHub Releases Deployment y específicamente en el módulo 08-GitHub-Releases-Deployment. Estos ejercicios son concisos, efectivos y te ayudarán a solidificar tus conocimientos.

-----

# Concepto a Resolver: Creación y Gestión de GitHub Releases

Este concepto se centra en la automatización de la creación de GitHub Releases para empaquetar y distribuir software, artefactos y notas de versión de manera consistente.

-----

## Desafío 1: Creación de una Release Automática en cada Push a `main`

Configura un flujo de trabajo que cree automáticamente una nueva release cada vez que se realiza un `push` a la rama `main`. La release debe incluir un artefacto de la compilación.

**Archivos a crear por el estudiante:**
- `.github/workflows/create-release.yml`
- `build_artifact.sh`

**Contenido de los archivos de apoyo (proporcionados por ti):**
```bash
# build_artifact.sh
#!/bin/bash
set -e
echo "Creating a dummy build artifact..."
DATE=$(date +%s)
echo "Build artifact content for release $DATE" > release_artifact.txt
echo "Artifact created: release_artifact.txt"
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse en cada `push` a la rama `main`.
- Realizar el checkout del código.
- Dar permisos de ejecución al script `build_artifact.sh` y ejecutarlo para crear un archivo de texto.
- Utilizar una acción (como `softprops/action-gh-release`) para crear una nueva release.
- El nombre de la tag y de la release debe ser dinámico (ej. `v1.0.${{ github.run_number }}`).
- Subir el `release_artifact.txt` como un activo (asset) de la release.

### Resultado Esperado:
- Una nueva release es creada en el repositorio con cada `push` a `main`.
- La release tiene un nombre y tag únicos basados en el número de ejecución del workflow.
- El archivo `release_artifact.txt` está adjunto a cada release.

-----

## Desafío 2: Creación de una Release Manual con Dispatch

Crea un workflow que permita la creación manual de una release utilizando el evento `workflow_dispatch`, aceptando la versión como un input.

**Archivos a crear por el estudiante:**
- `.github/workflows/manual-release.yml`

**Archivos de apoyo (proporcionados por ti):**
- `generate_changelog.sh`

**Contenido de los archivos de apoyo:**
```bash
# generate_changelog.sh
#!/bin/bash
set -e
echo "Generating changelog for version $1..."
cat << EOF > changelog.md
# Changelog for version $1

- Feature A was implemented.
- Bug B was fixed.
- Performance was improved.
EOF
echo "Changelog generated: changelog.md"
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse manualmente con `workflow_dispatch`.
- Solicitar una `version` como input obligatorio (ej. `1.2.3`).
- Dar permisos de ejecución al script `generate_changelog.sh` y ejecutarlo pasándole la versión como argumento.
- Crear una release utilizando la versión proporcionada como nombre de la tag y de la release.
- El cuerpo de la release debe contener el contenido del archivo `changelog.md`.
- Subir el `changelog.md` como un activo de la release.

### Resultado Esperado:
- El workflow se puede ejecutar manualmente desde la pestaña "Actions".
- Al ejecutarlo, se solicita un número de versión.
- Se crea una release con el nombre y tag correspondientes a la versión ingresada.
- El `changelog.md` se encuentra tanto en el cuerpo de la release como en los activos.

-----

## Desafío de Debugging: Corregir un Workflow de Release Roto

Debes identificar y corregir los errores en un workflow que intenta crear una release a partir de una tag, pero falla debido a una configuración incorrecta y problemas de permisos.

**Archivos a crear por el estudiante:**
- (Ninguno, debes corregir el archivo proporcionado)

**Archivos de apoyo (proporcionados por ti):**
```yaml
# .github/workflows/debug-release.yml (CON ERRORES INTENCIONALES)
name: Debug Release Creation

on:
  push:
    tags:
      - 'v*'

jobs:
  create_release:
    runs-on: ubuntu-latest
    # Faltan permisos para crear releases y subir assets

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Create Dummy File
      run: echo "dummy content" > artifact.log

    - name: Create Release
      id: create_release
      uses: actions/create-release@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        tag_name: ${{ github.tag }} # Error: github.tag no existe en este contexto
        release_name: 'Release ${{ github.ref }}'
        body: 'Release created from tag ${{ github.ref }}'
        draft: false
        prerelease: 'True' # Error: el valor de prerelease debe ser un booleano

    - name: Upload Release Asset
      # Falta un paso para subir el artefacto a la release
      run: echo "Asset should be uploaded here!"

```

**Pistas sutiles:**
- Para que una acción pueda crear una release, necesita permisos específicos. Revisa la sección `permissions` en la documentación de workflows.
- El contexto `github` es clave. ¿La referencia a la tag (`github.tag`) es la forma correcta de obtener el nombre de la tag en un evento `push`? Quizás `github.ref_name` es más adecuado.
- Los tipos de datos en YAML son importantes. Un string como `'True'` no es lo mismo que un booleano `true`.
- La acción `actions/create-release` solo *crea* la release. Necesitarás otra acción, como `actions/upload-release-asset`, para adjuntar archivos.

### Resultado Esperado:
- El workflow se ejecuta exitosamente cuando se empuja una nueva tag (ej. `v1.5.0`).
- Se crea una pre-release correctamente en GitHub con el nombre de la tag.
- El archivo `artifact.log` se sube como un activo a la nueva release.
- El log del workflow no muestra errores de permisos ni de configuración.