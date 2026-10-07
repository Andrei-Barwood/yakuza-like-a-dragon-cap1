# Guía de Laboratorio — Episodio 08: 18 años después (`08_liberacion`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 08
```

## Salida Orientativa
```text
======================================================================
EPISODIO 08: 18 AÑOS DESPUÉS
Slug: 08_liberacion
======================================================================

Eventos registrados (7):
  01. story.scenario_started [ichiban]  (escena: unspecified) | {:episode=>"08_liberacion"}
  02. story.prison_release [ichiban]  (escena: prison_gate_release) | {:year=>2019, :years_served=>18}
  03. story.character_introduced [adachi] -> [ichiban] (escena: adachi_approach) | {:role=>:ex_detective}
  04. story.combat_resolved [ichiban] -> [arakawa_thugs] (escena: hostile_greeting_brawl) | {:assisted_by=>:adachi, :victory=>true}
  05. story.information_revealed [adachi] -> [ichiban] (escena: revelation_of_the_fall) | {:news=>"arakawa_betrayal_and_omi_rise"}
  06. story.objective_started [ichiban]  (escena: revelation_of_the_fall) | {:goal=>"return_to_kamurocho"}
  07. story.scenario_completed [ichiban]  (escena: revelation_of_the_fall) | {:episode=>"08_liberacion", :final_location=>"Ruta hacia Kamurocho"}

Estado final:
  Ubicación: Ruta hacia Kamurocho
  Hora/Periodo: 2019 - Día
  Dinero: ¥500
  Inventario: []
  Flags: {:released_from_prison=>true, :adachi_contacted=>true, :ambush_survived=>true, :heard_arakawa_betrayal=>true, :destination=>:kamurocho}

Resumen:
  Episodio 08_liberacion completado: Ichiban sale tras 18 años, repele una emboscada junto a Adachi y descubre la supuesta traición de Arakawa.
======================================================================
```

## Criterios Observables
- Código de salida: `0`
- Año: 2019.
- Adachi contactado y noticia de la traición registrada (`heard_arakawa_betrayal => true`).
- Destino fijado hacia Kamurocho.
