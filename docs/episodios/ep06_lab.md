# Guía de Laboratorio — Episodio 06: La familia Arakawa (`06_lo_que_nos_une`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 06
```

## Salida Orientativa
```text
======================================================================
EPISODIO 06: LA FAMILIA ARAKAWA
Slug: 06_lo_que_nos_une
======================================================================

Eventos registrados (9):
  01. story.scenario_started [ichiban]  (escena: unspecified) | {:episode=>"06_lo_que_nos_une"}
  02. story.item_returned [ichiban] -> [arakawa] (escena: office_reprimand) | {:item=>:masato_wallet}
  03. story.funds_deposited [ichiban] -> [arakawa_family] (escena: office_reprimand) | {:amount=>250000}
  04. story.conflict_defused [arakawa] -> [sawashiro] (escena: office_reprimand)
  05. story.scene_transition [ichiban]  (escena: office_reprimand) | {:to_scene=>"intimate_dinner_talk", :location=>"Restaurante tradicional"}
  06. story.bond_deepened [arakawa] -> [ichiban] (escena: intimate_dinner_talk) | {:bond=>:father_son_loyalty}
  07. story.scene_transition [ichiban]  (escena: intimate_dinner_talk) | {:to_scene=>"theater_square_brawl", :location=>"Kamurocho - Theater Square"}
  08. story.combat_resolved [ichiban] -> [delinquents] (escena: theater_square_brawl) | {:assisted_by=>:arakawa}
  09. story.scene_transition [ichiban]  (escena: theater_square_brawl) | {:to_scene=>"apartment_retirement", :location=>"Apartamento de Ichiban"}
  10. story.scenario_completed [ichiban]  (escena: apartment_retirement) | {:episode=>"06_lo_que_nos_une", :final_location=>"Apartamento de Ichiban"}

Estado final:
  Ubicación: Apartamento de Ichiban
  Hora/Periodo: 2000 - Fin de la noche
  Dinero: ¥2000
  Inventario: [:arakawa_pin]
  Flags: {:funds_deposited=>true, :masato_wallet_returned=>true, :arakawa_intervened=>true, :shared_past_revealed=>true, :theater_square_cleared=>true, :resting_for_night=>true}

Resumen:
  Episodio 06_lo_que_nos_une completado: Arakawa frena a Sawashiro, comparte la cena con Ichiban, resuelven la pelea en Theater Square e Ichiban descansa.
======================================================================
```

## Criterios Observables
- Código de salida: `0`
- Cartera de Masato entregada (no está presente en el inventario final).
- Fondos de cobranza depositados (dinero final personal de Ichiban: ¥2,000).
- Relación de Ichiban con Arakawa establecida en `:father_figure`.
- Flag `:resting_for_night` en `true`.
