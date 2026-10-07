# Secuencia de Escenas — Episodio 05: Una noche para Masato (`05_el_joven_maestro`)

## Escena 1: `escorting_masato` (Escolta hacia el club)
- **Ubicación:** Calles de Kamurocho hacia Pink Street.
- **Participantes:** `ichiban`, `masato`.
- **Objetivo:** Trasladar a Masato con su silla de ruedas hasta el club de anfitrionas.
- **Acciones:**
  - `arrive_at_club`: Masato exige discreción y rapidez en sus pedidos.
- **Transición:** Conduce a `hostess_club_lounge`.

## Escena 2: `hostess_club_lounge` (El salón del club y Horinouchi)
- **Ubicación:** Hostess Club - Salón VIP.
- **Participantes:** `ichiban`, `masato`, `horinouchi`.
- **Precondiciones:** Llegada al club completada.
- **Objetivo:** Atender los deseos de Masato de reunirse con Yumeno.
- **Acciones:**
  - `request_yumeno`: Masato descubre que Yumeno está ocupada atendiendo al influyente cliente Horinouchi.
  - `confront_horinouchi`: Tensión pública; Horinouchi humilla sutilmente a Masato antes de retirarse.
- **Transición:** Conduce a `overhearing_backstage`.

## Escena 3: `overhearing_backstage` (La conversación entre bastidores)
- **Ubicación:** Pasillo de servicio del club.
- **Participantes:** `ichiban`, `yumeno` (anfitriona).
- **Precondiciones:** Conflicto en el salón finalizado.
- **Objetivo:** Localizar a Yumeno para que acuda a la mesa de Masato.
- **Acciones:**
  - `eavesdrop_confession`: Ichiban escucha accidentalmente a Yumeno burlándose de Masato ante otra compañera, dejando claro que solo le interesa el flujo constante de dinero y obsequios caros.
- **Transición:** Conduce a `masato_departure_and_bill`.

## Escena 4: `masato_departure_and_bill` (La marcha de Masato y la cuenta)
- **Ubicación:** Entrada del club.
- **Participantes:** `ichiban`, `masato`.
- **Precondiciones:** La verdad sobre Yumeno ha sido presenciada.
- **Objetivo:** Procesar el estallido de frustración de Masato y resolver la cuenta.
- **Acciones:**
  - `receive_masato_wallet`: Masato, resentido y furioso, arroja su lujosa cartera con dinero a Ichiban para que pague y se marcha en un taxi.
  - `settle_club_bill`: Ichiban paga la costosa factura del club (¥80,000) usando el efectivo de la cartera de Masato y conserva la cartera para devolverla en la oficina.
