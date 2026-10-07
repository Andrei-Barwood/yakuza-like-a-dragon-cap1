# Briefing — Episodio 10: Alianza con Adachi y Nick Ogata (`10_rescate_en_la_calle`)

## Propósito

Modelar el encuentro clave con el misterioso inversor internacional Nick Ogata y la consolidación de la alianza formal entre Ichiban Kasuga y Koichi Adachi como compañeros inseparables de combate. Este episodio introduce la mecánica de grupo (party) y el primer contacto que marcará el futuro financiero y de supervivencia de Ichiban.

## Canon incluido y límites
- **Incluido:**
  - Búsqueda de una ruta de acceso hacia la cumbre de la Omi.
  - Incidente callejero: Nick Ogata es acorralado y extorsionado violentamente por matones de Kamurocho.
  - Intervención física de Ichiban.
  - Llegada y apoyo de Koichi Adachi en el combate.
  - Derrota contundente de los extorsionadores.
  - Gratitud de Nick Ogata: entrega de su tarjeta de negocios personal (`:nick_ogata_business_card`) y promesa de corresponder en el futuro.
  - Pacto formal entre Ichiban y Adachi: Adachi busca atrapar al comisario corrupto Horinouchi y a Arakawa; Ichiban busca descubrir la verdad sobre su padre sustituto. Se unen como grupo permanente.
- **Fuera de alcance:**
  - La navegación por el alcantarillado (episodio 11).
  - El asalto y la lucha contra Sawashiro (episodio 12).

## Estado de entrada
- **Época:** 2019 - Atardecer.
- **Ubicación:** Callejones de Pink Street (Kamurocho).
- **Personajes presentes:**
  - `ichiban`: Investigando en la ciudad.
  - `adachi`: Aliado en la zona.
- **Precondiciones:** Objetivo de encontrar acceso a la cumbre activo (`next_objective == :find_way_into_summit`).

## Estado final esperado
- Nick Ogata rescatado (`nick_ogata_rescued => true`).
- Posesión de la tarjeta de Nick Ogata (`:nick_ogata_business_card` en inventario).
- Adachi unido formalmente al equipo (`adachi_party_joined => true`, relación `:partner`).
- Ruta de acceso descubierta por Adachi: los conductos subterráneos (`next_step => :enter_underground_sewers`).
