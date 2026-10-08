# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep82 < IchibanLab::BaseScenario
      protected

      def episode_id
        "82_la_prueba_del_dragon"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { kiryu: :revered_legend },
          belongings: []
        )
        kiryu = Character.new(
          id: :kazuma_kiryu,
          name: "Kazuma Kiryu (El Dragón de Dojima)",
          attributes: { hp: 1000, role: :legendary_dragon, status: :unwavering },
          relationships: { ichiban: :tested_successor },
          belongings: []
        )
        seonhee = Character.new(
          id: :seonhee,
          name: "Seonhee",
          attributes: { role: :geomijul_queen },
          relationships: { ichiban: :ally, kiryu: :guest_protector },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "geomijul_courtyard_rendezvous",
          location: "Fortaleza de Cables de Geomijul - Patio",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            kazuma_kiryu: kiryu,
            seonhee: seonhee
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :seiryu_crest,
            :raw_pork_buns,
            :zhao_cooking_recipe,
            :survive_bar_master_cup,
            :hamako_warm_handkerchief,
            :commemorative_photo_osaka
          ],
          flags: {
            ep81_completed: true,
            geomijul_meeting_scheduled: true
          }
        )
      end

      def define_scenes
        scene_dialogue = Scene.new(
          id: :geomijul_courtyard_rendezvous,
          title: "Encuentro nocturno con Kiryu y el dilema de la verdad frente al combate",
          location: "Fortaleza de Cables de Geomijul - Patio"
        )
        scene_dialogue.add_precondition("Ep81 debe haber concluido") do |ws|
          ws.flag?(:ep81_completed) && ws.flag?(:geomijul_meeting_scheduled)
        end

        scene_legend_duel = Scene.new(
          id: :kazuma_kiryu_trial_combat,
          title: "Combate de prueba legendario contra Kazuma Kiryu",
          location: "Fortaleza de Cables de Geomijul - Patio"
        )
        scene_legend_duel.add_precondition("Kasuga debe haber elegido conocer el movimiento de Aoki") do |ws|
          ws.flag?(:trial_condition_accepted)
        end

        scene_awakening = Scene.new(
          id: :silver_dragon_vision_and_entry,
          title: "Visión del gran dragón plateado y admisión a la sala de mandos de Geomijul",
          location: "Fortaleza de Cables de Geomijul - Interior"
        )
        scene_awakening.add_precondition("El duelo debe haberse librado") do |ws|
          ws.flag?(:kiryu_trial_fought)
        end

        [scene_dialogue, scene_legend_duel, scene_awakening]
      end

      def execute_scenario
        scene_dialogue, scene_legend_duel, scene_awakening = define_scenes

        # 1. Diálogo en Geomijul: la opción de conocer la identidad de Kiryu o los planes de Aoki
        scene_dialogue.check_preconditions!(@state)
        emit("story.kiryu_ultimatum_choice", actor: :kazuma_kiryu, target: :ichiban, data: {
          choice: "conocer_el_siguiente_golpe_de_aoki_a_cambio_de_someterse_a_prueba_fisica"
        })
        @state.set_flag(:trial_condition_accepted, true)

        # 2. Batalla colosal contra Kazuma Kiryu (El Dragón de Dojima)
        transition_to(scene_legend_duel)
        emit("story.combat_resolved", actor: :ichiban, target: :kazuma_kiryu, data: {
          result: :party_exhausted_kiryu_barely_winded,
          knockout: "kasuga_cae_inconsciente_tras_probar_la_fuerza_inconmensurable_de_kiryu"
        })
        @state.set_flag(:kiryu_trial_fought, true)

        # 3. Visión onírica del Dragón Plateado, despertar sereno e ingreso a la base de Seonhee
        transition_to(scene_awakening)
        emit("story.silver_dragon_dream_and_calmness", actor: :ichiban, target: :kazuma_kiryu, data: {
          dream: "sueno_venciendo_al_dragon_plateado_que_representa_la_figura_de_kiryu",
          advice: "kiryu_elogia_su_fuerza_pero_exige_templanza_y_calma_frente_a_la_ira",
          welcome: "seonhee_abre_las_puertas_de_geomijul_con_los_monitores_operativos"
        })
        @state.set_flag(:geomijul_command_room_unlocked, true)
        @state.set_flag(:ep82_completed, true)
      end

      def generate_summary
        "Episodio 82_la_prueba_del_dragon completado: En el patio de Geomijul, Kiryu ofrece a Kasuga una disyuntiva: saber quién es él o descubrir el siguiente movimiento de Aoki sometiéndose a una prueba de combate. El grupo libra una batalla titánica contra el Dragón de Dojima hasta el agotamiento absoluto. Tras caer inconsciente y soñar con un imponente dragón plateado, Kasuga despierta comprendiendo la lección de templanza de Kiryu y es admitido en la sala de mandos de Seonhee."
      end
    end
  end
end
