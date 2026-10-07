# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep15 < IchibanLab::BaseScenario
      protected

      def episode_id
        "15_la_ley_del_campamento"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 50, role: :homeless_rookie },
          relationships: { nanba: :companion },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :homeless_medic },
          relationships: { ichiban: :companion },
          belongings: []
        )
        zheng = Character.new(
          id: :zheng,
          name: "Zheng",
          attributes: { role: :liumang_collector, hp: 120 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "can_collection_dawn",
          location: "Campamento de Vagabundos",
          time_period: "2019 - 05:30 AM",
          money: 500,
          characters: { ichiban: ichiban, nanba: nanba, zheng: zheng },
          inventory: [:nick_ogata_business_card],
          flags: { camp_stay_permitted: true }
        )
      end

      def execute_scenario
        scene_cans = Scene.new(id: :can_collection_dawn, title: "Recolección de latas al alba", location: "Calles de Ijincho - Zona de reciclaje")
        scene_cans.add_precondition("Ichiban debe tener permiso del campamento") do |ws|
          ws.flag?(:camp_stay_permitted)
        end

        scene_bread = Scene.new(id: :sharing_bread_roll, title: "Compartiendo el pan", location: "Campamento de Vagabundos")
        scene_extortion = Scene.new(id: :zheng_extortion_brawl, title: "Cobro de cuota y combate contra Zheng", location: "Campamento de Vagabundos")
        scene_bill = Scene.new(id: :counterfeit_bill_discovery, title: "El billete sin orificio de bala", location: "Campamento de Vagabundos")

        # 1. Recolección de latas
        scene_cans.check_preconditions!(@state)
        transition_to(scene_cans, new_time: "2019 - 06:00 AM")
        emit("story.activity_completed", actor: :ichiban, data: { task: "can_collection", ecopoints: 120 })
        @state.adjust_money(800)
        emit("story.money_acquired", actor: :ichiban, data: { amount: 800, total: @state.money })

        # 2. Compartiendo el pan
        transition_to(scene_bread, new_location: "Campamento de Vagabundos", new_time: "2019 - Mañana")
        emit("story.dialogue_resolved", actor: :nanba, target: :ichiban, data: { action: "compartir_panecillo", bond_increase: true })
        @state.character(:ichiban).set_attribute(:hp, 80)

        # 3. Llegada de Zheng y enfrentamiento
        transition_to(scene_extortion)
        emit("story.threat_detected", actor: :zheng, target: :ichiban, data: { faction: "Yokohama Liumang", demand: "cuota_de_proteccion" })
        emit("story.combat_resolved", actor: :ichiban, target: :zheng, data: { assisted_by: :nanba, victory: true })
        @state.set_flag(:liumang_clash_witnessed, true)

        # 4. El billete de 10,000 yenes y la deducción de Nanba
        transition_to(scene_bill)
        @state.add_item(:counterfeit_10k_bill)
        emit("story.item_acquired", actor: :ichiban, data: { item: :counterfeit_10k_bill, condition: "no_bullet_hole", status: :counterfeit })
        emit("story.deduction_made", actor: :nanba, target: :ichiban, data: { observation: "el billete fue colocado en tu bolsillo después de recibir el tiro" })
        @state.set_flag(:counterfeit_bill_revealed, true)
        @state.set_flag(:ijin_three_lore_known, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "misterio_del_billete_iniciado" })
      end

      def generate_summary
        "Episodio 15_la_ley_del_campamento completado: Ichiban y Nanba recolectan latas ganando ¥800, repelen la extorsión de Zheng de Yokohama Liumang y descubren el misterioso billete falso de ¥10,000 colocado en su bolsillo tras el disparo."
      end
    end
  end
end
