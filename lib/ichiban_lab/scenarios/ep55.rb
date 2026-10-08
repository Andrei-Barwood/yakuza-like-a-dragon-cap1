# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep55 < IchibanLab::BaseScenario
      protected

      def episode_id
        "55_el_interrogatorio_de_ogasawara"
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
        seonhee = Character.new(
          id: :seonhee,
          name: "Seonhee",
          attributes: { role: :geomijul_leader },
          relationships: {},
          belongings: []
        )
        ogasawara = Character.new(
          id: :hajime_ogasawara,
          name: "Hajime Ogasawara",
          attributes: { role: :captive_director },
          relationships: {},
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :relieved_brother },
          relationships: { ichiban: :reconciled },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "homeless_camp_interrogation",
          location: "Campamento de Indigentes - Orilla del Río",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
            seonhee: seonhee,
            hajime_ogasawara: ogasawara,
            nanba: nanba
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
            chapter_9_completed: true,
            shoichi_confirmed_alive: true
          }
        )
      end

      def execute_scenario
        scene_interrogation = Scene.new(
          id: :homeless_camp_interrogation,
          title: "Interrogatorio a Hajime Ogasawara en el campamento",
          location: "Campamento de Indigentes - Orilla del Río"
        )
        scene_interrogation.add_precondition("Ogasawara debe estar en custodia y Shoichi a salvo tras el Capítulo 9") do |ws|
          ws.flag?(:chapter_9_completed) && ws.flag?(:shoichi_confirmed_alive)
        end

        scene_coup_alert = Scene.new(
          id: :liumang_coup_and_zhao_peril,
          title: "Alerta del golpe de Mabuchi y peligro inminente para Zhao",
          location: "Campamento de Indigentes - Orilla del Río"
        )

        scene_nanba_farewell = Scene.new(
          id: :nanba_reconciliation_departure,
          title: "Reconciliación y despedida temporal de Nanba",
          location: "Campamento de Indigentes - Orilla del Río"
        )

        # 1. Interrogatorio exhaustivo a Ogasawara en la tienda de campaña
        scene_interrogation.check_preconditions!(@state)
        transition_to(scene_interrogation)
        emit("story.captive_interrogated", actor: :ichiban, target: :hajime_ogasawara, data: { confessions: "revelacion_de_instigacion_de_aoki_y_fondos_de_bleach_japan" })
        @state.set_flag(:ogasawara_interrogated, true)

        # 2. Kasuga recuerda el golpe de estado de Mabuchi contra Zhao en los Liumang
        transition_to(scene_coup_alert)
        emit("story.zhao_distress_recalled", actor: :ichiban, data: { obligation: "zhao_nos_ayudo_a_salvar_a_geomijul_ahora_debemos_salvarlo_a_el" })
        @state.set_flag(:zhao_rescue_mission_active, true)

        # 3. Llegada de Nanba confirmando la seguridad de Shoichi y despedida temporal
        transition_to(scene_nanba_farewell)
        emit("story.brother_safety_confirmed", actor: :nanba, data: { status: "shoichi_nanba_a_salvo_en_refugio_protegido" })
        emit("story.nanba_departure_warning", actor: :nanba, target: :ichiban, data: { advice: "cuidado_con_las_mafias_de_ijincho" })
        @state.set_flag(:nanba_departed_temporarily, true)
      end

      def generate_summary
        "Episodio 55_el_interrogatorio_de_ogasawara completado: En el campamento de indigentes, el grupo interroga a Ogasawara extrayendo detalles del complot de Aoki. Kasuga recuerda que Tianyou Zhao está acorralado por el golpe de estado de Mabuchi y decide ir en su auxilio. Nanba reaparece agradeciendo que su hermano Shoichi esté a salvo y se despide advirtiéndoles del peligro."
      end
    end
  end
end
