# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep75 < IchibanLab::BaseScenario
      protected

      def episode_id
        "75_la_candidatura_inesperada"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :political_candidate_aspirant },
          relationships: { kume: :political_opponent, hoshino: :benefactor },
          belongings: []
        )
        han = Character.new(
          id: :joon_gi_han,
          name: "Joon-gi Han",
          attributes: { role: :intelligence_operative },
          relationships: { ichiban: :advisor },
          belongings: []
        )
        hoshino = Character.new(
          id: :ryuhei_hoshino,
          name: "Ryuhei Hoshino",
          attributes: { role: :seiryu_chairman },
          relationships: { ichiban: :political_sponsor },
          belongings: []
        )
        kume = Character.new(
          id: :sota_kume,
          name: "Sota Kume",
          attributes: { role: :bleach_japan_representative_candidate },
          relationships: { aoki: :puppet_master },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "isezaki_road_kume_speech_confrontation",
          location: "Isezaki Road - Yokohama",
          time_period: "2019 - Día",
          money: 26300,
          characters: {
            ichiban: ichiban,
            joon_gi_han: han,
            ryuhei_hoshino: hoshino,
            sota_kume: kume
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
            ep74_completed: true
          }
        )
      end

      def define_scenes
        scene_isezaki = Scene.new(
          id: "isezaki_road_kume_speech_confrontation",
          title: "Kasuga intenta acercarse al mitin de Kume en Isezaki Road y choca contra los matones de la Omi"
        )
        scene_isezaki.add_precondition do |state|
          state.flag(:ep74_completed) == true
        end

        scene_hoshino_strategy = Scene.new(
          id: "seaside_three_million_candidacy_deal",
          title: "Junto a la costa, Hoshino devuelve 3 millones de yenes y propone que Kasuga compita electoralmente contra Kume"
        )
        scene_hoshino_strategy.add_precondition do |state|
          state.flag(:kume_security_skirmish_won) == true
        end

        scene_registration = Scene.new(
          id: "nishihama_building_registration_deadline",
          title: "Carrera contrarreloj hacia el edificio Nishihama para registrar la candidatura antes del cierre"
        )
        scene_registration.add_precondition do |state|
          state.flag(:deposit_money_received) == true
        end

        [scene_isezaki, scene_hoshino_strategy, scene_registration]
      end

      def execute_scenario
        scene_isezaki, scene_hoshino_strategy, scene_registration = define_scenes

        # 1. En Isezaki Road, mitin de Kume custodiado por la Omi
        scene_isezaki.check_preconditions!(@state)
        emit("story.kume_rally_omi_blockade", actor: :ichiban, target: :sota_kume, data: {
          location: "Isezaki Road",
          blockade: "la_omi_impide_a_ciudadanos_acercarse_y_tienen_fichado_a_kasuga"
        })
        emit("story.combat_resolved", actor: :ichiban, target: :tokyo_omi_guards, data: { result: :guards_defeated })
        @state.set_flag(:kume_security_skirmish_won, true)

        # 2. Encuentro con Hoshino junto a la costa: estrategia electoral y devolución de los 3 millones
        transition_to(scene_hoshino_strategy, new_location: "Costa de Yokohama", new_time: "2019 - Tarde")
        @state.money += 3_000_000
        emit("story.item_acquired", actor: :ichiban, data: { item: :campaign_deposit_3m_yen })
        emit("story.election_run_proposed", actor: :ryuhei_hoshino, target: :ichiban, data: {
          district: "distrito_2_de_kanagawa",
          rule: "los_candidatos_electorales_estan_obligados_por_etiqueta_publica_a_saludarse_con_un_apreton_de_manos",
          immunity: "kume_no_podra_rechazar_acercarse_a_kasuga_frente_a_las_camaras"
        })
        @state.set_flag(:deposit_money_received, true)

        # 3. Inscripción contrarreloj en el Nishihama Building
        transition_to(scene_registration, new_location: "Edificio Nishihama - Oficina Electoral", new_time: "2019 - 17:00")
        @state.money -= 3_000_000 # Depósito oficial de garantía electoral
        emit("story.candidacy_officially_registered", actor: :ichiban, data: {
          candidate_name: "Ichiban Kasuga",
          district: "Kanagawa 2nd District",
          legal_status: "pena_cumplida_plenos_derechos_civiles"
        })
        @state.set_flag(:kasuga_candidacy_active, true)
        @state.set_flag(:ep75_completed, true)
      end

      def generate_summary
        "Episodio 75_la_candidatura_inesperada completado: Kasuga intenta abordar a Kume en Isezaki Road para llegar hasta Aoki, pero los sicarios de la Omi le cortan el paso. En la costa, Hoshino le reintegra los 3 millones de yenes de depósito y plantea una audaz jugada política: Kasuga se postulará como candidato por el 2º Distrito de Kanagawa, forzando a Kume a darle la mano en público por protocolo electoral. En una carrera contra el reloj, registran la candidatura en el edificio Nishihama antes del cierre oficial."
      end
    end
  end
end
