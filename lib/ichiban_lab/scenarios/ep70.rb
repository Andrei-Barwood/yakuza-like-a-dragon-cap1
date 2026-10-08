# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep70 < IchibanLab::BaseScenario
      protected

      def episode_id
        "70_el_pacto_de_disolucion"
      end

      def main_actor
        :masumi_arakawa
      end

      def default_initial_state
        arakawa = Character.new(
          id: :masumi_arakawa,
          name: "Masumi Arakawa",
          attributes: { hp: 100, role: :acting_captain_omi },
          relationships: { ichiban: :protector, daigo: :co_conspirator },
          belongings: []
        )
        daigo = Character.new(
          id: :daigo_dojima,
          name: "Daigo Dojima",
          attributes: { role: :sixth_chairman_tojo },
          relationships: { arakawa: :co_conspirator },
          belongings: []
        )
        watase = Character.new(
          id: :masaru_watase,
          name: "Masaru Watase",
          attributes: { role: :captain_omi_alliance },
          relationships: { daigo: :co_conspirator },
          belongings: []
        )
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { role: :witness_and_protector },
          relationships: { arakawa: :devoted_subordinate },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "plan_3k_truth_revealed",
          location: "Cuartel General Omi - Salón de Asambleas",
          time_period: "2019 - Noche a Mañana",
          money: 26300,
          characters: {
            masumi_arakawa: arakawa,
            daigo_dojima: daigo,
            masaru_watase: watase,
            ichiban: ichiban
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
            tojo_legends_alliance_confirmed: true,
            majima_saejima_defeated: true
          }
        )
      end

      def execute_scenario
        scene_truth = Scene.new(
          id: :plan_3k_truth_revealed,
          title: "La verdad del Plan 3K: la aparente traición orquestada por Daigo",
          location: "Cuartel General Omi - Cámara del Dragón"
        )
        scene_truth.add_precondition("La alianza de leyendas debe haberse confirmado") do |ws|
          ws.flag?(:tojo_legends_alliance_confirmed)
        end

        scene_assembly = Scene.new(
          id: :watase_arrival_and_joint_dissolution_announcement,
          title: "Llegada de Masaru Watase y anuncio conjunto de disolución",
          location: "Cuartel General Omi - Salón de Asambleas"
        )

        scene_rebellion = Scene.new(
          id: :omi_officers_outrage_and_rebellion,
          title: "Indignación de los capitanes de la Omi y conato de rebelión",
          location: "Cuartel General Omi - Salón de Asambleas"
        )

        # 1. Daigo Dojima y Arakawa explican que el Plan 3K fue una treta para dividir a la Omi trayéndola a Kamurocho
        scene_truth.check_preconditions!(@state)
        transition_to(scene_truth)
        emit("story.plan_3k_true_purpose_revealed", actor: :daigo_dojima, target: :ichiban, data: {
          scheme: "la_traicion_de_arakawa_fue_ordenada_por_daigo_para_salvar_al_tojo_y_dividir_a_la_omi",
          anti_yakuza_pressure: "las_leyes_hicieron_insostenible_la_existencia_de_los_sindicatos"
        })
        @state.set_flag(:plan_3k_truth_understood, true)

        # 2. A la mañana siguiente, Masaru Watase llega desde prisión; se presenta ante la cúpula Omi
        transition_to(scene_assembly, new_location: "Cuartel General Omi - Salón de Asambleas", new_time: "2019 - Mañana")
        emit("story.joint_dissolution_proclaimed", actor: :masaru_watase, data: {
          tojo_clan_status: "disolucion_anunciada_por_daigo_dojima",
          omi_alliance_status: "disolucion_anunciada_por_masaru_watase_y_masumi_arakawa",
          approval: "aprobado_por_el_presidente_enfermo_de_la_omi"
        })

        # 3. La asamblea entra en cólera; los capitanes de la Omi se alzan en armas contra la disolución
        transition_to(scene_rebellion)
        emit("story.omi_rebellion_sparked", actor: :masaru_watase, data: { provocation: "quien_quiera_impedir_la_entrega_del_acta_a_la_policia_tendra_que_matarme" })
        @state.set_flag(:joint_dissolution_proclaimed, true)
      end

      def generate_summary
        "Episodio 70_el_pacto_de_disolucion completado: Arakawa y Daigo revelan que la supuesta traición al Clan Tojo fue un plan maestro consensuado para dividir a la Alianza Omi. Masaru Watase es liberado de prisión y, junto a Daigo y Arakawa, proclama solemnemente ante la asamblea la disolución simultánea e histórica de ambos clanes yakuza, desatando la furia de los capitanes rebeldes."
      end
    end
  end
end
