# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep46 < IchibanLab::BaseScenario
      protected

      def episode_id
        "46_la_caida_de_mabuchi"
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
          relationships: { ichiban: :sworn_partner },
          belongings: []
        )
        mabuchi = Character.new(
          id: :akira_mabuchi,
          name: "Akira Mabuchi",
          attributes: { role: :liumang_conspirator, hp: 550 },
          relationships: {},
          belongings: []
        )
        ogasawara = Character.new(
          id: :hajime_ogasawara,
          name: "Hajime Ogasawara",
          attributes: { role: :bleach_japan_director },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "ogasawara_office_confrontation",
          location: "Edificio Hakuryo - Despacho del Director de Bleach Japan",
          time_period: "2019 - Mañana",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
            nanba: nanba,
            akira_mabuchi: mabuchi,
            hajime_ogasawara: ogasawara
          },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample, :shoichi_investigative_notes],
          flags: { bleach_japan_office_reached: true }
        )
      end

      def execute_scenario
        scene_office = Scene.new(
          id: :ogasawara_office_confrontation,
          title: "Confrontación en el despacho de Ogasawara",
          location: "Edificio Hakuryo - Despacho del Director de Bleach Japan"
        )
        scene_office.add_precondition("La oficina de Bleach Japan debe haber sido alcanzada") do |ws|
          ws.flag?(:bleach_japan_office_reached)
        end

        scene_boss = Scene.new(
          id: :mabuchi_boss_showdown,
          title: "Duelo final contra Akira Mabuchi",
          location: "Edificio Hakuryo - Despacho del Director de Bleach Japan"
        )

        scene_confession = Scene.new(
          id: :mabuchi_fall_and_conspiracy_confession,
          title: "La caída de Mabuchi y la confesión del asesinato",
          location: "Edificio Hakuryo - Despacho del Director de Bleach Japan"
        )

        # 1. Encuentro con Kume, Nanba y Hajime Ogasawara
        scene_office.check_preconditions!(@state)
        transition_to(scene_office)
        emit("story.reunion_in_office", actor: :ichiban, target: :nanba, data: { status: "nanba_refugiado_en_bleach_japan" })
        emit("story.underworld_intel_shared", actor: :ichiban, target: :hajime_ogasawara, data: { warning: "liumang_y_seiryu_buscan_a_nanba_por_el_dinero_falso" })

        # 2. Ogasawara invoca a Mabuchi y combate decisivo de jefe
        transition_to(scene_boss)
        emit("story.conspirator_summons", actor: :hajime_ogasawara, target: :akira_mabuchi, data: { alliance: "mabuchi_opera_secretamente_con_ogasawara" })
        emit("story.boss_defeated", actor: :ichiban, target: :akira_mabuchi, data: { victory: true, condition: "mabuchi_derrotado_definitivamente" })
        @state.set_flag(:mabuchi_defeated, true)

        # 3. Mabuchi confiesa que Ogasawara ordenó matar a Nonomiya y el respaldo de la Alianza Omi
        transition_to(scene_confession)
        emit("story.nonomiya_killer_revealed", actor: :akira_mabuchi, data: { instigator: "Hajime Ogasawara", motive: "provocar_al_ijin_three_para_hallar_los_fondos_de_ogikubo" })
        emit("story.omi_invasion_revealed", actor: :akira_mabuchi, data: { threat: "la_alianza_omi_invadira_yokohama_manana", plan: "vender_ijincho_para_ascender_como_arakawa" })
        @state.set_flag(:omi_invasion_alert_active, true)
      end

      def generate_summary
        "Episodio 46_la_caida_de_mabuchi completado: En el despacho de Bleach Japan, Ogasawara llama a Akira Mabuchi para silenciar al grupo. Tras una encarnizada batalla de jefe, Mabuchi cae derrotado y confiesa que el asesinato de Nonomiya fue ordenado por Ogasawara para quebrar a las tres mafias con el respaldo inminente de la Alianza Omi."
      end
    end
  end
end
