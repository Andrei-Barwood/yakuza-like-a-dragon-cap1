# Secuencia de Escenas — Episodio 01: La primera deuda (`01_origen`)

## Escena 1: `theatre_dressing_room` (Camerino teatral)
- **Ubicación:** Teatro ambulante / camerino.
- **Participantes:** `masumi` (niño), `toshio` (padre).
- **Objetivo:** Concluir la función teatral y compartir el momento de calidez entre padre e hijo.
- **Acciones:**
  - `finish_performance`: Toshio felicita a Masumi y promete una comida caliente.
- **Transición:** Conduce a `dinner_at_eatery`.

## Escena 2: `dinner_at_eatery` (La cena de felicitación)
- **Ubicación:** Restaurante popular tradicional.
- **Participantes:** `masumi`, `toshio`.
- **Precondiciones:** La función debe haberse completado (`performance_finished`).
- **Objetivo:** Compartir los platos sencillos y escuchar las palabras de Toshio sobre el valor del esfuerzo.
- **Acciones:**
  - `share_meal`: Disfrutan de la comida, Toshio entrega a Masumi un amuleto/recuerdo familiar.
- **Transición:** Conduce a `dark_alleyway_ambush`.

## Escena 3: `dark_alleyway_ambush` (La emboscada)
- **Ubicación:** Callejón oscuro a la salida del restaurante.
- **Participantes:** `masumi`, `toshio`, `assassin` (asaltante armado).
- **Precondiciones:** La cena debe haber finalizado.
- **Objetivo:** Afrontar el repentino ataque en las sombras.
- **Acciones:**
  - `protect_child`: Toshio interpone su cuerpo para proteger a Masumi del agresor.
  - `fatal_strike`: El agresor dispara / ataca mortalmente a Toshio y huye en la noche.
- **Transición:** Conduce a `prologue_aftermath`.

## Escena 4: `prologue_aftermath` (El peso de la pérdida)
- **Ubicación:** Callejón bajo la lluvia/noche.
- **Participantes:** `masumi`, `toshio` (inmóvil).
- **Precondiciones:** El ataque fatal debe haberse registrado.
- **Objetivo:** Registrar el quiebre emocional de Masumi y el juramento tácito que marcará su vida.
- **Acciones:**
  - `record_vow`: Masumi abraza el legado de su padre y queda solo en el mundo.
