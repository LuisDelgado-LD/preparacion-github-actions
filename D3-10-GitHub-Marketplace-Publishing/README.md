# Concepto a Resolver: Publicar en el GitHub Marketplace
Este módulo se centra en el proceso de empaquetar y publicar tus actions en el GitHub Marketplace para que otros usuarios puedan descubrirlas y utilizarlas. Cubre los requisitos de metadatos, branding y versionamiento necesarios para una publicación exitosa.

---

## Desafío 1: Preparar los Metadatos de una Action para el Marketplace
Antes de que una action pueda ser publicada, su archivo `action.yml` debe contener metadatos específicos como `branding`, `name`, y `description`. Este desafío consiste en preparar una action simple con todos los campos requeridos.

**Archivos a crear por el estudiante:**
- `action.yml`
- `entrypoint.sh`
- `Dockerfile`

**Archivos de apoyo (proporcionados por ti):**
- Ninguno. Debes crear todo desde cero.

**Contenido de los archivos a crear:**

```bash
# entrypoint.sh
#!/bin/sh -l
echo "Esta action está lista para el Marketplace!"
```

```docker
# Dockerfile
FROM alpine:3.11
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
```

**Instrucciones del desafío:**
1.  Crea los tres archivos (`action.yml`, `entrypoint.sh`, `Dockerfile`).
2.  Rellena el archivo `action.yml` con un nombre (`name`), una descripción (`description`), y la sección `branding`.
3.  En la sección `branding`, elige un icono de [Feather Icons](https://feathericons.com/) y un color válido (`white`, `yellow`, `blue`, `green`, `orange`, `red`, `purple`, o `gray-dark`).
4.  Crea un workflow de prueba (ej. `.github/workflows/test-action.yml`) para usar tu action localmente (`uses: ./`) y verificar que funciona.

### Resultado Esperado:
- El archivo `action.yml` es válido y contiene todos los metadatos necesarios para el Marketplace.
- La action se ejecuta correctamente en un workflow de prueba.
- El estudiante comprende qué campos son obligatorios para la publicación.

---

## Desafío 2: Crear un Release para Publicar la Action
Publicar una action en el Marketplace se logra creando un nuevo "release" en el repositorio de GitHub. Este desafío te guiará en ese proceso.

**Archivos a crear por el estudiante:**
- `.github/workflows/release-drafter.yml` (Opcional, para automatizar)

**Archivos de apoyo (proporcionados por ti):**
- Asume que ya tienes la action del Desafío 1 en tu repositorio.

**Instrucciones del desafío:**
1.  Asegúrate de que tu repositorio contenga la action funcional del desafío anterior.
2.  Ve a la pestaña "Releases" de tu repositorio en la interfaz de GitHub.
3.  Haz clic en "Draft a new release".
4.  Crea una nueva etiqueta (tag) que siga el versionamiento semántico (ej. `v1.0.0`).
5.  Dale un título y una descripción a tu release.
6.  Publica el release.
7.  Una vez publicado, GitHub detectará tu `action.yml` y la publicará en el Marketplace.
8.  (Opcional) Para automatizar borradores de releases futuros, puedes usar una action como `release-drafter/release-drafter`.

### Resultado Esperado:
- Se crea un nuevo release en el repositorio de GitHub.
- La action aparece listada en la página del GitHub Marketplace.
- El estudiante entiende que el mecanismo para publicar y actualizar una action es a través de los releases de GitHub.

---

## Desafío 3: Debugging - Metadatos Inválidos para el Marketplace
Se te proporciona un archivo `action.yml` que un desarrollador intentó publicar, pero GitHub rechazó debido a metadatos inválidos o faltantes. Tu tarea es encontrar y corregir los errores.

**Archivos a crear por el estudiante:**
- Ninguno. Debes corregir el `action.yml` proporcionado.

**Archivos de apoyo (proporcionados por ti):**
- `action.yml` (con errores)

**Contenido del `action.yml` con errores:**
```yaml
# action.yml
# Este archivo tiene errores que impiden su publicación en el Marketplace.
name: 'Mi Action Rota'
# Pista: Falta un campo obligatorio que describe lo que hace la action.

author: 'dev-olvidado'

# Pista: La sección de branding es obligatoria para el Marketplace.
# Además, el color y el icono deben ser valores válidos.

runs:
  using: 'node16'
  main: 'index.js'
```

**Instrucciones del desafío:**
1.  Analiza el archivo `action.yml`.
2.  Identifica los campos obligatorios que faltan según la documentación del GitHub Marketplace (descripción y branding).
3.  Añade el campo `description` con un texto apropiado.
4.  Añade la sección `branding` completa, especificando un `icon` y un `color` válidos.
    -   Por ejemplo, `icon: 'alert-circle'` y `color: 'red'`.

### Resultado Esperado:
- El archivo `action.yml` corregido contiene los campos `description` y `branding`.
- Los valores de `icon` y `color` en la sección `branding` son válidos.
- La action ahora estaría lista para ser publicada correctamente en el Marketplace.
