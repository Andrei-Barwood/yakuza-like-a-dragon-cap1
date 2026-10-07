# Briefing — Episodio 04: Cobrar sin destruir (`04_lo_que_se_debe`)

## Propósito

Modelar la cobranza a Koji Hiratsuka en Public Park 3. Hiratsuka es un conocido de la infancia de Ichiban que arrastra una deuda con la familia Arakawa. Este episodio resalta la tensión entre las órdenes de la yakuza y la empatía de Ichiban: tras vencerlo en combate, Ichiban comprueba la situación familiar precaria de Hiratsuka y decide cobrar lo indispensable sin despojarlo por completo, antes de recibir la llamada urgente del capitán Sawashiro.

## Canon incluido y límites
- **Incluido:**
  - Llegada a Public Park 3 en busca de Koji Hiratsuka.
  - Diálogo tenso y combate físico contra Hiratsuka y su desesperación.
  - Hiratsuka derrotado; entrega de su cartera a Ichiban.
  - Examen de la cartera: contiene ¥100,000 en efectivo y fotos de su familia.
  - Decisión moral de Ichiban: toma únicamente ¥50,000 para rendir cuentas básicas ante la familia y le devuelve los otros ¥50,000 para que su familia pueda subsistir.
  - Notificación/llamada entrante del capitán Jo Sawashiro ordenando a Ichiban que se presente de inmediato para custodiar y atender al hijo del patriarca, Masato Arakawa.
- **Fuera de alcance:**
  - Las andanzas nocturnas de Masato en el club o el altercado con Horinouchi (pertenecen al episodio 05).
  - La confrontación con Sawashiro en la oficina (episodio 06).

## Estado de entrada
- **Época:** 2000 - Tarde.
- **Ubicación:** Kamurocho - Public Park 3.
- **Personajes presentes:**
  - `ichiban`: Protagonista, cumpliendo la tarea encomendada por Mitsuo.
  - `hiratsuka`: Deudor en bancarrota, desesperado pero combativo.
- **Precondiciones:** Asignación previa del encargo de Hiratsuka activada.

## Estado final esperado
- Hiratsuka vencido en combate (`status: :defeated`).
- Cartera examinada; cobro parcial ejecutado (¥50,000 retenidos, ¥50,000 dejados a Hiratsuka).
- Flag `:hiratsuka_spared => true` y `:partial_collection => true`.
- Llamada de Sawashiro recibida con la orden sobre Masato (`sawashiro_summons => true`).
