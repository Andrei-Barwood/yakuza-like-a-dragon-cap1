# Guía de Laboratorio — Episodio 12: Duelo con Sawashiro (`12_el_guantelete`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 12
```

## Salida Orientativa
```text
======================================================================
EPISODIO 12: DUELO CON SAWASHIRO
Slug: 12_el_guantelete
======================================================================

Eventos registrados (7):
  01. story.scenario_started [ichiban]  (escena: unspecified) | {:episode=>"12_el_guantelete"}
  02. story.scene_transition [ichiban]  (escena: stairs_breach_to_executive_floor) | {:to_scene=>"stairs_breach_to_executive_floor", :location=>"Planta Ejecutiva - Entrada"}
  03. story.scene_transition [ichiban]  (escena: sawashiro_confrontation) | {:to_scene=>"sawashiro_confrontation", :location=>"Salón Ceremonial"}
  04. story.combat_resolved [ichiban] -> [sawashiro] (escena: sawashiro_boss_duel) | {:victory=>true, :type=>:boss_duel}
  05. story.scene_transition [ichiban]  (escena: corridor_breach_to_patriarch) | {:to_scene=>"corridor_breach_to_patriarch", :location=>"Puertas del Despacho"}
  06. story.objective_completed [ichiban]  (escena: corridor_breach_to_patriarch) | {:action=>"reach_arakawa_office"}
  07. story.scenario_completed [ichiban]  (escena: corridor_breach_to_patriarch) | {:episode=>"12_el_guantelete", :final_location=>"Puertas del Despacho"}

Estado final:
  Ubicación: Puertas del Despacho
  Hora/Periodo: 2019 - Noche cerrada
  Dinero: ¥3500
  Inventario: [:nick_ogata_business_card]
  Flags: {:executive_floor_breached=>true, :sawashiro_confronted=>true, :sawashiro_boss_defeated=>true, :adachi_holding_corridor=>true, :path_to_arakawa_opened=>true}

Resumen:
  Episodio 12_el_guantelete completado: Asalto a la planta ejecutiva, Sawashiro derrotado en duelo y camino abierto al despacho de Arakawa.
======================================================================
```

## Criterios Observables
- Código de salida: `0`
- Sawashiro con status `:defeated` y HP en 0.
- Bandera `:path_to_arakawa_opened` activa.
