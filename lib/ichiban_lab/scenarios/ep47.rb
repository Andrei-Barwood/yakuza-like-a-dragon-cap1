# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep47 < IchibanLab::BaseScenario
      protected

      def episode_id
        "47_la_huida_de_nanba"
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
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :fugitive },
          relationships: { ichiban: :parted_ways },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "nanba_departure_scene",
          location: "Edificio Hakuryo - Salida Trasera",
          time_period: "2019 - Mediodía",
          money: 26300,
          characters: { ichiban: ichiban, adachi: adachi, saeko: saeko, nanba: nanba },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample, :shoichi_investigative_notes],
          flags: { mabuchi_defeated: true, omi_invasion_alert_active: true }
        )
      end

      def execute_scenario
        scene_departure = Scene.new(
          id: :nanba_departure_scene,
          title: "La dolorosa separación de Nanba",
          location: "Edificio Hakuryo - Salida Trasera"
        )
        scene_departure.add_precondition("Mabuchi debe haber sido vencido y la conspiración descubierta") do |ws|
          ws.flag?(:mabuchi_defeated)
        end

        scene_office_search = Scene.new(
          id: :bleach_japan_office_search,
          title: "Registro de la oficina de Bleach Japan",
          location: "Edificio Hakuryo - Archivos de Dirección"
        )

        scene_newspaper = Scene.new(
          id: :founder_photo_discovery,
          title: "El recorte de prensa de los fundadores",
          location: "Edificio Hakuryo - Archivos de Dirección"
        )

        # 1. Nanba decide continuar su búsqueda en solitario y aparta al grupo
        scene_departure.check_preconditions!(@state)
        transition_to(scene_departure)
        emit("story.ogasawara_flight_reported", actor: :nanba, data: { status: "ogasawara_escapo_por_la_puerta_trasera" })
        emit("story.party_departure", actor: :nanba, target: :ichiban, data: { plea: "no_se_entrometan_mas_debo_encontrar_a_mi_hermano_shoichi", status: "nanba_rescata_a_mabuchi_y_se_marcha" })
        @state.set_flag(:nanba_left_party, true)

        # 2. El grupo investiga la oficina vacía de Bleach Japan
        transition_to(scene_office_search, new_location: "Edificio Hakuryo - Archivos de Dirección")
        emit("story.office_search_initiated", actor: :saeko, data: { objective: "encontrar_documentos_sobre_ogasawara" })

        # 3. Descubrimiento de la fotografía fundacional de Bleach Japan
        transition_to(scene_newspaper)
        emit("story.founders_photograph_found", actor: :ichiban, data: { founders: ["Hajime Ogasawara", "Ryo Aoki"] })
        @state.add_item(:bleach_japan_founders_clipping)
        @state.set_flag(:founders_clipping_found, true)
      end

      def generate_summary
        "Episodio 47_la_huida_de_nanba completado: Tras constatar la fuga de Ogasawara, Nanba pide a Ichiban que deje de interferir y huye cargando con Mabuchi para dar con el paradero de su hermano. En la oficina desierta de Bleach Japan, Kasuga halla un recorte periodístico con la foto de los fundadores: Hajime Ogasawara y Ryo Aoki."
      end
    end
  end
end
