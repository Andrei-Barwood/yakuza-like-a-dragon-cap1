# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep45 < IchibanLab::BaseScenario
      protected

      def episode_id
        "45_asalto_al_edificio_hakuryo"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { adachi: :brother_in_arms, saeko: :protectee },
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
        traitor = Character.new(
          id: :renegade_geomijul,
          name: "Asesino Renegado de Geomijul",
          attributes: { role: :mercenary, hp: 300 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "hakuryo_building_perimeter",
          location: "Carriage Highway - Exterior del Edificio Hakuryo",
          time_period: "2019 - Mañana",
          money: 26300,
          characters: { ichiban: ichiban, adachi: adachi, saeko: saeko, renegade_geomijul: traitor },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample, :shoichi_investigative_notes],
          flags: { hakuryo_building_target_active: true }
        )
      end

      def execute_scenario
        scene_perimeter = Scene.new(
          id: :hakuryo_building_perimeter,
          title: "Perímetro del Edificio Hakuryo",
          location: "Carriage Highway - Exterior del Edificio Hakuryo"
        )
        scene_perimeter.add_precondition("El objetivo del Edificio Hakuryo debe estar activo") do |ws|
          ws.flag?(:hakuryo_building_target_active)
        end

        scene_clash = Scene.new(
          id: :renegade_assassin_ambush,
          title: "Emboscada del asesino de Matsuo",
          location: "Carriage Highway - Exterior del Edificio Hakuryo"
        )

        scene_lobby = Scene.new(
          id: :hakuryo_building_entry,
          title: "Ingreso a la sede de Bleach Japan",
          location: "Edificio Hakuryo - Planta 2F"
        )

        # 1. Llegada al exterior del edificio de Bleach Japan en Carriage Highway
        scene_perimeter.check_preconditions!(@state)
        transition_to(scene_perimeter)
        emit("story.location_reached", actor: :ichiban, data: { location: "Edificio Hakuryo", objective: "encontrar_a_nanba_antes_que_los_sicarios" })

        # 2. Emboscada del ex-agente de Geomijul responsable de la muerte de Matsuo
        transition_to(scene_clash)
        emit("story.traitor_confrontation", actor: :renegade_geomijul, target: :ichiban, data: { identity: "asesino_de_matsuo_que_cambio_de_bando", threat: "eliminacion_por_contrato" })
        emit("story.combat_resolved", actor: :ichiban, target: :renegade_geomijul, data: { victory: true, status: "renegado_neutralizado" })
        @state.set_flag(:hakuryo_entrance_cleared, true)

        # 3. Acceso a la segunda planta donde opera Bleach Japan
        transition_to(scene_lobby, new_location: "Edificio Hakuryo - Planta 2F")
        emit("story.office_breached", actor: :ichiban, data: { office: "Bleach Japan Yokohama Headquarters", floor: "2F" })
        @state.set_flag(:bleach_japan_office_reached, true)
      end

      def generate_summary
        "Episodio 45_asalto_al_edificio_hakuryo completado: El grupo llega al Edificio Hakuryo en Carriage Highway, donde sufren la emboscada del renegado de Geomijul que asesinó a Matsuo en The Harbor Light. Tras derrotarlo en combate, ingresan a la segunda planta en busca de Nanba."
      end
    end
  end
end
