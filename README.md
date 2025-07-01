# 🚀 Preparación para el Examen de Certificación de GitHub Actions 🚀

¡Bienvenido a tu repositorio de preparación para el examen de Certificación de GitHub Actions! Este repositorio ha sido diseñado como una guía práctica y una colección de desafíos de codificación y depuración, enfocados en los dominios más importantes del examen.

**Tu objetivo:** Superar el examen de GitHub Actions y consolidar tus conocimientos para futuras oportunidades laborales.

---

## 🎯 Enfoque del Plan de Estudios

Este plan se centra en los dominios del examen con mayor peso porcentual y en tus necesidades específicas:

* **Dominio 1: Autoría y Mantenimiento de Flujos de Trabajo (40% del examen)**
* **Dominio 3: Autoría y Mantenimiento de Acciones (25% del examen)**
* **Dominio 2: Consumo de Flujos de Trabajo (20% del examen)**
* **Dominio 4: Implementación y Administración de Seguridad y Cumplimiento (15% del examen)**

---

## 🛡️ Niveles mínimos de cuenta requeridos por ejercicio

La siguiente tabla resume el nivel mínimo de cuenta de GitHub necesario para realizar cada ejercicio, según lo indicado en los README de cada carpeta:

| Directorio | Nivel mínimo requerido | Justificación |
|------------|-----------------------|--------------|
| D1-01-Workflow-Triggers | GitHub Free | Triggers básicos de workflow |
| D1-02-Secrets-Env-Vars | GitHub Free | Uso básico de secretos de repositorio |
| D1-05-CI-CD-Publishing | GitHub Free | Pipeline básico, publicación en registros |
| D1-07-CodeQL-Security-Scanning | GitHub Free | Escaneo de seguridad básico |
| D1-08-GitHub-Releases-Deployment | GitHub Free | Creación y gestión de releases |
| D2-08-Environment-Protections | GitHub Teams | Requiere aprobaciones manuales y entornos protegidos |
| D2-09-Matrix-Job-Configurations | GitHub Free | Configuraciones de matriz básicas |
| D2-13-Organizational-Workflow-Templates | GitHub Organizations | Requiere repositorio `.github` a nivel de organización |
| D3-02-JavaScript-Actions | GitHub Free | Creación de acciones básicas |
| D3-05-Action-Components-Structure | GitHub Free | Anatomía básica de acciones |
| D3-08-Action-Distribution-Models | GitHub Free | Distribución básica de acciones |
| D3-10-GitHub-Marketplace-Publishing | GitHub Free | Publicación en marketplace |
| D4-01-Enterprise-Actions-Distribution | GitHub Enterprise | Gestión de acciones en entorno empresarial |
| D4-02-Reusable-Components-Management | GitHub Organizations | Gestión a nivel organizacional |
| D4-03-Enterprise-Access-Control | GitHub Organizations | Control de acceso a runners y recursos organizacionales |
| D4-04-Organizational-Use-Policies | GitHub Organizations | Políticas de uso de acciones a nivel organización |
| D4-05-Runner-Management-Enterprise | GitHub Organizations | Runners auto-alojados a nivel organización |
| D4-06-IP-Allow-Lists-Configuration | GitHub Organizations | Configuración de seguridad organizacional |
| D4-08-Self-Hosted-Runner-Config | GitHub Free | El primer desafío es para runners auto-alojados a nivel de repositorio (GitHub Free); el segundo requiere organización, pero el nivel mínimo es Free |
| D4-09-Runner-Groups-Management | GitHub Organizations | Grupos de runners a nivel organización |
| D4-10-Runner-Monitoring-Troubleshooting | GitHub Organizations | API organizacional para monitoreo |
| D4-11-Enterprise-Secrets-Scope | GitHub Organizations | Secretos a nivel organización |
| D4-12-Organization-Level-Secrets | GitHub Organizations | Gestión centralizada de secretos |
| D4-13-Repository-Level-Secrets | GitHub Free | Secretos básicos de repositorio |
| ultimos ejercicios | GitHub Free | Ejercicios de práctica general |


## 🏗️ Estructura del Repositorio

Para cada concepto clave, encontrarás una carpeta dedicada que contiene:
* Un archivo `README.md` con las instrucciones detalladas del desafío.
* Una subcarpeta `.github/workflows/` con los archivos YAML de los flujos de trabajo (tanto para los desafíos de codificación como para los de depuración).
* En el caso de las acciones personalizadas, también verás la estructura de la acción (`my-js-action/`).

Asegúrate de replicar esta estructura en tu repositorio de GitHub.
---

## 🚀 Cómo Usar Este Repositorio

1.  **Clona este repositorio** o crea uno nuevo y replica la estructura de carpetas.
2.  **Navega a cada carpeta de desafío** (`D<Domain>-<Topic>-<Concept>/`).
3.  **Lee el `README.md`** dentro de cada carpeta para entender el desafío.
4.  **Crea o modifica los archivos YAML** según las instrucciones del desafío.
5.  **Haz commits y `push`** a tu repositorio para activar los flujos de trabajo.
6.  **Monitorea las ejecuciones** en la pestaña "Actions" de tu repositorio en GitHub para verificar los resultados y depurar.

¡Mucha suerte en tu preparación y en el examen! ¡Confío en tu éxito!

---
## Promps utilizados

Durante la creación de este repositorio se utilizaron diversos prompts, básicamente el trabajo se dividio en tres etapas.
1. Ánalisis del material de estudio y creación de los directorios
2. Generación de prompts genérico para la creación de los `README.md` dentro de cada directorio
3. Generación del contenido de los `README.md` y archivos asociados según lo obtenido en los pasos 1 y 2 

Debido a esto, desde la carpeta D1-06-Database-Service-Containers en adelante el contenido fue revisado de forma superficial, tanto de forma manual como automátizada utilizando agentes LLM.
Cualquier increpancia favor abrir una issue indicando el problema, si quiere puede abrir el pr asociandolo a la issue

### Promp de generación de contenido

Actúa como un experto instructor de GitHub Actions certificado. Necesito que generes desafíos prácticos para preparación de examen siguiendo estas especificaciones exactas:

**CONTEXTO DEL EXAMEN:**
- GitHub Actions Certification Exam
- Estructura basada en 4 dominios oficiales del Study Guide
- Enfoque en ejercicios hands-on simples y efectivos

**SOLICITUD ESPECÍFICA:**
- Dominio: {{DOM}}
- Módulo: {{MOD}}


**ESPECIFICACIONES TÉCNICAS:**
- Ejercicios completables en 15-30 minutos cada uno
- Sin dependencias externas complejas
- Preferencia por Python y Bash
- Enfoque práctico sin teoría excesiva
- Archivos de configuración incluidos en cada desafío

**FORMATO REQUERIDO:**
Estructura markdown con:
```markdown
# Concepto a Resolver: [TÍTULO_CONCEPTO]
[Descripción breve del concepto]

---

## Desafío: [NOMBRE_DESAFÍO]
[Descripción del ejercicio con archivos específicos a crear]

**Archivos a crear:**
- archivo1.yml
- archivo2.py

**Contenido de ejemplo:**
```[código de ejemplo]```

### Resultado Esperado:
- [Criterio 1 de éxito]
- [Criterio 2 de éxito]
- [Criterio 3 de éxito]
```

**CANTIDAD:** Genera entre 3-5 desafíos por módulo

**CALIDAD:** Cada desafío debe estar alineado con los objetivos oficiales del Study Guide y ser directamente aplicable al examen de certificación.


# UPDATE 29/06/2025
Gracias a los ejercicios de este repo, vídeos de youtube y los módulos de github de microsoft learn (que no son tan buenos la verdad), he podido obtener mi certificado de GitHub Actions. Motivo por el cual no seguiré desarrollando los ejercicios que tenía planificados.
Creo que uno de los problemas que enfrenté fue lo extenso de este path combinado con el poco tiempo que tuve para prepararme, de cerca de 2 semanas, así que los siguientes pasos son:
- Subir todos los desafíos que aún no había subido, con el fin de que si alguien quiere continuar con este path pueda hacerlo y no se quede sin repasar algún tema
- Separar los resultados que he subido a la rama main y colocarlos en la rama [resultados](https://github.com/LuisDelgado-LD/preparacion-github-actions/tree/resultados) eliminando toda referencia en la rama main. los últimos ejercicios ya los subí a esta rama 
- Subir los prompts que utilicé en la creación de este repositorio junto con otra información relevante
- **crear un nuevo repositorio** con el mismo fin, entregar herramientas para prepararse para la certificación de GitHub Actions, pero con un enfoque muy distinto

## Sobre este nuevo repositorio

Esta idea la tuve cuando llevaba poco tiempo estudiando para esta certificación, de hecho originalmente una versión abstracta vino cuando estudíe para GitHub Fundations y gracias a algún módulo de [GitHub Skills](https://github.com/skills) que me parecio muy entretenido. Claro en su momento no tenía idea pero ya empezando el curso de Actions me percaté de como hacían la magia y que mejor manera de estudiar!, sin embargo era consciente de que con tan poco tiempo no iba a poder desarrollar la idea y a la vez estudiar así que esperé a tener algo más de tiempo.
Ahora entre comillas tengo ese tiempo, así que como comenté, dejaré terminado este repo, solo con los ejercicios (que **pueden** contener errores, sobre todo en el código que brinda) sin los resultados faltantes para ponerme a trabajar en este nuevo repositorio

