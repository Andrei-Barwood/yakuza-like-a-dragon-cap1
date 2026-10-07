# Secuencia de Escenas — Episodio 04: Cobrar sin destruir (`04_lo_que_se_debe`)

## Escena 1: `park_confrontation` (Encuentro en Public Park 3)
- **Ubicación:** Public Park 3.
- **Participantes:** `ichiban`, `hiratsuka`.
- **Objetivo:** Localizar a Hiratsuka y reclamar la deuda pendiente.
- **Acciones:**
  - `identify_debtor`: Ichiban encara a Hiratsuka; este rehúsa someterse y empuña un arma improvisada.
- **Transición:** Conduce a `park_combat`.

## Escena 2: `park_combat` (Pelea en el parque)
- **Ubicación:** Public Park 3.
- **Participantes:** `ichiban`, `hiratsuka`.
- **Precondiciones:** Encuentro inicial realizado.
- **Objetivo:** Someter a Hiratsuka sin causarle daño permanente.
- **Acciones:**
  - `subdue_debtor`: Ichiban neutraliza los ataques de Hiratsuka y lo derrota.
- **Transición:** Conduce a `wallet_inspection_and_mercy`.

## Escena 3: `wallet_inspection_and_mercy` (La cartera y el dilema moral)
- **Ubicación:** Public Park 3 - Banco del parque.
- **Participantes:** `ichiban`, `hiratsuka`.
- **Precondiciones:** Hiratsuka derrotado.
- **Objetivo:** Revisar los fondos y decidir el cobro.
- **Acciones:**
  - `inspect_wallet`: Abre la cartera con ¥100,000 y ve las fotografías de la familia necesitada de Hiratsuka.
  - `take_partial_sum`: Toma ¥50,000 para el balance familiar y le devuelve la cartera con los ¥50,000 restantes.
- **Transición:** Conduce a `sawashiro_pager_call`.

## Escena 4: `sawashiro_pager_call` (La llamada de Sawashiro)
- **Ubicación:** Salida de Public Park 3.
- **Participantes:** `ichiban`.
- **Precondiciones:** Cobranza de Hiratsuka resuelta.
- **Objetivo:** Atender la llamada urgente de la jerarquía superior.
- **Acciones:**
  - `receive_sawashiro_order`: Sawashiro llama exigiendo que Ichiban cuide y acompañe al "Joven Maestro" Masato Arakawa esta misma noche.
