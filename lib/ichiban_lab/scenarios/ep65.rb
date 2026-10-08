# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep65 < IchibanLab::BaseScenario
      protected

      def episode_id
        "65_la_noche_en_otohime_land"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { arakawa: :father_figure, masato: :former_young_master },
          belongings: []
        )
        aoki = Character.new(
          id: :ryo_aoki,
          name: "Ryo Aoki / Masato Arakawa",
          attributes: { role: :governor_and_party_chair },
          relationships: { ichiban: :former_subordinate },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "otohime_land_night_meeting",
          location: "Otohime Land - Despacho Principal",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            ryo_aoki: aoki
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :seiryu_clan_key,
            :counterfeit_yuan_sample,
            :shoichi_investigative_notes,
            :bleach_japan_founders_clipping
          ],
          flags: {
            otohime_meeting_scheduled: true
          }
        )
      end

      def execute_scenario
        scene_meeting = Scene.new(
          id: :otohime_land_night_meeting,
          title: "Encuentro nocturno a solas en Otohime Land",
          location: "Otohime Land - Despacho Principal"
        )
        scene_meeting.add_precondition("Kasuga debe haber acudido a la cita privada") do |ws|
          ws.flag?(:otohime_meeting_scheduled)
        end

        scene_truth = Scene.new(
          id: :masato_suzumori_murder_revelation,
          title: "La verdad del año 2000: Masato asesinó a Suzumori",
          location: "Otohime Land - Despacho Principal"
        )

        scene_clash_of_will = Scene.new(
          id: :conditions_rejected_and_parting,
          title: "Ruptura de condiciones y choque frontal de voluntades",
          location: "Otohime Land - Despacho Principal"
        )

        # 1. Aoki explica su trasplante pulmonar en EE.UU. y confiesa haber mandado a matar a Ogasawara por control de riesgos
        scene_meeting.check_preconditions!(@state)
        transition_to(scene_meeting)
        emit("story.aoki_transplant_and_erasure_revealed", actor: :ryo_aoki, data: { lung_transplant: "operacion_en_estados_unidos", motive: "borrar_pasado_yakuza_y_reinventarse" })
        emit("story.ogasawara_hit_ordered_by_aoki", actor: :ryo_aoki, data: { justification: "control_de_riesgos_sabia_demasiado", reaction: "kasuga_enfurecido" })

        # 2. La verdad de Nochevieja del 2000: Masato mató a Suzumori cuando se le pasó el efecto de la efedrina y tiraron su silla
        transition_to(scene_truth)
        emit("story.suzumori_murder_true_killer_revealed", actor: :ryo_aoki, target: :ichiban, data: {
          real_killer: "masato_arakawa",
          motive: "suzumori_se_burlo_y_escupio_mientras_agonizaba_sin_silla_de_ruedas",
          sawashiro_coverup: "arakawa_pidio_a_kasuga_inculparse_para_proteger_a_su_hijo_no_a_sawashiro"
        })
        @state.set_flag(:suzumori_true_killer_known, true)

        # 3. Choque de condiciones: Kasuga exige la retirada de Kume de Ijincho; Aoki revela que el plan deportará a las trabajadoras
        transition_to(scene_clash_of_will)
        emit("story.revitalization_plan_deportation_scheme_exposed", actor: :ryo_aoki, data: { true_goal: "expulsion_y_deportacion_masiva_de_inmigrantes_ilegales_de_ijincho" })
        emit("story.mutual_ultimatums_rejected", actor: :ichiban, target: :ryo_aoki, data: { result: "ruptura_absoluta_sin_acuerdo" })
        @state.set_flag(:aoki_talks_broken, true)
      end

      def generate_summary
        "Episodio 65_la_noche_en_otohime_land completado: Cara a cara entre Kasuga y Aoki en Otohime Land. Aoki confiesa haber liquidado a Ogasawara y revela que fue él mismo quien asesinó a Suzumori en el año 2000, motivo por el cual Arakawa le pidió a Kasuga que asumiera la culpa. Tras rechazar sus mutuas condiciones, Aoki revela que su albergue deportará a las trabajadoras de Ijincho."
      end
    end
  end
end
