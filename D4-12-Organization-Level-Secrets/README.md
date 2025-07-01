# Concepto a Resolver: Gestión de Secretos a Nivel de Organización
Este módulo se centra en cómo crear, gestionar y utilizar secretos a nivel de organización en GitHub, permitiendo un almacenamiento seguro y centralizado de credenciales que pueden ser compartidas selectivamente con múltiples repositorios.

---

## Desafío 1: Uso Básico de un Secreto de Organización
El objetivo es configurar un workflow que utilice un secreto definido a nivel de organización para mostrar un mensaje personalizado.

**Archivos a crear por el estudiante:**
- `.github/workflows/use-org-secret.yml`

**Archivos de apoyo (proporcionados por ti):**
- `scripts/welcome.sh`

**Contenido de los archivos de apoyo:**
```bash
#!/bin/bash
# scripts/welcome.sh

TEAM_NAME="$1"

if [ -z "$TEAM_NAME" ]; then
  echo "Error: Nombre del equipo no proporcionado."
  exit 1
fi

echo "Bienvenido, equipo '$TEAM_NAME'. Este es un mensaje seguro."
```

**Instrucciones del workflow:**
1.  **Prerrequisito:** Un administrador de la organización debe crear un secreto llamado `ORG_TEAM_NAME` con el valor `Innovación` y conceder acceso a este repositorio.
2.  Crea un workflow que se active manualmente (`workflow_dispatch`).
3.  El workflow debe tener un único job llamado `display-message`.
4.  El job debe hacer checkout del código.
5.  Añade un paso para dar permisos de ejecución al script `welcome.sh`.
6.  El último paso debe ejecutar el script `welcome.sh`, pasándole el secreto `ORG_TEAM_NAME` como argumento.

### Resultado Esperado:
- El workflow se completa con éxito.
- El log del workflow muestra el mensaje: "Bienvenido, equipo 'Innovación'. Este es un mensaje seguro.".
- El valor del secreto no es visible en los logs.

---

## Desafío 2: Política de Acceso a Secretos de Organización
Este desafío simula un escenario donde un secreto de organización solo está disponible para repositorios con un *topic* específico. El estudiante debe asegurarse de que el repositorio esté configurado correctamente para acceder al secreto.

**Archivos a crear por el estudiante:**
- `.github/workflows/policy-restricted-secret.yml`

**Archivos de apoyo (proporcionados por ti):**
- `scripts/check_license.sh`

**Contenido de los archivos de apoyo:**
```bash
#!/bin/bash
# scripts/check_license.sh

LICENSE_KEY="$1"

if [[ "$LICENSE_KEY" == "premium-license-key-12345" ]]; then
  echo "Licencia Premium activada correctamente."
else
  echo "Error: La clave de licencia no es válida o no se pudo acceder a ella."
  exit 1
fi
```

**Instrucciones del workflow:**
1.  **Prerrequisito:**
    - Un administrador de la organización ha creado un secreto llamado `PREMIUM_LICENSE_KEY` con el valor `premium-license-key-12345`.
    - La política de acceso para este secreto está configurada para permitir el acceso solo a repositorios que tengan el topic `premium-feature`.
    - Asegúrate de que tu repositorio tenga asignado el topic `premium-feature` en la página principal del repositorio.
2.  Crea un workflow que se active en un `push` a la rama `main`.
3.  El workflow debe contener un job `validate-license`.
4.  El job debe hacer checkout del código, dar permisos de ejecución al script y ejecutar `check_license.sh` con el secreto `PREMIUM_LICENSE_KEY`.

### Resultado Esperado:
- El workflow se ejecuta exitosamente después de un push a `main`.
- El log del job `validate-license` muestra "Licencia Premium activada correctamente.".
- Si eliminas el topic `premium-feature` del repositorio y vuelves a ejecutar el workflow, este debería fallar con el mensaje de error del script.

---

## Desafío 3: Resolución de Problemas - Secreto de Organización no Encontrado
Te encuentras con un workflow que no puede acceder a un secreto de organización. Tu misión es identificar por qué el secreto no está disponible y arreglar el workflow.

**Archivos a crear por el estudiante:**
- Ninguno. El workflow con errores se proporciona a continuación.

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/debug-secret-access.yml`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/debug-secret-access.yml
name: Debug Organization Secret Access
on:
  workflow_dispatch:

jobs:
  connect-to-db:
    runs-on: ubuntu-latest
    steps:
      - name: Connect to Database
        env:
          DB_PASSWORD: ${{ secrets.DATABASE_PASSWORD }}
        run: |
          echo "Intentando conectar a la base de datos..."
          if [ -n "$DB_PASSWORD" ]; then
            echo "Conexión exitosa (simulada)."
          else
            echo "Fallo de conexión: la contraseña de la BD no fue encontrada."
            exit 1
          fi
```

**Instrucciones del desafío:**
1.  **Contexto:** Un administrador de la organización ha creado un secreto llamado `DB_PASSWORD` para toda la organización, pero el workflow falla indicando que la contraseña no fue encontrada.
2.  Revisa el workflow `debug-secret-access.yml`.
3.  Considera las razones por las que `secrets.DATABASE_PASSWORD` podría estar vacío.

**Pistas:**
- ¿Estás seguro de que el nombre del secreto en el workflow es el correcto? A veces, los nombres pueden tener prefijos o sufijos (ej. `PROD_DB_PASSWORD` vs. `DB_PASSWORD`).
- Revisa la configuración de acceso del secreto en la organización. ¿Está disponible para **todos** los repositorios o solo para una selección de ellos? ¿Está este repositorio en la lista de permitidos?
- ¿Podría haber un secreto con el mismo nombre a nivel de repositorio que esté vacío y, por lo tanto, anulando el de la organización?

### Resultado Esperado:
- Después de identificar el problema (por ejemplo, corregir el nombre del secreto en el workflow a `secrets.PROD_DB_PASSWORD` o ajustar la política de acceso), el workflow se ejecuta correctamente.
- El log del workflow muestra "Intentando conectar a la base de datos..." seguido de "Conexión exitosa (simulada).".
