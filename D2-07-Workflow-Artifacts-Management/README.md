# Concepto a Resolver: Gestión de Artefactos de Workflow (Workflow Artifacts Management)
Este módulo cubre cómo persistir archivos y directorios entre trabajos en un mismo workflow y cómo descargar estos artefactos después de que la ejecución haya finalizado. Los artefactos son esenciales para compartir resultados de build, informes de pruebas o cualquier otro archivo que deba sobrevivir más allá de la vida de un único trabajo.

---

## Desafío 1: Crear y Compartir un Artefacto de Build
Un trabajo compila una aplicación simple y el artefacto resultante (un binario o un paquete) debe ser subido para que otro trabajo pueda usarlo o para que un usuario pueda descargarlo.

**Archivos a crear por el estudiante:**
- `.github/workflows/build-and-upload.yml`

**Archivos de apoyo (proporcionados por ti):**
- `main.py`
- `build.sh`

**Contenido de los archivos de apoyo:**
```python
# main.py
print("Hola, Mundo desde mi aplicación Python!")
```

```bash
# build.sh
echo "Iniciando el proceso de build..."
mkdir -p dist
echo "Creando un archivo de paquete simulado..."
cp main.py dist/
echo "Build completado. El artefacto está en la carpeta 'dist'."
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse en `push` a `main`.
- Tener dos trabajos: `build` y `package_info`.
- El trabajo `build` debe:
    - Ejecutar el script `build.sh` para crear el directorio `dist`.
    - Usar la acción `actions/upload-artifact@v4` para subir el contenido del directorio `dist` como un artefacto llamado `my-app-build`.
- El trabajo `package_info` debe:
    - Depender de `build` (`needs: build`).
    - Usar la acción `actions/download-artifact@v4` para descargar el artefacto `my-app-build`.
    - Listar el contenido del directorio descargado para verificar que los archivos están presentes.

### Resultado Esperado:
- El trabajo `build` se completa y sube un artefacto llamado `my-app-build`.
- El trabajo `package_info` se inicia, descarga el artefacto y el comando `ls` muestra el archivo `main.py` dentro del directorio `dist`.
- En la página de resumen de la ejecución del workflow, el artefacto `my-app-build` está disponible para su descarga.

---

## Desafío 2: Subir Artefactos Condicionalmente
No siempre quieres subir artefactos. Por ejemplo, podrías querer subir logs de error solo si un trabajo falla. En este desafío, configurarás un workflow que sube un artefacto solo bajo una condición específica.

**Archivos a crear por el estudiante:**
- `.github/workflows/conditional-artifacts.yml`

**Archivos de apoyo (proporcionados por ti):**
- `run_tests.sh`

**Contenido de los archivos de apoyo:**
```bash
# run_tests.sh
echo "Ejecutando pruebas críticas..."
mkdir -p logs
# Simular un fallo
echo "Error: Una prueba crítica ha fallado. Detalles en error.log" > logs/error.log
exit 1
```

**Instrucciones del workflow:**
Tu workflow debe:
- Activarse manualmente con `workflow_dispatch`.
- Contener un único trabajo `test`.
- El trabajo `test` debe:
    - Ejecutar el script `run_tests.sh`, que siempre falla y crea un archivo de log.
    - Incluir un paso que use `actions/upload-artifact@v4` para subir el directorio `logs`.
    - Este paso de subida solo debe ejecutarse si el paso anterior (`run_tests.sh`) ha fallado. Utiliza una condición `if` para lograrlo.

### Resultado Esperado:
- El workflow se ejecuta y el trabajo `test` falla.
- A pesar del fallo del trabajo, se crea un artefacto llamado `error-logs` (o el nombre que elijas).
- Si modificas el script para que no falle (`exit 0`), el artefacto no debe ser subido en la siguiente ejecución.

---

## Desafío 3: Resolución de Problemas - Artefacto no Encontrado en el Siguiente Trabajo
Un workflow está diseñado para que un trabajo produzca un artefacto y otro lo consuma, pero el segundo trabajo falla porque no puede encontrar el artefacto.

**Archivos a crear por el estudiante:**
- El estudiante debe **corregir** el siguiente archivo.

**Archivos de apoyo (proporcionados por ti):**
- `.github/workflows/debug-artifacts.yml`

**Contenido del workflow con errores:**
```yaml
# .github/workflows/debug-artifacts.yml
name: Debugging Artifacts
on: push

jobs:
  creator:
    runs-on: ubuntu-latest
    steps:
      - name: Create a file
        run: echo "hello from creator" > my-file.txt

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: my-special-artifact # Nombre correcto
          path: my-file.txt

  consumer:
    runs-on: ubuntu-latest
    # Falta una dependencia clave aquí
    steps:
      - name: Download artifact
        uses: actions/download-artifact@v4
        with:
          # El nombre aquí es incorrecto
          name: my-artifact

      - name: Check file content
        run: cat my-file.txt
```

**El Problema:**
El trabajo `consumer` falla con un error que indica que el artefacto `my-artifact` no se pudo encontrar. Hay dos problemas en este workflow.

**Pistas:**
1.  ¿En qué orden se ejecutan los trabajos en un workflow por defecto? Si `consumer` necesita algo de `creator`, ¿deberías especificar esa relación explícitamente?
2.  Revisa los nombres de los artefactos. La acción `upload-artifact` y `download-artifact` deben usar exactamente el mismo `name`. ¿Hay alguna discrepancia?
3.  La falta de una cláusula `needs` es un error común que causa problemas de concurrencia y dependencia.

### Resultado Esperado:
- Identificas que al trabajo `consumer` le falta una dependencia `needs: creator`, lo que causa que se ejecute en paralelo y, por lo tanto, el artefacto aún no exista cuando intenta descargarlo.
- Descubres que el nombre del artefacto en el trabajo `consumer` (`my-artifact`) no coincide con el nombre usado en el trabajo `creator` (`my-special-artifact`).
- Corriges el workflow añadiendo `needs: creator` al trabajo `consumer` y unificando el nombre del artefacto.
- El workflow corregido se ejecuta con éxito, y el trabajo `consumer` descarga y muestra el contenido del archivo.
