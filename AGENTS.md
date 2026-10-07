# Reglas y Guía para Agentes — Laboratorio Narrativo Yakuza: Like a Dragon (Capítulo 1)

Este documento condensa los principios operativos y de diseño para cualquier intervención técnica en este repositorio.

## 1. Misión y Alcance
- Construir y mantener un laboratorio narrativo en Ruby para modelar las escenas y continuidad del **Capítulo 1: Light and Shadow** de *Yakuza: Like a Dragon*.
- Es un simulador narrativo y de decisiones comprobables, **no** un motor de RPG completo, ni un port del juego, ni una copia literal de diálogos o wikis.
- Rango cerrado de episodios: `01` a `07` (desde el prólogo de Masumi hasta el ingreso de Ichiban en prisión). No se modela contenido del capítulo 2 en adelante.

## 2. Idioma y Nomenclatura
- **Documentación, comentarios narrativos, prompts y mensajes de salida:** Español.
- **Código Ruby, clases, métodos, variables y tests:** Inglés.
- Nombres de eventos estables: `story.objective_started`, `story.item_acquired`, `story.choice_recorded`, `story.combat_resolved`, `story.chapter_boundary`, etc.

## 3. Modelo de Dominio y Calidad
- Separar reglas de dominio (`lib/ichiban_lab/`), orquestación de episodios (`lib/ichiban_lab/scenarios/`) y presentación (`bin/episodio`).
- No utilizar metáforas ajenas (sin terminología de ciberseguridad, NERV o sistemas de combate genéricos irrelevantes).
- Simulación determinista por defecto; cualquier componente estocástico debe permitir inyección de semilla fija para tests reproducibles.
- Los tests deben verificar transiciones de estado, eventos emitidos y decisiones, no meras cadenas de texto impresas.
- Precondiciones no cumplidas deben generar errores de dominio explícitos (`IchibanLab::PreconditionError`), nunca fallos silenciosos o defaults enmascarados.

## 4. Códigos de Salida CLI (`bin/episodio`)
- **`0`**: Escenario ejecutado con éxito técnico (independientemente de que el desenlace narrativo sea trágico o adverso).
- **`2`**: Error de ejecución, episodio no implementado o estado inconsistente del simulador.
- **`3`**: Uso incorrecto de argumentos o identificador de episodio desconocido (fuera del catálogo `01`..`07`).

## 5. Continuidad y Delimitación
- El prólogo de Masumi Arakawa (`ep01`) se mantiene cronológicamente aislado de la línea adulta de Ichiban (`ep02` a `ep07`).
- Cada episodio recibe únicamente el estado que su contrato exige y produce un estado comprobable sin adelantar hechos futuros.
- Actualizar siempre `prompts/ESTADO.txt` al completar fases o episodios.
