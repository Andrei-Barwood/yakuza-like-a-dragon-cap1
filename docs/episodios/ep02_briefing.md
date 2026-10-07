# Briefing — Episodio 02: El trabajo del día (`02_cobranza`)

## Propósito

Iniciar la línea temporal adulta en Kamurocho (año 2000 / víspera del nuevo milenio). Establece a Ichiban Kasuga como soldado raso de la familia Arakawa junto a su compañero menor Mitsuo Yasuda. Modela la primera tarea del día: cobrar una deuda a Hirotaka Ushio, introducir el primer combate callejero y evidenciar el código moral distintivo de Ichiban frente a los abusos usureros.

## Canon incluido y límites
- **Incluido:**
  - Ichiban adulto recorriendo Kamurocho con Mitsuo.
  - Encuentro con Hirotaka Ushio en su negocio de pornografía/reventa ilegal.
  - Confrontación física: combate introductorio contra Ushio y sus secuaces.
  - Recaudación del dinero de la extorsión/deuda (cobro de ¥200,000).
  - Decisión moral de Ichiban: indignado por el timo de Ushio a compradores inocentes, devuelve parte del dinero a las víctimas engañadas en lugar de confiscarlo ciegamente para la familia.
  - Reacción y perplejidad de Mitsuo ante el idealismo de Ichiban.
- **Fuera de alcance:**
  - El favor de Michiyo con Shangri-La (ocurre en el episodio 03).
  - La llamada o encargo de Koji Hiratsuka (episodio 04).
  - Sucesos del clan Tojo o Masato Arakawa.

## Estado de entrada
- **Época:** 2000 - Mañana.
- **Ubicación:** Calles de Kamurocho (Tenkaichi Street / Nakamichi Alley).
- **Personajes presentes:**
  - `ichiban`: Adulto, miembro de la familia Arakawa, HP 100, inventario básico.
  - `mitsuo`: Shatei / subordinado de Ichiban, leal pero pragmático.
- **Dinero inicial:** ¥2,000 (fondos de bolsillo).

## Estado final esperado
- Ushio derrotado en combate (`status: :defeated`).
- Deuda cobrada (monto retenido de ¥200,000 tras procesar la devolución a los clientes estafados).
- Decisión de reembolso a las víctimas registrada con el flag `:buyers_reimbursed => true`.
- Relación con Mitsuo fortalecida en lealtad/admiración (`:mitsuo => :loyal_comrade`).
