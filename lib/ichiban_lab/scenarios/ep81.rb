# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep81 < IchibanLab::BaseScenario
      protected

      def episode_id
        "81_el_hilo_de_la_conspiracion"
      end

      def main_actor
        :ryo_aoki
      end

      def default_initial_state
        aoki = Character.new(
          id: :ryo_aoki,
          name: "Ryo Aoki (Gobernador de Tokio)",
          attributes: { role: :political_mastermind, status: :ruthless_governor },
          relationships: { horinouchi: :blackmailed_puppet, ishioda: :expendable_pawn },
          belongings: []
        )
        horinouchi = Character.new(
          id: :juro_horinouchi,
          name: "Juro Horinouchi",
          attributes: { role: :police_commissioner },
          relationships: { aoki: :coerced_associate },
          belongings: []
        )
        ishioda = Character.new(
          id: :akira_ishioda,
          name: "Reiji Ishioda",
          attributes: { role: :tokyo_omi_lieutenant },
          relationships: { aoki: :ambitious_enforcer },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "governors_office_horinouchi_audience",
          location: "Despacho del Gobernador de Tokio",
          time_period: "2019 - Tarde",
          money: 26300,
          characters: {
            ryo_aoki: aoki,
            juro_horinouchi: horinouchi,
            akira_ishioda: ishioda
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
            ep80_completed: true,
            geomijul_meeting_scheduled: true
          }
        )
      end

      def define_scenes
        scene_horinouchi = Scene.new(
          id: :governors_office_horinouchi_audience,
          title: "Aoki se desliga de la muerte de Hoshino inculpando a Sawashiro y somete a Horinouchi",
          location: "Despacho del Gobernador de Tokio"
        )
        scene_horinouchi.add_precondition("Ep80 debe haber finalizado") do |ws|
          ws.flag?(:ep80_completed)
        end

        scene_ishioda_deal = Scene.new(
          id: :ishioda_campaign_security_and_pawn_promotion,
          title: "Ishioda solicita escolta para Kume y Aoki promete el liderazgo de la Tokyo Omi",
          location: "Despacho del Gobernador de Tokio"
        )
        scene_ishioda_deal.add_precondition("Horinouchi debe haber sido despachado") do |ws|
          ws.flag?(:horinouchi_subjugated)
        end

        [scene_horinouchi, scene_ishioda_deal]
      end

      def execute_scenario
        scene_horinouchi, scene_ishioda_deal = define_scenes

        # 1. Audiencia con el Comisionado Horinouchi
        scene_horinouchi.check_preconditions!(@state)
        emit("story.aoki_blames_sawashiro_for_hoshino", actor: :ryo_aoki, target: :juro_horinouchi, data: {
          narrative: "aoki_culpa_oficialmente_al_encarcelado_sawashiro_del_homicidio_de_hoshino",
          blackmail: "aoki_recuerda_a_horinouchi_sus_sobornos_pasados_obligandolo_a_obedecer"
        })
        @state.set_flag(:horinouchi_subjugated, true)

        # 2. Entrada de Ishioda: plan de seguridad para Kume y pacto de eliminación
        transition_to(scene_ishioda_deal)
        emit("story.ishioda_tokyo_omi_promotion_promise", actor: :ryo_aoki, target: :akira_ishioda, data: {
          kume_escort: "ishioda_garantiza_fuerzas_de_choque_para_la_campana_de_kume_en_kamurocho",
          deal: "aoki_promete_a_ishioda_la_presidencia_de_la_tokyo_omi_si_limpia_ijincho"
        })
        @state.set_flag(:ishioda_dispatched_with_hit, true)
        @state.set_flag(:ep81_completed, true)
      end

      def generate_summary
        "Episodio 81_el_hilo_de_la_conspiracion completado: En el despacho del Gobernador de Tokio, Ryo Aoki se lava las manos por el asesinato de Ryuhei Hoshino atribuyéndoselo por completo al encarcelado Jo Sawashiro, mientras intimida al comisionado policial Horinouchi para que guarde silencio. Acto seguido, recibe a Reiji Ishioda, coordinando la seguridad de Kume y prometiéndole el liderazgo de la Tokyo Omi si erradica a los cabos sueltos de Ijincho."
      end
    end
  end
end
