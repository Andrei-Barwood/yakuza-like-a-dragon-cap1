# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep08 < IchibanLab::BaseScenario
      protected

      def episode_id
        "08_liberacion"
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

        WorldState.new(
          episode: episode_id,
          scene_id: "prison_gate_release",
          location: "Puertas de la Prisión de Tokio",
          time_period: "2019 - Día",
          money: 500,
          characters: { ichiban: ichiban },
          inventory: [],
          flags: {}
        )
      end

      def execute_scenario
        scene_release = Scene.new(id: :prison_gate_release, title: "Liberación", location: "Puertas de la Prisión de Tokio")
        scene_approach = Scene.new(id: :adachi_approach, title: "Encuentro con Adachi", location: "Exterior de la Prisión")
        scene_brawl = Scene.new(id: :hostile_greeting_brawl, title: "Emboscada exterior", location: "Parada exterior")
        scene_revelation = Scene.new(id: :revelation_of_the_fall, title: "La revelación de la caída", location: "Ruta hacia Kamurocho")
        scene_revelation.add_precondition("Los agresores deben haber sido neutralizados") do |ws|
          ws.flag?(:ambush_survived)
        end

        # 1. Salida de prisión
        scene_release.check_preconditions!(@state)
        emit("story.prison_release", actor: :ichiban, data: { year: 2019, years_served: 18 })
        @state.set_flag(:released_from_prison, true)

        # 2. Encuentro con Adachi
        transition_to(scene_approach, new_location: "Exterior de la Prisión")
        adachi = Character.new(id: :adachi, name: "Koichi Adachi", attributes: { role: :former_detective })
        @state.add_character(adachi)
        @state.set_flag(:adachi_contacted, true)
        emit("story.character_introduced", actor: :adachi, target: :ichiban, data: { role: :ex_detective })

        # 3. Combate exterior
        transition_to(scene_brawl, new_location: "Parada exterior")
        thugs = Character.new(id: :arakawa_thugs, name: "Matones de la nueva Arakawa", attributes: { hostile: true })
        @state.add_character(thugs)
        @state.set_flag(:ambush_survived, true)
        emit("story.combat_resolved", actor: :ichiban, target: :arakawa_thugs, data: { assisted_by: :adachi, victory: true })

        # 4. Revelación y determinación hacia Kamurocho
        transition_to(scene_revelation, new_location: "Ruta hacia Kamurocho")
        @state.set_flag(:heard_arakawa_betrayal, true)
        @state.set_flag(:destination, :kamurocho)
        emit("story.information_revealed", actor: :adachi, target: :ichiban, data: { news: "arakawa_betrayal_and_omi_rise" })
        emit("story.objective_started", actor: :ichiban, data: { goal: "return_to_kamurocho" })
      end

      def generate_summary
        "Episodio 08_liberacion completado: Ichiban sale tras 18 años, repele una emboscada junto a Adachi y descubre la supuesta traición de Arakawa."
      end
    end
  end
end
