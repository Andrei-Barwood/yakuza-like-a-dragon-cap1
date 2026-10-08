# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep85 < IchibanLab::BaseScenario
      protected

      def episode_id
        "85_el_farol_en_kamurocho"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { aoki: :blood_brother_antagonist, nick_ogata: :strategic_ally },
          belongings: []
        )
        aoki = Character.new(
          id: :ryo_aoki,
          name: "Ryo Aoki",
          attributes: { role: :tokyo_governor },
          relationships: { ichiban: :despised_ghost, tendo: :enforcer },
          belongings: []
        )
        nick = Character.new(
          id: :nick_ogata,
          name: "Nick Ogata",
          attributes: { role: :corporate_strategist },
          relationships: { ichiban: :benefactor },
          belongings: []
        )
        date = Character.new(
          id: :makoto_date,
          name: "Makoto Date",
          attributes: { role: :legendary_detective },
          relationships: { adachi: :veteran_colleague, ichiban: :promising_warrior },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "kamurocho_campaign_bluff",
          location: "Kamurocho - Frente a la Furgoneta Electoral de Aoki",
          time_period: "2019 - Víspera Electoral",
          money: 26300,
          characters: {
            ichiban: ichiban,
            ryo_aoki: aoki,
            nick_ogata: nick,
            makoto_date: date
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :legendary_hero_bat,
            :masumi_arakawa_incense
          ],
          flags: {
            chapter_14_completed: true,
            tendo_culprit_revealed: true
          }
        )
      end

      def define_scenes
        scene_bluff = Scene.new(
          id: "kamurocho_campaign_bluff",
          title: "El Farol ante la Furgoneta Electoral",
          location: "Kamurocho - Teatro y Calles Principales"
        )
        scene_bluff.add_precondition do |state|
          state.flag?(:chapter_14_completed) && state.flag?(:tendo_culprit_revealed)
        end

        scene_earth_angel = Scene.new(
          id: "earth_angel_conclave",
          title: "El Cónclave Estratégico en Earth Angel",
          location: "Champion District - Bar Earth Angel"
        )
        scene_earth_angel.add_precondition do |state|
          state.flag?(:campaign_bluff_executed)
        end

        scene_new_serena = Scene.new(
          id: "new_serena_reunion",
          title: "Reunión y Refugio en New Serena",
          location: "Tenkaichi Street - Bar New Serena"
        )
        scene_new_serena.add_precondition do |state|
          state.flag?(:millennium_trap_prepared)
        end

        [scene_bluff, scene_earth_angel, scene_new_serena]
      end

      def execute_scenario
        scene_bluff, scene_earth_angel, scene_new_serena = define_scenes

        # 1. El farol de Kasuga disfrazado ante la furgoneta de Aoki
        transition_to(scene_bluff)
        emit("story.campaign_infiltration", actor: :ichiban, target: :ryo_aoki, data: {
          disguise: "kasuga_disfrazado_de_indigente_se_acerca_con_adachi_y_nanba",
          handshake: "apreton_de_manos_forzado_en_publico_atrayendo_camaras_y_atencion_mediatica"
        })
        emit("story.incriminating_tape_bluff", actor: :ichiban, target: :ryo_aoki, data: {
          threat: "kasuga_afirma_que_existe_una_grabacion_en_el_despacho_arakawa_de_millennium_tower",
          ultimatum: "amenaza_de_filtrar_la_orden_de_asesinato_contra_arakawa_ante_toda_la_nacion"
        })
        @state.set_flag(:campaign_bluff_executed, true)

        # 2. Reagrupamiento en Earth Angel con Nick Ogata
        transition_to(scene_earth_angel, new_location: "Champion District - Bar Earth Angel")
        emit("story.strategic_briefing_with_nick", actor: :nick_ogata, target: :ichiban, data: {
          analysis: "nick_advierte_que_aoki_mordera_el_anzuelo_y_enviara_a_tendo_a_limpiar_la_torre",
          countermeasure: "el_grupo_planea_emboscar_a_tendo_y_hacerle_pagar_el_asesinato_del_patriarca"
        })
        @state.set_flag(:millennium_trap_prepared, true)

        # 3. Llegada a New Serena con Makoto Date como cuartel de seguridad
        transition_to(scene_new_serena, new_location: "Tenkaichi Street - Bar New Serena")
        emit("story.safehouse_established_new_serena", actor: :adachi, target: :makoto_date, data: {
          reunion: "adachi_reencuentra_a_su_antiguo_colega_el_legendario_detective_date",
          safehouse: "date_cede_new_serena_para_descansar_antes_del_asalto_final"
        })
        emit("story.kasuga_resolution_before_dawn", actor: :ichiban, data: {
          resolve: "kasuga_y_sus_camaradas_juran_llegar_a_la_cima_y_hacer_justicia_por_el_viejo"
        })
        @state.set_flag(:ep85_completed, true)
      end

      def generate_summary
        "Episodio 85_el_farol_en_kamurocho completado: Disfrazado de indigente en Kamurocho, Kasuga intercepta la furgoneta electoral de Aoki, forzando un apretón de manos público y soltando un letal farol: asegura que en el despacho Arakawa de Millennium Tower hay una grabación que prueba que Aoki ordenó el magnicidio de su padre. En Earth Angel, Nick Ogata refina la estrategia sabiendo que Aoki enviará a Yosuke Tendo a registrar la oficina. Finalmente, Adachi conduce al grupo a New Serena, donde el legendario Makoto Date les ofrece refugio para pasar la noche antes de la batalla definitiva."
      end
    end
  end
end
