# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep61 < IchibanLab::BaseScenario
      protected

      def episode_id
        "61_el_ascenso_de_aoki"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { adachi: :brother_in_arms, saeko: :protectee, nanba: :sworn_brother, joon_gi_han: :ally, zhao: :ally },
          belongings: []
        )
        zhao = Character.new(
          id: :zhao,
          name: "Tianyou Zhao",
          attributes: { role: :ex_liumang_leader, party_member: true },
          relationships: { ichiban: :ally },
          belongings: []
        )
        han = Character.new(
          id: :joon_gi_han,
          name: "Joon-gi Han",
          attributes: { role: :geomijul_hitman, party_member: true },
          relationships: { ichiban: :ally },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "political_broadcast_and_survive_reunion",
          location: "Survive Bar - Sala Principal",
          time_period: "2019 - Mañana",
          money: 26300,
          characters: {
            ichiban: ichiban,
            zhao: zhao,
            joon_gi_han: han
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
            chapter_10_completed: true,
            arakawa_protection_confirmed: true,
            faith_in_arakawa_restored: true
          }
        )
      end

      def execute_scenario
        scene_broadcast = Scene.new(
          id: :political_broadcast_and_survive_reunion,
          title: "Transmisión política: renuncia de Ogikubo y ascenso de Ryo Aoki",
          location: "Survive Bar - Sala Principal"
        )
        scene_broadcast.add_precondition("El grupo debe haber completado el Capítulo 10") do |ws|
          ws.flag?(:chapter_10_completed)
        end

        scene_welcome = Scene.new(
          id: :zhao_and_han_welcomed_to_party,
          title: "Bienvenida formal de Tianyou Zhao y Joon-gi Han en Survive Bar",
          location: "Survive Bar - Segunda Planta"
        )

        scene_martyrdom = Scene.new(
          id: :ogasawara_martyrdom_and_bleach_surge,
          title: "El martirio de Ogasawara y la popularidad de Bleach Japan",
          location: "Survive Bar - Segunda Planta"
        )

        # 1. Noticiero: retiro forzado de Ogikubo, disolución del parlamento y ascenso de Aoki a presidente del CLP
        scene_broadcast.check_preconditions!(@state)
        transition_to(scene_broadcast)
        emit("story.political_broadcast_aired", actor: :ryo_aoki, data: { news: "ogikubo_retirado_por_enfermedad_aoki_presidente_clp", purge_target: "ijincho_zona_gris" })
        @state.set_flag(:aoki_political_ascension_known, true)

        # 2. Zhao y Han formalmente integrados en el búnker de Survive Bar
        transition_to(scene_welcome)
        emit("story.party_members_formalized", actor: :ichiban, data: { new_permanent_members: [:zhao, :joon_gi_han], status: "gran_muro_colapsado_enemigos_fuertes_en_las_calles" })
        @state.set_flag(:zhao_and_han_integrated, true)

        # 3. Se confirma que Bleach Japan capitalizó el incendio y Ogasawara fue convertido en mártir
        transition_to(scene_martyrdom)
        emit("story.ogasawara_martyrdom_analyzed", actor: :zhao, data: { cover_story: "murio_en_incendio_de_geomijul_victima_inocente", reality: "asesinado_en_secreto_por_la_omi_para_crear_un_martir" })
        @state.set_flag(:ogasawara_martyr_conspiracy_uncovered, true)
        @state.set_flag(:waiting_for_hamako_contact, true)
      end

      def generate_summary
        "Episodio 61_el_ascenso_de_aoki completado: Las noticias anuncian el ascenso de Ryo Aoki como presidente del CLP tras el retiro forzado de Ogikubo. En Survive Bar, Zhao y Han se suman permanentemente al grupo. Se descubre que Bleach Japan manipuló el incendio de Geomijul convirtiendo la muerte de Ogasawara en una estratagema para martirizarlo."
      end
    end
  end
end
