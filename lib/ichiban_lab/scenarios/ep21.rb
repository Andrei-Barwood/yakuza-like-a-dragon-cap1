# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep21 < IchibanLab::BaseScenario
      protected

      def episode_id
        "21_el_castillo_de_la_luz"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :sunlight_janitor },
          relationships: { nanba: :sworn_partner, adachi: :ally },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :sunlight_nurse },
          relationships: { ichiban: :sworn_partner },
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :sunlight_guard },
          relationships: { ichiban: :ally },
          belongings: []
        )
        kanbe = Character.new(
          id: :kanbe,
          name: "Director Shuichi Kanbe",
          attributes: { role: :hello_work_director },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "kanbe_placement",
          location: "Oficina de Hello Work Yokohama",
          time_period: "2019 - Noche",
          money: 6300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, kanbe: kanbe },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill],
          flags: { sunlight_castle_located: true }
        )
      end

      def execute_scenario
        scene_placement = Scene.new(id: :kanbe_placement, title: "Contrato externo con el Director Kanbe", location: "Oficina de Hello Work Yokohama")
        scene_placement.add_precondition("Sunlight Castle debe haber sido localizado") do |ws|
          ws.flag?(:sunlight_castle_located)
        end

        scene_shift = Scene.new(id: :sunlight_infiltration_shift, title: "Turno de infiltración encubierto", location: "Sunlight Castle")
        scene_dark_secret = Scene.new(id: :pension_scam_discovery, title: "El siniestro fraude de pensiones", location: "Otohime Land Soapland")

        # 1. Colocación como contratistas externos vía Kanbe
        scene_placement.check_preconditions!(@state)
        transition_to(scene_placement)
        emit("story.contractor_placement", actor: :kanbe, target: :ichiban, data: { roles: { ichiban: :janitor, nanba: :caretaker, adachi: :security } })
        @state.set_flag(:infiltrated_sunlight_castle, true)

        # 2. Turno encubierto y el grito aterrador en la zona VIP
        transition_to(scene_shift, new_location: "Sunlight Castle", new_time: "2019 - Noche avanzada")
        emit("story.suspicious_incident_witnessed", actor: :ichiban, data: { victim: "anciana_llevada_a_sala_vip", sound: "grito_aterrador" })
        @state.set_flag(:vip_screams_heard, true)

        # 3. Reunión de inteligencia y revelación del fraude
        transition_to(scene_dark_secret, new_location: "Otohime Land Soapland", new_time: "2019 - Madrugada")
        emit("story.intel_shared", actor: :adachi, target: :ichiban, data: { evidence: "caja_fuerte_con_cartillas_bancarias_de_residentes", modus_operandi: "eutanasia_nocturna_para_cobrar_pensiones" })
        emit("story.faction_link_revealed", actor: :adachi, data: { subsidiary: "Familia Ryuto", clan: "Clan Seiryu", deadline: "manana_para_tatsuro" })
        @state.set_flag(:pension_scam_uncovered, true)
        @state.set_flag(:tatsuro_rescue_urgent, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "preparar_asalto_para_salvar_a_tatsuro" })
      end

      def generate_summary
        "Episodio 21_el_castillo_de_la_luz completado: Infiltrados como contratistas en Sunlight Castle, descubren el negocio de la Familia Ryuto (Seiryu): eutanasia encubierta para cobrar pensiones. Tatsuro Mukoda morirá mañana si no intervienen."
      end
    end
  end
end
