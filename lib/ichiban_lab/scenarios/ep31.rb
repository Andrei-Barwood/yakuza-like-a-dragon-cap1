# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep31 < IchibanLab::BaseScenario
      protected

      def episode_id
        "31_el_despertar_encadenado"
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
        mabuchi = Character.new(
          id: :akira_mabuchi,
          name: "Akira Mabuchi",
          attributes: { role: :liumang_conspirator },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "mabuchi_interrogation_room",
          location: "Escondite Subterráneo de Mabuchi - Celda de Contención",
          time_period: "2019 - Noche",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, akira_mabuchi: mabuchi },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample],
          flags: { chapter_5_completed: true, warehouse_destroyed: true }
        )
      end

      def execute_scenario
        scene_interrogation = Scene.new(
          id: :mabuchi_interrogation_room,
          title: "Interrogatorio grabado y trampa de guerra",
          location: "Escondite Subterráneo de Mabuchi - Celda de Contención"
        )
        scene_interrogation.add_precondition("El grupo debe proceder de la destrucción del almacén del muelle") do |ws|
          ws.flag?(:chapter_5_completed)
        end

        scene_recording = Scene.new(
          id: :forced_video_recording,
          title: "La confesión de Nonomiya y el video manipulado",
          location: "Escondite Subterráneo de Mabuchi - Celda de Contención"
        )

        scene_condemnation = Scene.new(
          id: :sentenced_in_chains,
          title: "Sentencia a muerte en cadenas",
          location: "Escondite Subterráneo de Mabuchi - Celda de Contención"
        )

        # 1. Despertar encadenados en el sótano clandestino
        scene_interrogation.check_preconditions!(@state)
        transition_to(scene_interrogation)
        emit("story.awakening_restrained", actor: :ichiban, target: :akira_mabuchi, data: { status: "encadenados_tras_emboscada_post_almacen" })
        @state.set_flag(:party_restrained, true)

        # 2. Interrogatorio de Mabuchi frente a la cámara y admisión del crimen
        transition_to(scene_recording)
        emit("story.confession_extracted", actor: :akira_mabuchi, target: :ichiban, data: { crime: "asesinato_de_nonomiya_admitido", objective: "acusar_al_clan_seiryu_en_video" })
        emit("story.propaganda_uploaded", actor: :akira_mabuchi, data: { video: "interrogatorio_editado", footage: "almacen_vandalizado" })
        @state.set_flag(:mabuchi_video_uploaded, true)

        # 3. Sentencia dictada por Mabuchi antes de marcharse
        transition_to(scene_condemnation)
        emit("story.death_sentence_issued", actor: :akira_mabuchi, target: :ichiban, data: { enforcer: :yan, method: "ejecucion_ejemplar_encadenados" })
        @state.set_flag(:execution_ordered, true)
      end

      def generate_summary
        "Episodio 31_el_despertar_encadenado completado: Ichiban y su grupo despiertan atados con cadenas en un escondite subterráneo. Akira Mabuchi graba un interrogatorio manipulado acusándolos de ser saboteadores del Clan Seiryu para detonar la guerra de mafias, admite cínicamente haber asesinado a Nonomiya y ordena su ejecución."
      end
    end
  end
end
