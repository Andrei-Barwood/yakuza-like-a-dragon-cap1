# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep67 < IchibanLab::BaseScenario
      protected

      def episode_id
        "67_el_despacho_del_gobernador"
      end

      def main_actor
        :ryo_aoki
      end

      def default_initial_state
        aoki = Character.new(
          id: :ryo_aoki,
          name: "Ryo Aoki",
          attributes: { hp: 100, role: :governor_and_party_chair },
          relationships: { sawashiro: :captain, arakawa: :father },
          belongings: []
        )
        sawashiro = Character.new(
          id: :jo_sawashiro,
          name: "Jo Sawashiro",
          attributes: { role: :arakawa_captain },
          relationships: { aoki: :young_master },
          belongings: []
        )
        tendo = Character.new(
          id: :yosuke_tendo,
          name: "Yosuke Tendo",
          attributes: { role: :omi_lieutenant },
          relationships: { aoki: :enforcer },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "governor_office_distrust_session",
          location: "Despacho del Gobernador - Tokio",
          time_period: "2019 - Tarde",
          money: 26300,
          characters: {
            ryo_aoki: aoki,
            jo_sawashiro: sawashiro,
            yosuke_tendo: tendo
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
            chapter_11_completed: true,
            war_against_aoki_declared: true
          }
        )
      end

      def execute_scenario
        scene_distrust = Scene.new(
          id: :governor_office_distrust_session,
          title: "Despacho de Aoki: desconfianza ante la cumbre de Watase y Arakawa",
          location: "Despacho del Gobernador - Tokio"
        )
        scene_distrust.add_precondition("El grupo debe haber completado el Capítulo 11") do |ws|
          ws.flag?(:chapter_11_completed)
        end

        scene_sawashiro_pledge = Scene.new(
          id: :sawashiro_loyalty_pledge,
          title: "Voto de lealtad de Sawashiro y orden de espionaje a Osaka",
          location: "Despacho del Gobernador - Tokio"
        )

        scene_tendo_dispatch = Scene.new(
          id: :tendo_dispatched_to_sotenbori,
          title: "Envío de Yosuke Tendo a Sotenbori para vigilar a Arakawa",
          location: "Despacho del Gobernador - Tokio"
        )

        # 1. Aoki cuestiona a Sawashiro sobre la liberación inminente de Masaru Watase en Osaka
        scene_distrust.check_preconditions!(@state)
        transition_to(scene_distrust)
        emit("story.watase_release_briefed", actor: :ryo_aoki, target: :jo_sawashiro, data: { release_event: "masaru_watase_sale_de_prision", suspicion: "arakawa_planea_suceder_al_presidente_enfermo_de_la_omi" })
        emit("story.aoki_betrayal_warning", actor: :ryo_aoki, data: { rule: "los_yakuza_solo_tienen_poder_si_yo_se_lo_concedo", threat: "si_arakawa_me_traiciona_sera_eliminado" })

        # 2. Sawashiro jura poner a Aoki por encima de todo por orden del propio Arakawa
        transition_to(scene_sawashiro_pledge)
        emit("story.sawashiro_priority_confirmed", actor: :jo_sawashiro, target: :ryo_aoki, data: { priority: "poner_a_aoki_por_encima_de_arakawa_y_de_todos" })

        # 3. Sawashiro y Aoki despachan a Yosuke Tendo a Osaka para monitorear cada movimiento
        transition_to(scene_tendo_dispatch)
        emit("story.tendo_dispatched_to_osaka", actor: :jo_sawashiro, target: :yosuke_tendo, data: { destination: "sotenbori_osaka", objective: "vigilar_la_cumbre_arakawa_watase" })
        @state.set_flag(:tendo_dispatched_to_osaka, true)
        @state.set_flag(:watase_release_imminent, true)
      end

      def generate_summary
        "Episodio 67_el_despacho_del_gobernador completado: En Tokio, Ryo Aoki confronta a Jo Sawashiro sobre la salida de prisión de Masaru Watase y sospecha que Masumi Arakawa busca erigirse en líder supremo de la Omi. Sawashiro ratifica su lealtad ciega hacia Aoki y acuerdan enviar a Yosuke Tendo a Osaka para vigilar la cumbre."
      end
    end
  end
end
