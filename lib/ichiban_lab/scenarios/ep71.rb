# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep71 < IchibanLab::BaseScenario
      protected

      def episode_id
        "71_la_gran_batalla_de_la_omi"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { arakawa: :protector, watase: :ally },
          belongings: []
        )
        watase = Character.new(
          id: :masaru_watase,
          name: "Masaru Watase",
          attributes: { role: :reformer_leader },
          relationships: { ichiban: :comrade },
          belongings: []
        )
        kiryu = Character.new(
          id: :kazuma_kiryu,
          name: "Guardaespaldas Misterioso (Kazuma Kiryu)",
          attributes: { role: :bodyguard, status: :dragon_of_dojima },
          relationships: { watase: :client },
          belongings: []
        )
        tendo = Character.new(
          id: :yosuke_tendo,
          name: "Yosuke Tendo",
          attributes: { role: :opportunist_brawler },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "mass_brawl_at_omi_headquarters",
          location: "Cuartel General Omi - Salón de Asambleas",
          time_period: "2019 - Mañana",
          money: 26300,
          characters: {
            ichiban: ichiban,
            masaru_watase: watase,
            kazuma_kiryu: kiryu,
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
            joint_dissolution_proclaimed: true,
            plan_3k_truth_understood: true
          }
        )
      end

      def execute_scenario
        scene_brawl = Scene.new(
          id: :mass_brawl_at_omi_headquarters,
          title: "Batalla campal total contra los amotinados de la Alianza Omi",
          location: "Cuartel General Omi - Salón de Asambleas"
        )
        scene_brawl.add_precondition("La disolución debe haber sido proclamada") do |ws|
          ws.flag?(:joint_dissolution_proclaimed)
        end

        scene_kiryu_intervention = Scene.new(
          id: :kiryu_bodyguard_intervention,
          title: "Intervención providencial de Kazuma Kiryu protegiendo a Watase",
          location: "Cuartel General Omi - Salón de Asambleas"
        )

        scene_police_submission = Scene.new(
          id: :dissolution_documents_delivered_to_police,
          title: "Entrega oficial del acta de disolución a la policía de Osaka",
          location: "Jefatura de Policía de la Prefectura de Osaka"
        )

        # 1. Batalla multitudinaria: Tendo se suma al bando de Watase por ansia de pelea; el grupo resiste las oleadas
        scene_brawl.check_preconditions!(@state)
        transition_to(scene_brawl)
        emit("story.tendo_opportunist_alliance", actor: :yosuke_tendo, data: { choice: "luchar_en_el_bando_de_watase_y_daigo_por_el_placer_del_combate" })
        emit("story.omi_rebels_overwhelmed", actor: :ichiban, data: { outcome: "amotinados_de_la_omi_derrotados_por_el_frente_unido" })

        # 2. Un sicario intenta acuchillar a traición a Watase con un tanto; Kazuma Kiryu lo bloquea en seco
        transition_to(scene_kiryu_intervention)
        emit("story.kiryu_tanto_deflection_and_defense", actor: :kazuma_kiryu, target: :masaru_watase, data: {
          protector: "kazuma_kiryu",
          contract: "contratado_bajo_acuerdo_de_confidencialidad_como_guardaespaldas",
          assassin_subdued: "intento_de_magnicidio_frustrado_al_instante"
        })
        @state.set_flag(:kiryu_guardian_revealed, true)

        # 3. La comitiva entrega las actas notariales de disolución en la jefatura policial; la yakuza formalmente se extingue
        transition_to(scene_police_submission, new_location: "Jefatura de Policía de la Prefectura de Osaka")
        emit("story.dissolution_paperwork_submitted", actor: :masaru_watase, data: { recipient: "policia_prefectural_de_osaka", historical_event: "fin_oficial_del_clan_tojo_y_la_alianza_omi" })
        @state.set_flag(:dissolution_formally_filed, true)
      end

      def generate_summary
        "Episodio 71_la_gran_batalla_de_la_omi completado: Batalla campal histórica en el cuartel de la Omi. El grupo de Kasuga y las leyendas repelen a los cientos de miembros rebeldes. Kazuma Kiryu interviene como guardaespaldas de Watase interceptando a un atacante suicida. Las actas de disolución conjunta son entregadas formalmente a la policía de Osaka, poniendo fin a la era clásica de la yakuza."
      end
    end
  end
end
