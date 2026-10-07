# Briefing — Episodio 06: La familia Arakawa (`06_lo_que_nos_une`)

## Propósito

Modelar el núcleo emocional y vincular del capítulo 1: la relación casi paterno-filial entre Masumi Arakawa e Ichiban Kasuga. Tras la tensa noche con Masato, Ichiban regresa a la oficina familiar con la cartera del joven maestro y la recaudación del día. Afronta la violenta reprimenda de Sawashiro, desactivada por la autoridad serena de Arakawa. Posteriormente, Arakawa invita a Ichiban a cenar fuera; en esa intimidad comparten sus pasados (el origen de la lealtad incondicional de Ichiban hacia el patriarca que salvó su vida juvenil, y las reflexiones de Arakawa). La noche culmina con una intervención conjunta en un altercado callejero en Theater Square y el regreso a descansar.

## Canon incluido y límites
- **Incluido:**
  - Llegada a la oficina del clan Arakawa; entrega de la recaudación (¥250,000 netos de la familia) y la cartera de Masato.
  - Reprimenda y castigo físico inminente por parte de Jo Sawashiro, detenido por la oportuna intervención de Masumi Arakawa.
  - Cena íntima en un restaurante tradicional (pekin duck / sopa caliente): revelación compartida de orígenes e ideales de lealtad.
  - Altercado en Theater Square: Ichiban y Arakawa neutralizan a pendencieros locales que alteran la paz.
  - Despedida de la noche: Ichiban regresa a su modesto apartamento para dormir en la víspera del año nuevo.
- **Fuera de alcance:**
  - El despertar con el tiroteo del día siguiente y el crimen de Sawashiro (pertenecen al episodio 07).
  - El ataque violento de la familia Sakaki (episodio 07).
  - Los años en prisión o el destino de Kamurocho tras el salto temporal.

## Estado de entrada
- **Época:** 2000 - Medianoche.
- **Ubicación:** Sede de la Familia Arakawa (Kamurocho).
- **Personajes presentes:**
  - `ichiban`: Devoto miembro raso, portando la cartera de Masato y la recaudación.
  - `sawashiro`: Capitán implacable de la familia.
  - `arakawa`: Patriarca de la familia Arakawa.
- **Precondiciones:** Portar la cartera de Masato (`masato_wallet_held => true`).

## Estado final esperado
- Deuda/recaudación entregada a la caja familiar (`funds_deposited => true`).
- Cartera de Masato restituida (`masato_wallet_returned => true`).
- Historias personales compartidas y vínculo fortalecido (`shared_past_revealed => true`, relación `:arakawa => :father_figure`).
- Altercado en Theater Square resuelto (`theater_square_cleared => true`).
- Ichiban se retira a descansar en su apartamento (`resting_for_night => true`).
