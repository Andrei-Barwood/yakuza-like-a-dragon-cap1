# Guía de Laboratorio — Episodio 13: Reunión sangrienta (`13_reunion_sangrienta`)

## Comando de Ejecución
```bash
ruby -Ilib bin/episodio 13
```

## Salida Orientativa
```text
======================================================================
EPISODIO 13: REUNIÓN SANGRIENTA
Slug: 13_reunion_sangrienta
======================================================================

Eventos registrados (7):
  01. story.scenario_started [ichiban]  (escena: unspecified) | {:episode=>"13_reunion_sangrienta"}
  02. story.scene_transition [ichiban]  (escena: the_patriarch_audience) | {:to_scene=>"the_patriarch_audience", :location=>"Despacho Presidencial de la Omi"}
  03. story.arakawa_betrayal_shot [arakawa] -> [ichiban] (escena: the_point_blank_shot) | {:caliber=>"lethal", :location=>"chest"}
  04. story.scene_transition [ichiban]  (escena: trash_heap_awakening) | {:to_scene=>"trash_heap_awakening", :location=>"Isezaki Ijincho - Vertedero de basura"}
  05. story.medical_treatment [nanba] -> [ichiban] (escena: nanba_medical_salvation) | {:procedure=>"extracted_bullet", :saved=>true}
  06. story.chapter_boundary [ichiban]  (escena: nanba_medical_salvation) | {:chapter=>2, :status=>:concluded, :next=>:chapter_3}
  07. story.scenario_completed [ichiban]  (escena: nanba_medical_salvation) | {:episode=>"13_reunion_sangrienta", :final_location=>"Isezaki Ijincho - Campamento de Vagabundos"}

Estado final:
  Ubicación: Isezaki Ijincho - Campamento de Vagabundos
  Hora/Periodo: 2019 - Madrugada
  Dinero: ¥3500
  Inventario: [:nick_ogata_business_card]
  Flags: {:faced_arakawa=>true, :shot_by_arakawa=>true, :dumped_in_yokohama=>true, :saved_by_nanba=>true, :chapter_2_completed=>true}

Resumen:
  Episodio 13_reunion_sangrienta completado: Arakawa dispara al pecho de Ichiban, quien es arrojado en Yokohama y salvado milagrosamente por Nanba. Fin del Capítulo 2.
======================================================================
```

## Criterios Observables
- Código de salida: `0`
- Ubicación final: `"Isezaki Ijincho - Campamento de Vagabundos"`.
- Evento `story.arakawa_betrayal_shot` emitido por `:arakawa` contra `:ichiban`.
- Evento de frontera: `story.chapter_boundary` indicando `chapter: 2`, `next: :chapter_3`.
