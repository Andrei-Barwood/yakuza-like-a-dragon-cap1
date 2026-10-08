# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep90 < IchibanLab::BaseScenario
      protected

      def episode_id
        "90_hacia_la_cima"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { nanba: :sworn_brother, adachi: :sworn_brother, saeko: :sworn_sister },
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :vindicated_detective },
          relationships: { ichiban: :brother_in_arms },
          belongings: []
        )
        horinouchi = Character.new(
          id: :juro_horinouchi,
          name: "Juro Horinouchi",
          attributes: { role: :corrupt_commissioner },
          relationships: { adachi: :nemesis },
          belongings: []
        )
        nanba = Character.new(
          id: :yu_nanba,
          name: "Yu Nanba",
          attributes: { role: :closest_confidant },
          relationships: { ichiban: :lifesaver_partner },
          belongings: []
        )
        daigo = Character.new(
          id: :daigo_dojima,
          name: "Daigo Dojima",
          attributes: { role: :ex_yakuza_chairman },
          relationships: { ichiban: :respected_successor },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "horinouchi_rooftop_arrest",
          location: "Tokio - Azotea del Departamento de Policía",
          time_period: "2019 - Días Posteriores",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            juro_horinouchi: horinouchi,
            yu_nanba: nanba,
            daigo_dojima: daigo
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :legendary_hero_bat,
            :masumi_arakawa_incense,
            :horinouchi_bribery_usb
          ],
          flags: {
            ep89_completed: true,
            aoki_fatally_stabbed: true
          }
        )
      end

      def define_scenes
        scene_horinouchi = Scene.new(
          id: "horinouchi_rooftop_arrest",
          title: "La Caída de Horinouchi",
          location: "Tokio - Azotea del Cuartel General de Policía"
        )
        scene_horinouchi.add_precondition do |state|
          state.flag?(:ep89_completed) && state.flag?(:aoki_fatally_stabbed)
        end

        scene_funeral = Scene.new(
          id: "arakawa_family_funeral",
          title: "El Funeral de la Familia Arakawa",
          location: "Kamurocho - Tanatorio y Salón de Duelo"
        )
        scene_funeral.add_precondition do |state|
          state.flag?(:horinouchi_arrested)
        end

        scene_epilogue = Scene.new(
          id: "ijincho_bridge_future",
          title: "El Retorno al Hogar: El Héroe de Yokohama",
          location: "Isezaki Ijincho - Puente sobre el Río Ooka"
        )
        scene_epilogue.add_precondition do |state|
          state.flag?(:funeral_concluded)
        end

        [scene_horinouchi, scene_funeral, scene_epilogue]
      end

      def execute_scenario
        scene_horinouchi, scene_funeral, scene_epilogue = define_scenes

        # 1. Arresto de Horinouchi por Adachi con las pruebas del Plan 3K
        transition_to(scene_horinouchi)
        emit("story.horinouchi_confrontation_and_arrest", actor: :adachi, target: :juro_horinouchi, data: {
          evidence: "adachi_presenta_el_pendrive_usb_hallado_en_millennium_tower_con_el_soborno_de_300_millones",
          vindication: "el_inspector_general_ordena_la_detencion_inmediata_de_horinouchi_cerrando_el_rencor_de_adachi"
        })
        @state.set_flag(:horinouchi_arrested, true)

        # 2. Funeral conjunto de Masumi y Masato Arakawa; propuesta de Daigo y Watase
        transition_to(scene_funeral, new_location: "Kamurocho - Tanatorio y Salón de Duelo")
        emit("story.arakawa_funeral_and_sawashiro_fate", actor: :yu_nanba, target: :ichiban, data: {
          sawashiro_sentence: "sawashiro_recibe_cadena_perpetua_guardando_el_secreto_del_nacimiento",
          biological_truth: "nanba_sugiere_una_prueba_de_adn_pero_kasuga_la_rechaza_sabiendo_en_su_corazon_la_verdad"
        })
        emit("story.osaka_security_company_offer", actor: :daigo_dojima, target: :ichiban, data: {
          offer: "daigo_y_watase_invitan_a_kasuga_a_dirigir_su_nueva_empresa_de_seguridad_para_exyakuzas_en_osaka",
          refusal: "kasuga_declina_humildemente_afirmando_que_su_lugar_en_el_mundo_es_ijincho_junto_a_sus_amigos"
        })
        @state.set_flag(:funeral_concluded, true)

        # 3. Retorno triunfal a Yokohama; despedida en el puente y cierre definitivo
        transition_to(scene_epilogue, new_location: "Isezaki Ijincho - Puente sobre el Río Ooka")
        emit("story.friends_reunion_in_ijincho", actor: :ichiban, data: {
          welcoming: "saeko_nanba_adachi_zhao_han_seonhee_hamako_y_el_jefe_lo_reciben_con_los_brazos_abiertos",
          unity: "los_marginados_de_la_zona_gris_han_vencido_y_preservado_su_comunidad"
        })
        emit("story.the_end_of_an_upstart", actor: :ichiban, data: {
          epilogue: "kasuga_mira_al_rio_en_paz_recordando_las_ultimas_palabras_de_masato_y_la_sonrisa_del_patriarca",
          destiny: "un_verdadero_dragon_y_heroe_que_ascendio_desde_el_fondo_absoluto_hasta_la_cima_del_alma_humana"
        })
        @state.set_flag(:chapter_15_completed, true)
        @state.set_flag(:campaign_completed, true)

        # Evento solemne de cierre de la saga de Yakuza: Like a Dragon
        emit("story.chapter_boundary", actor: :ichiban, data: {
          chapter: 15,
          status: :grand_finale,
          campaign: :completed
        })
      end

      def generate_summary
        "Episodio 90_hacia_la_cima completado: En los días posteriores a la tragedia, Adachi ajusta cuentas con el comisionado Horinouchi entregando las pruebas irrefutables de los sobornos de 300 millones de yenes, consumando su arresto. En el funeral conjunto de Masumi y Masato Arakawa, Nanba informa que Sawashiro cumplirá cadena perpetua y Kasuga declina una prueba de ADN pues no necesita papeles para saber quién fue su padre. Daigo y Watase le ofrecen presidir su nueva compañía de seguridad civil en Osaka, pero Ichiban rehúsa para volver a Isezaki Ijincho, donde sus amigos y la gente de la zona gris lo reciben como su protector. Contemplando el río, Kasuga recuerda a Masato en paz: el héroe que subió desde el fondo ha alcanzado la verdadera cima. Gran Final de Yakuza: Like a Dragon."
      end
    end
  end
end
