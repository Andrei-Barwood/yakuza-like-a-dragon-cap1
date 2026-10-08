# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep59 < IchibanLab::BaseScenario
      protected

      def episode_id
        "59_reencuentro_con_mitsuo"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { adachi: :brother_in_arms, saeko: :protectee, nanba: :sworn_brother },
          belongings: []
        )
        zhao = Character.new(
          id: :tianyou_zhao,
          name: "Tianyou Zhao",
          attributes: { role: :rescued_leader },
          relationships: { ichiban: :ally },
          belongings: []
        )
        mitsuo = Character.new(
          id: :mitsuo_yasuda,
          name: "Mitsuo Yasuda",
          attributes: { role: :arakawa_family_member },
          relationships: { ichiban: :brother_in_arms },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "zhao_liberation_and_mitsuo_meeting",
          location: "Restaurante Qing Jin - Habitación Secreta",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            tianyou_zhao: zhao,
            mitsuo_yasuda: mitsuo
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
            nanba_permanently_rejoined: true,
            ishioda_subdued: true
          }
        )
      end

      def execute_scenario
        scene_mitsuo = Scene.new(
          id: :zhao_liberation_and_mitsuo_meeting,
          title: "Liberación de Zhao y reencuentro privado con Mitsuo",
          location: "Restaurante Qing Jin - Habitación Secreta"
        )
        scene_mitsuo.add_precondition("Nanba debe haberse reunido con el grupo tras derrotar a Ishioda") do |ws|
          ws.flag?(:nanba_permanently_rejoined) && ws.flag?(:ishioda_subdued)
        end

        scene_intel = Scene.new(
          id: :mitsuo_intelligence_and_warning,
          title: "Las confidencias de Mitsuo sobre Masumi Arakawa",
          location: "Restaurante Qing Jin - Habitación Secreta"
        )

        scene_succession = Scene.new(
          id: :zhao_succession_proposal,
          title: "Propuesta de sucesión de Liumang a Geomijul",
          location: "Restaurant Row - Exterior de Qing Jin"
        )

        # 1. Zhao es liberado y lleva a Kasuga a solas ante su viejo camarada de la Familia Arakawa: Mitsuo
        scene_mitsuo.check_preconditions!(@state)
        transition_to(scene_mitsuo)
        emit("story.old_friend_revealed", actor: :tianyou_zhao, target: :ichiban, data: { companion: "Mitsuo Yasuda", faction: "Familia Arakawa / Omi Alliance" })

        # 2. Mitsuo confiesa que Masumi Arakawa prepara un gran golpe y necesitará aliados
        transition_to(scene_intel)
        emit("story.arakawa_upcoming_move_revealed", actor: :mitsuo_yasuda, target: :ichiban, data: { warning: "arakawa_prepara_una_gran_jugada_y_pronto_necesitara_aliados", risk: "mitsuo_arriesgo_su_vida_para_ayudar_a_zhao" })
        @state.set_flag(:mitsuo_intel_received, true)

        # 3. Fuera de Qing Jin, Zhao anuncia que cederá el mando de Liumang a Seonhee
        transition_to(scene_succession, new_location: "Restaurant Row - Exterior de Qing Jin")
        emit("story.zhao_leadership_transition", actor: :tianyou_zhao, data: { plan: "ceder_mando_a_seonhee_para_darle_un_hogar_a_los_refugiados_de_geomijul" })
        @state.set_flag(:liumang_geomijul_alliance_sealed, true)
      end

      def generate_summary
        "Episodio 59_reencuentro_con_mitsuo completado: Tras ser liberado, Zhao conduce a Kasuga ante Mitsuo Yasuda, su antiguo compañero de la Familia Arakawa. Mitsuo le revela que el Patriarca Arakawa prepara un movimiento sísmico en el bajo mundo y pronto necesitará aliados confiables. En el exterior, Zhao decide transferir el liderazgo de los Liumang a Seonhee para dar cobijo a los desamparados de Geomijul."
      end
    end
  end
end
