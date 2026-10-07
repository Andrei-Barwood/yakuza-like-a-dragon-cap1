# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep09 < IchibanLab::BaseScenario
      protected

      def episode_id
        "09_el_nuevo_kamurocho"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :former_convict },
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

        WorldState.new(
          episode: episode_id,
          scene_id: "tenkaichi_gate_arrival",
          location: "Kamurocho - Tenkaichi Gate",
          time_period: "2019 - Tarde",
          money: 500,
          characters: { ichiban: ichiban, adachi: adachi },
          inventory: [],
          flags: { destination: :kamurocho }
        )
      end

      def execute_scenario
        scene_arrival = Scene.new(id: :tenkaichi_gate_arrival, title: "Llegada a Kamurocho", location: "Kamurocho - Tenkaichi Gate")
        scene_arrival.add_precondition("El destino debe ser Kamurocho") do |ws|
          ws.flag(:destination) == :kamurocho
        end

        scene_hq = Scene.new(id: :old_headquarters_surveillance, title: "Antigua sede Arakawa", location: "Callejón Nakamichi - Antigua sede")
        scene_clash = Scene.new(id: :clash_with_omi_patrol, title: "Pelea con la Omi", location: "Callejón Nakamichi")
        scene_lead = Scene.new(id: :summit_lead_discovery, title: "Pista de la cumbre", location: "Nakamichi Street")
        scene_lead.add_precondition("La patrulla debe haber sido derrotada") do |ws|
          ws.flag?(:omi_patrol_defeated)
        end

        # 1. Llegada a Kamurocho
        scene_arrival.check_preconditions!(@state)
        @state.set_flag(:kamurocho_entered, true)
        emit("story.scene_transition", data: { to_scene: "tenkaichi_gate_arrival", location: @state.location })

        # 2. Antigua sede
        transition_to(scene_hq, new_location: "Callejón Nakamichi - Antigua sede")
        @state.set_flag(:old_office_inspected, true)

        # 3. Pelea con la patrulla de la Omi
        transition_to(scene_clash, new_location: "Callejón Nakamichi")
        omi_patrol = Character.new(id: :omi_patrol, name: "Patrulla de la Omi Alliance", attributes: { hostile: true })
        @state.add_character(omi_patrol)
        @state.set_flag(:omi_patrol_defeated, true)
        @state.adjust_money(3000)
        emit("story.combat_resolved", actor: :ichiban, target: :omi_patrol, data: { victory: true })

        # 4. Pista de la cumbre
        transition_to(scene_lead, new_location: "Nakamichi Street")
        @state.set_flag(:summit_meeting_discovered, true)
        @state.set_flag(:next_objective, :find_way_into_summit)
        emit("story.information_revealed", actor: :omi_patrol, target: :ichiban, data: { intel: "arakawa_attending_omi_summit_tonight" })
        emit("story.objective_started", actor: :ichiban, data: { goal: "infiltrate_omi_summit" })
      end

      def generate_summary
        "Episodio 09_el_nuevo_kamurocho completado: Ichiban explora el Kamurocho ocupado por la Omi y descubre que Arakawa presidirá la cumbre de esta noche."
      end
    end
  end
end
