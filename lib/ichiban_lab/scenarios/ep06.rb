# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep06 < IchibanLab::BaseScenario
      protected

      def episode_id
        "06_lo_que_nos_une"
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
          belongings: [:arakawa_pin, :masato_wallet]
        )
        sawashiro = Character.new(
          id: :sawashiro,
          name: "Jo Sawashiro",
          attributes: { role: :captain, temper: :ruthless }
        )
        arakawa = Character.new(
          id: :arakawa,
          name: "Masumi Arakawa",
          attributes: { role: :patriarch, integrity: :high }
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "office_reprimand",
          location: "Oficina Familia Arakawa",
          time_period: "2000 - Medianoche",
          money: 252_000,
          characters: { ichiban: ichiban, sawashiro: sawashiro, arakawa: arakawa },
          inventory: [:arakawa_pin, :masato_wallet],
          flags: { masato_wallet_held: true }
        )
      end

      def execute_scenario
        scene_office = Scene.new(id: :office_reprimand, title: "Reprimenda en la oficina", location: "Oficina Familia Arakawa")
        scene_office.add_precondition("Ichiban debe portar la cartera de Masato") do |ws|
          ws.flag?(:masato_wallet_held)
        end

        scene_dinner = Scene.new(id: :intimate_dinner_talk, title: "Cena íntima con Arakawa", location: "Restaurante tradicional")
        scene_dinner.add_precondition("Arakawa debe haber intervenido en la oficina") do |ws|
          ws.flag?(:arakawa_intervened)
        end

        scene_square = Scene.new(id: :theater_square_brawl, title: "Altercado en Theater Square", location: "Kamurocho - Theater Square")
        scene_square.add_precondition("Deben haber compartido la cena y recuerdos") do |ws|
          ws.flag?(:shared_past_revealed)
        end

        scene_apartment = Scene.new(id: :apartment_retirement, title: "Regreso al apartamento", location: "Apartamento de Ichiban")
        scene_apartment.add_precondition("El altercado en Theater Square debe resolverse") do |ws|
          ws.flag?(:theater_square_cleared)
        end

        # 1. Oficina
        scene_office.check_preconditions!(@state)
        @state.remove_item(:masato_wallet)
        @state.character(:ichiban).remove_belonging(:masato_wallet)
        emit("story.item_returned", actor: :ichiban, target: :arakawa, data: { item: :masato_wallet })

        @state.adjust_money(-250_000)
        emit("story.funds_deposited", actor: :ichiban, target: :arakawa_family, data: { amount: 250_000 })
        emit("story.conflict_defused", actor: :arakawa, target: :sawashiro)

        @state.set_flag(:funds_deposited, true)
        @state.set_flag(:masato_wallet_returned, true)
        @state.set_flag(:arakawa_intervened, true)

        # 2. Cena y revelación del pasado
        transition_to(scene_dinner, new_location: "Restaurante tradicional")
        @state.character(:ichiban).set_relationship(:arakawa, :father_figure)
        @state.character(:arakawa).set_relationship(:ichiban, :surrogate_son)
        @state.set_flag(:shared_past_revealed, true)
        emit("story.bond_deepened", actor: :arakawa, target: :ichiban, data: { bond: :father_son_loyalty })

        # 3. Theater Square
        transition_to(scene_square, new_location: "Kamurocho - Theater Square")
        delinquents = Character.new(id: :delinquents, name: "Alborotadores", attributes: { status: :brawling })
        @state.add_character(delinquents)
        @state.set_flag(:theater_square_cleared, true)
        emit("story.combat_resolved", actor: :ichiban, target: :delinquents, data: { assisted_by: :arakawa })

        # 4. Apartamento de descanso
        transition_to(scene_apartment, new_location: "Apartamento de Ichiban", new_time: "2000 - Fin de la noche")
        @state.set_flag(:resting_for_night, true)
      end

      def generate_summary
        "Episodio 06_lo_que_nos_une completado: Arakawa frena a Sawashiro, comparte la cena con Ichiban, resuelven la pelea en Theater Square e Ichiban descansa."
      end
    end
  end
end
