# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep41 < IchibanLab::BaseScenario
      protected

      def episode_id
        "41_el_rescate_de_nanba"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { nanba: :sworn_partner, adachi: :brother_in_arms, saeko: :protectee },
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
        han = Character.new(
          id: :joon_gi_han,
          name: "Joon-gi Han",
          attributes: { role: :geomijul_boss, hp: 500 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "loyalty_defense_and_han_duel",
          location: "Fortaleza de Geomijul - Sala de Impresión Maestra",
          time_period: "2019 - Noche",
          money: 26300,
          characters: { ichiban: ichiban, adachi: adachi, saeko: saeko, joon_gi_han: han },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample],
          flags: { nanba_captured_by_geomijul: true, shoichi_mystery_revealed: true }
        )
      end

      def execute_scenario
        scene_loyalty = Scene.new(
          id: :loyalty_defense_and_han_duel,
          title: "Lealtad a Nanba y duelo contra Joon-gi Han",
          location: "Fortaleza de Geomijul - Sala de Impresión Maestra"
        )
        scene_loyalty.add_precondition("Nanba debe haber sido capturado por Geomijul") do |ws|
          ws.flag?(:nanba_captured_by_geomijul)
        end

        scene_breakout = Scene.new(
          id: :nanba_extraction_and_escape,
          title: "Extracción de Nanba y fuga de la fortaleza",
          location: "Fortaleza de Geomijul - Salida Trasera"
        )

        scene_heian = Scene.new(
          id: :seonhee_warning_and_heian_summons,
          title: "La advertencia de Seonhee y la cita en Heian Tower",
          location: "Yokohama Koreatown - Callejón Exterior"
        )

        # 1. Ichiban defiende a Nanba a pesar de todo y combate de jefe contra Han
        scene_loyalty.check_preconditions!(@state)
        transition_to(scene_loyalty)
        emit("story.loyalty_proclaimed", actor: :ichiban, target: :nanba, data: { declaration: "nanba_me_salvo_la_vida_y_sigue_siendo_mi_camarada" })
        emit("story.boss_defeated", actor: :ichiban, target: :joon_gi_han, data: { victory: true, assisted_by: [:adachi, :saeko] })

        # 2. Rescate de Nanba rompiendo el cerco de agentes
        transition_to(scene_breakout, new_location: "Fortaleza de Geomijul - Salida Trasera")
        emit("story.extraction_successful", actor: :ichiban, target: :nanba, data: { status: "nanba_liberado_y_puesto_a_salvo_en_la_fuga" })
        @state.set_flag(:nanba_rescued_and_fled, true)

        # 3. Seonhee advierte del colapso de Ijincho y cita al grupo en Heian Tower a las 2 AM
        transition_to(scene_heian, new_location: "Yokohama Koreatown - Callejón Exterior", new_time: "2019 - 01:00 AM")
        emit("story.prophecy_of_ruin", actor: :seonhee, data: { warning: "han_desencadenado_eventos_que_destruiran_ijincho" })
        emit("story.summons_issued", actor: :seonhee, target: :ichiban, data: { location: "Heian Tower", time: "02:00 AM" })
        @state.set_flag(:heian_tower_summons_active, true)
      end

      def generate_summary
        "Episodio 41_el_rescate_de_nanba completado: Ichiban se niega a abandonar a Nanba y derrota a Joon-gi Han en un feroz combate. Tras ayudar a Nanba a huir de las garras de Geomijul, Seonhee advierte que han desatado la ruina de Ijincho y los convoca a una cumbre secreta en Heian Tower a las 2 AM."
      end
    end
  end
end
