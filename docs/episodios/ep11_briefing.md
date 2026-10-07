# Briefing — Episodio 11: Los conductos subterráneos (`11_los_bajos_fondos`)

## Propósito

Modelar la peligrosa infiltración táctica a través del sistema de túneles y alcantarillado subterráneo de Kamurocho. Con las calles perimetrales selladas por la policía corrupta y cientos de centinelas de la Omi, Ichiban y Adachi descienden a los conductos para llegar sigilosamente a los cimientos del edificio de la cumbre.

## Canon incluido y límites
- **Incluido:**
  - Descenso a los túneles subterráneos de alcantarillado bajo el Hotel District.
  - Navegación táctica entre compuertas oxidadas y pasajes anegados.
  - Encuentro y combate contra centinelas y guardias de patrulla subterránea de la Omi.
  - Apertura de la escotilla de mantenimiento que conecta con el sótano del edificio.
  - Acceso seguro a las escaleras de servicio hacia los pisos ejecutivos.
- **Fuera de alcance:**
  - El piso de la reunión y el duelo con Jo Sawashiro (episodio 12).
  - El despacho de Masumi Arakawa (episodio 13).

## Estado de entrada
- **Época:** 2019 - Noche.
- **Ubicación:** Entrada del alcantarillado de Kamurocho.
- **Personajes presentes:**
  - `ichiban`: Líder de la infiltración.
  - `adachi`: Compañero de equipo y guía de los conductos.
- **Precondiciones:** Entrada autorizada tras el pacto con Adachi (`next_step == :enter_underground_sewers`).

## Estado final esperado
- Túneles superados y centinelas neutralizados (`sewer_guards_defeated => true`).
- Escotilla forzada con éxito (`access_hatch_opened => true`).
- Ubicación alcanzada: Sótano del Edificio de la Cumbre (`building_infiltrated => true`).
- Listo para el asalto a la planta ejecutiva (`next_step => :storm_executive_floor`).
