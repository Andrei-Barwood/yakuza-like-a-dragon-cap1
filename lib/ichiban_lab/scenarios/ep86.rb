# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep86 < IchibanLab::BaseScenario
      protected

      def episode_id
        "86_la_cumbre_de_la_torre_milenio"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { tendo: :mortal_adversary },
          belongings: []
        )
        tendo = Character.new(
          id: :yosuke_tendo,
          name: "Yosuke Tendo",
          attributes: { hp: 100, role: :ruthless_boxing_lieutenant },
          relationships: { aoki: :ambitious_partner, ichiban: :thorn_in_flesh },
          belongings: []
        )
        nick = Character.new(
          id: :nick_ogata,
          name: "Nick Ogata",
          attributes: { role: :strategist },
          relationships: { ichiban: :live_support },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "millennium_tower_breach",
          location: "Kamurocho - Millennium Tower (Atrio y Oficinas)",
          time_period: "2019 - Día Electoral (Jornada de Votación)",
          money: 26300,
          characters: {
            ichiban: ichiban,
            yosuke_tendo: tendo,
            nick_ogata: nick
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :legendary_hero_bat,
            :masumi_arakawa_incense
          ],
          flags: {
            ep85_completed: true
          }
        )
      end

      def define_scenes
        scene_breach = Scene.new(
          id: "millennium_tower_breach",
          title: "Infiltración y Asalto a Millennium Tower",
          location: "Kamurocho - Millennium Tower (Atrio y Pisos Intermedios)"
        )
        scene_breach.add_precondition do |state|
          state.flag?(:ep85_completed)
        end

        scene_climb = Scene.new(
          id: "millennium_tower_ascent",
          title: "Ascenso entre las Filas de la Tokyo Omi",
          location: "Kamurocho - Millennium Tower (Piso 50)"
        )
        scene_climb.add_precondition do |state|
          state.flag?(:millennium_atrium_cleared)
        end

        scene_tendo_duel = Scene.new(
          id: "tendo_boxing_showdown",
          title: "Duelo a Muerte contra Yosuke Tendo",
          location: "Kamurocho - Millennium Tower (Piso Superior - Despacho Arakawa)"
        )
        scene_tendo_duel.add_precondition do |state|
          state.flag?(:penthouse_reached)
        end

        [scene_breach, scene_climb, scene_tendo_duel]
      end

      def execute_scenario
        scene_breach, scene_climb, scene_tendo_duel = define_scenes

        # 1. Entrada a la torre y noticia electoral en pantallas gigantes
        transition_to(scene_breach)
        emit("story.election_results_broadcast", actor: :ichiban, data: {
          broadcast: "los_sondeos_confirman_la_victoria_de_kume_en_kanagawa_distrito_2",
          atmosphere: "la_alianza_clp_celebra_mientras_la_omi_custodia_la_torre"
        })
        emit("story.combat_resolved", actor: :ichiban, target: :tokyo_omi_vanguard, data: {
          location: "atrio_principal_de_millennium_tower",
          result: :guards_defeated
        })
        @state.set_flag(:millennium_atrium_cleared, true)

        # 2. Ascenso hacia el ático con soporte en directo de Nick Ogata
        transition_to(scene_climb, new_location: "Kamurocho - Millennium Tower (Piso 50)")
        emit("story.nick_intel_live_transmission", actor: :nick_ogata, target: :ichiban, data: {
          stream: "nick_ogata_rastrea_los_movimientos_de_la_torre_en_tiempo_real",
          warning: "tendo_esta_en_el_piso_superior_armado_y_esperando_en_el_despacho_arakawa"
        })
        emit("story.combat_resolved", actor: :ichiban, target: :tokyo_omi_elites, data: {
          location: "piso_50_y_sala_de_conferencias",
          result: :elites_neutralized
        })
        @state.set_flag(:penthouse_reached, true)

        # 3. Duelo decisivo en el ático contra Tendo
        transition_to(scene_tendo_duel, new_location: "Kamurocho - Millennium Tower (Piso Superior - Despacho Arakawa)")
        emit("story.tendo_confrontation_and_motive", actor: :yosuke_tendo, target: :ichiban, data: {
          confession: "tendo_admite_haber_ejecutado_a_masumi_arakawa_sin_remordimientos_para_alcanzar_la_cima",
          mockery: "se_burla_de_la_lealtad_ciega_de_kasuga_hacia_su_padre_muerto"
        })
        emit("story.combat_resolved", actor: :ichiban, target: :yosuke_tendo, data: {
          boss: :yosuke_tendo,
          result: :tendo_knocked_out_cold
        })
        emit("story.tendo_vanquished", actor: :ichiban, target: :yosuke_tendo, data: {
          retribution: "kasuga_y_sus_amigos_derrotan_al_exboxeador_reivindicando_el_honor_de_arakawa"
        })
        @state.set_flag(:tendo_defeated, true)
        @state.set_flag(:ep86_completed, true)
      end

      def generate_summary
        "Episodio 86_la_cumbre_de_la_torre_milenio completado: Mientras las pantallas de Kamurocho anuncian el triunfo electoral de Sota Kume, Kasuga y sus camaradas irrumpen en Millennium Tower. Con la asistencia logística y el monitoreo por streaming de Nick Ogata, el equipo limpia los pisos fuertemente resguardados por los paramilitares de la Tokyo Omi Alliance hasta alcanzar el ático. En el despacho de la Familia Arakawa, confrontan cara a cara a Yosuke Tendo. Tras admitir cínicamente el magnicidio de Masumi Arakawa en el muelle, se desata una brutal pelea de boxeo a muerte en la que Kasuga deja noqueado a Tendo, vengando la memoria del patriarca."
      end
    end
  end
end
