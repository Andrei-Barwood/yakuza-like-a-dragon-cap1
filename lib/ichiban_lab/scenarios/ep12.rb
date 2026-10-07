# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep12 < IchibanLab::BaseScenario
      protected

      def episode_id
        "12_el_guantelete"
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
        sawashiro = Character.new(
          id: :sawashiro,
          name: "Jo Sawashiro",
          attributes: { hp: 150, role: :omi_captain, status: :ready_for_duel },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "stairs_breach_to_executive_floor",
          location: "Planta Ejecutiva - Entrada",
          time_period: "2019 - Noche cerrada",
          money: 3500,
          characters: { ichiban: ichiban, adachi: adachi, sawashiro: sawashiro },
          inventory: [:nick_ogata_business_card],
          flags: { building_infiltrated: true }
        )
      end

      def execute_scenario
        scene_stairs = Scene.new(id: :stairs_breach_to_executive_floor, title: "Asalto a la planta ejecutiva", location: "Planta Ejecutiva - Entrada")
        scene_stairs.add_precondition("El edificio debe haber sido infiltrado") do |ws|
          ws.flag?(:building_infiltrated)
        end

        scene_confront = Scene.new(id: :sawashiro_confrontation, title: "Reencuentro con Sawashiro", location: "Salón Ceremonial")
        scene_duel = Scene.new(id: :sawashiro_boss_duel, title: "Duelo contra Sawashiro", location: "Salón Ceremonial")
        scene_doors = Scene.new(id: :corridor_breach_to_patriarch, title: "Puertas del despacho", location: "Puertas del Despacho")
        scene_doors.add_precondition("Sawashiro debe haber sido derrotado") do |ws|
          ws.flag?(:sawashiro_boss_defeated)
        end

        # 1. Asalto al piso ejecutivo
        scene_stairs.check_preconditions!(@state)
        @state.set_flag(:executive_floor_breached, true)
        emit("story.scene_transition", data: { to_scene: "stairs_breach_to_executive_floor", location: @state.location })

        # 2. Reencuentro con Sawashiro
        transition_to(scene_confront, new_location: "Salón Ceremonial")
        @state.set_flag(:sawashiro_confronted, true)

        # 3. Duelo de jefe
        transition_to(scene_duel)
        sawashiro = @state.character(:sawashiro)
        sawashiro.set_attribute(:hp, 0)
        sawashiro.set_attribute(:status, :defeated)
        @state.set_flag(:sawashiro_boss_defeated, true)
        emit("story.combat_resolved", actor: :ichiban, target: :sawashiro, data: { victory: true, type: :boss_duel })

        # 4. Puertas del despacho
        transition_to(scene_doors, new_location: "Puertas del Despacho")
        @state.set_flag(:adachi_holding_corridor, true)
        @state.set_flag(:path_to_arakawa_opened, true)
        emit("story.objective_completed", actor: :ichiban, data: { action: "reach_arakawa_office" })
      end

      def generate_summary
        "Episodio 12_el_guantelete completado: Asalto a la planta ejecutiva, Sawashiro derrotado en duelo y camino abierto al despacho de Arakawa."
      end
    end
  end
end
