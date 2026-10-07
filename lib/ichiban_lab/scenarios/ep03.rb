# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep03 < IchibanLab::BaseScenario
      protected

      def episode_id
        "03_encargo_urgente"
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
        michiyo = Character.new(
          id: :michiyo,
          name: "Michiyo",
          attributes: { role: :shangri_la_manager }
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "michiyo_request",
          location: "Shangri-La exterior",
          time_period: "2000 - Mediodía",
          money: 202_000,
          characters: { ichiban: ichiban, michiyo: michiyo },
          inventory: [:arakawa_pin],
          flags: {}
        )
      end

      def execute_scenario
        _scene_request = Scene.new(id: :michiyo_request, title: "El recado de Michiyo", location: "Shangri-La exterior")
        scene_skirmish = Scene.new(id: :street_skirmish_elderly, title: "Acoso en la calle", location: "Nakamichi Street")
        scene_shop = Scene.new(id: :cigarette_shop_errand, title: "Tienda de cigarrillos", location: "Tienda de cigarrillos")
        scene_shop.add_precondition("El altercado callejero debe resolverse antes") do |ws|
          ws.flag?(:elderly_protected)
        end

        scene_resolution = Scene.new(id: :shangri_la_resolution, title: "Reparación en Shangri-La", location: "Shangri-La")
        scene_resolution.add_precondition("Ichiban debe tener el desatascador") do |ws|
          ws.has_item?(:heavy_duty_plunger)
        end

        # 1. Recado de Michiyo
        emit("story.objective_started", actor: :ichiban, data: { task: "resolve_shangri_la_plumbing" })
        @state.set_flag(:favor_accepted, true)

        # 2. Altercado callejero
        transition_to(scene_skirmish, new_location: "Nakamichi Street")
        thugs = Character.new(id: :street_thugs, name: "Matones callejeros", attributes: { hostile: true })
        @state.add_character(thugs)
        @state.set_flag(:elderly_protected, true)
        emit("story.combat_resolved", actor: :ichiban, target: :street_thugs, data: { protected: :elderly_man })

        # 3. Tienda de cigarrillos y adquisición del desatascador
        transition_to(scene_shop, new_location: "Tienda de cigarrillos")
        @state.add_item(:heavy_duty_plunger)
        @state.set_flag(:plunger_acquired, true)
        emit("story.item_acquired", actor: :ichiban, data: { item: :heavy_duty_plunger })

        # 4. Resolución en Shangri-La
        transition_to(scene_resolution, new_location: "Shangri-La")
        @state.remove_item(:heavy_duty_plunger)
        @state.set_flag(:shangri_la_unclogged, true)
        emit("story.objective_completed", actor: :ichiban, data: { resolved: :shangri_la_toilet })

        # Comunicación de Mitsuo
        @state.set_flag(:mitsuo_called, true)
        @state.set_flag(:next_assignment_target, :hiratsuka)
        emit("story.communication_received", actor: :mitsuo, target: :ichiban, data: { assignment: "collect_hiratsuka_park_3" })
      end

      def generate_summary
        "Episodio 03_encargo_urgente completado: Ichiban protege al anciano, desatasca Shangri-La con el desatascador y recibe el encargo de Mitsuo."
      end
    end
  end
end
