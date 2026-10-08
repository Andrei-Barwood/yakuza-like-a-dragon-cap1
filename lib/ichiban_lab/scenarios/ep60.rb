# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep60 < IchibanLab::BaseScenario
      protected

      def episode_id
        "60_la_promesa_del_pato_de_pekin"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { adachi: :brother_in_arms, saeko: :protectee, nanba: :sworn_brother },
          belongings: []
        )
        chief = Character.new(
          id: :homeless_chief,
          name: "Jefe de los Indigentes",
          attributes: { role: :informant },
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
          scene_id: "chief_confession_and_arakawa_orders",
          location: "Campamento de Indigentes - Orilla del Río",
          time_period: "2019 - Mañana",
          money: 26300,
          characters: {
            ichiban: ichiban,
            homeless_chief: chief,
            ryuhei_hoshino: hoshino
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :seiryu_clan_key,
            :counterfeit_yuan_sample,
            :shoichi_investigative_notes,
            :bleach_japan_founders_clipping
          ],
          flags: {
            mitsuo_intel_received: true,
            liumang_geomijul_alliance_sealed: true
          }
        )
      end

      def execute_scenario
        scene_chief = Scene.new(
          id: :chief_confession_and_arakawa_orders,
          title: "La confesión del Jefe: el pacto médico de la Familia Arakawa",
          location: "Campamento de Indigentes - Orilla del Río"
        )
        scene_chief.add_precondition("El grupo debe haber recibido los informes de Mitsuo") do |ws|
          ws.flag?(:mitsuo_intel_received)
        end

        scene_heian_lunch = Scene.new(
          id: :peking_duck_lunch_at_heian_tower,
          title: "Almuerzo de pato de Pekín con Ryuhei Hoshino en Heian Tower",
          location: "Heian Tower - Restaurante Panorámico"
        )

        scene_bill_truth = Scene.new(
          id: :counterfeit_10k_bill_origins_and_message,
          title: "El origen del billete defectuoso de 1984 y el mensaje grabado",
          location: "Heian Tower - Restaurante Panorámico"
        )

        # 1. El Jefe de los indigentes confiesa que Arakawa ordenaba curar en secreto a los heridos que enviaba a Ijincho
        scene_chief.check_preconditions!(@state)
        transition_to(scene_chief)
        emit("story.arakawa_corpse_protocol_revealed", actor: :homeless_chief, target: :ichiban, data: { protocol: "salvar_la_vida_a_los_enviados_vivos_simulando_su_muerte", memory: "arakawa_dijo_cuento_contigo_kasuga" })
        @state.set_flag(:arakawa_protection_confirmed, true)

        # 2. Almuerzo de pato de Pekín en Heian Tower con Ryuhei Hoshino: la verdad sobre Toshio Arakawa en 1977
        transition_to(scene_heian_lunch, new_location: "Heian Tower - Restaurante Panorámico", new_time: "2019 - Mediodía")
        emit("story.toshio_murder_confessed", actor: :ryuhei_hoshino, data: { murder_origin: "hoshino_mato_a_toshio_por_la_perdida_de_100_millones_falsos_robados_por_yoko" })
        emit("story.arakawa_forgiveness_recounted", actor: :ryuhei_hoshino, data: { meeting_seven_years_later: "arakawa_le_perdono_la_vida_al_reconocer_su_culpa_y_su_arrepentimiento" })

        # 3. El origen del billete defectuoso de 1984 y la inscripción oculta en el reverso
        transition_to(scene_bill_truth)
        emit("story.defective_bill_1984_revealed", actor: :ryuhei_hoshino, data: { gift_year: 1984, motive: "regalo_en_gratitud_por_mantener_a_flote_a_los_tres_de_ijin" })
        emit("story.engraved_motto_unveiled", actor: :ichiban, data: { motto: "Ni la justicia ni la piedad deben inclinar la balanza", meaning: "arakawa_considera_a_kasuga_su_familia_y_le_envio_para_buscar_a_hoshino" })
        @state.set_flag(:faith_in_arakawa_restored, true)
        @state.set_flag(:chapter_10_completed, true)

        # Cierre y frontera del Capítulo 10
        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 10, status: :concluded, next: :chapter_11 })
      end

      def generate_summary
        "Episodio 60_la_promesa_del_pato_de_pekin completado: El Jefe de los indigentes confiesa que la Familia Arakawa tenía la directriz secreta de sanar a quienes enviaba con vida. En Heian Tower, Hoshino agasaja a Kasuga con pato de Pekín y revela que mató a Toshio Arakawa por error en 1977, pero Masumi le perdonó la vida años después. El billete defectuoso de 1984, con el lema 'Ni la justicia ni la piedad deben inclinar la balanza', era la contraseña de Arakawa hacia Hoshino confiándole el destino de Kasuga como su verdadera familia. Fin del Capítulo 10."
      end
    end
  end
end
