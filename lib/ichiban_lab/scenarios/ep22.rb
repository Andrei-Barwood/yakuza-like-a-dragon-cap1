# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep22 < IchibanLab::BaseScenario
      protected

      def episode_id
        "22_la_noche_en_survive"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { nanba: :sworn_partner, adachi: :ally },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :party_member },
          relationships: { ichiban: :sworn_partner },
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :party_member },
          relationships: { ichiban: :ally },
          belongings: []
        )
        iroha = Character.new(
          id: :iroha,
          name: "Iroha Yanagi",
          attributes: { role: :survive_bar_hostess },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "arrival_at_survive",
          location: "Survive Bar (Bar District)",
          time_period: "2019 - Madrugada",
          money: 6300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, iroha: iroha },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill],
          flags: { pension_scam_uncovered: true, tatsuro_rescue_urgent: true }
        )
      end

      def execute_scenario
        scene_arrival = Scene.new(id: :arrival_at_survive, title: "Llegada a Survive Bar", location: "Survive Bar (Bar District)")
        scene_arrival.add_precondition("El fraude de Sunlight Castle debe estar al descubierto") do |ws|
          ws.flag?(:pension_scam_uncovered)
        end

        scene_drinks = Scene.new(id: :drink_links_intro, title: "Copas, confidencias y Drink Links", location: "Survive Bar (Bar District)")
        scene_resolve = Scene.new(id: :morning_determination, title: "Determinación al amanecer", location: "Survive Bar (Bar District)")

        # 1. Llegada y presentación de la base de operaciones
        scene_arrival.check_preconditions!(@state)
        transition_to(scene_arrival)
        emit("story.hideout_unlocked", actor: :adachi, target: :ichiban, data: { location: "Survive Bar", purpose: "base_de_operaciones_del_grupo" })
        @state.set_flag(:survive_bar_unlocked, true)

        # 2. Confidencias nocturnas con Adachi y Drink Links
        transition_to(scene_drinks)
        emit("story.mechanic_unlocked", actor: :ichiban, data: { system: :drink_links })
        emit("story.dialogue_resolved", actor: :adachi, target: :ichiban, data: { bond: :deepened, topic: "motivos_para_desenmascarar_la_red_de_corrupcion" })
        @state.character(:ichiban).set_relationship(:adachi, :brother_in_arms)
        @state.character(:adachi).set_relationship(:ichiban, :brother_in_arms)
        @state.character(:ichiban).set_attribute(:hp, 100) # descanso reparador

        # 3. Determinación para la mañana decisiva
        transition_to(scene_resolve, new_time: "2019 - 07:00 AM")
        emit("story.objective_started", actor: :ichiban, data: { goal: "asaltar_sunlight_castle_antes_del_procedimiento" })
        @state.set_flag(:ready_to_breach_sunlight, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "preparativos_en_survive_concluidos" })
      end

      def generate_summary
        "Episodio 22_la_noche_en_survive completado: El grupo descansa y estrecha lazos en Survive Bar desbloqueando Drink Links. Al alba, Ichiban, Adachi y Nanba parten decididos a salvar la vida de Tatsuro Mukoda."
      end
    end
  end
end
