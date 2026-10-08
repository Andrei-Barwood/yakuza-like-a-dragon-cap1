# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep78 < IchibanLab::BaseScenario
      protected

      def episode_id
        "78_los_bebes_de_las_taquillas"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { sawashiro: :sworn_enemy_and_mentor, hoshino: :mourned_mentor },
          belongings: []
        )
        sawashiro = Character.new(
          id: :jo_sawashiro,
          name: "Jo Sawashiro",
          attributes: { hp: 100, role: :assassin_and_biological_father },
          relationships: { ichiban: :coin_locker_counterpart, aoki: :biological_son },
          belongings: []
        )
        takabe = Character.new(
          id: :mamoru_takabe,
          name: "Mamoru Takabe",
          attributes: { role: :wounded_captain },
          relationships: { hoshino: :fallen_patriarch },
          belongings: []
        )
        hoshino = Character.new(
          id: :ryuhei_hoshino,
          name: "Ryuhei Hoshino",
          attributes: { role: :deceased_chairman, status: :killed_by_sawashiro },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "seiryu_hq_breach_and_bloodstained_corridors",
          location: "Sede del Clan Seiryu - Pasillos",
          time_period: "2019 - Atardecer",
          money: 26300,
          characters: {
            ichiban: ichiban,
            jo_sawashiro: sawashiro,
            mamoru_takabe: takabe,
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
            ep77_completed: true,
            seiryu_assault_alert_active: true
          }
        )
      end

      def define_scenes
        scene_breach = Scene.new(
          id: "seiryu_hq_breach_and_bloodstained_corridors",
          title: "Incursión en la sede del Seiryu, Takabe herido y avance por pasillos tomados por la Tokyo Omi"
        )
        scene_breach.add_precondition do |state|
          state.flag(:ep77_completed) == true && state.flag(:seiryu_assault_alert_active) == true
        end

        scene_duel = Scene.new(
          id: "hoshino_office_showdown_sawashiro",
          title: "Despacho de Hoshino: hallazgo del cadáver del patriarca y duelo a muerte contra Jo Sawashiro"
        )
        scene_duel.add_precondition do |state|
          state.flag(:seiryu_corridors_cleared) == true
        end

        scene_coin_locker = Scene.new(
          id: "coin_locker_babies_truth_revealed",
          title: "Confesión definitiva de Sawashiro: la verdad de las taquillas de 1977, Masato Arakawa y los orígenes de Kasuga"
        )
        scene_coin_locker.add_precondition do |state|
          state.flag(:sawashiro_duel_resolved) == true
        end

        [scene_breach, scene_duel, scene_coin_locker]
      end

      def execute_scenario
        scene_breach, scene_duel, scene_coin_locker = define_scenes

        # 1. Asalto y pasillos del Clan Seiryu
        scene_breach.check_preconditions!(@state)

        # Asegurar personajes requeridos para la escena
        unless @state.has_character?(:mamoru_takabe)
          @state.add_character(Character.new(id: :mamoru_takabe, name: "Mamoru Takabe", attributes: { role: :wounded_captain }, relationships: {}, belongings: []))
        end
        unless @state.has_character?(:ryuhei_hoshino)
          @state.add_character(Character.new(id: :ryuhei_hoshino, name: "Ryuhei Hoshino", attributes: { role: :deceased_chairman, status: :killed_by_sawashiro }, relationships: {}, belongings: []))
        end
        unless @state.has_character?(:jo_sawashiro)
          @state.add_character(Character.new(id: :jo_sawashiro, name: "Jo Sawashiro", attributes: { hp: 100, role: :assassin_and_biological_father }, relationships: {}, belongings: []))
        end

        emit("story.seiryu_hq_invasion_found", actor: :ichiban, target: :mamoru_takabe, data: {
          takabe_status: "herido_tras_enfrentar_a_la_tokyo_omi",
          corridors: "el_grupo_barre_a_los_sicarios_de_la_omi_camino_al_despacho"
        })
        emit("story.combat_resolved", actor: :ichiban, target: :tokyo_omi_invaders, data: { result: :invaders_crushed })
        @state.set_flag(:seiryu_corridors_cleared, true)

        # 2. Despacho de Hoshino: el cuerpo sin vida y combate contra Sawashiro
        transition_to(scene_duel, new_location: "Sede del Clan Seiryu - Despacho del Presidente")
        emit("story.hoshino_assassinated_by_sawashiro", actor: :jo_sawashiro, target: :ryuhei_hoshino, data: {
          motive: "orden_directa_de_aoki_por_el_apoyo_de_los_tres_de_ijin_a_la_campana_de_kasuga"
        })
        @state.character(:ryuhei_hoshino).attributes[:status] = :deceased
        emit("story.combat_resolved", actor: :ichiban, target: :jo_sawashiro, data: {
          result: :sawashiro_defeated_in_brutal_duel
        })
        @state.character(:jo_sawashiro).attributes[:hp] = 10
        @state.set_flag(:sawashiro_duel_resolved, true)

        # 3. La revelación suprema: Los bebés de las taquillas (Coin Locker Babies)
        transition_to(scene_coin_locker)
        emit("story.coin_locker_babies_confession", actor: :jo_sawashiro, target: :ichiban, data: {
          refusal_to_kill_arakawa: "sawashiro_rechazo_la_orden_de_aoki_de_matar_a_arakawa",
          biological_truth: "masato_arakawa_es_en_realidad_el_hijo_biologico_de_sawashiro_abandonado_en_la_taquilla",
          kasuga_lineage: "kasuga_es_el_hijo_biologico_de_masumi_arakawa_y_akane_rescatado_por_jiro_kasuga",
          intentional_leak: "sawashiro_filtro_su_propia_orden_a_geomijul_para_que_kasuga_lo_detuviera"
        })
        @state.set_flag(:sawashiro_secret_revealed, true)
        @state.set_flag(:biological_truth_unveiled, true)
        @state.set_flag(:chapter_13_completed, true)

        # Frontera y transición al Capítulo 14
        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 13, status: :concluded, next: :chapter_14 })
      end

      def generate_summary
        "Episodio 78_los_bebes_de_las_taquillas completado: Kasuga y su equipo asaltan la sede del Clan Seiryu encontrando a Takabe herido. Al llegar al despacho del presidente, descubren a Ryuhei Hoshino ejecutado por Jo Sawashiro bajo órdenes de Aoki. Tras un extenuante duelo cuerpo a cuerpo, Sawashiro cae derrotado y desvela la verdad de Nochevieja de 1977: Masato Arakawa (Ryo Aoki) es en realidad el hijo biológico de Sawashiro que Masumi rescató creyéndolo suyo; mientras que Ichiban Kasuga es el verdadero hijo biológico de Masumi Arakawa y Akane, extraído de la taquilla vecina por Jiro Kasuga. Fin del Capítulo 13."
      end
    end
  end
end
