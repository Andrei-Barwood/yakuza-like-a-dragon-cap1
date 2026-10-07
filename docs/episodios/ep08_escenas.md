# Secuencia de Escenas — Episodio 08: 18 años después (`08_liberacion`)

## Escena 1: `prison_gate_release` (Liberación en los portones)
- **Ubicación:** Puertas de la Prisión de Tokio.
- **Participantes:** `ichiban`.
- **Objetivo:** Cruzar los portones de la prisión tras 18 años y buscar el coche de recepción de la familia.
- **Acciones:**
  - `step_into_freedom`: Ichiban constata el silencio y la ausencia total de comitiva de bienvenida.
- **Transición:** Conduce a `adachi_approach`.

## Escena 2: `adachi_approach` (El abordaje de Adachi)
- **Ubicación:** Callejón exterior de la prisión.
- **Participantes:** `ichiban`, `adachi`.
- **Precondiciones:** Salida de prisión consumada.
- **Objetivo:** Recibir al misterioso hombre de gabardina que vigila la salida.
- **Acciones:**
  - `introduce_adachi`: Koichi Adachi se presenta como exagente de policía y le advierte sobre el peligro que corre.
- **Transición:** Conduce a `hostile_greeting_brawl`.

## Escena 3: `hostile_greeting_brawl` (Emboscada a las afueras)
- **Ubicación:** Parada exterior / cruce de caminos.
- **Participantes:** `ichiban`, `adachi`, `arakawa_thugs`.
- **Precondiciones:** Encuentro con Adachi.
- **Objetivo:** Neutralizar a los matones que llegan a silenciar a Ichiban.
- **Acciones:**
  - `repel_hostiles`: Ichiban y Adachi luchan espalda con espalda y derrotan a los agresores.
- **Transición:** Conduce a `revelation_of_the_fall`.

## Escena 4: `revelation_of_the_fall` (La caída del Clan Tojo)
- **Ubicación:** Parada de autobús / ruta a Kamurocho.
- **Participantes:** `ichiban`, `adachi`.
- **Precondiciones:** Agresores derrotados.
- **Objetivo:** Escuchar el informe de Adachi sobre el estado del mundo criminal en 2019.
- **Acciones:**
  - `reveal_betrayal`: Adachi revela la Operación 3K, la alianza de Arakawa con la Omi y la caída de Kamurocho.
  - `resolve_to_verify`: Ichiban jura regresar a Kamurocho para mirar a los ojos a su patriarca y descubrir la verdad.
