# Concepto a Resolver: Configuraciones de Job con Matriz (Matrix)
Una matriz de estrategia de jobs te permite usar variables en la definición de un job para crear automáticamente múltiples ejecuciones de jobs basadas en las combinaciones de las variables. Por ejemplo, puedes usar una matriz para probar tu código en múltiples versiones de un lenguaje o en diferentes sistemas operativos.

---

## Desafío 1: Creación de una Matriz de Build Simple
Tu objetivo es crear un workflow que compile una aplicación simple (simulada) en diferentes versiones de Python.

**Archivos a crear por el estudiante:**
- `.github/workflows/matrix-build.yml`
- `app/main.py`

**Contenido de los archivos de apoyo (proporcionados por ti):**
```python
# app/main.py
import sys

def main():
    print(f"Hola desde Python {sys.version}")

if __name__ == "__main__":
    main()
```

**Instrucciones del workflow:**
Tu workflow `.github/workflows/matrix-build.yml` debe:
- Activarse en un `push` a la rama `main`.
- Contener un job llamado `build`.
- Configurar una matriz de estrategia para el job `build` que incluya las siguientes versiones de Python: `3.8`, `3.9`, y `3.10`.
- El job debe ejecutarse en `ubuntu-latest`.
- Incluir un paso para hacer checkout del código.
- Incluir un paso que use la acción `actions/setup-python` para configurar la versión de Python según la variable de la matriz.
- Incluir un paso que ejecute el script `app/main.py` usando el intérprete de Python configurado.

### Resultado Esperado:
- Al hacer push a `main`, se inician tres jobs en paralelo.
- Cada job utiliza una de las versiones de Python especificadas (`3.8`, `3.9`, `3.10`).
- El log de cada job muestra el mensaje "Hola desde Python" seguido de la versión correspondiente.

---

## Desafío 2: Expandiendo la Matriz con Múltiples Sistemas Operativos
Ahora, ampliarás la matriz para que las pruebas se ejecuten no solo en diferentes versiones de Python, sino también en diferentes sistemas operativos.

**Archivos a crear por el estudiante:**
- (Modificar el archivo `.github/workflows/matrix-build.yml` del desafío anterior)

**Archivos de apoyo (proporcionados por ti):**
- (Ninguno, se reutiliza `app/main.py`)

**Instrucciones del workflow:**
Modifica tu workflow `.github/workflows/matrix-build.yml` para:
- Añadir una nueva variable `os` a la matriz de estrategia.
- La variable `os` debe incluir `ubuntu-latest` y `windows-latest`.
- El job debe usar la variable `os` de la matriz para definir su `runs-on`.

### Resultado Esperado:
- Al hacer push a `main`, se inician seis jobs en paralelo (3 versiones de Python x 2 sistemas operativos).
- Verás ejecuciones para cada combinación, por ejemplo: `build (3.8, ubuntu-latest)`, `build (3.8, windows-latest)`, etc.
- Todos los jobs se completan con éxito.

---

## Desafío 3: Excluir Configuraciones Específicas de la Matriz
A veces, no todas las combinaciones de una matriz son válidas o necesarias. Aprenderás a excluir configuraciones específicas.

**Archivos a crear por el estudiante:**
- (Modificar el archivo `.github/workflows/matrix-build.yml`)

**Archivos de apoyo (proporcionados por ti):**
- (Ninguno)

**Instrucciones del workflow:**
Modifica tu workflow `.github/workflows/matrix-build.yml` para:
- Añadir una sección `exclude` a la estrategia de la matriz.
- Excluir la combinación específica de Python `3.8` en `windows-latest`.

### Resultado Esperado:
- Al hacer push a `main`, se inician solo cinco jobs.
- El job para la combinación `(3.8, windows-latest)` no se crea y no se ejecuta.
- Los otros cinco jobs se ejecutan y completan con éxito.

---

## Desafío 4: Debugging de un Workflow con Matriz
Se te proporciona un workflow con una matriz que no funciona como se espera. Tu tarea es identificar y solucionar los problemas.

**Archivos a crear por el estudiante:**
- (Ninguno, debes corregir el workflow proporcionado)

**Archivos de apoyo (proporcionados por ti):**
```yaml
# .github/workflows/debug-matrix.yml
name: Debug Matrix Workflow
on: workflow_dispatch

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        python-version: [3.8, 3.9]
        os: [ubuntu-latest, macos-latest]
        include:
          - os: windows-latest
            python-version: 3.9
            experimental: true
    
    steps:
    - uses: actions/checkout@v3
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}

    - name: Display Python version
      run: python --version
      
    - name: Run only on experimental
      if: matrix.experimental == true
      run: echo "Running experimental test on Windows!"

```

**Instrucciones:**
1.  Crea el archivo `.github/workflows/debug-matrix.yml` con el contenido anterior.
2.  Ejecútalo manualmente.
3.  Observa los resultados y los logs en la pestaña "Actions". El objetivo es que todos los jobs se ejecuten correctamente y que el paso "Run only on experimental" solo se ejecute en la configuración de Windows.

**Pistas:**
- La condición `if` para el paso experimental parece correcta, pero ¿está la variable `experimental` disponible en las otras configuraciones de la matriz? Las variables añadidas a través de `include` solo existen en esa combinación específica.
- ¿Cómo se comporta una condición `if` cuando la variable que comprueba no existe en absoluto?
- Revisa la documentación de `strategy.matrix` para ver cómo manejar valores por defecto o cómo estructurar las condiciones para que no fallen en las combinaciones no experimentales.

### Resultado Esperado:
- Identificas que la condición `if: matrix.experimental == true` falla en los jobs no experimentales porque `matrix.experimental` no está definida para ellos.
- Corriges la condición para que funcione correctamente, por ejemplo, comprobando si la variable existe y es verdadera: `if: matrix.experimental`.
- Después de la corrección, los tres jobs (`(3.8, ubuntu-latest)`, `(3.9, macos-latest)`, `(3.9, windows-latest)`) se ejecutan con éxito.
- El mensaje "Running experimental test on Windows!" solo aparece en el log del job que se ejecuta en Windows.
