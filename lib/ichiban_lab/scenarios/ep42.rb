# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep42 < IchibanLab::BaseScenario
      protected

      def episode_id
        "42_la_cumbre_de_los_tres"
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
          scene_id: "nanba_laptop_investigation",
          location: "Campamento de Indigentes - Chabola de Nanba",
          time_period: "2019 - 01:30 AM",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
            tianyou_zhao: zhao,
            seonhee: seonhee,
            ryuhei_hoshino: hoshino
          },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample],
          flags: { heian_tower_summons_active: true, nanba_rescued_and_fled: true }
        )
      end

      def execute_scenario
        scene_laptop = Scene.new(
          id: :nanba_laptop_investigation,
          title: "El ordenador de Nanba y el informe sobre Ogikubo",
          location: "Campamento de Indigentes - Chabola de Nanba"
        )
        scene_laptop.add_precondition("La cita de Heian Tower debe estar activa") do |ws|
          ws.flag?(:heian_tower_summons_active)
        end

        scene_tower = Scene.new(
          id: :heian_tower_arrival,
          title: "Llegada a Heian Tower a las 2 AM",
          location: "Heian Tower - Mirador Panorámico"
        )

        scene_summit = Scene.new(
          id: :ijin_three_summit_revelation,
          title: "La cumbre de los Tres de Ijin y el muro de la ciudad",
          location: "Heian Tower - Mirador Panorámico"
        )

        # 1. Búsqueda en el campamento: hallazgo del portátil y artículo periodístico sobre Yutaka Ogikubo
        scene_laptop.check_preconditions!(@state)
        transition_to(scene_laptop)
        emit("story.laptop_uncovered", actor: :ichiban, data: { item: "portatil_de_nanba", location: "chabola_del_campamento" })
        emit("story.political_conspiracy_revealed", actor: :saeko, data: { journalist: "Shoichi Akiba", politician: "Yutaka Ogikubo (Presidente del CLP)", scandal: "trama_de_dinero_falso_de_50_años_en_yokohama" })
        @state.add_item(:shoichi_investigative_notes)
        @state.set_flag(:ogikubo_conspiracy_revealed, true)

        # 2. Llegada a Heian Tower en la madrugada
        transition_to(scene_tower, new_location: "Heian Tower - Mirador Panorámico", new_time: "2019 - 02:00 AM")
        emit("story.arrival_at_summit", actor: :ichiban, data: { destination: "Heian Tower", time: "02:00 AM" })

        # 3. Audiencia cumbre con los tres líderes: Zhao, Seonhee y Hoshino reunidos
        transition_to(scene_summit)
        emit("story.triumvirate_assembled", actor: :ryuhei_hoshino, data: { leaders: [:tianyou_zhao, :seonhee, :ryuhei_hoshino], purpose: "revelar_el_pacto_del_gran_muro_del_musculo" })
        emit("story.ijin_three_alliance_confirmed", actor: :tianyou_zhao, data: { alliance: "Yokohama Liumang, Geomijul y Clan Seiryu unidos para proteger el secreto de Yokohama" })
        @state.set_flag(:ijin_three_summit_concluded, true)
        @state.set_flag(:chapter_7_completed, true)

        # Cierre y frontera del Capítulo 7
        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 7, status: :concluded, next: :chapter_8 })
      end

      def generate_summary
        "Episodio 42_la_cumbre_de_los_tres completado: El grupo examina el portátil de Nanba y descubre la investigación de su hermano vinculando el dinero falso al político Yutaka Ogikubo. A las 2 AM en Heian Tower, Kasuga es recibido conjuntamente por Tianyou Zhao, Seonhee y Ryuhei Hoshino, revelándose la verdad detrás de los Tres de Ijin y el Gran Muro del Músculo. Fin del Capítulo 7."
      end
    end
  end
end
