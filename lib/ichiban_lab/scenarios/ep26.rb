# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep26 < IchibanLab::BaseScenario
      protected

      def episode_id
        "26_el_club_lin_lin"
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
        zheng = Character.new(
          id: :zheng,
          name: "Zheng",
          attributes: { role: :liumang_club_manager, hp: 200 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "lin_lin_vip_infiltration",
          location: "Lin Lin Hostess Bar - Sala VIP",
          time_period: "2019 - Noche",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, zheng: zheng },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key],
          flags: { saeko_joined_party: true, mabuchi_investigation_started: true }
        )
      end

      def execute_scenario
        scene_vip = Scene.new(id: :lin_lin_vip_infiltration, title: "Incursión en la sala VIP de Lin Lin", location: "Lin Lin Hostess Bar - Sala VIP")
        scene_vip.add_precondition("Saeko debe estar integrada en el grupo de investigación") do |ws|
          ws.flag?(:saeko_joined_party)
        end

        scene_brawl = Scene.new(id: :zheng_interrogation_brawl, title: "Castigo a Zheng y combate", location: "Lin Lin Hostess Bar")
        scene_trade_lead = Scene.new(id: :yokohama_trading_lead, title: "La pista de Yokohama Trading Company", location: "Callejón de Restaurant Row")

        # 1. Incursión en la sala VIP y rescate de Saeko de los abusos de Zheng
        scene_vip.check_preconditions!(@state)
        transition_to(scene_vip)
        emit("story.hostess_rescue", actor: :ichiban, target: :saeko, data: { aggressor: "Zheng", incident: "conducta_denigrante_en_sala_vip" })

        # 2. Enfrentamiento y derrota de Zheng
        transition_to(scene_brawl)
        emit("story.threat_detected", actor: :zheng, target: :ichiban, data: { faction: "Yokohama Liumang" })
        emit("story.combat_resolved", actor: :ichiban, target: :zheng, data: { assisted_by: [:nanba, :adachi, :saeko], victory: true })

        # 3. Interrogatorio bajo amenaza y revelación de Yokohama Trading Company
        transition_to(scene_trade_lead, new_location: "Callejón de Restaurant Row", new_time: "2019 - Madrugada")
        emit("story.intel_extracted", actor: :ichiban, target: :zheng, data: { company: "Yokohama Trading Company", location: "muelle_de_hamakita_park", operator: "Akira Mabuchi" })
        @state.set_flag(:yokohama_trading_identified, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "investigar_yokohama_trading_company" })
      end

      def generate_summary
        "Episodio 26_el_club_lin_lin completado: El grupo irrumpe en el club Lin Lin, rescata a Saeko, derrota a Zheng y le arranca la pista clave: el mayor negocio de Mabuchi es la empresa Yokohama Trading Company en el muelle de Hamakita."
      end
    end
  end
end
