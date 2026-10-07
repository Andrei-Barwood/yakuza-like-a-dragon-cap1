# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep04 < IchibanLab::BaseScenario
      protected

      def episode_id
        "04_lo_que_se_debe"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :arakawa_soldier },
          relationships: { mitsuo: :loyal_comrade },
          belongings: [:arakawa_pin]
        )
        hiratsuka = Character.new(
          id: :hiratsuka,
          name: "Koji Hiratsuka",
          attributes: { hp: 80, role: :debtor, status: :desperate }
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "park_confrontation",
          location: "Kamurocho - Public Park 3",
          time_period: "2000 - Tarde",
          money: 202_000,
          characters: { ichiban: ichiban, hiratsuka: hiratsuka },
          inventory: [:arakawa_pin],
          flags: { next_assignment_target: :hiratsuka }
        )
      end

      def execute_scenario
        scene_confrontation = Scene.new(id: :park_confrontation, title: "Encuentro en el parque", location: "Public Park 3")
        scene_confrontation.add_precondition("El objetivo debe ser Hiratsuka") do |ws|
          ws.flag(:next_assignment_target) == :hiratsuka
        end

        scene_combat = Scene.new(id: :park_combat, title: "Pelea en el parque", location: "Public Park 3")
        scene_mercy = Scene.new(id: :wallet_inspection_and_mercy, title: "Decisión con la cartera", location: "Public Park 3")
        scene_mercy.add_precondition("Hiratsuka debe haber sido derrotado") do |ws|
          ws.character(:hiratsuka)&.attribute(:status) == :defeated
        end

        scene_call = Scene.new(id: :sawashiro_pager_call, title: "Llamada de Sawashiro", location: "Public Park 3")
        scene_call.add_precondition("La cobranza debe haber sido resuelta") do |ws|
          ws.flag?(:partial_collection)
        end

        # 1. Confrontación en el parque
        scene_confrontation.check_preconditions!(@state)
        emit("story.objective_started", actor: :ichiban, data: { target: :hiratsuka, location: "Public Park 3" })

        # 2. Combate
        transition_to(scene_combat)
        hiratsuka = @state.character(:hiratsuka)
        hiratsuka.set_attribute(:hp, 0)
        hiratsuka.set_attribute(:status, :defeated)
        emit("story.combat_resolved", actor: :ichiban, target: :hiratsuka, data: { victory: true })

        # 3. Decisión moral y cobro parcial
        transition_to(scene_mercy)
        @state.adjust_money(50_000)
        @state.set_flag(:hiratsuka_spared, true)
        @state.set_flag(:partial_collection, true)
        emit("story.choice_recorded", actor: :ichiban, data: { choice: :spare_half_debt, retained: 50_000, spared: 50_000 })
        emit("story.debt_collected", actor: :ichiban, target: :hiratsuka, data: { amount: 50_000 })

        # 4. Orden de Sawashiro
        transition_to(scene_call)
        sawashiro = Character.new(id: :sawashiro, name: "Jo Sawashiro", attributes: { role: :captain })
        @state.add_character(sawashiro)
        @state.set_flag(:sawashiro_summons, true)
        @state.set_flag(:next_assignment_target, :masato)
        emit("story.communication_received", actor: :sawashiro, target: :ichiban, data: { order: "attend_masato" })
      end

      def generate_summary
        "Episodio 04_lo_que_se_debe completado: Ichiban vence a Hiratsuka, retiene ¥50,000 perdonando el resto y recibe la orden de Sawashiro sobre Masato."
      end
    end
  end
end
