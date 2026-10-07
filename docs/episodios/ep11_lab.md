# Guía de Laboratorio — Episodio 11: Los conductos subterráneos (`11_los_bajos_fondos`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 11
```

## Salida Orientativa
```text
======================================================================
EPISODIO 11: LOS CONDUCTOS SUBTERRÁNEOS
Slug: 11_los_bajos_fondos
======================================================================

Eventos registrados (6):
  01. story.scenario_started [ichiban]  (escena: unspecified) | {:episode=>"11_los_bajos_fondos"}
  02. story.scene_transition [ichiban]  (escena: sewer_descent) | {:to_scene=>"sewer_descent", :location=>"Alcantarillado de Kamurocho"}
  03. story.combat_resolved [ichiban] -> [omi_tunnel_guards] (escena: underground_security_checkpoint) | {:assisted_by=>:adachi, :victory=>true}
  04. story.objective_completed [ichiban]  (escena: maintenance_hatch_breach) | {:action=>"force_maintenance_hatch"}
  05. story.scene_transition [ichiban]  (escena: building_basement_arrival) | {:to_scene=>"building_basement_arrival", :location=>"Sótano del Edificio de la Cumbre"}
  06. story.scenario_completed [ichiban]  (escena: building_basement_arrival) | {:episode=>"11_los_bajos_fondos", :final_location=>"Sótano del Edificio de la Cumbre"}

Estado final:
  Ubicación: Sótano del Edificio de la Cumbre
  Hora/Periodo: 2019 - Noche
  Dinero: ¥3500
  Inventario: [:nick_ogata_business_card]
  Flags: {:sewer_navigated=>true, :sewer_guards_defeated=>true, :access_hatch_opened=>true, :building_infiltrated=>true, :next_step=>:storm_executive_floor}

Resumen:
  Episodio 11_los_bajos_fondos completado: Infiltración subterránea exitosa a través del alcantarillado hasta los cimientos del edificio de la cumbre.
======================================================================
```

## Criterios Observables
- Código de salida: `0`
- Ubicación final: `"Sótano del Edificio de la Cumbre"`.
- Banderas `:building_infiltrated` y `:access_hatch_opened` en `true`.
