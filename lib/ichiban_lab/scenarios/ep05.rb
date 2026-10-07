# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep05 < IchibanLab::BaseScenario
      protected

      def episode_id
        "05_el_joven_maestro"
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
        masato = Character.new(
          id: :masato,
          name: "Masato Arakawa",
          attributes: { mobility: :wheelchair, temper: :proud },
          belongings: [:masato_wallet]
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "escorting_masato",
          location: "Kamurocho - Pink Street",
          time_period: "2000 - Noche",
          money: 252_000,
          characters: { ichiban: ichiban, masato: masato },
          inventory: [:arakawa_pin],
          flags: { sawashiro_summons: true }
        )
      end

      def execute_scenario
        scene_escort = Scene.new(id: :escorting_masato, title: "Escolta hacia el club", location: "Kamurocho - Pink Street")
        scene_escort.add_precondition("Debe haber una orden previa de Sawashiro") do |ws|
          ws.flag?(:sawashiro_summons)
        end

        scene_lounge = Scene.new(id: :hostess_club_lounge, title: "Salón VIP del club", location: "Hostess Club - Salón VIP")
        scene_backstage = Scene.new(id: :overhearing_backstage, title: "Pasillo de servicio del club", location: "Pasillo de servicio del club")
        scene_departure = Scene.new(id: :masato_departure_and_bill, title: "Marcha de Masato y pago de la cuenta", location: "Entrada del club")
        scene_departure.add_precondition("Ichiban debe haber escuchado la verdad sobre Yumeno") do |ws|
          ws.flag?(:heard_yumeno_truth)
        end

        # 1. Escolta
        scene_escort.check_preconditions!(@state)
        emit("story.objective_started", actor: :ichiban, data: { task: "escort_masato", destination: "Hostess Club" })

        # 2. Salón VIP y Horinouchi
        transition_to(scene_lounge, new_location: "Hostess Club - Salón VIP")
        horinouchi = Character.new(id: :horinouchi, name: "Morinaga Horinouchi", attributes: { role: :police_commissioner })
        @state.add_character(horinouchi)
        @state.set_flag(:horinouchi_tension, true)

        # 3. Revelación de Yumeno entre bastidores
        transition_to(scene_backstage, new_location: "Pasillo de servicio del club")
        yumeno = Character.new(id: :yumeno, name: "Yumeno", attributes: { role: :hostess })
        @state.add_character(yumeno)
        @state.set_flag(:heard_yumeno_truth, true)
        emit("story.information_revealed", actor: :ichiban, target: :yumeno, data: { fact: "yumeno_exploits_masato" })

        # 4. Marcha de Masato y cuenta
        transition_to(scene_departure, new_location: "Entrada del club")
        masato = @state.character(:masato)
        masato.remove_belonging(:masato_wallet)
        @state.character(:ichiban).add_belonging(:masato_wallet)
        @state.add_item(:masato_wallet)

        emit("story.item_acquired", actor: :ichiban, target: :masato, data: { item: :masato_wallet })
        emit("story.payment_made", actor: :ichiban, data: { expense: :club_bill, amount: 80_000, source: :masato_wallet })
        emit("story.character_departed", actor: :masato, data: { reason: "humiliation_and_anger" })

        @state.set_flag(:club_bill_paid, true)
        @state.set_flag(:masato_wallet_held, true)
        @state.set_flag(:masato_departed, true)
      end

      def generate_summary
        "Episodio 05_el_joven_maestro completado: Ichiban escolta a Masato, descubre la traición emocional de Yumeno, recibe la cartera y paga la cuenta del club."
      end
    end
  end
end
