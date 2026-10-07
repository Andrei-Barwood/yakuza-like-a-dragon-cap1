# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep19 < IchibanLab::BaseScenario
      protected

      def episode_id
        "19_el_empleo_prometido"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :registered_citizen, address: "Sunrise Street, Ijincho", calling: :hero },
          relationships: { nanba: :sworn_partner },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :sworn_partner, address: "Sunrise Street, Ijincho" },
          relationships: { ichiban: :sworn_partner },
          belongings: []
        )
        ririka = Character.new(
          id: :ririka,
          name: "Ririka",
          attributes: { role: :hello_work_clerk },
          relationships: {},
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :former_detective },
          relationships: {},
          belongings: []
        )
        nonomiya = Character.new(
          id: :nonomiya,
          name: "Nonomiya",
          attributes: { role: :otohime_land_manager },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "hello_work_with_address",
          location: "Oficina de Hello Work Yokohama",
          time_period: "2019 - Mañana",
          money: 6300,
          characters: { ichiban: ichiban, nanba: nanba, ririka: ririka, adachi: adachi, nonomiya: nonomiya },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill],
          flags: { has_permanent_residence: true, chapter_3_completed: true }
        )
      end

      def execute_scenario
        scene_interview = Scene.new(id: :hello_work_with_address, title: "Registro laboral en Hello Work", location: "Oficina de Hello Work Yokohama")
        scene_interview.add_precondition("Ichiban debe tener domicilio legal acreditado") do |ws|
          ws.flag?(:has_permanent_residence)
        end

        scene_reunion = Scene.new(id: :adachi_reunion, title: "Reencuentro con Adachi", location: "Exterior de Hello Work")
        scene_contract = Scene.new(id: :nonomiya_recruitment, title: "La oferta de Nonomiya", location: "Oficina de Hello Work Yokohama")

        # 1. Presentación de documentos y validación con Ririka
        scene_interview.check_preconditions!(@state)
        transition_to(scene_interview)
        emit("story.official_registration", actor: :ririka, target: :ichiban, data: { address: "Sunrise Street, Ijincho", status: :eligible_for_employment })
        @state.set_flag(:officially_registered_jobseeker, true)

        # 2. Reencuentro con Adachi en Yokohama
        transition_to(scene_reunion, new_location: "Exterior de Hello Work")
        emit("story.character_reencountered", actor: :adachi, target: :ichiban, data: { status: :investigating_arakawa_ties_in_yokohama })
        @state.character(:ichiban).set_relationship(:adachi, :ally)
        @state.character(:adachi).set_relationship(:ichiban, :ally)
        @state.set_flag(:adachi_rejoined_party, true)

        # 3. Llegada de Nonomiya y oferta para Otohime Land
        transition_to(scene_contract, new_location: "Oficina de Hello Work Yokohama", new_time: "2019 - Mediodía")
        emit("story.job_opportunity_unlocked", actor: :nonomiya, target: :ichiban, data: { establishment: "Otohime Land", role: "investigador_de_personal" })
        @state.set_flag(:otohime_land_assigned, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "ir_a_otohime_land" })
      end

      def generate_summary
        "Episodio 19_el_empleo_prometido completado: Gracias al domicilio en Sunrise Street, Ichiban y Nanba se registran formalmente en Hello Work, se reencuentran con Adachi y aceptan la oferta laboral de Nonomiya en Otohime Land."
      end
    end
  end
end
