# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep73 < IchibanLab::BaseScenario
      protected

      def episode_id
        "73_el_dolor_en_el_muelle"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader, emotional_state: :grief_stricken },
          relationships: { arakawa: :eternal_father },
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :detective_partner },
          relationships: { ichiban: :trusted_partner },
          belongings: []
        )
        takabe = Character.new(
          id: :mamoru_takabe,
          name: "Mamoru Takabe",
          attributes: { role: :seiryu_captain },
          relationships: { hoshino: :patriarch },
          belongings: []
        )
        sawashiro = Character.new(
          id: :jo_sawashiro,
          name: "Jo Sawashiro",
          attributes: { role: :tokyo_omi_provisional_captain },
          relationships: { arakawa: :patriarch, ishioda: :rival },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "coastal_pier_crime_scene",
          location: "Muelle Costero - Yokohama",
          time_period: "2019 - Mañana",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            mamoru_takabe: takabe,
            jo_sawashiro: sawashiro
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
            chapter_12_completed: true,
            arakawa_deceased: true
          }
        )
      end

      def define_scenes
        scene_pier = Scene.new(
          id: "coastal_pier_crime_scene",
          title: "Kasuga corre desesperado hacia el muelle costero donde la policía acordona el cadáver de Arakawa"
        )
        scene_pier.add_precondition do |state|
          state.flag(:chapter_12_completed) == true && state.flag(:arakawa_deceased) == true
        end

        scene_heian_report = Scene.new(
          id: "takabe_briefing_at_survive_bar",
          title: "Takabe informa a Adachi y Kasuga que Arakawa se retiró solo de Heian Tower tras cenar con Hoshino"
        )
        scene_heian_report.add_precondition do |state|
          state.flag(:police_cordon_restrained) == true
        end

        scene_tokyo_meeting = Scene.new(
          id: "sawashiro_kamurocho_conclave",
          title: "En Kamurocho, Sawashiro e Ishioda se disputan el control de los restos de la Omi en Tokio"
        )
        scene_tokyo_meeting.add_precondition do |state|
          state.flag(:heian_briefing_received) == true
        end

        [scene_pier, scene_heian_report, scene_tokyo_meeting]
      end

      def execute_scenario
        scene_pier, scene_heian_report, scene_tokyo_meeting = define_scenes

        # 1. En el muelle, Kasuga intenta romper el cordón policial sumido en dolor
        scene_pier.check_preconditions!(@state)
        emit("story.arakawa_corpse_cordon_rush", actor: :ichiban, target: :police, data: {
          location: "Muelle de Yokohama",
          grief: "kasuga_intenta_alcanzar_a_su_patriarca_y_es_frenado_por_la_policia"
        })
        @state.set_flag(:police_cordon_restrained, true)

        # 2. En Survive Bar, Takabe entrega los pormenores de la última noche de Arakawa
        transition_to(scene_heian_report, new_location: "Survive Bar - Yokohama", new_time: "2019 - Mediodía")
        emit("story.takabe_briefing_last_dinner", actor: :mamoru_takabe, target: :adachi, data: {
          dinner_details: "arakawa_ceno_con_hoshino_en_heian_tower_y_se_marcho_a_pie",
          ambush_suspicions: "atentados_simultaneos_contra_watase_y_dojima_en_osaka"
        })
        @state.set_flag(:heian_briefing_received, true)

        # 3. Sawashiro e Ishioda en Kamurocho
        transition_to(scene_tokyo_meeting, new_location: "Kamurocho - Sede Provisional", new_time: "2019 - Noche")
        emit("story.sawashiro_ishioda_feud", actor: :jo_sawashiro, target: :akira_ishioda, data: {
          alliance: "creacion_de_la_tokyo_omi_alliance_provisional",
          retaliation: "sawashiro_ejecuta_a_un_subordinado_y_jura_venganza_contra_el_asesino"
        })
        @state.set_flag(:tokyo_omi_tension_escalated, true)
        @state.set_flag(:ep73_completed, true)
      end

      def generate_summary
        "Episodio 73_el_dolor_en_el_muelle completado: Tras el hallazgo del cuerpo de Masumi Arakawa en el mar, Kasuga intenta desesperadamente llegar hasta él en el muelle de Yokohama antes de ser contenido por la policía. Takabe informa que Arakawa cenó tranquilamente con Hoshino en Heian Tower antes de ser emboscado, confirmando ataques coordinados contra Watase y Daigo. En Kamurocho, Sawashiro e Ishioda se acusan mutuamente por el crimen mientras forjan a la fuerza la Tokyo Omi Alliance."
      end
    end
  end
end
