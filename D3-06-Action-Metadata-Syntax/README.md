# Concepto a Resolver: Sintaxis de Metadatos de una Acción (`action.yml`)
La sintaxis del archivo `action.yml` es fundamental para definir cómo funciona una acción, qué datos de entrada (inputs) acepta, qué datos de salida (outputs) produce, y cómo se ejecuta. Dominar esta sintaxis es clave para crear acciones personalizadas robustas y reutilizables.

---

## Desafío 1: Definiendo Entradas y Salidas Básicas
Crea una acción compuesta que reciba un nombre de usuario y genere un saludo personalizado como salida. Deberás definir los metadatos necesarios para que la acción sea configurable.

**Archivos a crear por el estudiante:**
- `saludo-action/action.yml`
- `.github/workflows/test-saludo.yml`

**Instrucciones de la acción (`action.yml`):**
- **`name`**: "Generador de Saludos"
- **`description`**: "Una acción simple que genera un saludo personalizado."
- **`inputs`**:
  - `nombre`:
    - `description`: 'El nombre de la persona a saludar.'
    - `required`: `true`
- **`outputs`**:
  - `mensaje-salida`:
    - `description`: 'El mensaje de saludo generado.'
- **`runs`**:
  - `using`: 'composite'
  - `steps`:
    - Un paso que ejecute un comando de shell para generar el saludo "¡Hola, ${{ inputs.nombre }}!" y lo asigne al `mensaje-salida`.

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse con `workflow_dispatch`.
- Usar la acción local `./saludo-action`.
- Pasar un nombre de tu elección al input `nombre`.
- Imprimir el `mensaje-salida` de la acción en un paso posterior.

### Resultado Esperado:
- El workflow se ejecuta sin errores.
- La salida del workflow muestra el mensaje de saludo personalizado, por ejemplo: "¡Hola, Mona!".

---

## Desafío 2: Inputs con Valores por Defecto y Branding
Modifica la acción anterior para que el saludo sea más flexible, permitiendo un saludo por defecto si no se proporciona un nombre, y añade branding para que se vea profesional en el Marketplace.

**Archivos a crear por el estudiante:**
- `saludo-action/action.yml` (modificar el del desafío anterior)
- `.github/workflows/test-saludo-avanzado.yml`

**Instrucciones de la acción (`action.yml`):**
- Modifica el input `nombre`:
  - `required`: `false`
  - `default`: 'Mundo'
- Añade `branding` a tu acción:
  - `icon`: 'message-circle'
  - `color`: 'blue'

**Instrucciones del workflow:**
Crea un workflow con dos jobs:
1.  **Saludo Personalizado**: Llama a la acción proporcionando un nombre específico.
2.  **Saludo Genérico**: Llama a la acción sin proporcionar el input `nombre`.

### Resultado Esperado:
- El primer job imprime un saludo con el nombre proporcionado (ej. "¡Hola, Octocat!").
- El segundo job imprime el saludo por defecto "¡Hola, Mundo!".
- Si publicaras la acción, mostraría un ícono de círculo de mensaje de color azul.

---

## Desafío 3: Resolución de Problemas - Metadatos Rotos
Has recibido una acción que no funciona. El workflow que intenta usarla falla con errores confusos. Tu tarea es diagnosticar y corregir los errores en el archivo `action.yml`.

**Archivos de apoyo (proporcionados por ti):**
- `broken-action/action.yml`
- `.github/workflows/debug-action.yml`

**Contenido de `broken-action/action.yml` (con errores):**
```yaml
# broken-action/action.yml
name: 'Calculadora de Descuento'
description: 'Calcula el precio final aplicando un descuento.'

imputs:
  precio-base:
    description: 'Precio original del producto'
    required: true
  porcentaje-descuento:
    description: 'Porcentaje de descuento a aplicar (ej. 15 para 15%)'
    required: true
    default: 10

outputs:
  precio-final
    description: 'El precio calculado después del descuento.'

runs:
  using: 'composite'
  steps:
    - name: Calcular Descuento
      id: calcular
      shell: bash
      run: |
        precio_final=$(echo "$(( ${{ inputs.precio-base }} * (100 - ${{ inputs.porcentaje-descuento }}} ) / 100))"
        echo "::set-output name=precio-final::$precio_final"
```

**Contenido de `.github/workflows/debug-action.yml`:**
```yaml
# .github/workflows/debug-action.yml
name: Debug Action Metadata

on: workflow_dispatch

jobs:
  test-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Usar acción rota
        id: descuento
        uses: ./broken-action
        with:
          precio-base: '200'
          porcentaje-descuento: '25'
      - name: Mostrar resultado
        run: echo "El precio con descuento es ${{ steps.descuento.outputs.precio-final }}"
```

**Instrucciones del desafío:**
1.  Ejecuta el workflow `debug-action.yml` y observa los errores.
2.  Revisa cuidadosamente el archivo `broken-action/action.yml` en busca de errores de sintaxis y lógicos.
3.  Corrige los problemas para que el workflow se ejecute correctamente.

**Pistas:**
- La sintaxis de YAML es sensible a la indentación y a las palabras clave. ¿Están todas las claves bien escritas?
- ¿Cómo se definen correctamente los `outputs`?
- Revisa la expresión matemática en el `run`, ¿hay algún carácter que sobre o falte?

### Resultado Esperado:
- El workflow se completa exitosamente.
- La salida del último paso muestra: "El precio con descuento es 150".
