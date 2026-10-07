# Briefing — Episodio 13: Reunión sangrienta (`13_reunion_sangrienta`)

## Propósito

Modelar el clímax trágico y el cierre definitivo del Capítulo 2 (*Bloody Reunion*). Ichiban Kasuga entra finalmente a solas en el despacho de Masumi Arakawa para pedir explicaciones tras 18 años de sacrificio. En lugar de gratitud o reconocimiento paterno, Arakawa lo recibe con frialdad implacable y le dispara un tiro a quemarropa en el pecho. La escena concluye con el rescate milagroso de Ichiban en un basurero de Isezaki Ijincho (Yokohama) por parte del vagabundo Yu Nanba.

## Canon incluido y límites
- **Incluido:**
  - Entrada de Ichiban al despacho presidencial de la Omi.
  - Encuentro a solas con Masumi Arakawa.
  - Diálogo cargado de emoción: Ichiban proclama su regreso tras cumplir la condena voluntaria de 18 años.
  - La respuesta de Arakawa: sin mediar explicaciones, desenfunda su arma de fuego, apunta y le dispara al pecho a Ichiban.
  - Ichiban cae ensangrentado y pierde el conocimiento creyendo morir.
  - Despertar en un vertedero de basura en Isezaki Ijincho (Yokohama).
  - Intervención médica de emergencia de Yu Nanba: le extrae la bala, sutura la herida y le salva la vida.
  - Conclusión definitiva del Capítulo 2.
- **Fuera de alcance:**
  - Las misiones y tramas completas del Capítulo 3 en Yokohama.
  - Hello Work, Seiryu Clan, Bleach Japan o Yokohama Liumang.

## Estado de entrada
- **Época:** 2019 - Medianoche.
- **Ubicación:** Puertas del Despacho de la Omi (Kamurocho).
- **Personajes presentes:**
  - `ichiban`: Protagonista, llegando al final de su búsqueda.
  - `arakawa`: Patriarca y ahora segundo al mando de la Alianza Omi.
- **Precondiciones:** Camino al despacho abierto (`path_to_arakawa_opened => true`).

## Estado final esperado
- Disparo de Arakawa registrado (`shot_by_arakawa => true`, HP de Ichiban reducido a 1).
- Rescate de Nanba consumado (`saved_by_nanba => true`, relación con Nanba establecida).
- Ubicación final: `"Isezaki Ijincho - Campamento de Vagabundos (Yokohama)"`.
- Evento de frontera: `story.chapter_boundary` con `chapter: 2`, `status: :concluded`, `next: :chapter_3`.
- Código de salida técnico del simulador: `0`.
