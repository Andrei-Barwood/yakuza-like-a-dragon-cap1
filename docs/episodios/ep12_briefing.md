# Briefing — Episodio 12: Duelo con Sawashiro (`12_el_guantelete`)

## Propósito

Modelar el asalto a la planta ejecutiva de la cumbre y el gran combate contra Jo Sawashiro, quien tras 18 años ocupa una alta posición de mando en la Alianza Omi. La escena confronta el choque ideológico entre la lealtad inquebrantable de Ichiban y el pragmatismo despiadado de Sawashiro, resolviendo el combate culminante antes de abrir paso al despacho de Arakawa.

## Canon incluido y límites
- **Incluido:**
  - Asalto a la planta ejecutiva tras subir las escaleras del sótano.
  - Enfrentamiento frontal con Jo Sawashiro y sus guardias de élite.
  - Diálogo de desprecio: Sawashiro se burla de que Ichiban haya desperdiciado su juventud en prisión por una causa muerta.
  - Combate de jefe (boss battle): Ichiban y Adachi luchan contra Sawashiro armado con katana/bastón de combate.
  - Derrota física de Sawashiro (`status: :defeated`).
  - Adachi contiene a los refuerzos que acuden por el pasillo y apremia a Ichiban a entrar a solas a la oficina donde se encuentra Masumi Arakawa.
- **Fuera de alcance:**
  - El encuentro a solas con Arakawa y el disparo (episodio 13).
  - El despertar en Yokohama (episodio 13).

## Estado de entrada
- **Época:** 2019 - Noche cerrada.
- **Ubicación:** Sótano del Edificio de la Cumbre.
- **Personajes presentes:**
  - `ichiban`: Salud y determinación plenas.
  - `adachi`: Apoyo de combate.
- **Precondiciones:** Infiltración en el sótano consumada (`building_infiltrated => true`).

## Estado final esperado
- Jo Sawashiro derrotado en combate de jefe (`sawashiro_boss_defeated => true`, `status => :defeated`).
- Pasillo despejado y refuerzos contenidos por Adachi (`adachi_holding_corridor => true`).
- Puerta del despacho de Arakawa abierta (`path_to_arakawa_opened => true`).
