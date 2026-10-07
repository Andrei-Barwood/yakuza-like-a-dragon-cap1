# Guía de Laboratorio — Episodio 10: Alianza con Adachi y Nick Ogata (`10_rescate_en_la_calle`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 10
```

## Salida Orientativa
```text
======================================================================
EPISODIO 10: ALIANZA CON ADACHI Y NICK OGATA
Slug: 10_rescate_en_la_calle
======================================================================

Eventos registrados (7):
  01. story.scenario_started [ichiban]  (escena: unspecified) | {:episode=>"10_rescate_en_la_calle"}
  02. story.scene_transition [ichiban]  (escena: pink_street_alley_cry) | {:to_scene=>"pink_street_alley_cry", :location=>"Callejón de Pink Street"}
  03. story.combat_resolved [ichiban] -> [street_extortionists] (escena: brawl_protecting_nick) | {:assisted_by=>:adachi, :victory=>true}
  04. story.item_acquired [ichiban] -> [nick_ogata] (escena: ogata_gratitude) | {:item=>:nick_ogata_business_card}
  05. story.party_member_joined [adachi] -> [ichiban] (escena: adachi_party_pact) | {:role=>:partner}
  06. story.objective_started [ichiban]  (escena: adachi_party_pact) | {:goal=>"infiltrate_through_sewers"}
  07. story.scenario_completed [ichiban]  (escena: adachi_party_pact) | {:episode=>"10_rescate_en_la_calle", :final_location=>"Frente a la reja de alcantarillado"}

Estado final:
  Ubicación: Frente a la reja de alcantarillado
  Hora/Periodo: 2019 - Atardecer
  Dinero: ¥3500
  Inventario: [:nick_ogata_business_card]
  Flags: {:nick_ogata_rescued=>true, :extortionists_defeated=>true, :adachi_party_joined=>true, :next_step=>:enter_underground_sewers}

Resumen:
  Episodio 10_rescate_en_la_calle completado: Ichiban y Adachi rescatan a Nick Ogata, consolidan el grupo y descubren el acceso al alcantarillado.
======================================================================
```

## Criterios Observables
- Código de salida: `0`
- Inventario contiene `:nick_ogata_business_card`.
- Adachi y Kasuga con relación `:partner`.
- Flag `:adachi_party_joined` en `true`.
