# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep54 < IchibanLab::BaseScenario
      protected

      def episode_id
        "54_el_sacrificio_de_geomijul"
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
        ishioda = Character.new(
          id: :reiji_ishioda,
          name: "Reiji Ishioda",
          attributes: { role: :omi_lieutenant, hp: 600 },
          relationships: {},
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :reluctant_combatant },
          relationships: { ichiban: :conflicted },
          belongings: []
        )
        ogasawara = Character.new(
          id: :hajime_ogasawara,
          name: "Hajime Ogasawara",
          attributes: { role: :bleach_japan_director },
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
        han = Character.new(
          id: :joon_gi_han,
          name: "Joon-gi Han",
          attributes: { role: :geomijul_lieutenant },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "printer_room_confrontation",
          location: "Base Central de Geomijul - Sala de la Imprenta",
          time_period: "2019 - Tarde",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
            reiji_ishioda: ishioda,
            nanba: nanba,
            hajime_ogasawara: ogasawara,
            seonhee: seonhee,
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
            geomijul_scorched_earth_active: true
          }
        )
      end

      def execute_scenario
        scene_standoff = Scene.new(
          id: :printer_room_confrontation,
          title: "Confrontación en la sala de la imprenta en llamas",
          location: "Base Central de Geomijul - Sala de la Imprenta"
        )
        scene_standoff.add_precondition("El plan de quema y retención de Geomijul debe estar activo") do |ws|
          ws.flag?(:geomijul_scorched_earth_active)
        end

        scene_clash = Scene.new(
          id: :grand_clash_against_ishioda_and_nanba,
          title: "Gran batalla campal contra Ishioda y Nanba",
          location: "Base Central de Geomijul - Sala de la Imprenta"
        )

        scene_capture = Scene.new(
          id: :ogasawara_capture_and_reconciliation,
          title: "Captura de Ogasawara, verdad de Shoichi y traslado al campamento",
          location: "Campamento de Indigentes - Orilla del Río"
        )

        # 1. Los invasores irrumpen en la sala de impresión mientras arden las máquinas
        scene_standoff.check_preconditions!(@state)
        transition_to(scene_standoff)
        emit("story.intruders_arrival", actor: :reiji_ishioda, target: :ichiban, data: { status: "perplejidad_por_la_supervivencia_de_kasuga" })
        emit("story.fire_noticed", actor: :hajime_ogasawara, data: { alert: "las_pruebas_y_maquinas_estan_ardiendo" })

        # 2. Batalla contra Ishioda, matones de la Omi y Nanba
        transition_to(scene_clash)
        emit("story.epic_clash_resolved", actor: :ichiban, target: :reiji_ishioda, data: { victory: true, enemies_repelled: "fuerzas_de_la_omi_desalojadas" })
        @state.set_flag(:omi_raid_repelled, true)

        # 3. Captura de Ogasawara, revelación de que Shoichi está con vida y traslado seguro
        transition_to(scene_capture, new_location: "Campamento de Indigentes - Orilla del Río", new_time: "2019 - Atardecer")
        emit("story.ogasawara_captured", actor: :joon_gi_han, target: :hajime_ogasawara, data: { captive: "director_de_bleach_japan" })
        emit("story.brother_safety_revealed", actor: :seonhee, target: :nanba, data: { revelation: "shoichi_nanba_sigue_vivo_bajo_custodia_segura" })
        @state.set_flag(:shoichi_confirmed_alive, true)
        @state.set_flag(:chapter_9_completed, true)

        # Cierre y frontera del Capítulo 9
        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 9, status: :concluded, next: :chapter_10 })
      end

      def generate_summary
        "Episodio 54_el_sacrificio_de_geomijul completado: Con la imprenta ardiendo a sus espaldas, Kasuga resiste la embestida de Ishioda, la Omi y Nanba en una desesperada batalla. Tras repeler a los invasores, Seonhee y Joon-gi capturan a Ogasawara y le revelan a Nanba que su hermano Shoichi sigue con vida. El grupo traslada al prisionero al campamento de indigentes. Fin del Capítulo 9."
      end
    end
  end
end
