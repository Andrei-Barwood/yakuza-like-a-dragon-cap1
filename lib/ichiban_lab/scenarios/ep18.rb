# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep18 < IchibanLab::BaseScenario
      protected

      def episode_id
        "18_un_techo_y_un_ideal"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :trusted_guard },
          relationships: { nanba: :companion, hamako: :trusted_ally },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :companion },
          relationships: { ichiban: :companion },
          belongings: []
        )
        hamako = Character.new(
          id: :hamako,
          name: "Hamako",
          attributes: { role: :hostel_proprietor },
          relationships: { ichiban: :trusted_ally },
          belongings: []
        )
        kume = Character.new(
          id: :kume,
          name: "Sota Kume",
          attributes: { role: :bleach_japan_branch_leader },
          relationships: {},
          belongings: []
        )
        hooligans = Character.new(
          id: :hooligans,
          name: "Matones de Bleach Japan",
          attributes: { hp: 160 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "hamako_restaurant_cleanup",
          location: "Restaurante de Hamako (Sunrise Street)",
          time_period: "2019 - Mañana siguiente",
          money: 6300,
          characters: { ichiban: ichiban, nanba: nanba, hamako: hamako, kume: kume, hooligans: hooligans },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill],
          flags: { harbor_light_defended: true }
        )
      end

      def execute_scenario
        scene_cleanup = Scene.new(id: :hamako_restaurant_cleanup, title: "Labores en Sunrise Street", location: "Restaurante de Hamako (Sunrise Street)")
        scene_cleanup.add_precondition("The Harbor Light debe haber sido defendido con éxito") do |ws|
          ws.flag?(:harbor_light_defended)
        end

        scene_protest = Scene.new(id: :bleach_japan_protest, title: "Manifestación hostil de Bleach Japan", location: "Sunrise Street")
        scene_brawl = Scene.new(id: :bleach_japan_brawl, title: "Combate contra los provocadores de Kume", location: "Sunrise Street")
        scene_room_and_dream = Scene.new(id: :room_acquisition_and_hero_dream, title: "Habitación propia y la vocación de Héroe", location: "Habitación alquilada - Sunrise Street")

        # 1. Limpieza matutina y encuentro con la realidad de las trabajadoras de Hamako
        scene_cleanup.check_preconditions!(@state)
        transition_to(scene_cleanup)
        emit("story.dialogue_resolved", actor: :hamako, target: :ichiban, data: { reality: "protege a mujeres sin papeles e indocumentadas rechazadas por el sistema" })

        # 2. Manifestación y confrontación moral con Sota Kume
        transition_to(scene_protest)
        emit("story.ideological_clash", actor: :kume, target: :hamako, data: { organization: "Bleach Japan", leader_tokyo: "Ryo Aoki", demand: "erradicar_zonas_grises" })
        emit("story.moral_defense", actor: :ichiban, target: :kume, data: { defense: "yo crecí criado por trabajadoras de soapland y no me avergüenzo" })

        # 3. Escalada violenta de Bleach Japan y combate
        transition_to(scene_brawl)
        emit("story.combat_resolved", actor: :ichiban, target: :hooligans, data: { assisted_by: :nanba, victory: true })
        @state.set_flag(:bleach_japan_repelled, true)

        # 4. Habitación propia en el edificio de Hamako y revelación de Nanba
        transition_to(scene_room_and_dream, new_time: "2019 - Noche")
        @state.set_flag(:has_permanent_residence, true)
        emit("story.residence_acquired", actor: :hamako, target: :ichiban, data: { room: "apartamento_en_sunrise_street", status: :legal_tenant })

        # Nanba confiesa su pasado médico y contrabando de medicinas
        emit("story.backstory_revealed", actor: :nanba, target: :ichiban, data: { past: "enfermero_despedido_por_desviar_farmacos" })
        # Ichiban declara su vocación heroica de videojuego
        emit("story.heroic_calling_declared", actor: :ichiban, target: :nanba, data: { dream: "ser_un_heroe_como_dragon_quest" })
        @state.character(:ichiban).set_attribute(:calling, :hero)
        @state.character(:ichiban).set_attribute(:address, "Sunrise Street, Ijincho")
        @state.character(:nanba).set_relationship(:ichiban, :sworn_partner)
        @state.set_flag(:chapter_3_completed, true)

        # Cierre y frontera del Capítulo 3
        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 3, status: :concluded, next: :chapter_4 })
      end

      def generate_summary
        "Episodio 18_un_techo_y_un_ideal completado: Ichiban y Nanba repelen la protesta de Bleach Japan liderada por Sota Kume, obtienen habitación propia gracias a Hamako y sellan su pacto para forjar una nueva era de héroes. Fin del Capítulo 3."
      end
    end
  end
end
