# Guía de Laboratorio — Episodio 03: Un favor en el barrio (`03_encargo_urgente`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 03
```

## Salida Orientativa
```text
======================================================================
EPISODIO 03: UN FAVOR EN EL BARRIO
Slug: 03_encargo_urgente
======================================================================

Eventos registrados (8):
  01. story.scenario_started [ichiban]  (escena: unspecified) | {:episode=>"03_encargo_urgente"}
  02. story.objective_started [ichiban]  (escena: michiyo_request) | {:task=>"resolve_shangri_la_plumbing"}
  03. story.combat_resolved [ichiban] -> [street_thugs] (escena: street_skirmish_elderly) | {:protected=>:elderly_man}
  04. story.item_acquired [ichiban]  (escena: cigarette_shop_errand) | {:item=>:heavy_duty_plunger}
  05. story.scene_transition [ichiban]  (escena: cigarette_shop_errand) | {:to_scene=>"shangri_la_resolution", :location=>"Shangri-La"}
  06. story.objective_completed [ichiban]  (escena: shangri_la_resolution) | {:resolved=>:shangri_la_toilet}
  07. story.communication_received [mitsuo] -> [ichiban] (escena: shangri_la_resolution) | {:assignment=>"collect_hiratsuka_park_3"}
  08. story.scenario_completed [ichiban]  (escena: shangri_la_resolution) | {:episode=>"03_encargo_urgente", :final_location=>"Shangri-La"}

Estado final:
  Ubicación: Shangri-La
  Hora/Periodo: 2000 - Mediodía
  Dinero: ¥202000
  Inventario: [:arakawa_pin]
  Flags: {:favor_accepted=>true, :elderly_protected=>true, :plunger_acquired=>true, :shangri_la_unclogged=>true, :mitsuo_called=>true, :next_assignment_target=>:hiratsuka}

Resumen:
  Episodio 03_encargo_urgente completado: Ichiban protege al anciano, desatasca Shangri-La con el desatascador y recibe el encargo de Mitsuo.
======================================================================
```

## Criterios Observables
- Código de salida: `0`
- Ítem `:heavy_duty_plunger` adquirido y utilizado con éxito.
- Flag `:elderly_protected` en `true`.
- Flag `:next_assignment_target` fijado a `:hiratsuka`.
- Si se intenta ingresar a la resolución de Shangri-La sin el desatascador, se lanza `IchibanLab::PreconditionError`.
