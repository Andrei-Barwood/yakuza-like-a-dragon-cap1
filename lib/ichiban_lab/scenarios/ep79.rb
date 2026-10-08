# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep79 < IchibanLab::BaseScenario
      protected

      def episode_id
        "79_la_sangre_del_patriarca"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader, grief: :profound },
          relationships: { arakawa: :biological_father, aoki: :sworn_brother_and_nemesis },
          belongings: []
        )
        nanba = Character.new(
          id: :yu_nanba,
          name: "Yu Nanba",
          attributes: { role: :advisor_friend },
          relationships: { ichiban: :brother_in_arms },
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :detective_partner },
          relationships: { ichiban: :protector },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "survive_bar_patrilineal_revelation",
          location: "Survive Bar - Yokohama",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            yu_nanba: nanba,
            adachi: adachi
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
            chapter_13_completed: true,
            biological_truth_unveiled: true
          }
        )
      end

      def define_scenes
        scene_contemplation = Scene.new(
          id: :survive_bar_patrilineal_revelation,
          title: "Kasuga asimila su verdadera filiación biológica con Masumi Arakawa",
          location: "Survive Bar - Yokohama"
        )
        scene_contemplation.add_precondition("El capítulo 13 debe estar concluido con la verdad biológica revelada") do |ws|
          ws.flag?(:chapter_13_completed) && ws.flag?(:biological_truth_unveiled)
        end

        scene_brawl_outside = Scene.new(
          id: :survive_bar_perimeter_omi_clash,
          title: "Emboscada de la Tokyo Omi a las puertas de Survive Bar",
          location: "Survive Bar - Exterior"
        )
        scene_brawl_outside.add_precondition("Kasuga debe haber decidido encarar a Aoki y buscar a Kume") do |ws|
          ws.flag?(:resolve_to_find_aoki_formed)
        end

        scene_kume_hunt = Scene.new(
          id: :kume_search_initiative,
          title: "Determinación de localizar a Kume en el edificio Hakuryo",
          location: "Distrito de los Bares - Ijincho"
        )
        scene_kume_hunt.add_precondition("La emboscada de la Omi debe haber sido repelida") do |ws|
          ws.flag?(:survive_exterior_brawl_won)
        end

        [scene_contemplation, scene_brawl_outside, scene_kume_hunt]
      end

      def execute_scenario
        scene_contemplation, scene_brawl_outside, scene_kume_hunt = define_scenes

        # 1. Reflexión en Survive Bar sobre la sangre de Arakawa y la necesidad de ajustar cuentas con Aoki
        scene_contemplation.check_preconditions!(@state)
        emit("story.arakawa_bloodline_realization", actor: :ichiban, data: {
          lineage: "ichiban_comprende_que_masumi_arakawa_era_su_verdadero_padre_biologico",
          resolve: "debe_encontrar_a_aoki_pero_desconocen_su_paradero_actual"
        })
        @state.set_flag(:resolve_to_find_aoki_formed, true)

        # 2. Salida al exterior y combate contra una horda de la Tokyo Omi
        transition_to(scene_brawl_outside)
        emit("story.combat_resolved", actor: :ichiban, target: :tokyo_omi_street_pack, data: {
          result: :street_pack_defeated
        })
        @state.set_flag(:survive_exterior_brawl_won, true)

        # 3. Pista de Kume y partida hacia la oficina de Bleach Japan en el edificio Hakuryo
        transition_to(scene_kume_hunt)
        emit("story.target_kume_office_set", actor: :ichiban, target: :yu_nanba, data: {
          lead: "kume_puede_conocer_el_paradero_de_aoki",
          destination: "edificio_hakuryo"
        })
        @state.set_flag(:target_hakuryo_building_set, true)
        @state.set_flag(:ep79_completed, true)
      end

      def generate_summary
        "Episodio 79_la_sangre_del_patriarca completado: En Survive Bar, Kasuga asimila la revelación de Sawashiro: él es el hijo biológico de Masumi Arakawa. Junto a Nanba y el grupo deciden confrontar a Aoki, pero al ignorar su escondite, concluyen que Sota Kume debe saberlo. Al salir, repelen un asedio de la Tokyo Omi y fijan rumbo hacia la sede de Bleach Japan en el edificio Hakuryo."
      end
    end
  end
end
