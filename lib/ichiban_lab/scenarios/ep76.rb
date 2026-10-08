# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep76 < IchibanLab::BaseScenario
      protected

      def episode_id
        "76_el_debate_en_hamakita"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :grassroots_candidate },
          relationships: { kume: :political_rival, hamako: :ally },
          belongings: []
        )
        kume = Character.new(
          id: :sota_kume,
          name: "Sota Kume",
          attributes: { role: :bleach_japan_candidate, status: :rattled },
          relationships: { ichiban: :enemy },
          belongings: []
        )
        hamako = Character.new(
          id: :hamako,
          name: "Hamako",
          attributes: { role: :community_supporter },
          relationships: { ichiban: :protector },
          belongings: []
        )
        chief = Character.new(
          id: :homeless_chief,
          name: "Jefe del Campamento",
          attributes: { role: :community_supporter },
          relationships: { ichiban: :comrade },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "survive_bar_campaign_stickers",
          location: "Survive Bar - Yokohama",
          time_period: "2019 - Mañana",
          money: 26300,
          characters: {
            ichiban: ichiban,
            sota_kume: kume,
            hamako: hamako,
            homeless_chief: chief
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :seiryu_crest,
            :raw_pork_buns,
            :zhao_cooking_recipe,
            :survive_bar_master_cup,
            :hamako_warm_handkerchief,
            :commemorative_photo_osaka,
            :election_campaign_van
          ],
          flags: {
            ep75_completed: true,
            kasuga_candidacy_active: true
          }
        )
      end

      def define_scenes
        scene_stickers = Scene.new(
          id: "survive_bar_campaign_stickers",
          title: "Survive Bar amanece tapizado de pegatinas de difamación de Bleach Japan; Takabe cede la furgoneta de campaña"
        )
        scene_stickers.add_precondition do |state|
          state.flag(:ep75_completed) == true && state.flag(:kasuga_candidacy_active) == true
        end

        scene_debate = Scene.new(
          id: "hamakita_park_live_debate",
          title: "En Hamakita Park, Kasuga desmonta el purismo dogmático de Kume defendiendo las zonas grises y la humanidad real"
        )
        scene_debate.add_precondition do |state|
          state.flag(:campaign_van_deployed) == true
        end

        scene_aoki_ultimatum = Scene.new(
          id: "aoki_furious_ultimatum_to_sawashiro",
          title: "Aoki contempla furioso la viralización del debate y da un ultimátum letal de 24 horas a Sawashiro"
        )
        scene_aoki_ultimatum.add_precondition do |state|
          state.flag(:hamakita_debate_won) == true
        end

        [scene_stickers, scene_debate, scene_aoki_ultimatum]
      end

      def execute_scenario
        scene_stickers, scene_debate, scene_aoki_ultimatum = define_scenes

        # 1. Survive Bar tapizado y despliegue de la furgoneta
        scene_stickers.check_preconditions!(@state)
        emit("story.kume_smear_campaign_stickers", actor: :sota_kume, target: :ichiban, data: {
          smear: "survive_bar_inundado_de_propaganda_anti_kasuga",
          support: "takabe_entrega_la_furgoneta_clasica_de_campana_de_hoshino"
        })
        @state.set_flag(:campaign_van_deployed, true)

        # 2. Debate público e improvisado en Hamakita Park
        transition_to(scene_debate, new_location: "Hamakita Park - Estrado Electoral", new_time: "2019 - Mediodía")
        emit("story.philosophical_gray_zone_debate", actor: :ichiban, target: :sota_kume, data: {
          speech: "las_leyes_imperfectas_generan_zonas_grises_y_la_gente_vulnerable_no_elige_estar_alli",
          resonance: "el_jefe_y_hamako_lideran_el_aplauso_popular_dejando_en_evidencia_a_kume"
        })
        emit("story.kume_humiliated_retreat", actor: :sota_kume, target: :ichiban, data: {
          retreat: "kume_huye_del_estrado_rechazando_el_apreton_de_manos_y_quedando_grabado"
        })
        @state.set_flag(:hamakita_debate_won, true)

        # 3. Repercusión en Tokio: ultimátum de Aoki a Sawashiro
        transition_to(scene_aoki_ultimatum, new_location: "Despacho del Gobernador - Tokio", new_time: "2019 - Tarde")
        emit("story.aoki_rage_24h_ultimatum", actor: :ryo_aoki, target: :jo_sawashiro, data: {
          viral_impact: "las_redes_sociales_estallan_a_favor_de_kasuga",
          order: "plazo_de_24_horas_para_eliminar_a_un_objetivo_clave_o_ser_descartado"
        })
        @state.set_flag(:sawashiro_ultimatum_issued, true)
        @state.set_flag(:ep76_completed, true)
      end

      def generate_summary
        "Episodio 76_el_debate_en_hamakita completado: Kume llena Survive Bar de pegatinas de odio, pero Takabe equipa al grupo con una furgoneta electoral cedida por Hoshino. En Hamakita Park, Kasuga confronta a Kume en un memorable debate callejero, defendiendo con emoción que la vida real habita en zonas grises y que la gente marginada no eligió ser excluida. El clamor popular y el apoyo de Hamako y el Jefe humillan a Kume, volviendo viral a Kasuga. En Tokio, Aoki enfurece y otorga a Sawashiro 24 horas para liquidar un blanco decisivo."
      end
    end
  end
end
