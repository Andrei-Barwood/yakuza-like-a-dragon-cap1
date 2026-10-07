# Guía de Laboratorio — Episodio 07: Quince años (`07_el_precio`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 07
```

## Salida Orientativa
```text
======================================================================
EPISODIO 07: QUINCE AÑOS
Slug: 07_el_precio
======================================================================

Eventos registrados (10):
  01. story.scenario_started [ichiban]  (escena: unspecified) | {:episode=>"07_el_precio"}
  02. story.emergency_call [arakawa] -> [ichiban] (escena: new_years_awakening) | {:reason=>"urgent_crisis"}
  03. story.combat_resolved [ichiban] -> [sakaki_thugs] (escena: sakaki_family_ambush) | {:victory=>true}
  04. story.scene_transition [ichiban]  (escena: sakaki_family_ambush) | {:to_scene=>"patriarch_solemn_request", :location=>"Oficina Familia Arakawa"}
  05. story.crime_confessed_privately [arakawa]  (escena: patriarch_solemn_request) | {:true_culprit=>:sawashiro}
  06. story.choice_recorded [ichiban]  (escena: patriarch_solemn_request) | {:choice=>:accept_blame_for_family, :sacrifice=>:prison_term}
  07. story.scene_transition [ichiban]  (escena: patriarch_solemn_request) | {:to_scene=>"the_last_meal_and_surrender", :location=>"Centro de Detención de Kamurocho"}
  08. story.meal_shared [ichiban] -> [arakawa] (escena: the_last_meal_and_surrender) | {:meal=>:beef_bowl}
  09. story.legal_surrender [ichiban] -> [police] (escena: the_last_meal_and_surrender) | {:charge=>:murder_confession}
  10. story.chapter_boundary [ichiban]  (escena: the_last_meal_and_surrender) | {:chapter=>1, :status=>:concluded, :next=>:out_of_scope}
  11. story.scenario_completed [ichiban]  (escena: the_last_meal_and_surrender) | {:episode=>"07_el_precio", :final_location=>"Centro de Detención de Kamurocho"}

Estado final:
  Ubicación: Centro de Detención de Kamurocho
  Hora/Periodo: 2001 - 1 de Enero (Tarde)
  Dinero: ¥0
  Inventario: []
  Flags: {:sakaki_ambush_repelled=>true, :crime_revealed=>:sawashiro_homicide, :accepted_prison_sacrifice=>true, :last_meal_consumed=>true, :surrendered_to_police=>true, :imprisoned=>true, :chapter_1_completed=>true}

Resumen:
  Episodio 07_el_precio completado: Ichiban acepta la culpa del asesinato por Arakawa, comparte la última comida y entra en prisión. Fin del Capítulo 1.
======================================================================
```

## Criterios Observables
- Código de salida: `0` (éxito técnico del runner a pesar del desenlace trágico/adverso de la historia).
- Ubicación final: `"Centro de Detención de Kamurocho"`.
- Estado de Ichiban: `:imprisoned => true`, rol `:prisoner`.
- Evento de frontera de capítulo: `story.chapter_boundary` con `next: :out_of_scope`.
- Ningún contenido o mecánica del capítulo 2 es ejecutado.
