# Guía de Laboratorio — Episodio 09: El nuevo Kamurocho (`09_el_nuevo_kamurocho`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 09
```

## Salida Orientativa
```text
======================================================================
EPISODIO 09: EL NUEVO KAMUROCHO
Slug: 09_el_nuevo_kamurocho
======================================================================

Eventos registrados (7):
  01. story.scenario_started [ichiban]  (escena: unspecified) | {:episode=>"09_el_nuevo_kamurocho"}
  02. story.scene_transition [ichiban]  (escena: tenkaichi_gate_arrival) | {:to_scene=>"tenkaichi_gate_arrival", :location=>"Kamurocho - Tenkaichi Gate"}
  03. story.scene_transition [ichiban]  (escena: old_headquarters_surveillance) | {:to_scene=>"old_headquarters_surveillance", :location=>"Callejón Nakamichi - Antigua sede"}
  04. story.combat_resolved [ichiban] -> [omi_patrol] (escena: clash_with_omi_patrol) | {:victory=>true}
  05. story.information_revealed [omi_patrol] -> [ichiban] (escena: summit_lead_discovery) | {:intel=>"arakawa_attending_omi_summit_tonight"}
  06. story.objective_started [ichiban]  (escena: summit_lead_discovery) | {:goal=>"infiltrate_omi_summit"}
  07. story.scenario_completed [ichiban]  (escena: summit_lead_discovery) | {:episode=>"09_el_nuevo_kamurocho", :final_location=>"Nakamichi Street"}

Estado final:
  Ubicación: Nakamichi Street
  Hora/Periodo: 2019 - Tarde
  Dinero: ¥3500
  Inventario: []
  Flags: {:kamurocho_entered=>true, :old_office_inspected=>true, :omi_patrol_defeated=>true, :summit_meeting_discovered=>true, :next_objective=>:find_way_into_summit}

Resumen:
  Episodio 09_el_nuevo_kamurocho completado: Ichiban explora el Kamurocho ocupado por la Omi y descubre que Arakawa presidirá la cumbre de esta noche.
======================================================================
```

## Criterios Observables
- Código de salida: `0`
- Patrulla Omi derrotada en combate.
- Banderas `:summit_meeting_discovered` y `:next_objective => :find_way_into_summit` registradas.
