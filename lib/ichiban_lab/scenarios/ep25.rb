# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep25 < IchibanLab::BaseScenario
      protected

      def episode_id
        "25_la_heredera_de_otohime"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { nanba: :sworn_partner, adachi: :brother_in_arms },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :party_member },
          relationships: { ichiban: :sworn_partner },
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
          attributes: { role: :otohime_hostess, grief: :seeking_truth },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "otohime_land_crime_scene",
          location: "Otohime Land Soapland - Despacho de Nonomiya",
          time_period: "2019 - Noche del incidente",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key],
          flags: { nonomiya_found_dead: true, chapter_4_completed: true }
        )
      end

      def execute_scenario
        scene_crime = Scene.new(id: :otohime_land_crime_scene, title: "La escena del crimen y la llegada de Saeko", location: "Otohime Land Soapland - Despacho de Nonomiya")
        scene_crime.add_precondition("Nonomiya debe haber sido encontrado muerto") do |ws|
          ws.flag?(:nonomiya_found_dead)
        end

        scene_pact = Scene.new(id: :saeko_investigation_pact, title: "Pacto de investigación con Saeko", location: "Otohime Land Soapland - Despacho de Nonomiya")
        scene_lead = Scene.new(id: :mabuchi_lead_discovered, title: "La pista de Akira Mabuchi", location: "Isezaki Road")

        # 1. Escena de la tragedia y sospechas de asesinato encubierto
        scene_crime.check_preconditions!(@state)
        transition_to(scene_crime)
        emit("story.dialogue_resolved", actor: :saeko, target: :ichiban, data: { reaction: "Nonomiya nunca se habría suicidado; esto es obra de la mafia china" })
        @state.character(:saeko).set_relationship(:ichiban, :ally)
        @state.character(:ichiban).set_relationship(:saeko, :protectee)

        # 2. Saeko se une formalmente al grupo de investigación
        transition_to(scene_pact)
        emit("story.party_member_joined", actor: :saeko, data: { name: "Saeko Mukoda", motivation: "vengar_a_nonomiya_y_proteger_el_soapland" })
        @state.set_flag(:saeko_joined_party, true)

        # 3. Descubrimiento de la conexión con Akira Mabuchi (Yokohama Liumang)
        transition_to(scene_lead, new_location: "Isezaki Road", new_time: "2019 - Medianoche")
        emit("story.target_identified", actor: :ichiban, data: { suspect: "Akira Mabuchi", faction: "Yokohama Liumang", next_step: "infiltrar_lin_lin_hostess_bar" })
        @state.set_flag(:mabuchi_investigation_started, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "ir_a_lin_lin_hostess_bar" })
      end

      def generate_summary
        "Episodio 25_la_heredera_de_otohime completado: Saeko Mukoda rechaza la tesis del suicidio de Nonomiya y se une al grupo de Ichiban para dar caza al responsable intelectual: Akira Mabuchi de Yokohama Liumang."
      end
    end
  end
end
