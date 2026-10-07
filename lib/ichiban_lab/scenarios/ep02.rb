# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep02 < IchibanLab::BaseScenario
      protected

      def episode_id
        "02_cobranza"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :arakawa_soldier },
          relationships: { mitsuo: :junior },
          belongings: [:arakawa_pin]
        )
        mitsuo = Character.new(
          id: :mitsuo,
          name: "Mitsuo Yasuda",
          attributes: { hp: 80, role: :shatei },
          relationships: { ichiban: :aniki },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "streets_morning_patrol",
          location: "Kamurocho - Tenkaichi Street",
          time_period: "2000 - Mañana",
          money: 2000,
          characters: { ichiban: ichiban, mitsuo: mitsuo },
          inventory: [:arakawa_pin],
          flags: {}
        )
      end

      def execute_scenario
        _scene_patrol = Scene.new(id: :streets_morning_patrol, title: "Ronda matutina", location: "Kamurocho - Tenkaichi Street")
        scene_confrontation = Scene.new(id: :ushio_den_confrontation, title: "Local clandestino de Ushio", location: "Callejón Nakamichi - Local clandestino")
        scene_confrontation.add_precondition("El objetivo debe estar identificado") do |ws|
          ws.flag?(:target_identified)
        end

        scene_combat = Scene.new(id: :ushio_combat, title: "Combate contra Ushio", location: "Callejón Nakamichi - Local clandestino")
        scene_combat.add_precondition("Ushio debe estar confrontado") do |ws|
          ws.has_character?(:ushio)
        end

        scene_choice = Scene.new(id: :moral_choice_reimbursement, title: "Cobranza y reembolso", location: "Callejón Nakamichi")
        scene_choice.add_precondition("El combate debe estar resuelto") do |ws|
          ws.flag?(:combat_resolved)
        end

        # 1. Patrulla matutina
        emit("story.objective_started", actor: :ichiban, data: { task: "locate_and_collect_debt", target: :ushio })
        @state.set_flag(:target_identified, true)

        # 2. Local de Ushio
        transition_to(scene_confrontation, new_location: "Callejón Nakamichi - Local clandestino")
        ushio = Character.new(
          id: :ushio,
          name: "Hirotaka Ushio",
          attributes: { hp: 100, role: :bootlegger, status: :hostile }
        )
        @state.add_character(ushio)

        # 3. Combate
        transition_to(scene_combat)
        ushio.set_attribute(:hp, 0)
        ushio.set_attribute(:status, :defeated)
        @state.set_flag(:combat_resolved, true)
        emit("story.combat_resolved", actor: :ichiban, target: :ushio, data: { victory: true })

        # 4. Decisión moral y cobro
        transition_to(scene_choice, new_location: "Callejón Nakamichi")
        @state.set_flag(:buyers_reimbursed, true)
        @state.set_flag(:debt_collected, true)
        @state.adjust_money(200_000)
        @state.character(:ichiban).set_relationship(:mitsuo, :loyal_comrade)

        emit("story.choice_recorded", actor: :ichiban, data: { choice: :refund_buyers, amount_refunded: 50_000 })
        emit("story.debt_collected", actor: :ichiban, target: :ushio, data: { amount_collected: 200_000 })
      end

      def generate_summary
        "Episodio 02_cobranza completado: Ichiban cobra los ¥200,000 adeudados tras vencer a Ushio y reembolsa ¥50,000 a las víctimas."
      end
    end
  end
end
