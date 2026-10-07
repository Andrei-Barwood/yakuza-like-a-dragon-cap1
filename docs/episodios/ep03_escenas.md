# Secuencia de Escenas — Episodio 03: Un favor en el barrio (`03_encargo_urgente`)

## Escena 1: `michiyo_request` (El encargo de Michiyo)
- **Ubicación:** Kamurocho - Exterior de Shangri-La.
- **Participantes:** `ichiban`, `michiyo`.
- **Objetivo:** Escuchar la emergencia del atasco en el baño del club y aceptar conseguir una herramienta.
- **Acciones:**
  - `accept_favor`: Ichiban accede a ir a la tienda de cigarrillos a pedir un desatascador.
- **Transición:** Conduce a `cigarette_shop_errand`.

## Escena 2: `street_skirmish_elderly` (Emboscada a un anciano en el camino)
- **Ubicación:** Nakamichi Street / calle transversal.
- **Participantes:** `ichiban`, `elderly_man`, `street_thugs` (extorsionadores).
- **Objetivo:** Intervenir y proteger al anciano que está siendo intimidado por delincuentes.
- **Acciones:**
  - `defend_elderly`: Ichiban enfrenta y noquea a los matones callejeros.
  - `thank_ichiban`: El anciano agradece la intervención y regala una bebida energética/recompensa menor.
- **Transición:** Conduce a `cigarette_shop_errand`.

## Escena 3: `cigarette_shop_errand` (La tienda de cigarrillos)
- **Ubicación:** Kamurocho - Tienda de cigarrillos tradicional.
- **Participantes:** `ichiban`, `shopkeeper`.
- **Precondiciones:** El incidente callejero debe haber sido neutralizado.
- **Objetivo:** Pedir prestado o comprar el desatascador.
- **Acciones:**
  - `acquire_plunger`: El dependiente entrega el objeto `:heavy_duty_plunger`.
- **Transición:** Conduce a `shangri_la_resolution`.

## Escena 4: `shangri_la_resolution` (Reparación y llamada de Mitsuo)
- **Ubicación:** Shangri-La.
- **Participantes:** `ichiban`, `michiyo`.
- **Precondiciones:** Ichiban debe poseer en su inventario `:heavy_duty_plunger`.
- **Objetivo:** Desatascar el inodoro y liberar el servicio.
- **Acciones:**
  - `unclog_toilet`: Se usa el desatascador; Michiyo agradece enormemente el favor.
  - `pager_call_mitsuo`: Suena el buscapersonas/teléfono; Mitsuo convoca a Ichiban para el cobro urgente a Koji Hiratsuka en Public Park 3.
