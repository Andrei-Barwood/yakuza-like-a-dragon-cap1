# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep27 < IchibanLab::BaseScenario
      protected

      def episode_id
        "27_el_cambio_de_oficio"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader, current_job: :freelancer },
          relationships: { nanba: :sworn_partner, adachi: :brother_in_arms, saeko: :protectee },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :party_member, current_job: :homeless },
          relationships: { ichiban: :sworn_partner },
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :party_member, current_job: :detective },
          relationships: { ichiban: :brother_in_arms },
          belongings: []
        )
        saeko = Character.new(
          id: :saeko,
          name: "Saeko Mukoda",
          attributes: { role: :party_member, current_job: :hostess },
          relationships: { ichiban: :ally },
          belongings: []
        )
        ririka = Character.new(
          id: :ririka,
          name: "Ririka",
          attributes: { role: :job_counselor },
          relationships: {},
          belongings: []
        )
        kanbe = Character.new(
          id: :kanbe,
          name: "Director Shuichi Kanbe",
          attributes: { role: :hello_work_director },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "hello_work_job_system",
          location: "Oficina de Hello Work Yokohama",
          time_period: "2019 - Mañana",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, ririka: ririka, kanbe: kanbe },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key],
          flags: { yokohama_trading_identified: true }
        )
      end

      def execute_scenario
        scene_jobs = Scene.new(id: :hello_work_job_system, title: "Desbloqueo del Job System con Ririka", location: "Oficina de Hello Work Yokohama")
        scene_jobs.add_precondition("Yokohama Trading Company debe haber sido identificada") do |ws|
          ws.flag?(:yokohama_trading_identified)
        end

        scene_kanbe = Scene.new(id: :warehouse_part_time_offer, title: "Colocación de mozos en el muelle de Hamakita", location: "Oficina de Hello Work Yokohama")
        scene_dock = Scene.new(id: :yokohama_trading_arrival, title: "Llegada al almacén de Yokohama Trading", location: "Muelle de Hamakita Park - Almacén")

        # 1. Desbloqueo del sistema de oficios con Ririka
        scene_jobs.check_preconditions!(@state)
        transition_to(scene_jobs)
        emit("story.mechanic_unlocked", actor: :ichiban, data: { system: :job_change_system, counselor: "Ririka" })
        @state.character(:ichiban).set_attribute(:job_system_unlocked, true)
        @state.set_flag(:job_system_available, true)

        # 2. Asignación encubierta de Kanbe para el almacén de Mabuchi
        transition_to(scene_kanbe)
        emit("story.undercover_assignment", actor: :kanbe, target: :ichiban, data: { destination: "Yokohama Trading Company Warehouse", role: "mozos_de_carga" })
        @state.set_flag(:warehouse_job_contracted, true)

        # 3. Llegada y turno inicial en el muelle
        transition_to(scene_dock, new_location: "Muelle de Hamakita Park - Almacén", new_time: "2019 - Tarde")
        emit("story.warehouse_inspection", actor: :saeko, target: :ichiban, data: { cargo: ["aletas_de_tiburon", "oreja_de_mar", "papel_especial"], payment: "estricto_efectivo" })
        @state.set_flag(:dock_infiltration_active, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "inspeccionar_almacen_de_mabuchi" })
      end

      def generate_summary
        "Episodio 27_el_cambio_de_oficio completado: Ririka desbloquea el Job System formal en Hello Work. El Director Kanbe consigue puestos de mozos de almacén en Yokohama Trading Company, comenzando la infiltración en el muelle de Hamakita."
      end
    end
  end
end
