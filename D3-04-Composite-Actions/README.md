# Concepto a Resolver: Creación y Uso de Acciones Compuestas (Composite)
Este módulo se centra en las acciones compuestas, que te permiten agrupar múltiples pasos de un workflow en una sola acción reutilizable. Son ideales para reducir la duplicación de código en tus workflows y simplificar secuencias de comandos complejas sin necesidad de usar Docker o JavaScript.

---

## Desafío 1: Mi Primera Acción Compuesta
**Descripción:** Crea una acción compuesta que instala un paquete usando un gestor de paquetes de línea de comandos (como `cowsay`) y luego lo ejecuta para mostrar un mensaje. Este desafío te enseñará la estructura básica de una acción compuesta y cómo ejecutar comandos de shell.

**Archivos a crear por el estudiante:**
- `action/action.yml`
- `.github/workflows/test-composite-action.yml`

**Archivos de apoyo (proporcionados por ti):**
No se necesitan archivos de apoyo. Crearás la acción desde cero.


**Instrucciones del workflow:**
Tu workflow (`.github/workflows/test-composite-action.yml`) debe:
1.  Activarse con `workflow_dispatch`.
2.  Tener un job que se ejecute en `ubuntu-latest`.
3.  Hacer checkout del código de tu repositorio.
4.  Utilizar tu acción compuesta local (`./action`) con un `id`.
5.  Pasar un mensaje personalizado al input `mensaje`.
6.  Imprimir la salida `resultado-vaca` de la acción en un paso posterior.

### Resultado Esperado:
- El workflow se ejecuta correctamente.
- El log del workflow muestra la instalación de `cowsay`.
- El paso final imprime el arte ASCII de la vaca diciendo tu mensaje personalizado.

---

## Desafío 2: Acción Compuesta que Ejecuta un Script
**Descripción:** Crea una acción compuesta que no ejecuta los comandos directamente, sino que llama a un script de shell (`.sh`) que se encuentra dentro del directorio de la acción. Esto es útil para organizar lógicas más complejas.

**Archivos a crear por el estudiante:**
- `saludo-action/action.yml`
- `saludo-action/entrypoint.sh`
- `.github/workflows/script-composite-action.yml`

**Archivos de apoyo (proporcionados por ti):**

**`saludo-action/entrypoint.sh` (Contenido):**
```bash
#!/bin/bash
# saludo-action/entrypoint.sh

NOMBRE=$1
APELLIDO=$2

MENSAJE_SALUDO="Saludos, $NOMBRE $APELLIDO. ¡Bienvenido desde un script!"

echo "mensaje_final=$MENSAJE_SALUDO" >> $GITHUB_OUTPUT
```

**Instrucciones:**
1.  Haz que el script `entrypoint.sh` sea ejecutable.
2.  Crea el `action.yml` para la acción compuesta.
3.  Crea el workflow que la utiliza.


**Instrucciones del workflow:**
Tu workflow (`.github/workflows/script-composite-action.yml`) debe:
1.  Activarse en un `push`.
2.  Usar tu acción compuesta local (`./saludo-action`).
3.  Pasar tu nombre y apellido a los inputs `nombre` y `apellido`.
4.  Imprimir la salida `saludo_completo`.

### Resultado Esperado:
- El workflow se ejecuta con éxito.
- El paso final imprime: "Saludos, [tu-nombre] [tu-apellido]. ¡Bienvenido desde un script!".

---

## Desafío 3: Debugging de una Acción Compuesta
**Descripción:** Se te proporciona un workflow y una acción compuesta con errores. Tu misión es depurar y corregir los archivos para que el workflow se ejecute correctamente.

**Archivos a crear por el estudiante:**
- Ninguno. Debes corregir los archivos existentes.

**Archivos de apoyo (proporcionados por ti con errores):**

**`.github/workflows/broken-composite.yml`:**
```yaml
# .github/workflows/broken-composite.yml
name: Broken Composite Workflow
on: workflow_dispatch

jobs:
  debug-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run broken composite action
        id: broken-composite
        uses: ./broken-action
        with:
          comando: 'date'
      - name: Check output
        run: echo "El resultado fue ${{ steps.broken-composite.outputs.resultado }}"
```

**`broken-action/action.yml`:**
```yaml
# broken-action/action.yml
name: 'Broken Composite'
description: 'Esta acción está rota'
inputs:
  command:
    description: 'Comando a ejecutar'
    required: true
# Falta la sección de outputs
runs:
  using: "composite"
  steps:
    - name: Run command
      id: run_command
      run: ${{ inputs.command }}
      # Falta especificar el shell, lo que puede causar problemas
    - name: Set output
      # Este paso no tiene id, y el comando para establecer la salida es incorrecto
      run: echo "resultado=${{ steps.run_command.outputs.stdout }}" >> $GITHUB_OUTPUT
      shell: bash
```

**Instrucciones del workflow:**
1.  Ejecuta el workflow y observa los errores. Pueden ser de sintaxis en el `action.yml` o de lógica en la ejecución.
2.  Revisa el `action.yml` y el workflow para encontrar las discrepancias.
3.  Corrige los errores para que la acción ejecute el comando pasado como input y exponga el resultado como un output.

**Pistas:**
- ¿Cómo se definen correctamente los `outputs` en una acción compuesta? La sintaxis es diferente a la de las acciones Docker/JS.
- ¿Están todos los pasos que necesitan un `id` correctamente identificados?
- ¿El `shell` por defecto es siempre `bash`? A veces es mejor ser explícito.
- ¿Cómo se captura la salida estándar (`stdout`) de un paso para usarla en otro?

### Resultado Esperado:
- El workflow se ejecuta y finaliza con éxito.
- El último paso del workflow imprime la fecha y hora actuales (el resultado del comando `date`).
