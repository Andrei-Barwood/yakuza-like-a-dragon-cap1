# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep23 < IchibanLab::BaseScenario
      protected

      def episode_id
        "23_el_rescate_de_tatsuro"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { nanba: :sworn_partner, adachi: :brother_in_arms },
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
        doctor = Character.new(
          id: :corrupt_doctor,
          name: "Médico de Sunlight Castle",
          attributes: { role: :lethal_injector },
          relationships: {},
          belongings: []
        )
        totsuka = Character.new(
          id: :totsuka,
          name: "Yamato Totsuka",
          attributes: { role: :ryuto_family_patriarch, hp: 180 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "sunlight_castle_breach",
          location: "Sunlight Castle - Pasillos VIP",
          time_period: "2019 - Mañana",
          money: 6300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, corrupt_doctor: doctor, totsuka: totsuka },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill],
          flags: { ready_to_breach_sunlight: true }
        )
      end

      def execute_scenario
        scene_breach = Scene.new(id: :sunlight_castle_breach, title: "Incursión en el área Excellent", location: "Sunlight Castle - Pasillos VIP")
        scene_breach.add_precondition("El grupo debe estar preparado para asaltar el asilo") do |ws|
          ws.flag?(:ready_to_breach_sunlight)
        end

        scene_save = Scene.new(id: :lethal_injection_stopped, title: "Frenando la inyección letal de cloruro de potasio", location: "Sunlight Castle - Sala VIP")
        scene_totsuka = Scene.new(id: :totsuka_confrontation, title: "Enfrentamiento con Yamato Totsuka", location: "Sunlight Castle - Recepción")

        # 1. Incursión y tarjeta de acceso obtenida por Adachi
        scene_breach.check_preconditions!(@state)
        transition_to(scene_breach)
        emit("story.security_card_obtained", actor: :adachi, target: :ichiban, data: { item: :vip_keycard })
        @state.add_item(:vip_keycard)

        # 2. Interrupción in extremis al médico y rescate de Tatsuro Mukoda
        transition_to(scene_save, new_location: "Sunlight Castle - Sala VIP")
        emit("story.lethal_procedure_intercepted", actor: :ichiban, target: :corrupt_doctor, data: { poison: "cloruro_de_potasio", victim_saved: "Tatsuro Mukoda" })
        @state.set_flag(:tatsuro_mukoda_rescued, true)

        # 3. Combate contra Totsuka y los matones de la Familia Ryuto
        transition_to(scene_totsuka, new_location: "Sunlight Castle - Recepción")
        emit("story.threat_detected", actor: :totsuka, target: :ichiban, data: { faction: "Familia Ryuto (Clan Seiryu)" })
        emit("story.combat_resolved", actor: :ichiban, target: :totsuka, data: { assisted_by: [:nanba, :adachi], victory: true })
        @state.set_flag(:totsuka_defeated, true)

        # Decisión de llevar a Totsuka a la sede del Clan Seiryu
        emit("story.escalation_chosen", actor: :ichiban, target: :totsuka, data: { decision: "llevar_a_totsuka_ante_el_patriarca_hoshino" })
        @state.set_flag(:escorting_totsuka_to_seiryu, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "ir_a_la_sede_del_clan_seiryu" })
      end

      def generate_summary
        "Episodio 23_el_rescate_de_tatsuro completado: El grupo asalta la sala VIP de Sunlight Castle, frena la inyección letal de cloruro de potasio salvando a Tatsuro, derrota a Yamato Totsuka y marcha hacia la sede del Clan Seiryu."
      end
    end
  end
end
