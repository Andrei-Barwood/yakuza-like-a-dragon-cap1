# Briefing — Episodio 05: Una noche para Masato (`05_el_joven_maestro`)

## Propósito

Modelar la noche de servicio de Ichiban para Masato Arakawa ("El Joven Maestro"), hijo del patriarca Masumi Arakawa en silla de ruedas. La secuencia expone el contraste entre la posición de Masato y la devoción sumisa de Ichiban: llevarlo a un club de anfitrionas, lidiar con el capricho respecto a la anfitriona Yumeno, presenciar la humillación ante el cliente influyente Horinouchi, y escuchar inadvertidamente la verdad sobre la superficialidad del afecto de Yumeno hacia Masato. Culmina con Masato marchándose enfurecido y dejando su cartera a Ichiban para que cubra la cuenta del local.

## Canon incluido y límites
- **Incluido:**
  - Reunión con Masato Arakawa y escolta en silla de ruedas hacia el club nocturno.
  - Búsqueda de Yumeno en el club por encargo de Masato.
  - Incidente en el salón VIP: enfrentamiento verbal/tensión con el comisario/político Horinouchi.
  - Conversación secreta escuchada por Ichiban: Yumeno y sus compañeras revelan que solo fingen afecto por el dinero de Masato y desprecian su condición física.
  - Reacción y partida de Masato: lanza su cartera a Ichiban para pagar el consumo de la noche y se retira en solitario.
  - Ichiban salda la cuenta con los fondos de Masato y custodia la cartera.
- **Fuera de alcance:**
  - El regreso a la oficina y la reprimenda de Sawashiro (ocurre en el episodio 06).
  - La conversación de la cena sobre el pasado de Arakawa e Ichiban (episodio 06).
  - La mañana del tiroteo (episodio 07).

## Estado de entrada
- **Época:** 2000 - Noche.
- **Ubicación:** Kamurocho - Calles hacia el Hostess Club.
- **Personajes presentes:**
  - `ichiban`: Escolta y subordinado.
  - `masato`: Joven maestro de la familia Arakawa, postrado en silla de ruedas, orgulloso y temperamental.
- **Precondiciones:** Llamada de Sawashiro recibida (`sawashiro_summons => true`).

## Estado final esperado
- Masato se ha marchado del local (`masato_departed => true`).
- Cartera de Masato recibida y cuenta pagada (`masato_wallet_held => true`, `club_bill_paid => true`).
- Revelación sobre Yumeno registrada en la memoria de Ichiban (`heard_yumeno_truth => true`).
- No se filtran conocimientos sobre los eventos posteriores ni interpretaciones omniscientes.
