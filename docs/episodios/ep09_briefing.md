# Briefing — Episodio 09: El nuevo Kamurocho (`09_el_nuevo_kamurocho`)

## Propósito

Modelar el impacto visual y político del regreso de Ichiban Kasuga a Kamurocho en 2019. Tras casi dos décadas ausente, descubre una ciudad vigilada por fuerzas policiales militarizadas y bajo la bota de la Alianza Omi (Kansai). El objetivo es explorar los viejos puntos de referencia, confrontar la hostilidad de los nuevos ocupantes y descubrir la celebración inminente de una reunión cumbre de la Omi encabezada por Masumi Arakawa.

## Canon incluido y límites
- **Incluido:**
  - Llegada a Kamurocho (Tenkaichi Street / Theater Square en 2019).
  - Reconocimiento de los cambios radicales: presencia policial y patrullas de la Omi.
  - Visita a los antiguos bastiones: el viejo puesto de cigarrillos y la antigua sede de la Familia Arakawa.
  - La antigua oficina está tomada y resguardada por la Omi Alliance.
  - Enfrentamiento y victoria contra una patrulla de matones de la Omi que intentan expulsar a Ichiban.
  - Interrogatorio y descubrimiento: Masumi Arakawa asistirá a una reunión cumbre secreta de la Omi esa misma noche en Kamurocho.
- **Fuera de alcance:**
  - El rescate de Nick Ogata (episodio 10).
  - El sistema de alcantarillado (episodio 11) y el asalto a la reunión (episodios 12 y 13).

## Estado de entrada
- **Época:** 2019 - Tarde.
- **Ubicación:** Entrada de Kamurocho (Tenkaichi Gate).
- **Personajes presentes:**
  - `ichiban`: Investigando su antiguo hogar.
  - `adachi`: Siguiéndolo a distancia / brindando información de fondo.
- **Precondiciones:** Liberación y viaje a Kamurocho completados (`destination == :kamurocho`).

## Estado final esperado
- Patrulla de la Omi derrotada en combate (`omi_patrol_defeated => true`).
- Noticia de la cumbre de la Omi obtenida (`summit_meeting_discovered => true`).
- Objetivo fijado: infiltrarse en la reunión de la Omi para ver a Arakawa (`objective => :infiltrate_omi_summit`).
