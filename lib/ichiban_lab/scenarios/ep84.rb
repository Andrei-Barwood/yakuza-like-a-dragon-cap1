# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep84 < IchibanLab::BaseScenario
      protected

      def episode_id
        "84_fuego_cruzado_en_el_distrito_de_bares"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { ishioda: :sworn_enemy, adachi: :trusted_partner },
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :detective_partner },
          relationships: { ichiban: :loyal_friend },
          belongings: []
        )
        ishioda = Character.new(
          id: :akira_ishioda,
          name: "Reiji Ishioda",
          attributes: { hp: 100, role: :ruthless_lieutenant },
          relationships: { aoki: :puppet_master, tendo: :lethal_rival },
          belongings: []
        )
        mirror_face = Character.new(
          id: :mirror_face,
          name: "Mirror Face",
          attributes: { hp: 100, role: :master_of_disguise },
          relationships: { ishioda: :client },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "bar_district_building_ascent",
          location: "Edificio de Ishioda - Bar District (Planta Baja y Escaleras)",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            akira_ishioda: ishioda,
            mirror_face: mirror_face
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
            ep83_completed: true,
            bar_district_target_confirmed: true
          }
        )
      end

      def define_scenes
        scene_ascent = Scene.new(
          id: :bar_district_building_ascent,
          title: "Ascenso por el edificio del Bar District repeliendo a la Familia Ishioda",
          location: "Edificio de Ishioda - Bar District (Planta Baja y Escaleras)"
        )
        scene_ascent.add_precondition("El objetivo del Bar District debe estar fijado") do |ws|
          ws.flag?(:ep83_completed) && ws.flag?(:bar_district_target_confirmed)
        end

        scene_double_adachi = Scene.new(
          id: :mirror_face_impostor_quiz,
          title: "Piso 4: Mirror Face suplanta a Adachi y Kasuga lo desenmascara con normas viales",
          location: "Edificio de Ishioda - Piso 4"
        )
        scene_double_adachi.add_precondition("Los pisos inferiores deben haber sido despejados") do |ws|
          ws.flag?(:ishioda_floors_cleared)
        end

        scene_climax = Scene.new(
          id: :ishioda_tendo_bomb_revelation,
          title: "Duelo final, confesión del asesinato de Arakawa por Tendo y detonación explosiva",
          location: "Edificio de Ishioda - Despacho Principal"
        )
        scene_climax.add_precondition("El impostor debe haber sido neutralizado") do |ws|
          ws.flag?(:traffic_quiz_solved)
        end

        [scene_ascent, scene_double_adachi, scene_climax]
      end

      def execute_scenario
        scene_ascent, scene_double_adachi, scene_climax = define_scenes

        # 1. Asalto y combate por los pasillos del edificio
        scene_ascent.check_preconditions!(@state)
        emit("story.ishioda_family_brawl_ascent", actor: :ichiban, data: { floors: "combate_ascendente_hasta_el_cuarto_piso" })
        emit("story.combat_resolved", actor: :ichiban, target: :ishioda_family_enforcers, data: { result: :enforcers_defeated })
        @state.set_flag(:ishioda_floors_cleared, true)

        # 2. Piso 4: Enfrentamiento con dos Adachis y prueba ingeniosa de Kasuga
        transition_to(scene_double_adachi, new_location: "Edificio de Ishioda - Piso 4")
        emit("story.mirror_face_adachi_impersonation", actor: :mirror_face, target: :adachi, data: {
          tactic: "mirror_face_inmoviliza_al_adachi_real_adoptando_su_identidad_y_voz"
        })
        emit("story.traffic_laws_quiz_breakthrough", actor: :ichiban, target: :mirror_face, data: {
          trick: "kasuga_interroga_sobre_el_codigo_de_circulacion_el_verdadero_adachi_lo_desconoce_por_completo",
          impostor_unmasked: "mirror_face_responde_con_precision_quedando_en_evidencia_inmediata"
        })
        @state.set_flag(:traffic_quiz_solved, true)

        # 3. Combate de jefe conjunto (Ishioda & Mirror Face), confesión del crimen de Arakawa y bomba
        transition_to(scene_climax, new_location: "Edificio de Ishioda - Despacho Principal")
        emit("story.combat_resolved", actor: :ichiban, target: :akira_ishioda, data: {
          bosses: [:akira_ishioda, :mirror_face],
          result: :ishioda_and_mirror_face_defeated
        })
        emit("story.ishioda_confession_tendo_murdered_arakawa", actor: :akira_ishioda, target: :ichiban, data: {
          truth: "ishioda_revela_que_tendo_disparo_a_quema_ropa_a_masumi_arakawa_tras_emboscarlo_en_el_muelle",
          motive: "tendo_traiciono_la_disolucion_para_quedarse_con_la_cima_del_crimen_organizado_junto_a_aoki"
        })
        emit("story.tendo_bomb_detonation_trap", actor: :yosuke_tendo, target: :akira_ishioda, data: {
          explosion: "tendo_y_aoki_silencian_a_ishioda_detonando_una_bomba_a_distancia_en_el_edificio",
          aftermath: "el_grupo_de_kasuga_escapa_del_fuego_con_la_verdad_revelada"
        })
        @state.set_flag(:tendo_culprit_revealed, true)
        @state.set_flag(:chapter_14_completed, true)

        # Frontera y transición al Capítulo 15 (Final)
        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 14, status: :concluded, next: :chapter_15 })
      end

      def generate_summary
        "Episodio 84_fuego_cruzado_en_el_distrito_de_bares completado: Kasuga y su equipo barren el edificio del Distrito de Bares. En el cuarto piso, Mirror Face suplanta a Adachi pero es delatado cuando Kasuga le pregunta por las leyes de tránsito. Tras vencer a Ishioda y a Mirror Face en feroz combate, Ishioda confiesa que quien disparó a matar a Masumi Arakawa en el muelle fue Yosuke Tendo para tomar el mando con Aoki. Segundos después, Tendo detona a distancia una bomba para eliminar a Ishioda; Kasuga escapa de las llamas decidido a viajar a Tokio. Fin del Capítulo 14."
      end
    end
  end
end
