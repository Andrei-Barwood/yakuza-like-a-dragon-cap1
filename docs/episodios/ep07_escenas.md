# Secuencia de Escenas — Episodio 07: Quince años (`07_el_precio`)

## Escena 1: `new_years_awakening` (Despertar de Año Nuevo y llamada)
- **Ubicación:** Apartamento de Ichiban.
- **Participantes:** `ichiban`.
- **Objetivo:** Recibir la llamada telefónica urgente del patriarca Arakawa.
- **Acciones:**
  - `answer_emergency_call`: Arakawa ordena a Ichiban personarse de inmediato en la oficina sin hablar con nadie.
- **Transición:** Conduce a `sakaki_family_ambush`.

## Escena 2: `sakaki_family_ambush` (Emboscada de la Familia Sakaki)
- **Ubicación:** Calles de Kamurocho (camino a la oficina).
- **Participantes:** `ichiban`, `sakaki_thugs` (sicarios de la familia rival).
- **Precondiciones:** Ichiban ha salido de su apartamento tras la llamada.
- **Objetivo:** Repeler a los miembros hostiles del clan rival.
- **Acciones:**
  - `repel_sakaki`: Ichiban derrota a los atacantes en combate callejero.
- **Transición:** Conduce a `patriarch_solemn_request`.

## Escena 3: `patriarch_solemn_request` (La petición solemne del Patriarca)
- **Ubicación:** Oficina de la Familia Arakawa (puerta cerrada).
- **Participantes:** `ichiban`, `arakawa`.
- **Precondiciones:** Emboscada de los Sakaki repelida.
- **Objetivo:** Escuchar la situación extrema del clan y tomar la decisión de lealtad.
- **Acciones:**
  - `explain_sawashiro_crime`: Arakawa revela que Jo Sawashiro disparó mortalmente contra un oficial del clan Sakaki.
  - `plead_sacrifice`: Arakawa se inclina y le pide a Ichiban que declare ser el autor del crimen para salvar a la familia de la aniquilación.
  - `accept_responsibility`: Ichiban acepta sin dudar, jurando proteger a la familia con su libertad.
- **Transición:** Conduce a `the_last_meal_and_surrender`.

## Escena 4: `the_last_meal_and_surrender` (La última comida y entrega)
- **Ubicación:** Puesto de comida callejera -> Comisaría de Kamurocho / Centro de Detención.
- **Participantes:** `ichiban`, `arakawa`, `police_officers`.
- **Precondiciones:** Sacrificio aceptado por Ichiban.
- **Objetivo:** Compartir la última comida y entregarse a la ley.
- **Acciones:**
  - `eat_last_meal`: Disfrutan de un tazón caliente en silencio solemne.
  - `surrender_to_police`: Ichiban entra en la comisaría confesando el asesinato.
  - `cell_bars_close`: Se cierran los barrotes de la prisión; fin del Capítulo 1.
