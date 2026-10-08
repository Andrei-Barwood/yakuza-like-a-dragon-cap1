# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep88 < IchibanLab::BaseScenario
      protected

      def episode_id
        "88_el_fin_del_advenedizo"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { aoki: :brother_to_save },
          belongings: []
        )
        aoki = Character.new(
          id: :ryo_aoki,
          name: "Ryo Aoki",
          attributes: { hp: 100, role: :cornered_governor },
          relationships: { ichiban: :mirror_of_hate },
          belongings: []
        )
        officer = Character.new(
          id: :police_hostage,
          name: "Oficial de Policía",
          attributes: { role: :hostage },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "aoki_personal_duel",
          location: "Kamurocho - Millennium Tower (Piso Superior)",
          time_period: "2019 - Medianoche Electoral",
          money: 26300,
          characters: {
            ichiban: ichiban,
            ryo_aoki: aoki,
            police_hostage: officer
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :legendary_hero_bat,
            :masumi_arakawa_incense
          ],
          flags: {
            ep87_completed: true,
            aoki_publicly_exposed: true
          }
        )
      end

      def define_scenes
        scene_guards = Scene.new(
          id: "aoki_bodyguards_brawl",
          title: "Los Escoltas de Élite del Gobernador",
          location: "Kamurocho - Millennium Tower (Piso Superior)"
        )
        scene_guards.add_precondition do |state|
          state.flag?(:ep87_completed) && state.flag?(:aoki_publicly_exposed)
        end

        scene_duel = Scene.new(
          id: "aoki_personal_duel",
          title: "Duelo de Hermanos: Kasuga vs Ryo Aoki",
          location: "Kamurocho - Millennium Tower (Piso Superior Destrozado)"
        )
        scene_duel.add_precondition do |state|
          state.flag?(:aoki_bodyguards_defeated)
        end

        scene_escape = Scene.new(
          id: "aoki_hostage_escape",
          title: "La Fuga del Cristal Roto",
          location: "Kamurocho - Millennium Tower (Ascensor de Emergencia)"
        )
        scene_escape.add_precondition do |state|
          state.flag?(:aoki_duel_won)
        end

        [scene_guards, scene_duel, scene_escape]
      end

      def execute_scenario
        scene_guards, scene_duel, scene_escape = define_scenes

        # 1. Combate contra la guardia personal del gobernador
        transition_to(scene_guards)
        emit("story.aoki_bodyguards_clash", actor: :ryo_aoki, target: :ichiban, data: {
          desperation: "aoki_ordena_a_sus_guardaespaldas_armados_masacrar_a_todos_sin_piedad",
          response: "el_equipo_de_kasuga_repele_el_fuego_y_neutraliza_a_los_escoltas"
        })
        emit("story.combat_resolved", actor: :ichiban, target: :ryo_aoki_guards, data: {
          result: :guards_subdued
        })
        @state.set_flag(:aoki_bodyguards_defeated, true)

        # 2. Duelo singular puño a puño entre Kasuga y Aoki
        transition_to(scene_duel, new_location: "Kamurocho - Millennium Tower (Piso Superior Destrozado)")
        emit("story.ideological_clash_of_brothers", actor: :ichiban, target: :ryo_aoki, data: {
          dialogue: "aoki_despotrica_que_el_poder_es_lo_unico_que_cuenta_para_cambiar_el_mundo",
          kasuga_reply: "kasuga_le_espeta_que_su_ambicion_solo_ha_dejado_un_rastro_de_muerte_y_soledad"
        })
        emit("story.combat_resolved", actor: :ichiban, target: :ryo_aoki, data: {
          boss: :ryo_aoki,
          result: :aoki_battered_and_defeated
        })
        @state.set_flag(:aoki_duel_won, true)

        # 3. La policía irrumpe, Aoki toma un rehén con un fragmento de vidrio y escapa por el ascensor
        transition_to(scene_escape, new_location: "Kamurocho - Millennium Tower (Ascensor de Emergencia)")
        emit("story.police_arrival_and_hostage_crisis", actor: :ryo_aoki, target: :police_hostage, data: {
          police_force: "la_policia_metropolitana_llega_para_arrestar_a_aoki_tras_ver_el_video",
          hostage: "aoki_apenas_en_pie_toma_un_cristal_roto_y_encanona_a_un_oficial"
        })
        emit("story.elevator_escape_and_final_words", actor: :ryo_aoki, target: :ichiban, data: {
          escape: "aoki_noquea_al_oficial_en_el_ascensor_y_escapa_hacia_las_calles_de_kamurocho",
          words: "aoki_confiesa_que_kasuga_siempre_le_recordo_demasiado_a_su_padre_arakawa"
        })
        @state.set_flag(:aoki_escaped_to_streets, true)
        @state.set_flag(:ep88_completed, true)
      end

      def generate_summary
        "Episodio 88_el_fin_del_advenedizo completado: Acorralado en el ático de Millennium Tower, Aoki ordena a sus escoltas armados matar a todos, pero Kasuga y su equipo los doblegan. A solas entre vidrios rotos, Kasuga y Aoki libran un desgarrador combate puño a puño donde se enfrentan dos visiones de vida irreconciliables. Tras ser derrotado, la policía metropolitana llega para detenerlo; Aoki utiliza un trozo de cristal para tomar a un agente de rehén y meterse al ascensor. Antes de cerrarse las puertas, admite que siempre detestó a Kasuga porque le recordaba demasiado a Masumi Arakawa, huyendo malherido hacia el exterior."
      end
    end
  end
end
