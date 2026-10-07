# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep40 < IchibanLab::BaseScenario
      protected

      def episode_id
        "40_la_confesion_de_nanba"
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
        seonhee = Character.new(
          id: :seonhee,
          name: "Seonhee",
          attributes: { role: :geomijul_leader },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "nanba_background_interrogation",
          location: "Fortaleza de Geomijul - Sala de Impresión Maestra",
          time_period: "2019 - Noche",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, seonhee: seonhee },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample],
          flags: { nanba_suspicions_triggered: true, seonhee_identified: true }
        )
      end

      def execute_scenario
        scene_interrogation = Scene.new(
          id: :nanba_background_interrogation,
          title: "Interrogatorio sobre el pasado de Nanba",
          location: "Fortaleza de Geomijul - Sala de Impresión Maestra"
        )
        scene_interrogation.add_precondition("Las sospechas sobre Nanba deben estar activas") do |ws|
          ws.flag?(:nanba_suspicions_triggered)
        end

        scene_brother = Scene.new(
          id: :shoichi_nanba_revelation,
          title: "La revelación de Shoichi Nanba",
          location: "Fortaleza de Geomijul - Sala de Impresión Maestra"
        )

        scene_tasing = Scene.new(
          id: :nanba_tased_and_captured,
          title: "La descarga eléctrica y la captura de Nanba",
          location: "Fortaleza de Geomijul - Sala de Impresión Maestra"
        )

        # 1. Seonhee confronta a Nanba con su vigilancia previa de 6 meses
        scene_interrogation.check_preconditions!(@state)
        transition_to(scene_interrogation)
        emit("story.surveillance_history_revealed", actor: :seonhee, target: :nanba, data: { detail: "nanba_llego_hace_6_meses_y_vigilaba_el_edificio_de_geomijul" })

        # 2. Nanba confiesa la búsqueda de su hermano periodista Shoichi Nanba (Shoichi Akiba)
        transition_to(scene_brother)
        emit("story.confession_unsealed", actor: :nanba, target: :ichiban, data: { brother: "Shoichi Nanba (alias Shoichi Akiba)", motive: "periodista_desaparecido_investigando_dinero_falso" })
        emit("story.motives_clarified", actor: :nanba, data: { reason: "se_unio_a_ichiban_al_ver_el_billete_impreso_erroneamente" })
        @state.set_flag(:shoichi_mystery_revealed, true)

        # 3. Nanba suplica por su hermano, Seonhee lo electrocuta con un taser y ordena apartarlo
        transition_to(scene_tasing)
        emit("story.taser_subdual", actor: :seonhee, target: :nanba, data: { weapon: "taser_electrico", status: "nanba_inconsciente" })
        emit("story.hostage_declared", actor: :seonhee, data: { target: :nanba, classification: "unico_enemigo_de_geomijul" })
        @state.set_flag(:nanba_captured_by_geomijul, true)
      end

      def generate_summary
        "Episodio 40_la_confesion_de_nanba completado: Seonhee desvela que Nanba vigilaba Geomijul desde hacía medio año. Nanba confiesa que su verdadero propósito era encontrar a su hermano menor desaparecido, el periodista Shoichi Nanba, quien investigaba la red de dinero falso. Tras pedir clemencia para Ichiban, Seonhee lo reduce con un taser y ordena su captura."
      end
    end
  end
end
