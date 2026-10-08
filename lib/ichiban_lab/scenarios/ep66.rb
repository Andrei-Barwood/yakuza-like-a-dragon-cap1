# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep66 < IchibanLab::BaseScenario
      protected

      def episode_id
        "66_el_desengano_y_la_resolucion"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { nanba: :sworn_brother, adachi: :brother_in_arms, saeko: :protectee, hamako: :benefactor },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :party_member },
          relationships: { ichiban: :sworn_brother },
          belongings: []
        )
        hamako = Character.new(
          id: :hamako,
          name: "Hamako",
          attributes: { role: :shelter_matron },
          relationships: { ichiban: :friend },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "otohime_ambush_and_nanba_rescue",
          location: "Otohime Land - Callejón Trasero",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            nanba: nanba,
            hamako: hamako
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
            aoki_talks_broken: true,
            suzumori_true_killer_known: true
          }
        )
      end

      def execute_scenario
        scene_ambush = Scene.new(
          id: :otohime_ambush_and_nanba_rescue,
          title: "Emboscada de la Omi y rescate providencial de Nanba",
          location: "Otohime Land - Callejón Trasero"
        )
        scene_ambush.add_precondition("Las negociaciones con Aoki deben haberse roto") do |ws|
          ws.flag?(:aoki_talks_broken)
        end

        scene_street_combat = Scene.new(
          id: :omi_enforcers_street_combat,
          title: "Combate contra los refuerzos armados de la Alianza Omi",
          location: "Calles de Ijincho - Frente a Otohime Land"
        )

        scene_hamako_tears = Scene.new(
          id: :hamako_tears_and_unwavering_resolve,
          title: "Las lágrimas de Hamako y la resolución definitiva del grupo",
          location: "Calles de Ijincho - Frente a Otohime Land"
        )

        # 1. Aoki deja a Sawashiro y a los esbirros de la Omi para ejecutar a Kasuga; Nanba interviene oportunamente
        scene_ambush.check_preconditions!(@state)
        transition_to(scene_ambush)
        emit("story.omi_execution_ambush_sprung", actor: :jo_sawashiro, target: :ichiban, data: { ambush_orders: "eliminar_a_kasuga_sin_dejar_rastro" })
        emit("story.nanba_opportune_intervention", actor: :nanba, target: :ichiban, data: { action: "abrir_brecha_de_escape_en_el_callejon" })

        # 2. Batalla en plena calle contra los matones de la Omi
        transition_to(scene_street_combat, new_location: "Calles de Ijincho - Frente a Otohime Land")
        emit("story.omi_enforcers_defeated", actor: :ichiban, data: { outcome: "sicarios_derrotados_en_la_calzada" })

        # 3. Hamako llega llorando: sus chicas han sido detenidas y deportadas; el grupo jura combatir sin marcha atrás
        transition_to(scene_hamako_tears)
        emit("story.migrant_women_deportation_confirmed", actor: :hamako, data: { tragedy: "las_trabajadoras_fueron_capturadas_y_deportadas_del_pais" })
        emit("story.no_turning_back_resolved", actor: :ichiban, data: { resolution: "guerra_total_contra_aoki_la_omi_y_la_policia_corrupta", no_exit: "nadie_del_grupo_puede_ni_quiere_abandonar_ijincho" })
        @state.set_flag(:hamako_workers_deported, true)
        @state.set_flag(:war_against_aoki_declared, true)
        @state.set_flag(:chapter_11_completed, true)

        # Transición hacia el Capítulo 12
        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 11, status: :concluded, next: :chapter_12 })
      end

      def generate_summary
        "Episodio 66_el_desengano_y_la_resolucion completado: Kasuga escapa de la trampa mortal de Aoki y Sawashiro gracias a Nanba y el grupo derrota a los matones de la Omi. Hamako confirma con desesperación que sus empleadas fueron engañadas y deportadas masivamente. Sin hogar ni opción de huida, Kasuga y sus aliados declaran la guerra total contra Ryo Aoki, la Alianza Omi y la cúpula corrupta. Fin del Capítulo 11."
      end
    end
  end
end
