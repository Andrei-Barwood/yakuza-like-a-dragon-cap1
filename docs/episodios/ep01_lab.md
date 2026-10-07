# Guía de Laboratorio — Episodio 01: La primera deuda (`01_origen`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 01
```

## Salida Orientativa
```text
======================================================================
EPISODIO 01: LA PRIMERA DEUDA
Slug: 01_origen
======================================================================

Eventos registrados (8):
  01. story.scenario_started [masumi]  (escena: unspecified) | {:episode=>"01_origen"}
  02. story.objective_started [masumi]  (escena: theatre_dressing_room) | {:objective=>"Completar función teatral"}
  03. story.scene_transition [masumi]  (escena: theatre_dressing_room) | {:to_scene=>"dinner_at_eatery", :location=>"Restaurante tradicional"}
  04. story.meal_shared [toshio] -> [masumi] (escena: dinner_at_eatery) | {:dishes=>"Cena caliente"}
  05. story.scene_transition [masumi]  (escena: dinner_at_eatery) | {:to_scene=>"dark_alleyway_ambush", :location=>"Callejón trasero"}
  06. story.ambush_triggered [assassin] -> [toshio] (escena: dark_alleyway_ambush) | {:threat=>"Ataque con arma"}
  07. story.sacrifice_recorded [toshio] -> [masumi] (escena: dark_alleyway_ambush) | {:protection=>"Escudo humano"}
  08. story.chapter_boundary [masumi]  (escena: prologue_aftermath) | {:boundary=>"prologue_1977_end"}
  09. story.scenario_completed [masumi]  (escena: prologue_aftermath) | {:episode=>"01_origen", :final_location=>"Callejón trasero"}

Estado final:
  Ubicación: Callejón trasero
  Hora/Periodo: 1977 - Noche
  Dinero: ¥500
  Inventario: [:family_talisman]
  Flags: {:performance_finished=>true, :dinner_shared=>true, :ambush_occurred=>true, :vow_recorded=>true, :toshio_deceased=>true}

Resumen:
  Episodio 01_origen completado: Toshio Arakawa es asesinado protegiendo a su hijo Masumi.
======================================================================
```

## Criterios Observables
- Código de salida: `0`
- Toshio en estado `:deceased` y HP en 0.
- Masumi conserva el talisman y el trauma registrado.
- Aislamiento: El dinero o inventario de 1977 no pasa al episodio 02.
