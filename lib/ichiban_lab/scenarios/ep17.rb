# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep17 < IchibanLab::BaseScenario
      protected

      def episode_id
        "17_defensa_de_harbor_light"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :night_watchman },
          relationships: { nanba: :companion },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :night_watchman },
          relationships: { ichiban: :companion },
          belongings: []
        )
        hamako = Character.new(
          id: :hamako,
          name: "Hamako",
          attributes: { role: :harbor_light_owner },
          relationships: {},
          belongings: []
        )
        matsuo = Character.new(
          id: :matsuo,
          name: "Matsuo",
          attributes: { role: :geomijul_saboteur, hp: 150 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "harbor_light_briefing",
          location: "The Harbor Light Bar",
          time_period: "2019 - Noche",
          money: 1300,
          characters: { ichiban: ichiban, nanba: nanba, hamako: hamako, matsuo: matsuo },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill],
          flags: { harbor_light_job_accepted: true }
        )
      end

      def execute_scenario
        scene_briefing = Scene.new(id: :harbor_light_briefing, title: "El encargo de Hamako y el robo de electricidad", location: "The Harbor Light Bar")
        scene_briefing.add_precondition("Debe haber aceptado el trabajo en Hello Work") do |ws|
          ws.flag?(:harbor_light_job_accepted)
        end

        scene_sabotage = Scene.new(id: :matsuo_sledgehammer_attack, title: "Ataque del saboteador Matsuo", location: "The Harbor Light Bar")
        scene_sniper = Scene.new(id: :geomijul_sniper_standoff, title: "Desafío abierto ante el francotirador", location: "Callejón frente a The Harbor Light")
        scene_reward = Scene.new(id: :hamako_gratitude_and_pay, title: "Gratitud y pago de Hamako", location: "The Harbor Light Bar")

        # 1. Briefing con Hamako sobre la mafia coreana Geomijul
        scene_briefing.check_preconditions!(@state)
        transition_to(scene_briefing)
        emit("story.dialogue_resolved", actor: :hamako, target: :ichiban, data: { threat: "Geomijul robaba cables eléctricos de la taberna" })
        @state.character(:ichiban).set_relationship(:hamako, :employer)

        # 2. Asalto de Matsuo con mazo y combate
        transition_to(scene_sabotage)
        emit("story.assault_initiated", actor: :matsuo, target: :hamako, data: { weapon: "sledgehammer", intent: "destruir_local" })
        emit("story.combat_resolved", actor: :ichiban, target: :matsuo, data: { assisted_by: :nanba, victory: true })

        # 3. Lluvia de flechas y desafío abierto al francotirador en el tejado
        transition_to(scene_sniper, new_location: "Callejón frente a The Harbor Light")
        emit("story.sniper_threat_detected", actor: :ichiban, data: { faction: "Geomijul", weapon: "crossbow/sniper" })
        emit("story.heroic_standoff", actor: :ichiban, data: { speech: "dejad en paz a la señora; este local no puede pagar más abusos", grazed_cheek: true })
        @state.set_flag(:geomijul_standoff_survived, true)

        # 4. Cobro de recompensa y reconocimiento de Hamako
        transition_to(scene_reward, new_location: "The Harbor Light Bar", new_time: "2019 - Medianoche")
        @state.adjust_money(5000)
        emit("story.money_acquired", actor: :ichiban, data: { amount: 5000, total: @state.money, source: :hamako_payment })
        @state.character(:ichiban).set_relationship(:hamako, :trusted_ally)
        @state.set_flag(:harbor_light_defended, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "guardia_cumplida_con_exito" })
      end

      def generate_summary
        "Episodio 17_defensa_de_harbor_light completado: Ichiban y Nanba protegen The Harbor Light, derrotan a Matsuo, desafían con audacia a los francotiradores de Geomijul y cobran la recompensa de ¥5,000 de Hamako."
      end
    end
  end
end
