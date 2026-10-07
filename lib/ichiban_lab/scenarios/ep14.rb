# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep14 < IchibanLab::BaseScenario
      protected

      def episode_id
        "14_la_ciudad_en_el_fondo"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 10, role: :former_convict, status: :recovering },
          relationships: { nanba: :savior },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :homeless_medic },
          relationships: { ichiban: :patient },
          belongings: []
        )
        chief = Character.new(
          id: :chief,
          name: "Jefe del Campamento",
          attributes: { role: :settlement_leader },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "trash_pile_recovery",
          location: "Isezaki Ijincho - Vertedero de Basura",
          time_period: "2019 - Mañana (3 días después del disparo)",
          money: 0,
          characters: { ichiban: ichiban, nanba: nanba, chief: chief },
          inventory: [:nick_ogata_business_card],
          flags: { saved_by_nanba: true, shot_by_arakawa: true }
        )
      end

      def execute_scenario
        scene_recovery = Scene.new(id: :trash_pile_recovery, title: "Recuperación en el vertedero", location: "Isezaki Ijincho - Vertedero de Basura")
        scene_recovery.add_precondition("Ichiban debe haber sido salvado por Nanba") do |ws|
          ws.flag?(:saved_by_nanba)
        end

        scene_foraging = Scene.new(id: :treasure_hunt_teaching, title: "Técnica de rebusque bajo las máquinas", location: "Calles de Ijincho - Máquinas Expendedoras")
        scene_camp_intro = Scene.new(id: :chief_audience, title: "Audiencia y permiso del Jefe", location: "Campamento de Vagabundos")
        scene_camp_intro.add_precondition("Debe haber reunido algo de dinero inicial") do |ws|
          ws.money >= 500
        end

        # 1. Recuperación en el vertedero y conversación con Nanba
        scene_recovery.check_preconditions!(@state)
        transition_to(scene_recovery)
        emit("story.objective_started", actor: :ichiban, data: { objective: "comprender_situacion_en_yokohama" })
        emit("story.dialogue_resolved", actor: :nanba, target: :ichiban, data: { message: "has sobrevivido gracias al hilo de pescar; debes ganar dinero para quedarte" })
        @state.character(:ichiban).set_attribute(:hp, 35)

        # 2. Aprendizaje de supervivencia: Treasure Hunt bajo las máquinas expendedoras
        transition_to(scene_foraging, new_location: "Calles de Ijincho - Máquinas Expendedoras")
        emit("story.mechanic_unlocked", actor: :ichiban, data: { ability: :treasure_hunt })
        @state.adjust_money(500)
        emit("story.money_acquired", actor: :ichiban, data: { amount: 500, source: :vending_machines })

        # 3. Presentación ante el Jefe del Campamento y permiso de residencia
        transition_to(scene_camp_intro, new_location: "Campamento de Vagabundos", new_time: "2019 - Atardecer")
        scene_camp_intro.check_preconditions!(@state)
        emit("story.settlement_permission_granted", actor: :chief, target: :ichiban, data: { condition: "respetar_normas_del_campamento" })
        @state.set_flag(:camp_stay_permitted, true)
        @state.character(:nanba).set_relationship(:ichiban, :companion)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "permiso_de_estancia_concedido" })
      end

      def generate_summary
        "Episodio 14_la_ciudad_en_el_fondo completado: Ichiban asimila su nueva realidad en Ijincho, aprende a buscar monedas bajo máquinas recaudando ¥500 y obtiene permiso del Jefe del campamento."
      end
    end
  end
end
