# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep20 < IchibanLab::BaseScenario
      protected

      def episode_id
        "20_otohime_land"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :soapland_employee },
          relationships: { nanba: :sworn_partner, adachi: :ally },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :soapland_employee },
          relationships: { ichiban: :sworn_partner },
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :party_investigator },
          relationships: { ichiban: :ally },
          belongings: []
        )
        nonomiya = Character.new(
          id: :nonomiya,
          name: "Nonomiya",
          attributes: { role: :otohime_land_manager },
          relationships: {},
          belongings: []
        )
        nanoha = Character.new(
          id: :nanoha,
          name: "Nanoha Mukoda",
          attributes: { role: :soapland_worker, status: :exhausted },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "otohime_land_briefing",
          location: "Otohime Land Soapland",
          time_period: "2019 - Tarde",
          money: 6300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, nonomiya: nonomiya, nanoha: nanoha },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill],
          flags: { otohime_land_assigned: true, adachi_rejoined_party: true }
        )
      end

      def execute_scenario
        scene_briefing = Scene.new(id: :otohime_land_briefing, title: "El encargo de Nonomiya", location: "Otohime Land Soapland")
        scene_briefing.add_precondition("Ichiban debe haber sido contratado por Nonomiya") do |ws|
          ws.flag?(:otohime_land_assigned)
        end

        scene_stakeout = Scene.new(id: :pocket_cafe_wiretap, title: "Vigilancia en Pocket Café", location: "Pocket Café")
        scene_lead = Scene.new(id: :sunlight_castle_discovery, title: "Descubrimiento de Sunlight Castle", location: "Exterior de Sunlight Castle")

        # 1. Briefing en Otohime Land sobre las sospechas hacia Nanoha Mukoda
        scene_briefing.check_preconditions!(@state)
        transition_to(scene_briefing)
        emit("story.assignment_received", actor: :nonomiya, target: :ichiban, data: { subject: "Nanoha Mukoda", issue: "solicita adelantos masivos de dinero y luce extenuada" })
        @state.character(:ichiban).set_relationship(:nonomiya, :employer)

        # 2. Vigilancia y escucha telefónica en Pocket Café
        transition_to(scene_stakeout, new_location: "Pocket Café")
        emit("story.wiretap_planted", actor: :adachi, target: :nanoha, data: { method: "telefono_en_maceta", target_met: "hombre_de_traje_oscuro" })
        emit("story.overheard_conversation", actor: :ichiban, data: { keywords: ["Tatsuro", "pagos_desorbitados", "procedimiento_en_diez_dias"] })

        # 3. Seguimiento hasta el asilo Sunlight Castle
        transition_to(scene_lead, new_location: "Exterior de Sunlight Castle", new_time: "2019 - Atardecer")
        emit("story.facility_identified", actor: :ichiban, data: { facility: "Sunlight Castle", type: "residencia_de_ancianos", restriction: "solo_familiares_directos" })
        @state.set_flag(:sunlight_castle_located, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "investigar_sunlight_castle" })
      end

      def generate_summary
        "Episodio 20_otohime_land completado: Nonomiya encarga investigar a Nanoha Mukoda. Mediante la astucia de Adachi en Pocket Café descubren pagos sospechosos para su padre Tatsuro y localizan el asilo Sunlight Castle."
      end
    end
  end
end
