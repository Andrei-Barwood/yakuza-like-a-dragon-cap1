# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep89 < IchibanLab::BaseScenario
      protected

      def episode_id
        "89_las_taquillas_del_destino"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { aoki: :brother_to_save, kume: :fanatical_danger },
          belongings: []
        )
        aoki = Character.new(
          id: :ryo_aoki,
          name: "Ryo Aoki",
          attributes: { hp: 20, role: :broken_man },
          relationships: { ichiban: :only_listener },
          belongings: []
        )
        kume = Character.new(
          id: :sota_kume,
          name: "Sota Kume",
          attributes: { role: :crazed_fanatic },
          relationships: { aoki: :fallen_idol },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "kamurocho_streets_pursuit",
          location: "Kamurocho - Calles Principales y Pantallas Gigantes",
          time_period: "2019 - Madrugada",
          money: 26300,
          characters: {
            ichiban: ichiban,
            ryo_aoki: aoki,
            sota_kume: kume
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :legendary_hero_bat,
            :masumi_arakawa_incense
          ],
          flags: {
            ep88_completed: true,
            aoki_escaped_to_streets: true
          }
        )
      end

      def define_scenes
        scene_pursuit = Scene.new(
          id: "kamurocho_streets_pursuit",
          title: "La Huida bajo las Pantallas de la Vergüenza",
          location: "Kamurocho - Theater Square y Bulevar Central"
        )
        scene_pursuit.add_precondition do |state|
          state.flag?(:ep88_completed) && state.flag?(:aoki_escaped_to_streets)
        end

        scene_lockers = Scene.new(
          id: "coin_lockers_redemption",
          title: "El Llanto ante las Taquillas de Monedas",
          location: "Kamurocho - Rincón de las Taquillas de Monedas"
        )
        scene_lockers.add_precondition do |state|
          state.flag?(:coin_lockers_reached)
        end

        scene_tragedy = Scene.new(
          id: "kume_betrayal_tragedy",
          title: "La Puñalada del Fanatismo",
          location: "Kamurocho - Frente a las Taquillas"
        )
        scene_tragedy.add_precondition do |state|
          state.flag?(:aoki_surrender_pledged)
        end

        [scene_pursuit, scene_lockers, scene_tragedy]
      end

      def execute_scenario
        scene_pursuit, scene_lockers, scene_tragedy = define_scenes

        # 1. Persecución por las calles; Aoki ve su propia confesión en las pantallas gigantes
        transition_to(scene_pursuit)
        emit("story.aoki_wander_in_ruins", actor: :ryo_aoki, data: {
          broadcast: "el_video_de_su_orden_criminal_se_reproduce_en_bucle_en_el_jumbotron_de_kamurocho",
          isolation: "los_transeuntes_lo_reconocen_y_lo_senalan_su_imperio_ha_colapsado_por_completo"
        })
        @state.set_flag(:coin_lockers_reached, true)

        # 2. Las taquillas de monedas: el arma, el suicidio frustrado y las lágrimas de Kasuga
        transition_to(scene_lockers, new_location: "Kamurocho - Rincón de las Taquillas de Monedas")
        emit("story.aoki_suicide_attempt", actor: :ryo_aoki, target: :ichiban, data: {
          location: "aoki_llega_a_la_misma_taquilla_donde_fue_abandonado_de_bebe_en_la_nochevieja_de_1977",
          despair: "apunta_el_arma_a_su_propia_cabeza_sintiendo_que_nadie_en_el_mundo_lo_amo_jamas"
        })
        emit("story.kasuga_tearful_plea_brotherhood", actor: :ichiban, target: :ryo_aoki, data: {
          plea: "kasuga_llora_desconsoladamente_suplicandole_que_viva_y_empiece_de_cero_desde_el_fondo",
          reassurance: "le_recuerda_que_arakawa_sawashiro_y_el_mismo_siempre_lo_quisieron_de_verdad"
        })
        emit("story.aoki_relents_and_surrenders_gun", actor: :ryo_aoki, target: :ichiban, data: {
          redemption: "conmovido_hasta_el_alma_aoki_baja_el_arma_y_la_guarda_dentro_de_la_taquilla",
          surrender: "llama_a_su_secretaria_para_anunciar_que_se_entregara_a_la_policia_y_le_agradece_su_servicio"
        })
        @state.set_flag(:aoki_surrender_pledged, true)

        # 3. La tragedia imprevista: Kume aparece y apuñala a Aoki
        transition_to(scene_tragedy, new_location: "Kamurocho - Frente a las Taquillas")
        emit("story.kume_fanatical_assassination", actor: :sota_kume, target: :ryo_aoki, data: {
          betrayal: "sota_kume_fuera_de_si_por_la_hipocresia_de_su_lider_clava_un_cuchillo_en_el_vientre_de_aoki",
          fanaticism: "kume_grita_que_bleach_japan_debe_seguir_pura_antes_de_huir_enloquecido"
        })
        emit("story.kasuga_desperate_embrace", actor: :ichiban, target: :ryo_aoki, data: {
          despair: "kasuga_toma_en_brazos_el_cuerpo_agonizante_de_su_hermano_corriendo_en_busca_de_auxilio",
          tragedy: "el_destino_de_los_bebes_de_las_taquillas_se_cierra_en_un_bano_de_sangre_y_redencion"
        })
        @state.set_flag(:aoki_fatally_stabbed, true)
        @state.set_flag(:ep89_completed, true)
      end

      def generate_summary
        "Episodio 89_las_taquillas_del_destino completado: Malherido y desorientado, Aoki recorre Kamurocho mientras las pantallas gigantes proyectan su condena. Termina ante la misma taquilla de monedas donde Arakawa lo encontró en 1977. Desesperado, se apunta a la cabeza con un revólver; pero Kasuga, entre lágrimas de dolor fraternal, le ruega que elija vivir y empezar de nuevo desde el fondo, recordándole que su padre y él siempre lo quisieron. Aokibrado, guarda el arma en la taquilla y llama a su secretaria para entregarse a la ley. Sin embargo, un enloquecido Sota Kume aparece por la espalda y lo apuñala mortalmente por traicionar el dogma de Bleach Japan. Kasuga sostiene el cuerpo de su hermano en un alarido desgarrador."
      end
    end
  end
end
