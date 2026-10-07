# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep29 < IchibanLab::BaseScenario
      protected

      def episode_id
        "29_la_imprenta_clandestina"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { nanba: :sworn_partner, adachi: :brother_in_arms, saeko: :protectee },
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
          relationships: { ichiban: :brother_in_arms },
          belongings: []
        )
        saeko = Character.new(
          id: :saeko,
          name: "Saeko Mukoda",
          attributes: { role: :party_member },
          relationships: { ichiban: :ally },
          belongings: []
        )
        yan = Character.new(
          id: :yan,
          name: "Yan",
          attributes: { role: :warehouse_overseer },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "cash_shortage_incident",
          location: "Yokohama Trading Company - Oficina Principal",
          time_period: "2019 - Mañana",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, yan: yan },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key],
          flags: { bleach_japan_humiliated: true, dock_infiltration_active: true }
        )
      end

      def execute_scenario
        scene_shortage = Scene.new(id: :cash_shortage_incident, title: "La falta de cambio y la visita sospechosa al piso superior", location: "Yokohama Trading Company - Oficina Principal")
        scene_shortage.add_precondition("La infiltración en el muelle debe continuar activa") do |ws|
          ws.flag?(:dock_infiltration_active)
        end

        scene_deduction = Scene.new(id: :counterfeit_yuan_deduction, title: "Deducción de la imprenta clandestina de yuanes", location: "Yokohama Trading Company - Almacén")
        scene_heist_plan = Scene.new(id: :paper_sample_plan, title: "Plan para sustraer una muestra del papel", location: "Yokohama Trading Company - Almacén")

        # 1. Incidente de caja: Yan sube con papel y baja con un maletín repleto de efectivo recién impreso
        scene_shortage.check_preconditions!(@state)
        transition_to(scene_shortage)
        emit("story.suspicious_procedure_witnessed", actor: :saeko, target: :yan, data: { action: "subio_con_papel_en_blanco_y_bajo_con_fajon_de_billetes" })
        @state.set_flag(:printing_press_suspected, true)

        # 2. Análisis del grupo: falsificación masiva de moneda extranjera (yuanes chinos)
        transition_to(scene_deduction)
        emit("story.deduction_made", actor: :adachi, target: :ichiban, data: { scheme: "falsificacion_de_yuanes_chinos_sin_conversion_bancaria_japonesa", mastermind: "Akira Mabuchi" })
        @state.set_flag(:counterfeit_yuan_operation_confirmed, true)

        # 3. Plan conjunto: Saeko facilitará una muestra del papel falso a Ichiban
        transition_to(scene_heist_plan, new_time: "2019 - Mediodía")
        emit("story.strategy_devised", actor: :saeko, target: :ichiban, data: { plan: "pasar_un_billete_falso_a_ichiban_para_sacarlo_sin_cacheo_femenino" })
        @state.set_flag(:sample_extraction_ready, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "extraer_muestra_y_escapar" })
      end

      def generate_summary
        "Episodio 29_la_imprenta_clandestina completado: Saeko e Ichiban descubren la fábrica clandestina de moneda china falsificada en el piso superior de Yokohama Trading Company y coordinan sustraer una muestra del papel impreso."
      end
    end
  end
end
