# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep77 < IchibanLab::BaseScenario
      protected

      def episode_id
        "77_el_apreton_de_manos_en_jinnai"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :candidate },
          relationships: { kume: :forced_counterpart, han: :intelligence_partner },
          belongings: []
        )
        kume = Character.new(
          id: :sota_kume,
          name: "Sota Kume",
          attributes: { role: :shaken_candidate },
          relationships: { ichiban: :nemesis },
          belongings: []
        )
        han = Character.new(
          id: :joon_gi_han,
          name: "Joon-gi Han",
          attributes: { role: :intelligence_operative },
          relationships: { ichiban: :protector },
          belongings: []
        )
        hoshino = Character.new(
          id: :ryuhei_hoshino,
          name: "Ryuhei Hoshino",
          attributes: { role: :targeted_chairman },
          relationships: { ichiban: :mentor },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "jinnai_station_approach_on_foot",
          location: "Estación de Jinnai - Yokohama",
          time_period: "2019 - Tarde",
          money: 26300,
          characters: {
            ichiban: ichiban,
            sota_kume: kume,
            joon_gi_han: han,
            ryuhei_hoshino: hoshino
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :seiryu_crest,
            :raw_pork_buns,
            :zhao_cooking_recipe,
            :survive_bar_master_cup,
            :hamako_warm_handkerchief,
            :commemorative_photo_osaka
          ],
          flags: {
            ep76_completed: true,
            sawashiro_ultimatum_issued: true
          }
        )
      end

      def define_scenes
        scene_jinnai = Scene.new(
          id: "jinnai_station_approach_on_foot",
          title: "Aproximación a pie a la Estación de Jinnai para evitar que Kume escape en furgoneta"
        )
        scene_jinnai.add_precondition do |state|
          state.flag(:ep76_completed) == true && state.flag(:sawashiro_ultimatum_issued) == true
        end

        scene_handshake = Scene.new(
          id: "protocol_handshake_and_omi_brawl",
          title: "Desmantelamiento de los sicarios de la Omi y forzado apretón de manos público frente a la prensa"
        )
        scene_handshake.add_precondition do |state|
          state.flag(:jinnai_perimeter_reached) == true
        end

        scene_alert = Scene.new(
          id: "geomijul_emergency_tipoff_seiryu_hq",
          title: "Joon-gi Han recibe alerta roja de Geomijul: la sede del Clan Seiryu está bajo ataque y Hoshino en peligro"
        )
        scene_alert.add_precondition do |state|
          state.flag(:public_handshake_completed) == true
        end

        [scene_jinnai, scene_handshake, scene_alert]
      end

      def execute_scenario
        scene_jinnai, scene_handshake, scene_alert = define_scenes

        # 1. Acercamiento a pie a Jinnai Station
        scene_jinnai.check_preconditions!(@state)
        emit("story.jinnai_foot_patrol_approach", actor: :ichiban, target: :sota_kume, data: {
          strategy: "acercamiento_a_pie_para_no_alertar_al_convoy_de_kume"
        })
        @state.set_flag(:jinnai_perimeter_reached, true)

        # 2. Combate contra sicarios de la Tokyo Omi y apretón de manos protocolar
        transition_to(scene_handshake)
        emit("story.combat_resolved", actor: :ichiban, target: :tokyo_omi_station_guards, data: { result: :guards_neutralized })
        emit("story.forced_election_handshake", actor: :ichiban, target: :sota_kume, data: {
          handshake: "kume_obligado_a_estrechar_la_mano_frente_a_reporteros_y_camaras",
          publicity: "impacto_positivo_masivo_para_la_campana_de_kasuga"
        })
        @state.set_flag(:public_handshake_completed, true)

        # 3. Aviso de emergencia de Joon-gi Han
        transition_to(scene_alert)
        emit("story.geomijul_alert_hoshino_targeted", actor: :joon_gi_han, target: :ichiban, data: {
          intel: "la_tokyo_omi_ha_asaltado_la_sede_del_clan_seiryu",
          danger: "la_vida_de_hoshino_corre_inminente_peligro_en_su_despacho"
        })
        @state.set_flag(:seiryu_assault_alert_active, true)
        @state.set_flag(:ep77_completed, true)
      end

      def generate_summary
        "Episodio 77_el_apreton_de_manos_en_jinnai completado: Para evitar que Kume escape al verlos venir, el grupo se acerca a pie a la Estación de Jinnai. Tras neutralizar a una escuadra encubierta de la Tokyo Omi, Kasuga acorrala diplomáticamente a Kume frente a la prensa y lo fuerza al apretón de manos protocolar. Justo cuando Kasuga intentaba interrogarlo en privado, Joon-gi Han recibe una alerta urgente de Geomijul: la Omi ha asaltado el cuartel del Clan Seiryu para ejecutar al patriarca Hoshino."
      end
    end
  end
end
