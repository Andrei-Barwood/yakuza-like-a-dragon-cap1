# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep32 < IchibanLab::BaseScenario
      protected

      def episode_id
        "32_la_fuga_subterranea"
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
          attributes: { role: :mabuchi_enforcer, hp: 180 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "mysterious_savior_rescue",
          location: "Escondite Subterráneo de Mabuchi - Celda de Contención",
          time_period: "2019 - Noche",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, yan: yan },
          inventory: [],
          flags: { execution_ordered: true, party_restrained: true }
        )
      end

      def execute_scenario
        scene_savior = Scene.new(
          id: :mysterious_savior_rescue,
          title: "Intervención del salvador misterioso",
          location: "Escondite Subterráneo de Mabuchi - Celda de Contención"
        )
        scene_savior.add_precondition("La ejecución debe haber sido ordenada previamente") do |ws|
          ws.flag?(:execution_ordered)
        end

        scene_clash = Scene.new(
          id: :cell_brawl_and_release,
          title: "Combate contra los carceleros y liberación del grupo",
          location: "Escondite Subterráneo de Mabuchi - Celda de Contención"
        )

        scene_recovery = Scene.new(
          id: :gear_recovery_no_signal,
          title: "Recuperación de pertenencias y ausencia de señal",
          location: "Túneles de Contrabando Subterráneo - B2F"
        )

        # 1. Liberación sorpresiva por el hombre misterioso
        scene_savior.check_preconditions!(@state)
        transition_to(scene_savior)
        emit("story.mysterious_ally_intervention", actor: :mysterious_man, target: :ichiban, data: { action: "romper_cadenas_de_ichiban", phrase: "el_resto_depende_de_ti" })
        @state.set_flag(:ichiban_unshackled, true)

        # 2. Ichiban combate a los guardias y libera a sus compañeros
        transition_to(scene_clash)
        emit("story.combat_resolved", actor: :ichiban, target: :guards, data: { status: "guardias_noqueados", victory: true })
        emit("story.party_unshackled", actor: :ichiban, data: { freed: [:nanba, :adachi, :saeko] })
        @state.set_flag(:party_restrained, false)
        @state.set_flag(:party_freed, true)

        # 3. Recuperar las cajas de cartón con el inventario y celulares sin señal
        transition_to(scene_recovery, new_location: "Túneles de Contrabando Subterráneo - B2F")
        @state.add_item(:nick_ogata_business_card)
        @state.add_item(:counterfeit_10k_bill)
        @state.add_item(:seiryu_clan_key)
        @state.add_item(:counterfeit_yuan_sample)
        emit("story.inventory_recovered", actor: :ichiban, data: { items: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample] })
        emit("story.comms_offline", actor: :adachi, data: { status: "sin_cobertura_movil_en_subsuelo" })
        @state.set_flag(:gear_recovered, true)
      end

      def generate_summary
        "Episodio 32_la_fuga_subterranea completado: Justo antes de que Yan apuñale a Adachi, un misterioso individuo libera a Ichiban y huye. Kasuga derrota a los carceleros, libera a sus compañeros y recuperan todas sus pertenencias, comprobando que se encuentran atrapados en túneles subterráneos sin cobertura telefónica."
      end
    end
  end
end
