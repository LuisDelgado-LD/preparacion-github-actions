
# Concepto a Resolver: Estrategia de Versionamiento de Actions
Este módulo cubre la importancia de seleccionar una estrategia de versionamiento para las actions que utilizas en tus workflows. Aprenderás sobre los riesgos y beneficios de usar etiquetas flotantes (como `v2`), versiones específicas (como `v2.1.0`) o un hash de commit (SHA) para garantizar la estabilidad y seguridad de tus procesos de CI/CD.

---

## Desafío 1: Usar una Versión Flotante vs. una Versión Específica
En este desafío, explorarás la diferencia entre usar una etiqueta de versión mayor (flotante) y una etiqueta de versión semántica específica.

**Archivos a crear por el estudiante:**
- `.github/workflows/versioning-strategies.yml`

**Archivos de apoyo (proporcionados por ti):**
- Ninguno.

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse con un `workflow_dispatch`.
- Contener dos jobs que se ejecuten en paralelo:
  1.  `use-floating-version`: Este job debe usar la action `actions/checkout` apuntando a una versión mayor flotante (ej. `v3`).
  2.  `use-specific-version`: Este job debe usar la misma action `actions/checkout` pero apuntando a una versión semántica específica (ej. `v3.5.0`).
- Cada job debe imprimir la versión de la action que se está utilizando para la verificación.

### Resultado Esperado:
- El workflow se ejecuta correctamente con ambos jobs completándose exitosamente.
- Los logs de cada job muestran claramente qué versión de la action `checkout` fue utilizada.
- El estudiante puede reflexionar sobre cómo la versión flotante podría cambiar en el futuro, mientras que la específica permanecerá constante.

---

## Desafío 2: Fijar una Action a un Commit SHA para Máxima Seguridad
Este es el método más seguro para usar una action, ya que garantiza que estás ejecutando exactamente el mismo código cada vez. En este desafío, fijarás una action a un hash de commit específico.

**Archivos a crear por el estudiante:**
- `.github/workflows/pin-by-sha.yml`

**Archivos de apoyo (proporcionados por ti):**
- Ninguno.

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse con un `push` a la rama `main`.
- Utilizar la action `actions/setup-python@v4`.
- En lugar de usar una etiqueta como `v4`, encuentra el hash de commit (SHA) completo de una versión específica de la action en su repositorio de GitHub y úsalo en el campo `uses`.
- Añade un comentario en el workflow explicando por qué has elegido ese commit específico (ej. `Fijado al commit XXXXXXX correspondiente a la versión v4.7.0 para estabilidad`).

### Resultado Esperado:
- El workflow se ejecuta exitosamente.
- La action `setup-python` se ejecuta usando el hash de commit exacto que especificaste.
- El estudiante comprende cómo encontrar y utilizar un hash de commit para fijar una action.

---

## Desafío 3: Debugging - Ruptura de Dependencia por Versión Flotante
Se te proporciona un workflow que recientemente comenzó a fallar. Una de las actions que usa una etiqueta de versión flotante ha sido actualizada por su autor con un cambio que rompe la compatibilidad. Tu misión es encontrar la action problemática y fijarla a una versión anterior que funcione.

**Archivos a crear por el estudiante:**
- Ninguno. Debes corregir el workflow proporcionado.

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/broken-version.yml`
- `check-output.sh`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/broken-version.yml
name: Broken Dependency Due to Floating Version
on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Create a dummy file
        id: create_file
        run: |
          echo "version=1.0" > my_output.txt
          echo "output_path=$(pwd)/my_output.txt" >> $GITHUB_OUTPUT

      # Pista: Esta action hipotética solía generar un archivo de salida, pero en su 'última' versión, el nombre del archivo cambió.
      # La versión flotante @v1 ha introducido un cambio de ruptura.
      - name: Generate content (hypothetical action)
        id: generator
        uses: actions/github-script@v1 # Supongamos que v1 ahora crea 'new_output.txt' en lugar de 'my_output.txt'
        with:
          script: |
            core.setOutput('old_output_path', steps.create_file.outputs.output_path);

      - name: Check file existence
        # Este script espera encontrar 'my_output.txt', pero la 'nueva' versión de la action no lo crea.
        run: ./check-output.sh ${{ steps.generator.outputs.old_output_path }}
```

**Contenido de los archivos de apoyo:**
```bash
# check-output.sh
#!/bin/bash
FILE_PATH=$1
if [ -f "$FILE_PATH" ]; then
  echo "Archivo encontrado! El contenido es: $(cat $FILE_PATH)"
else
  echo "Error: El archivo esperado en la ruta $FILE_PATH no fue encontrado."
  exit 1
fi
```

**Instrucciones del desafío:**
1.  Ejecuta el workflow y observa que falla en el paso "Check file existence".
2.  Lee los logs y las pistas. La causa raíz es que la action `actions/github-script@v1` (en este escenario hipotético) ha cambiado su comportamiento.
3.  Tu tarea es "revertir" a una versión anterior que funcione. En lugar de usar `@v1`, encuentra el hash de commit de una versión más antigua y estable (para este ejercicio, puedes usar el hash de la `v6` real, que es `v6.4.0`, cuyo SHA es `0a80f5836c0243a9d13502a695ce856d84cb81b6`).
4.  Corrige la línea `uses` para apuntar a ese hash de commit específico.

### Resultado Esperado:
- El workflow se completa exitosamente después de fijar la action `actions/github-script` a un hash de commit anterior y estable.
- El script `check-output.sh` encuentra el archivo y el workflow termina sin errores.
