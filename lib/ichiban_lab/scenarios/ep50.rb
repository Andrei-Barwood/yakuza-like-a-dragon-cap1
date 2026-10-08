# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep50 < IchibanLab::BaseScenario
      protected

      def episode_id
        "50_el_contraataque_de_totsuka"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { adachi: :brother_in_arms, saeko: :protectee },
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :party_member },
          relationships: { ichiban: :brother_in_arms },
          belongings: []
        )
        saeko = Character.new(
          id: :saeko,
          name: "Saeko Mukoda",
          attributes: { role: :party_member },
          relationships: { ichiban: :ally },
          belongings: []
        )
        hamako = Character.new(
          id: :hamako,
          name: "Hamako",
          attributes: { role: :innkeeper_and_benefactor },
          relationships: {},
          belongings: []
        )
        totsuka = Character.new(
          id: :totsuka,
          name: "Totsuka",
          attributes: { role: :seiryu_defector, hp: 350 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "hamako_distress_call",
          location: "Survive Bar - Planta 2F",
          time_period: "2019 - Mañana",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
            hamako: hamako,
            totsuka: totsuka
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :seiryu_clan_key,
            :counterfeit_yuan_sample,
            :shoichi_investigative_notes,
            :bleach_japan_founders_clipping
          ],
          flags: {
            survive_hideout_unlocked: true,
            aoki_background_uncovered: true
          }
        )
      end

      def execute_scenario
        scene_call = Scene.new(
          id: :hamako_distress_call,
          title: "Llamada de auxilio de Hamako",
          location: "Survive Bar - Planta 2F"
        )
        scene_call.add_precondition("El grupo debe haber descansado en Survive Bar") do |ws|
          ws.flag?(:survive_hideout_unlocked)
        end

        scene_residence = Scene.new(
          id: :hamako_residence_confrontation,
          title: "Confrontación en la residencia de Hamako",
          location: "Residencia de Hamako - Distrito Comercial"
        )

        scene_resolution = Scene.new(
          id: :totsuka_defeat_and_warning,
          title: "Derrota de Totsuka y protección de Hamako",
          location: "Residencia de Hamako - Distrito Comercial"
        )

        # 1. Llamada urgente de Hamako: Totsuka y desertores del Seiryu la acorralan
        scene_call.check_preconditions!(@state)
        transition_to(scene_call)
        emit("story.distress_call_received", actor: :hamako, target: :ichiban, data: { alert: "totsuka_y_matones_del_seiryu_registran_el_lugar" })

        # 2. Llegada a la casa de Hamako: Totsuka revela la fractura del Seiryu por el dinero falso
        transition_to(scene_residence, new_location: "Residencia de Hamako - Distrito Comercial")
        emit("story.seiryu_schism_revealed", actor: :totsuka, data: { motive: "miembros_desertan_tras_saber_que_hoshino_pactaba_con_liumang_pese_a_los_asesinatos" })
        emit("story.intimidation_defied", actor: :ichiban, target: :totsuka, data: { ultimatum: "no_permitiremos_que_toques_a_hamako" })

        # 3. Combate contra Totsuka y sus secuaces, expulsión definitiva
        transition_to(scene_resolution)
        emit("story.combat_resolved", actor: :ichiban, target: :totsuka, data: { victory: true, condition: "totsuka_derrotado_y_expulsado" })
        emit("story.hamako_safeguarded", actor: :ichiban, target: :hamako, data: { status: "proteccion_asegurada" })
        @state.set_flag(:totsuka_subdued, true)
        @state.set_flag(:hamako_protected, true)
      end

      def generate_summary
        "Episodio 50_el_contraataque_de_totsuka completado: A la mañana siguiente, Hamako llama alertando que Totsuka y disidentes del Clan Seiryu la tienen acorralada tras enterarse de la red de falsificación. Kasuga y su equipo acuden de inmediato, derrotan a Totsuka y a sus hombres, y aseguran la protección incondicional de Hamako."
      end
    end
  end
end
