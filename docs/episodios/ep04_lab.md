# Guía de Laboratorio — Episodio 04: Cobrar sin destruir (`04_lo_que_se_debe`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 04
```

## Salida Orientativa
```text
======================================================================
EPISODIO 04: COBRAR SIN DESTRUIR
Slug: 04_lo_que_se_debe
======================================================================

Eventos registrados (7):
  01. story.scenario_started [ichiban]  (escena: unspecified) | {:episode=>"04_lo_que_se_debe"}
  02. story.objective_started [ichiban]  (escena: park_confrontation) | {:target=>:hiratsuka, :location=>"Public Park 3"}
  03. story.combat_resolved [ichiban] -> [hiratsuka] (escena: park_combat) | {:victory=>true}
  04. story.choice_recorded [ichiban]  (escena: wallet_inspection_and_mercy) | {:choice=>:spare_half_debt, :retained=>50000, :spared=>50000}
  05. story.debt_collected [ichiban] -> [hiratsuka] (escena: wallet_inspection_and_mercy) | {:amount=>50000}
  06. story.communication_received [sawashiro] -> [ichiban] (escena: sawashiro_pager_call) | {:order=>"attend_masato"}
  07. story.scenario_completed [ichiban]  (escena: sawashiro_pager_call) | {:episode=>"04_lo_que_se_debe", :final_location=>"Public Park 3"}

Estado final:
  Ubicación: Public Park 3
  Hora/Periodo: 2000 - Tarde
  Dinero: ¥252000
  Inventario: [:arakawa_pin]
  Flags: {:hiratsuka_spared=>true, :partial_collection=>true, :sawashiro_summons=>true, :next_assignment_target=>:masato}

Resumen:
  Episodio 04_lo_que_se_debe completado: Ichiban vence a Hiratsuka, retiene ¥50,000 perdonando el resto y recibe la orden de Sawashiro sobre Masato.
======================================================================
```

## Criterios Observables
- Código de salida: `0`
- Saldo final: ¥252,000 (¥202,000 + ¥50,000 cobrados).
- Hiratsuka en estado `:defeated` pero no arruinado totalmente (`:hiratsuka_spared => true`).
- Sawashiro emite la orden sobre Masato (`:sawashiro_summons => true`).
