# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep10 < IchibanLab::BaseScenario
      protected

      def episode_id
        "10_rescate_en_la_calle"
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
          scene_id: "pink_street_alley_cry",
          location: "Kamurocho - Callejón de Pink Street",
          time_period: "2019 - Atardecer",
          money: 3500,
          characters: { ichiban: ichiban, adachi: adachi },
          inventory: [],
          flags: { next_objective: :find_way_into_summit }
        )
      end

      def execute_scenario
        scene_cry = Scene.new(id: :pink_street_alley_cry, title: "Gritos en el callejón", location: "Kamurocho - Callejón de Pink Street")
        scene_cry.add_precondition("Debe haber una búsqueda activa de acceso") do |ws|
          ws.flag(:next_objective) == :find_way_into_summit
        end

        scene_brawl = Scene.new(id: :brawl_protecting_nick, title: "Pelea protegiendo a Nick", location: "Callejón de Pink Street")
        scene_gratitude = Scene.new(id: :ogata_gratitude, title: "Agradecimiento de Ogata", location: "Callejón de Pink Street")
        scene_gratitude.add_precondition("Los extorsionadores deben haber sido derrotados") do |ws|
          ws.flag?(:extortionists_defeated)
        end

        scene_pact = Scene.new(id: :adachi_party_pact, title: "El pacto del grupo", location: "Frente a la reja de alcantarillado")

        # 1. Alerta en el callejón
        scene_cry.check_preconditions!(@state)
        nick = Character.new(id: :nick_ogata, name: "Nick Ogata", attributes: { role: :investor })
        thugs = Character.new(id: :street_extortionists, name: "Extorsionadores", attributes: { hostile: true })
        @state.add_character(nick)
        @state.add_character(thugs)
        emit("story.scene_transition", data: { to_scene: "pink_street_alley_cry", location: @state.location })

        # 2. Pelea en equipo
        transition_to(scene_brawl, new_location: "Callejón de Pink Street")
        @state.set_flag(:extortionists_defeated, true)
        @state.set_flag(:nick_ogata_rescued, true)
        emit("story.combat_resolved", actor: :ichiban, target: :street_extortionists, data: { assisted_by: :adachi, victory: true })

        # 3. Gratitud y tarjeta
        transition_to(scene_gratitude)
        @state.add_item(:nick_ogata_business_card)
        emit("story.item_acquired", actor: :ichiban, target: :nick_ogata, data: { item: :nick_ogata_business_card })

        # 4. Pacto y acceso al alcantarillado
        transition_to(scene_pact, new_location: "Frente a la reja de alcantarillado")
        @state.character(:ichiban).set_relationship(:adachi, :partner)
        @state.character(:adachi).set_relationship(:ichiban, :partner)
        @state.set_flag(:adachi_party_joined, true)
        @state.set_flag(:next_step, :enter_underground_sewers)

        emit("story.party_member_joined", actor: :adachi, target: :ichiban, data: { role: :partner })
        emit("story.objective_started", actor: :ichiban, data: { goal: "infiltrate_through_sewers" })
      end

      def generate_summary
        "Episodio 10_rescate_en_la_calle completado: Ichiban y Adachi rescatan a Nick Ogata, consolidan el grupo y descubren el acceso al alcantarillado."
      end
    end
  end
end
