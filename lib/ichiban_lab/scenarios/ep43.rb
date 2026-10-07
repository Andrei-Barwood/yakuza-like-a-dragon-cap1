# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep43 < IchibanLab::BaseScenario
      protected

      def episode_id
        "43_el_pacto_de_los_tres"
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
        zhao = Character.new(
          id: :tianyou_zhao,
          name: "Tianyou Zhao",
          attributes: { role: :liumang_leader },
          relationships: {},
          belongings: []
        )
        seonhee = Character.new(
          id: :seonhee,
          name: "Seonhee",
          attributes: { role: :geomijul_leader },
          relationships: {},
          belongings: []
        )
        hoshino = Character.new(
          id: :ryuhei_hoshino,
          name: "Ryuhei Hoshino",
          attributes: { role: :seiryu_chairman },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "heian_tower_triumvirate_dialogue",
          location: "Heian Tower - Mirador Panorámico",
          time_period: "2019 - 02:15 AM",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
            tianyou_zhao: zhao,
            seonhee: seonhee,
            ryuhei_hoshino: hoshino
          },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample, :shoichi_investigative_notes],
          flags: { chapter_7_completed: true, ijin_three_summit_concluded: true }
        )
      end

      def execute_scenario
        scene_triumvirate = Scene.new(
          id: :heian_tower_triumvirate_dialogue,
          title: "Diálogo cumbre con el Triunvirato de Ijincho",
          location: "Heian Tower - Mirador Panorámico"
        )
        scene_triumvirate.add_precondition("El grupo debe proceder de la cumbre del Capítulo 7") do |ws|
          ws.flag?(:chapter_7_completed) && ws.flag?(:ijin_three_summit_concluded)
        end

        scene_history = Scene.new(
          id: :postwar_history_and_ogikubo_scheme,
          title: "La historia de posguerra y el esquema de Ogikubo",
          location: "Heian Tower - Mirador Panorámico"
        )

        scene_stalemate = Scene.new(
          id: :gray_zone_stalemate_revelation,
          title: "La zona gris y el precio del equilibrio",
          location: "Heian Tower - Mirador Panorámico"
        )

        # 1. Audiencia tensa con Hoshino, Zhao y Seonhee
        scene_triumvirate.check_preconditions!(@state)
        transition_to(scene_triumvirate)
        emit("story.leaders_assembly_confronted", actor: :ichiban, data: { demands: "frenar_el_derramamiento_de_sangre_inutil" })

        # 2. Hoshino relata el origen de la posguerra y la propuesta de Yutaka Ogikubo hace 60 años
        transition_to(scene_history)
        emit("story.postwar_origin_revealed", actor: :ryuhei_hoshino, data: { originator: "Yutaka Ogikubo", pact_age: "60_años_atras", mechanics: "Liumang_consigue_papel_Seiryu_distribuye" })
        emit("story.jingweon_integration_recounted", actor: :seonhee, data: { arrival: "refugiados_coreanos_de_Jingweon_en_los_80", role: "Geomijul_asume_la_vigilancia_y_la_imprenta" })

        # 3. La compra de lealtad policial y la creación de la zona gris de Ijincho
        transition_to(scene_stalemate)
        emit("story.police_corruption_explained", actor: :ryuhei_hoshino, data: { effect: "policia_financiada_que_mantiene_la_paz_artificial_en_la_zona_gris" })
        @state.set_flag(:ogikubo_system_fully_understood, true)
      end

      def generate_summary
        "Episodio 43_el_pacto_de_los_tres completado: En la mesa de Heian Tower, Ryuhei Hoshino y Seonhee relatan a Ichiban el origen del sistema establecido hace sesenta años por el político Yutaka Ogikubo, financiando a la policía y coordinando a las tres mafias para forjar la zona gris pacífica de Ijincho."
      end
    end
  end
end
