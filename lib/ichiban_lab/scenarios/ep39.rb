# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep39 < IchibanLab::BaseScenario
      protected

      def episode_id
        "39_la_reina_de_la_telaraña"
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
          attributes: { role: :geomijul_leader, hp: 500 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "counterfeit_yen_factory",
          location: "Fortaleza de Geomijul - Imprenta Clandestina de Yenes",
          time_period: "2019 - Noche",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, seonhee: seonhee },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample],
          flags: { mabuchi_murder_footage_confirmed: true, han_identity_confirmed: true }
        )
      end

      def execute_scenario
        scene_mint = Scene.new(
          id: :counterfeit_yen_factory,
          title: "La imprenta clandestina de yenes",
          location: "Fortaleza de Geomijul - Imprenta Clandestina de Yenes"
        )
        scene_mint.add_precondition("Las cintas de Mabuchi deben haber sido revisadas") do |ws|
          ws.flag?(:mabuchi_murder_footage_confirmed)
        end

        scene_seonhee = Scene.new(
          id: :seonhee_introduction_and_truth,
          title: "Aparición de Seonhee y el secreto del papel",
          location: "Fortaleza de Geomijul - Sala de Impresión Maestra"
        )

        scene_gunpoint = Scene.new(
          id: :misprinted_bill_confrontation,
          title: "Interrogatorio a punta de pistola por el billete defectuoso",
          location: "Fortaleza de Geomijul - Sala de Impresión Maestra"
        )

        # 1. Entrada al verdadero corazón económico de Geomijul: la falsificación de yenes
        scene_mint.check_preconditions!(@state)
        transition_to(scene_mint)
        emit("story.secret_mint_unveiled", actor: :joon_gi_han, data: { operation: "imprenta_de_yenes_japoneses_falsificados_de_alta_calidad" })

        # 2. Reaparición de la guía misteriosa: es Seonhee, la líder suprema
        transition_to(scene_seonhee, new_location: "Fortaleza de Geomijul - Sala de Impresión Maestra")
        emit("story.leader_identity_revealed", actor: :seonhee, target: :ichiban, data: { title: "Líder Suprema de Geomijul", relation: "guia_misteriosa_de_koreatown" })
        emit("story.counterfeiting_origin_explained", actor: :seonhee, data: { explanation: "el_papel_de_mabuchi_era_suministrado_por_liumang_para_fabricar_yenes_en_geomijul" })
        @state.set_flag(:seonhee_identified, true)

        # 3. Encañonamiento a Kasuga para exigir la verdad sobre el billete defectuoso
        transition_to(scene_gunpoint)
        emit("story.gunpoint_cross_examination", actor: :seonhee, target: :ichiban, data: { focus_item: :counterfeit_10k_bill, question: "origen_del_billete_impreso_erroneamente" })
        emit("story.target_shift", actor: :seonhee, target: :nanba, data: { suspicion: "kasuga_es_inocente_pero_nanba_oculta_algo" })
        @state.set_flag(:nanba_suspicions_triggered, true)
      end

      def generate_summary
        "Episodio 39_la_reina_de_la_telaraña completado: Han conduce al grupo ante la imprenta clandestina de yenes de Geomijul, donde la misteriosa guía se revela como Seonhee, líder de la organización. Seonhee explica la alianza secreta de los Tres de Ijin para producir yenes falsos y, a punta de pistola, interroga a Ichiban sobre el billete defectuoso antes de posar sus sospechas sobre Nanba."
      end
    end
  end
end
