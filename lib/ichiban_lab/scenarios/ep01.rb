# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep01 < IchibanLab::BaseScenario
      protected

      def episode_id
        "01_origen"
      end

      def main_actor
        :masumi
      end

      def default_initial_state
        masumi = Character.new(
          id: :masumi,
          name: "Masumi Arakawa (niño)",
          attributes: { hp: 100, age: :child, role: :theatre_actor },
          relationships: { toshio: :father },
          belongings: []
        )
        toshio = Character.new(
          id: :toshio,
          name: "Toshio Arakawa",
          attributes: { hp: 100, role: :theatre_leader, status: :alive },
          relationships: { masumi: :beloved_son },
          belongings: [:family_talisman]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "theatre_dressing_room",
          location: "Camerino teatral",
          time_period: "1977 - Noche",
          money: 500,
          characters: { masumi: masumi, toshio: toshio },
          inventory: [],
          flags: {}
        )
      end

      def execute_scenario
        _scene_dressing = Scene.new(id: :theatre_dressing_room, title: "Camerino teatral", location: "Camerino teatral")
        scene_dinner = Scene.new(id: :dinner_at_eatery, title: "Restaurante tradicional", location: "Restaurante tradicional")
        scene_dinner.add_precondition("La función teatral debe haber concluido") do |ws|
          ws.flag?(:performance_finished)
        end

        scene_ambush = Scene.new(id: :dark_alleyway_ambush, title: "Callejón trasero", location: "Callejón trasero")
        scene_ambush.add_precondition("Deben haber compartido la cena") do |ws|
          ws.flag?(:dinner_shared)
        end

        scene_aftermath = Scene.new(id: :prologue_aftermath, title: "Desenlace del prólogo", location: "Callejón trasero")
        scene_aftermath.add_precondition("La emboscada debe haber ocurrido") do |ws|
          ws.flag?(:ambush_occurred)
        end

        # 1. Camerino teatral
        emit("story.objective_started", actor: :masumi, data: { objective: "Completar función teatral" })
        @state.set_flag(:performance_finished, true)
        @state.character(:toshio).remove_belonging(:family_talisman)
        @state.character(:masumi).add_belonging(:family_talisman)
        @state.add_item(:family_talisman)

        # 2. Cena
        transition_to(scene_dinner, new_location: "Restaurante tradicional")
        emit("story.meal_shared", actor: :toshio, target: :masumi, data: { dishes: "Cena caliente" })
        @state.set_flag(:dinner_shared, true)

        # 3. Emboscada
        transition_to(scene_ambush, new_location: "Callejón trasero")
        assassin = Character.new(id: :assassin, name: "Asaltante desconocido", attributes: { armed: true })
        @state.add_character(assassin)
        emit("story.ambush_triggered", actor: :assassin, target: :toshio, data: { threat: "Ataque con arma" })

        # Sacrificio de Toshio
        toshio = @state.character(:toshio)
        toshio.set_attribute(:hp, 0)
        toshio.set_attribute(:status, :deceased)
        @state.character(:masumi).set_attribute(:trauma, :father_killed)
        @state.set_flag(:ambush_occurred, true)
        @state.set_flag(:toshio_deceased, true)
        emit("story.sacrifice_recorded", actor: :toshio, target: :masumi, data: { protection: "Escudo humano" })

        # 4. Desenlace
        transition_to(scene_aftermath)
        @state.set_flag(:vow_recorded, true)
        emit("story.chapter_boundary", actor: :masumi, data: { boundary: "prologue_1977_end" })
      end

      def generate_summary
        "Episodio 01_origen completado: Toshio Arakawa es asesinado protegiendo a su hijo Masumi en 1977."
      end
    end
  end
end
