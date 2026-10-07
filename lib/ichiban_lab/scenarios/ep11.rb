# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep11 < IchibanLab::BaseScenario
      protected

      def episode_id
        "11_los_bajos_fondos"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :former_convict },
          relationships: { adachi: :partner },
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :partner },
          relationships: { ichiban: :partner },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "sewer_descent",
          location: "Alcantarillado de Kamurocho",
          time_period: "2019 - Noche",
          money: 3500,
          characters: { ichiban: ichiban, adachi: adachi },
          inventory: [:nick_ogata_business_card],
          flags: { next_step: :enter_underground_sewers }
        )
      end

      def execute_scenario
        scene_descent = Scene.new(id: :sewer_descent, title: "Descenso a las cloacas", location: "Alcantarillado de Kamurocho")
        scene_descent.add_precondition("Debe existir la orden de entrar y tener a Adachi") do |ws|
          ws.flag(:next_step) == :enter_underground_sewers && ws.has_character?(:adachi)
        end

        scene_guards = Scene.new(id: :underground_security_checkpoint, title: "Puesto de guardia", location: "Alcantarillado - Cruce de compuertas")
        scene_hatch = Scene.new(id: :maintenance_hatch_breach, title: "Forzar escotilla", location: "Final del túnel")
        scene_hatch.add_precondition("Los guardias del túnel deben ser neutralizados") do |ws|
          ws.flag?(:sewer_guards_defeated)
        end

        scene_basement = Scene.new(id: :building_basement_arrival, title: "Llegada al sótano", location: "Sótano del Edificio de la Cumbre")
        scene_basement.add_precondition("La escotilla debe estar abierta") do |ws|
          ws.flag?(:access_hatch_opened)
        end

        # 1. Descenso al alcantarillado
        scene_descent.check_preconditions!(@state)
        @state.set_flag(:sewer_navigated, true)
        emit("story.scene_transition", data: { to_scene: "sewer_descent", location: @state.location })

        # 2. Puesto de centinelas
        transition_to(scene_guards, new_location: "Alcantarillado - Cruce de compuertas")
        guards = Character.new(id: :omi_tunnel_guards, name: "Centinelas de la Omi", attributes: { hostile: true })
        @state.add_character(guards)
        @state.set_flag(:sewer_guards_defeated, true)
        emit("story.combat_resolved", actor: :ichiban, target: :omi_tunnel_guards, data: { assisted_by: :adachi, victory: true })

        # 3. Forzar escotilla
        transition_to(scene_hatch, new_location: "Final del túnel")
        @state.set_flag(:access_hatch_opened, true)
        emit("story.objective_completed", actor: :ichiban, data: { action: "force_maintenance_hatch" })

        # 4. Llegada al sótano
        transition_to(scene_basement, new_location: "Sótano del Edificio de la Cumbre")
        @state.set_flag(:building_infiltrated, true)
        @state.set_flag(:next_step, :storm_executive_floor)
      end

      def generate_summary
        "Episodio 11_los_bajos_fondos completado: Infiltración subterránea exitosa a través del alcantarillado hasta los cimientos del edificio de la cumbre."
      end
    end
  end
end
