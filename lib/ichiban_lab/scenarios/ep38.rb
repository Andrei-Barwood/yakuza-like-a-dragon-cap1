# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep38 < IchibanLab::BaseScenario
      protected

      def episode_id
        "38_la_fortaleza_electrica"
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
        han = Character.new(
          id: :joon_gi_han,
          name: "Joon-gi Han",
          attributes: { role: :geomijul_lieutenant, hp: 450 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "cable_crossing_and_ambush",
          location: "Fortaleza de Geomijul - Entresuelo de Cables Eléctricos",
          time_period: "2019 - Noche",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, joon_gi_han: han },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample],
          flags: { geomijul_entrance_reached: true }
        )
      end

      def execute_scenario
        scene_cables = Scene.new(
          id: :cable_crossing_and_ambush,
          title: "Cruce de cables de alta tensión y emboscada",
          location: "Fortaleza de Geomijul - Entresuelo de Cables Eléctricos"
        )
        scene_cables.add_precondition("El grupo debe haber ingresado al edificio de Geomijul") do |ws|
          ws.flag?(:geomijul_entrance_reached)
        end

        scene_welcome = Scene.new(
          id: :joon_gi_han_revelation,
          title: "Bienvenida y revelación de Joon-gi Han",
          location: "Fortaleza de Geomijul - Centro de Control"
        )

        scene_surveillance = Scene.new(
          id: :panoptic_surveillance_and_mabuchi_tape,
          title: "La red de vigilancia y el video de Otohime Land",
          location: "Fortaleza de Geomijul - Sala de Monitores"
        )

        # 1. Caminar entre cables eléctricos y superar la emboscada
        scene_cables.check_preconditions!(@state)
        transition_to(scene_cables)
        emit("story.electrical_network_traversal", actor: :ichiban, data: { hazard: "cables_alta_tension", status: "acceso_bloqueado_superado" })
        emit("story.combat_resolved", actor: :ichiban, target: :geomijul_operatives, data: { victory: true, condition: "prueba_de_fuerza_superada" })

        # 2. Encuentro con su salvador subterráneo: Joon-gi Han
        transition_to(scene_welcome, new_location: "Fortaleza de Geomijul - Centro de Control")
        emit("story.identity_revealed", actor: :joon_gi_han, target: :ichiban, data: { role: "salvador_misterioso_de_los_tuneles", organization: "Geomijul" })
        emit("story.power_theft_explained", actor: :adachi, data: { deduction: "el_robo_electrico_en_ijincho_alimenta_el_centro_de_inteligencia" })
        @state.set_flag(:han_identity_confirmed, true)

        # 3. La cinta de seguridad incriminatoria contra Mabuchi
        transition_to(scene_surveillance, new_location: "Fortaleza de Geomijul - Sala de Monitores")
        emit("story.incriminating_footage_viewed", actor: :joon_gi_han, target: :ichiban, data: { footage: "mabuchi_entrando_a_otohime_land_antes_de_la_muerte_de_nonomiya", proof: :solid })
        @state.set_flag(:mabuchi_murder_footage_confirmed, true)
      end

      def generate_summary
        "Episodio 38_la_fortaleza_electrica completado: El grupo sortea puentes de cables eléctricos y emboscadas para llegar al centro neurálgico de Geomijul. Son recibidos por su salvador anónimo de los túneles, Joon-gi Han, quien les muestra las grabaciones de seguridad que demuestran la culpabilidad directa de Mabuchi en el asesinato de Nonomiya."
      end
    end
  end
end
