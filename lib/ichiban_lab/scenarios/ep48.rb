# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep48 < IchibanLab::BaseScenario
      protected

      def episode_id
        "48_la_verdadera_identidad_de_aoki"
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
        aoki = Character.new(
          id: :ryo_aoki,
          name: "Ryo Aoki / Masato Arakawa",
          attributes: { role: :tokyo_governor },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "photo_scrutiny_and_shocking_truth",
          location: "Edificio Hakuryo - Archivos de Dirección",
          time_period: "2019 - Tarde",
          money: 26300,
          characters: { ichiban: ichiban, adachi: adachi, saeko: saeko, ryo_aoki: aoki },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :seiryu_clan_key,
            :counterfeit_yuan_sample,
            :shoichi_investigative_notes,
            :bleach_japan_founders_clipping
          ],
          flags: { founders_clipping_found: true, nanba_left_party: true }
        )
      end

      def execute_scenario
        scene_photo = Scene.new(
          id: :photo_scrutiny_and_shocking_truth,
          title: "El examen de la foto y la revelación de Masato",
          location: "Edificio Hakuryo - Archivos de Dirección"
        )
        scene_photo.add_precondition("El recorte de prensa debe estar en posesión del grupo") do |ws|
          ws.flag?(:founders_clipping_found)
        end

        scene_tokyo = Scene.new(
          id: :tokyo_metropolitan_government_office,
          title: "El despacho del Gobernador de Tokio",
          location: "Oficina del Gobernador de Tokio - Shinjuku"
        )

        scene_call = Scene.new(
          id: :reinforcements_call_and_chapter_boundary,
          title: "La llamada secreta y la orden de invasión",
          location: "Oficina del Gobernador de Tokio - Shinjuku"
        )

        # 1. Kasuga examina la fotografía y reconoce al Gobernador Ryo Aoki: es el Joven Maestro Masato Arakawa
        scene_photo.check_preconditions!(@state)
        transition_to(scene_photo)
        emit("story.identity_epiphany", actor: :ichiban, data: { governor: "Ryo Aoki", real_identity: "Masato Arakawa (El Joven Maestro)", status: "presuntamente_fallecido_pero_ahora_gobernador" })
        @state.set_flag(:masato_arakawa_identity_revealed, true)

        # 2. La escena cambia a Tokio: Ryo Aoki en su despacho gubernamental
        transition_to(scene_tokyo, new_location: "Oficina del Gobernador de Tokio - Shinjuku", new_time: "2019 - Atardecer")
        emit("story.political_maneuvering", actor: :ryo_aoki, data: { office: "Gobernador de Tokio", action: "recortes_de_presupuesto_y_control_institucional" })

        # 3. Llamada telefónica de Ogasawara informando de la imprenta de Geomijul y petición de tropas de la Omi
        transition_to(scene_call)
        emit("story.secret_call_received", actor: :ryo_aoki, target: :hajime_ogasawara, data: { report: "descubrimiento_de_la_imprenta_de_yenes_en_geomijul" })
        emit("story.invasion_forces_ordered", actor: :ryo_aoki, data: { command: "desplegar_refuerzos_masivos_de_la_alianza_omi_en_yokohama" })
        @state.set_flag(:chapter_8_completed, true)

        # Cierre y frontera del Capítulo 8
        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 8, status: :concluded, next: :chapter_9 })
      end

      def generate_summary
        "Episodio 48_la_verdadera_identidad_de_aoki completado: Al observar la fotografía, Kasuga descubre con estupor que el gobernador de Tokio, Ryo Aoki, es en realidad su antiguo señor, el joven maestro Masato Arakawa. En Tokio, Aoki recibe la llamada de Ogasawara sobre la imprenta clandestina de Geomijul y ordena a la Alianza Omi movilizar tropas para arrasar Yokohama. Fin del Capítulo 8."
      end
    end
  end
end
