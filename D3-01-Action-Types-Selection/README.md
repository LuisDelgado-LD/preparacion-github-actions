# Concepto a Resolver: Selección de Tipos de Acción
GitHub Actions ofrece tres tipos de acciones que puedes construir: acciones de JavaScript, acciones de contenedor Docker y acciones compuestas. La elección depende de los requisitos de tu tarea, el entorno de ejecución y las dependencias que necesites. Entender las ventajas y desventajas de cada tipo es clave para crear acciones eficientes y mantenibles.

---

## Desafío 1: Identificar el Tipo de Acción Adecuado (Teórico)
**Objetivo:** Analizar una serie de escenarios y determinar qué tipo de acción (JavaScript, Docker o Compuesta) sería la más apropiada.

**Instrucciones:**
Para cada uno de los siguientes escenarios, decide el tipo de acción más adecuado y justifica tu elección. No necesitas escribir código, solo el razonamiento.

-   **Escenario A:** Necesitas crear una acción que interactúe directamente con las APIs de GitHub (por ejemplo, para añadir una etiqueta a un issue) y que se ejecute de la forma más rápida posible en los runners hospedados por GitHub.

-   **Escenario B:** Tu acción necesita un conjunto específico de herramientas y dependencias que no están preinstaladas en los runners de GitHub (por ejemplo, una versión específica de `ffmpeg` y `ImageMagick`). Quieres asegurarte de que el entorno sea idéntico cada vez que se ejecuta, sin importar el runner.

-   **Escenario C:** Quieres agrupar una secuencia de varios pasos de `run` y acciones existentes en una única acción reutilizable para simplificar tus workflows. No quieres gestionar un entorno de Docker ni escribir código en JavaScript.

### Resultado Esperado:
-   **Escenario A:**
    -   **Tipo de Acción:** JavaScript.
    -   **Justificación:** Las acciones de JavaScript son ideales para tareas que interactúan con la API de GitHub y son más rápidas que las acciones de Docker porque no tienen la sobrecarga de construir o descargar una imagen de contenedor. Se ejecutan directamente en la máquina del runner.

-   **Escenario B:**
    -   **Tipo de Acción:** Contenedor Docker.
    -   **Justificación:** Las acciones de Docker encapsulan su propio entorno, incluyendo todas las herramientas y dependencias necesarias. Esto garantiza la portabilidad y la consistencia, ya que el entorno es el mismo sin importar dónde se ejecute la acción.

-   **Escenario C:**
    -   **Tipo de Acción:** Compuesta.
    -   **Justificación:** Las acciones compuestas están diseñadas precisamente para este propósito: agrupar múltiples pasos de workflow en una unidad reutilizable. Son una forma sencilla de reducir la duplicación de código en los workflows sin la complejidad de los otros tipos de acciones.

---

## Desafío 2: Cuándo NO Usar un Tipo de Acción (Teórico)
**Objetivo:** Identificar las limitaciones y desventajas de cada tipo de acción para evitar elegirlas en escenarios inadecuados.

**Instrucciones:**
Para cada tipo de acción, describe un escenario en el que sería una mala elección.

-   **Escenario para NO usar JavaScript:**

-   **Escenario para NO usar Docker:**

-   **Escenario para NO usar Compuesta:**

### Resultado Esperado:
-   **NO usar JavaScript:** Sería una mala elección si tu acción requiere dependencias del sistema operativo que no están disponibles en los runners estándar (ej. una librería C específica) o si necesitas un control total sobre el sistema operativo y el entorno de ejecución. Además, solo se ejecutan en runners Linux, Windows y macOS, no en otros sistemas operativos si se usaran self-hosted runners.

-   **NO usar Docker:** Sería una mala elección para tareas muy simples y rápidas que no tienen dependencias externas (ej. una simple llamada a una API). La sobrecarga de tiempo de inicio del contenedor haría que el workflow fuera innecesariamente lento. Además, las acciones de Docker solo se pueden ejecutar en runners de Linux.

-   **NO usar Compuesta:** Sería una mala elección si necesitas escribir lógica compleja que no se puede expresar fácilmente con una secuencia de comandos de shell o acciones existentes. Tampoco puedes usar una acción compuesta para publicar en el GitHub Marketplace directamente si contiene lógica que deba ser privada o si quieres anidar acciones compuestas (aunque puedes llamar a otras acciones).
