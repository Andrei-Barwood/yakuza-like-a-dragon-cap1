# Guía de Laboratorio — Episodio 02: El trabajo del día (`02_cobranza`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 02
```

## Salida Orientativa
```text
======================================================================
EPISODIO 02: EL TRABAJO DEL DÍA
Slug: 02_cobranza
======================================================================

Eventos registrados (7):
  01. story.scenario_started [ichiban]  (escena: unspecified) | {:episode=>"02_cobranza"}
  02. story.objective_started [ichiban]  (escena: streets_morning_patrol) | {:task=>"locate_and_collect_debt", :target=>:ushio}
  03. story.scene_transition [ichiban]  (escena: streets_morning_patrol) | {:to_scene=>"ushio_den_confrontation", :location=>"Callejón Nakamichi - Local clandestino"}
  04. story.combat_resolved [ichiban] -> [ushio] (escena: ushio_combat) | {:victory=>true}
  05. story.scene_transition [ichiban]  (escena: ushio_combat) | {:to_scene=>"moral_choice_reimbursement", :location=>"Callejón Nakamichi"}
  06. story.choice_recorded [ichiban]  (escena: moral_choice_reimbursement) | {:choice=>:refund_buyers, :amount_refunded=>50000}
  07. story.debt_collected [ichiban] -> [ushio] (escena: moral_choice_reimbursement) | {:amount_collected=>200000}
  08. story.scenario_completed [ichiban]  (escena: moral_choice_reimbursement) | {:episode=>"02_cobranza", :final_location=>"Callejón Nakamichi"}

Estado final:
  Ubicación: Callejón Nakamichi
  Hora/Periodo: 2000 - Mañana
  Dinero: ¥202000
  Inventario: [:arakawa_pin]
  Flags: {:target_identified=>true, :combat_resolved=>true, :buyers_reimbursed=>true, :debt_collected=>true}

Resumen:
  Episodio 02_cobranza completado: Ichiban cobra los ¥200,000 adeudados tras vencer a Ushio y reembolsa ¥50,000 a las víctimas.
======================================================================
```

## Criterios Observables
- Código de salida: `0`
- Dinero final: ¥202,000 (¥2,000 de base + ¥200,000 recaudados netos).
- Flag `:buyers_reimbursed` en `true`.
- Ushio con status `:defeated`.
