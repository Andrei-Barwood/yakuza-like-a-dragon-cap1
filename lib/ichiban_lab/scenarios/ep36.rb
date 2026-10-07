# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep36 < IchibanLab::BaseScenario
      protected

      def episode_id
        "36_el_juicio_de_tianyou_zhao"
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
        takabe = Character.new(
          id: :mamoru_takabe,
          name: "Mamoru Takabe",
          attributes: { role: :seiryu_captain },
          relationships: { ichiban: :frenemy },
          belongings: []
        )
        zhao = Character.new(
          id: :tianyou_zhao,
          name: "Tianyou Zhao",
          attributes: { role: :liumang_leader, hp: 500 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "zhao_arrival_outside_qing_jin",
          location: "Restaurante Qing Jin - Puertas Exteriores",
          time_period: "2019 - Noche",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, mamoru_takabe: takabe, tianyou_zhao: zhao },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample],
          flags: { takabe_subdued: true }
        )
      end

      def execute_scenario
        scene_arrival = Scene.new(
          id: :zhao_arrival_outside_qing_jin,
          title: "Aparición de Tianyou Zhao",
          location: "Restaurante Qing Jin - Puertas Exteriores"
        )
        scene_arrival.add_precondition("Takabe debe haber sido reducido para evitar el tiroteo") do |ws|
          ws.flag?(:takabe_subdued)
        end

        scene_video = Scene.new(
          id: :edited_video_confrontation,
          title: "El video manipulado y la sospecha de traición",
          location: "Restaurante Qing Jin - Entrada Principal"
        )

        scene_geomijul = Scene.new(
          id: :geomijul_ultimatum_and_standoff,
          title: "El ultimátum de Zhao y el rastro de Geomijul",
          location: "Restaurante Qing Jin - Entrada Principal"
        )

        # 1. Llega Tianyou Zhao, líder supremo de Yokohama Liumang
        scene_arrival.check_preconditions!(@state)
        transition_to(scene_arrival)
        emit("story.boss_appearance", actor: :tianyou_zhao, target: :ichiban, data: { title: "Líder de Yokohama Liumang", demeanor: "sarcastico_y_amenazante" })
        emit("story.firearm_standoff", actor: :tianyou_zhao, target: :mamoru_takabe, data: { weapon: "pistola_apuntada_a_la_cabeza_de_takabe" })

        # 2. Zhao muestra el video editado subido por Mabuchi
        transition_to(scene_video, new_location: "Restaurante Qing Jin - Entrada Principal")
        emit("story.deceptive_evidence_revealed", actor: :tianyou_zhao, target: :ichiban, data: { video: "interrogatorio_recortado", claim: "ichiban_y_takabe_actuan_para_hoshino" })
        emit("story.internal_suspicion", actor: :tianyou_zhao, data: { thought: "mabuchi_como_posible_traidor_interno_carece_de_motivo_claro" })

        # 3. Falta de pruebas contundentes y dirección hacia la red de espionaje Geomijul
        transition_to(scene_geomijul)
        emit("story.investigative_ultimatum", actor: :tianyou_zhao, target: :ichiban, data: { condition: "obtener_evidencia_definitiva_o_habra_guerra_total", target_organization: "Geomijul" })
        emit("story.ceasefire_agreed", actor: :tianyou_zhao, target: :mamoru_takabe, data: { status: "tregua_temporal_mientras_se_investiga" })
        @state.set_flag(:geomijul_lead_unlocked, true)
        @state.set_flag(:temporary_ceasefire_active, true)
        @state.set_flag(:chapter_6_completed, true)

        # Cierre y frontera del Capítulo 6
        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 6, status: :concluded, next: :chapter_7 })
      end

      def generate_summary
        "Episodio 36_el_juicio_de_tianyou_zhao completado: Tianyou Zhao interviene apuntando a Takabe y mostrando el video manipulado por Mabuchi. Incapaz de comprender por qué su mano derecha provocaría la guerra, Zhao exige pruebas irrefutables antes de desatar el conflicto y envía a Kasuga a infiltrarse en la red de la mafia coreana Geomijul. Fin del Capítulo 6."
      end
    end
  end
end
