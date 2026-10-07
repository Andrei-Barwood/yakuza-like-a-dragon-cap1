# Guía de Laboratorio — Episodio 05: Una noche para Masato (`05_el_joven_maestro`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 05
```

## Salida Orientativa
```text
======================================================================
EPISODIO 05: UNA NOCHE PARA MASATO
Slug: 05_el_joven_maestro
======================================================================

Eventos registrados (9):
  01. story.scenario_started [ichiban]  (escena: unspecified) | {:episode=>"05_el_joven_maestro"}
  02. story.objective_started [ichiban]  (escena: escorting_masato) | {:task=>"escort_masato", :destination=>"Hostess Club"}
  03. story.scene_transition [ichiban]  (escena: escorting_masato) | {:to_scene=>"hostess_club_lounge", :location=>"Hostess Club - Salón VIP"}
  04. story.scene_transition [ichiban]  (escena: hostess_club_lounge) | {:to_scene=>"overhearing_backstage", :location=>"Pasillo de servicio del club"}
  05. story.information_revealed [ichiban] -> [yumeno] (escena: overhearing_backstage) | {:fact=>"yumeno_exploits_masato"}
  06. story.scene_transition [ichiban]  (escena: overhearing_backstage) | {:to_scene=>"masato_departure_and_bill", :location=>"Entrada del club"}
  07. story.item_acquired [ichiban] -> [masato] (escena: masato_departure_and_bill) | {:item=>:masato_wallet}
  08. story.payment_made [ichiban]  (escena: masato_departure_and_bill) | {:expense=>:club_bill, :amount=>80000, :source=>:masato_wallet}
  09. story.character_departed [masato]  (escena: masato_departure_and_bill) | {:reason=>"humiliation_and_anger"}
  10. story.scenario_completed [ichiban]  (escena: masato_departure_and_bill) | {:episode=>"05_el_joven_maestro", :final_location=>"Entrada del club"}

Estado final:
  Ubicación: Entrada del club
  Hora/Periodo: 2000 - Noche
  Dinero: ¥252000
  Inventario: [:arakawa_pin, :masato_wallet]
  Flags: {:heard_yumeno_truth=>true, :club_bill_paid=>true, :masato_wallet_held=>true, :masato_departed=>true}

Resumen:
  Episodio 05_el_joven_maestro completado: Ichiban escolta a Masato, descubre la traición emocional de Yumeno, recibe la cartera y paga la cuenta del club.
======================================================================
```

## Criterios Observables
- Código de salida: `0`
- Inventario contiene `:masato_wallet`.
- Flag `:heard_yumeno_truth` activo.
- Masato se ha marchado (`masato_departed => true`).
- Dinero de la recaudación de Ichiban se mantiene íntegro (¥252,000).
