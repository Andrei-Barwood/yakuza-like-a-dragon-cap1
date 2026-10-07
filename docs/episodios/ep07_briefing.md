# Briefing — Episodio 07: Quince años (`07_el_precio`)

## Propósito

Modelar el clímax trágico y el cierre definitivo del Capítulo 1 (*Light and Shadow*). En la mañana del 1 de enero de 2001, Ichiban despierta con una llamada de emergencia del patriarca Arakawa tras cometerse un homicidio. De camino a la oficina es emboscado por miembros de la familia Sakaki. En la reunión secreta, Arakawa le revela la cruda verdad: Jo Sawashiro asesinó a un miembro de alto rango del clan Sakaki; si Sawashiro va a prisión, la familia Arakawa colapsará. Arakawa le pide entre lágrimas a Ichiban que asuma la culpa del crimen. Ichiban, por lealtad incondicional hacia quien considera su padre, acepta el sacrificio. Tras compartir un último tazón de fideos de ternera, Ichiban camina hacia la comisaría y se entrega.

## Canon incluido y límites
- **Incluido:**
  - Ichiban despierta en su apartamento con la llamada telefónica urgente de Arakawa.
  - Ataque y combate callejero en ruta contra sicarios de la familia rival Sakaki.
  - Llegada a la oficina / encuentro a solas con Masumi Arakawa.
  - Revelación del crimen: Sawashiro cometió el asesinato; la familia pende de un hilo.
  - La petición solemne de Arakawa y la aceptación sin vacilar de Ichiban.
  - La última comida en libertad (beef bowl / fideos).
  - Entrega voluntaria ante la policía de Kamurocho y cierre del capítulo al cerrarse los barrotes de la celda.
- **Fuera de alcance:**
  - Los años de reclusión en prisión o la salida en 2019 (Capítulo 2 en adelante).
  - Yokohama / Isezaki Ijincho.
  - Cualquier consecuencia que no pertenezca al capítulo 1.

## Estado de entrada
- **Época:** 2001 - 1 de Enero (Mañana).
- **Ubicación:** Apartamento de Ichiban (Kamurocho).
- **Personajes presentes:**
  - `ichiban`: Miembro leal, descansado tras la noche anterior.
- **Precondiciones:** Descanso nocturno del episodio 06 completado (`resting_for_night => true`).

## Estado final esperado
- Emboscada de los Sakaki superada (`sakaki_ambush_repelled => true`).
- Petición de Arakawa escuchada y aceptada (`accepted_prison_sacrifice => true`).
- Última comida compartida (`last_meal_consumed => true`).
- Entrega policial formalizada e ingreso en prisión (`surrendered_to_police => true`, `imprisoned => true`).
- Ubicación final: Prisión de Kamurocho / Centro de Detención.
- Código de salida técnico del simulador: `0`.
- El capítulo 1 concluye aquí formalmente.
