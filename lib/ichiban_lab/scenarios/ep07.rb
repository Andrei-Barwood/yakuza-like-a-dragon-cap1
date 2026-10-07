# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep07 < IchibanLab::BaseScenario
      protected

      def episode_id
        "07_el_precio"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :arakawa_soldier },
          relationships: { arakawa: :father_figure, mitsuo: :loyal_comrade },
          belongings: [:arakawa_pin]
        )
        arakawa = Character.new(
          id: :arakawa,
          name: "Masumi Arakawa",
          attributes: { role: :patriarch },
          relationships: { ichiban: :surrogate_son }
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "new_years_awakening",
          location: "Apartamento de Ichiban",
          time_period: "2001 - 1 de Enero (Mañana)",
          money: 2000,
          characters: { ichiban: ichiban, arakawa: arakawa },
          inventory: [:arakawa_pin],
          flags: { resting_for_night: true }
        )
      end

      def execute_scenario
        scene_awakening = Scene.new(id: :new_years_awakening, title: "Llamada de Año Nuevo", location: "Apartamento de Ichiban")
        scene_awakening.add_precondition("Ichiban debe haber descansado la noche anterior") do |ws|
          ws.flag?(:resting_for_night)
        end

        scene_sakaki = Scene.new(id: :sakaki_family_ambush, title: "Emboscada Sakaki", location: "Calles de Kamurocho")
        scene_request = Scene.new(id: :patriarch_solemn_request, title: "La petición solemne del Patriarca", location: "Oficina Familia Arakawa")
        scene_request.add_precondition("La emboscada Sakaki debe haber sido neutralizada") do |ws|
          ws.flag?(:sakaki_ambush_repelled)
        end

        scene_surrender = Scene.new(id: :the_last_meal_and_surrender, title: "Última comida y entrega", location: "Centro de Detención de Kamurocho")
        scene_surrender.add_precondition("Ichiban debe haber aceptado el sacrificio") do |ws|
          ws.flag?(:accepted_prison_sacrifice)
        end

        # 1. Llamada urgente
        scene_awakening.check_preconditions!(@state)
        emit("story.emergency_call", actor: :arakawa, target: :ichiban, data: { reason: "urgent_crisis" })
        @state.set_flag(:emergency_call_received, true)

        # 2. Emboscada Sakaki
        transition_to(scene_sakaki, new_location: "Calles de Kamurocho")
        sakaki = Character.new(id: :sakaki_thugs, name: "Sicarios Sakaki", attributes: { hostile: true })
        @state.add_character(sakaki)
        @state.set_flag(:sakaki_ambush_repelled, true)
        emit("story.combat_resolved", actor: :ichiban, target: :sakaki_thugs, data: { victory: true })

        # 3. Petición del Patriarca
        transition_to(scene_request, new_location: "Oficina Familia Arakawa")
        emit("story.crime_confessed_privately", actor: :arakawa, data: { true_culprit: :sawashiro })
        @state.set_flag(:crime_revealed, :sawashiro_homicide)
        @state.set_flag(:accepted_prison_sacrifice, true)
        emit("story.choice_recorded", actor: :ichiban, data: { choice: :accept_blame_for_family, sacrifice: :prison_term })

        # 4. Última comida y entrega a la policía
        transition_to(scene_surrender, new_location: "Centro de Detención de Kamurocho", new_time: "2001 - 1 de Enero (Tarde)")
        police = Character.new(id: :police, name: "Policía de Kamurocho")
        @state.add_character(police)

        emit("story.meal_shared", actor: :ichiban, target: :arakawa, data: { meal: :beef_bowl })
        emit("story.legal_surrender", actor: :ichiban, target: :police, data: { charge: :murder_confession })

        # Transición a condición de recluso y entrega de pertenencias
        ichiban = @state.character(:ichiban)
        ichiban.set_attribute(:role, :prisoner)
        ichiban.set_attribute(:status, :incarcerated)
        ichiban.remove_belonging(:arakawa_pin)
        @state.remove_item(:arakawa_pin)
        @state.adjust_money(-@state.money)

        @state.set_flag(:last_meal_consumed, true)
        @state.set_flag(:surrendered_to_police, true)
        @state.set_flag(:imprisoned, true)
        @state.set_flag(:chapter_1_completed, true)

        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 1, status: :concluded, next: :out_of_scope })
      end

      def generate_summary
        "Episodio 07_el_precio completado: Ichiban acepta la culpa del asesinato por Arakawa, comparte la última comida y entra en prisión. Fin del Capítulo 1."
      end
    end
  end
end
