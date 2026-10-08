# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep74 < IchibanLab::BaseScenario
      protected

      def episode_id
        "74_el_lamento_y_la_determinacion"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader, grief: :heavy },
          relationships: { hoshino: :respected_elder, aoki: :adversary },
          belongings: []
        )
        hoshino = Character.new(
          id: :ryuhei_hoshino,
          name: "Ryuhei Hoshino",
          attributes: { role: :seiryu_chairman },
          relationships: { ichiban: :protector, arakawa: :sworn_brother },
          belongings: []
        )
        zhao = Character.new(
          id: :tianyou_zhao,
          name: "Tianyou Zhao",
          attributes: { role: :party_member },
          relationships: { ichiban: :comrade },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "survive_bar_mourning_call",
          location: "Survive Bar - Yokohama",
          time_period: "2019 - Día",
          money: 26300,
          characters: {
            ichiban: ichiban,
            ryuhei_hoshino: hoshino,
            tianyou_zhao: zhao
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
            ep73_completed: true
          }
        )
      end

      def define_scenes
        scene_call = Scene.new(
          id: "survive_bar_mourning_call",
          title: "Zhao anima a Kasuga a responder la llamada de Hoshino en Survive Bar"
        )
        scene_call.add_precondition do |state|
          state.flag(:ep73_completed) == true
        end

        scene_heian = Scene.new(
          id: "heian_tower_revelations",
          title: "En Heian Tower, Hoshino comparte recuerdos de la última cena con Arakawa y sospecha de Aoki"
        )
        scene_heian.add_precondition do |state|
          state.flag(:mourning_call_answered) == true
        end

        scene_determination = Scene.new(
          id: "kasuga_refuses_clan_revenge",
          title: "Kasuga rechaza la venganza armada del Seiryu para cumplir el ideal de redención de Arakawa"
        )
        scene_determination.add_precondition do |state|
          state.flag(:peking_duck_memory_shared) == true
        end

        [scene_call, scene_heian, scene_determination]
      end

      def execute_scenario
        scene_call, scene_heian, scene_determination = define_scenes

        # 1. En Survive Bar, llamada de Hoshino
        scene_call.check_preconditions!(@state)
        emit("story.hoshino_survive_bar_call", actor: :tianyou_zhao, target: :ichiban, data: {
          invitation: "hoshino_invita_a_kasuga_a_heian_tower_para_hablar_a_solas"
        })
        @state.set_flag(:mourning_call_answered, true)

        # 2. Heian Tower: recuerdos de Arakawa comiendo pato de Pekín en paz
        transition_to(scene_heian, new_location: "Restaurante Heian Tower - Ijincho", new_time: "2019 - Tarde")
        emit("story.heian_tower_arakawa_peace", actor: :ryuhei_hoshino, target: :ichiban, data: {
          peking_duck: "arakawa_probo_pato_de_pekin_por_primera_vez_y_se_mostraba_en_paz_tras_la_disolucion",
          suspect: "hoshino_sospecha_de_las_facciones_remanentes_de_la_omi_organizadas_por_aoki"
        })
        @state.set_flag(:peking_duck_memory_shared, true)

        # 3. Determinación de Kasuga: no venganza mafiosa, sino desmontar a Aoki
        transition_to(scene_determination)
        emit("story.kasuga_vow_of_restoration", actor: :ichiban, target: :ryuhei_hoshino, data: {
          refusal: "kasuga_rechaza_usar_al_clan_seiryu_como_sicarios",
          resolution: "despertar_a_aoki_y_mantener_vivo_el_sueno_de_arakawa_sin_derramar_sangre_inutil"
        })
        @state.set_flag(:arakawa_ideal_reaffirmed, true)
        @state.set_flag(:ep74_completed, true)
      end

      def generate_summary
        "Episodio 74_el_lamento_y_la_determinacion completado: Aislado por el duelo en Survive Bar, Kasuga es motivado por Zhao para acudir a Heian Tower con Hoshino. El patriarca del Seiryu le relata cómo Masumi Arakawa disfrutó en paz de su primera cena de pato de Pekín tras disolver los clanes antes de ser asesinado. Hoshino ofrece el poder militar del Seiryu para vengarlo, pero Kasuga rechaza la venganza armada: enfrentará a Ryo Aoki y consumará el sueño de reintegración de Arakawa con sus propios compañeros."
      end
    end
  end
end
