# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep30 < IchibanLab::BaseScenario
      protected

      def episode_id
        "30_explosion_en_el_muelle"
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
        foreman = Character.new(
          id: :liumang_foreman,
          name: "Capataz de Liumang",
          attributes: { role: :warehouse_enforcer, hp: 220 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "handover_fumble_and_clash",
          location: "Yokohama Trading Company - Almacén del Muelle",
          time_period: "2019 - Tarde",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, liumang_foreman: foreman },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key],
          flags: { sample_extraction_ready: true, counterfeit_yuan_operation_confirmed: true }
        )
      end

      def execute_scenario
        scene_fumble = Scene.new(id: :handover_fumble_and_clash, title: "El tropiezo del billete y combate en el muelle", location: "Yokohama Trading Company - Almacén del Muelle")
        scene_fumble.add_precondition("El plan de extracción de muestra debe estar preparado") do |ws|
          ws.flag?(:sample_extraction_ready)
        end

        scene_truck = Scene.new(id: :truck_ramming_assault, title: "Ataque del camión cisterna", location: "Yokohama Trading Company - Bahía de Carga")
        scene_blast = Scene.new(id: :warehouse_fireball_escape, title: "Explosión masiva y escape del muelle", location: "Hamakita Park - Paseo marítimo")

        # 1. Traspaso torpe del billete, tropiezo de Nanba y combate contra los capataces
        scene_fumble.check_preconditions!(@state)
        transition_to(scene_fumble)
        emit("story.extraction_accident", actor: :nanba, target: :ichiban, data: { incident: "tropiezo_accidental_que_revela_el_billete_falso" })
        emit("story.threat_detected", actor: :liumang_foreman, target: :ichiban, data: { alert: "traidores_japoneses_descubiertos" })
        emit("story.combat_resolved", actor: :ichiban, target: :liumang_foreman, data: { assisted_by: [:nanba, :adachi, :saeko], victory: true })
        @state.add_item(:counterfeit_yuan_sample)

        # 2. El camión cisterna embiste contra la estructura
        transition_to(scene_truck, new_location: "Yokohama Trading Company - Bahía de Carga")
        emit("story.vehicular_assault", actor: :liumang_foreman, data: { vehicle: "camion_cisterna_estrellado", hazard: "fuga_masiva_de_combustible" })
        @state.set_flag(:fuel_leak_triggered, true)

        # 3. Explosión en cadena, huida al parque Hamakita y observador misterioso
        transition_to(scene_blast, new_location: "Hamakita Park - Paseo marítimo", new_time: "2019 - Atardecer")
        emit("story.catastrophic_explosion", actor: :ichiban, data: { location: "Yokohama Trading Company Warehouse", status: "destruido_por_el_fuego" })
        emit("story.mysterious_observer_sighted", actor: :ichiban, data: { observer: "hombre_enigmático_en_banco_del_parque", chapter_transition: true })
        @state.set_flag(:warehouse_destroyed, true)
        @state.set_flag(:chapter_5_completed, true)

        # Cierre y frontera del Capítulo 5
        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 5, status: :concluded, next: :chapter_6 })
      end

      def generate_summary
        "Episodio 30_explosion_en_el_muelle completado: El billete es descubierto tras un tropiezo; tras vencer a los sicarios, un camión cisterna estalla reduciendo el almacén a cenizas. El grupo escapa con una muestra del dinero falso ante la mirada de un misterioso observador. Fin del Capítulo 5."
      end
    end
  end
end
