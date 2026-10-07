# Briefing — Episodio 03: Un favor en el barrio (`03_encargo_urgente`)

## Propósito

Modelar el enredo cotidiano de Ichiban en Kamurocho: un encargo doméstico/urgente encomendado por la encargada Michiyo en el club de baños Shangri-La. Este segmento ilustra cómo Ichiban asume tareas que van desde destapar cañerías hasta defender a vecinos vulnerables frente a extorsionadores callejeros, antes de recibir la asignación del siguiente cobro formal por parte de Mitsuo.

## Canon incluido y límites
- **Incluido:**
  - Ichiban recibe el aviso urgente de Michiyo sobre una emergencia de fontanería en Shangri-La.
  - La necesidad de conseguir un desatascador (plunger) en la tienda de cigarrillos del barrio.
  - Encuentro callejero: defender a un anciano acosado por extorsionadores en el trayecto.
  - Resolución del problema en Shangri-La utilizando el desatascador adquirido.
  - Llamada de Mitsuo notificando la siguiente tarea (la deuda de Koji Hiratsuka).
- **Fuera de alcance:**
  - El encuentro y cobro a Koji Hiratsuka en Public Park 3 (pertenece al episodio 04).
  - Escenas de Masato Arakawa o Sawashiro.

## Estado de entrada
- **Época:** 2000 - Mediodía.
- **Ubicación:** Calles de Kamurocho (frente a Shangri-La / Hotel District).
- **Personajes presentes:**
  - `ichiban`: Protagonista, salud plena.
  - `michiyo`: Encargada de Shangri-La, solicita auxilio.
- **Dinero inicial:** Fondos heredados del episodio 02 (¥202,000 por defecto o continuados).

## Estado final esperado
- Desatascador obtenido y empleado en Shangri-La (`inventory` actualizado).
- Extorsionadores derrotados y anciano protegido (`elderly_protected => true`).
- Problema de fontanería solucionado (`shangri_la_unclogged => true`).
- Notificación de Mitsuo recibida con el encargo de Hiratsuka activado (`next_assignment_received => true`).
