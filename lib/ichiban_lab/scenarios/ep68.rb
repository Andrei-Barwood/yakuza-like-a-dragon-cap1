# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep68 < IchibanLab::BaseScenario
      protected

      def episode_id
        "68_rumbo_a_sotenbori"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { arakawa: :father_figure, mitsuo: :trusted_contact },
          belongings: []
        )
        mitsuo = Character.new(
          id: :mitsuo,
          name: "Mitsuo Yasuda",
          attributes: { role: :arakawa_insider },
          relationships: { ichiban: :loyal_comrade },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "sotenbori_arrival_and_grand_wait",
          location: "Cabaret Grand - Sotenbori",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            mitsuo: mitsuo
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
            watase_release_imminent: true,
            tendo_dispatched_to_osaka: true
          }
        )
      end

      def execute_scenario
        scene_grand = Scene.new(
          id: :sotenbori_arrival_and_grand_wait,
          title: "Llegada a Sotenbori y espera nerviosa en el Cabaret Grand",
          location: "Cabaret Grand - Sotenbori"
        )
        scene_grand.add_precondition("La liberación de Watase debe estar en curso") do |ws|
          ws.flag?(:watase_release_imminent)
        end

        scene_mitsuo_call = Scene.new(
          id: :mitsuo_secret_intel_call,
          title: "Llamada encubierta de Mitsuo: la Cámara del Dragón",
          location: "Cabaret Grand - Sotenbori"
        )

        scene_disguise_plan = Scene.new(
          id: :catering_disguise_plan_hatched,
          title: "Plan de infiltración como personal de catering en el cuartel Omi",
          location: "Exterior del Cuartel General de la Omi - Osaka"
        )

        # 1. Llegada a Sotenbori: Kasuga espera noticias mientras circulan rumores de guerra Omi
        scene_grand.check_preconditions!(@state)
        transition_to(scene_grand)
        emit("story.sotenbori_tension_observed", actor: :ichiban, data: { atmosphere: "temor_a_guerra_abierta_entre_facciones_de_la_omi", location: "Cabaret Grand" })

        # 2. Mitsuo llama y revela la reunión privada de Arakawa en la Cámara del Dragón con tres invitados
        transition_to(scene_mitsuo_call)
        emit("story.mitsuo_dragon_chamber_alert", actor: :mitsuo, target: :ichiban, data: { location: "camara_del_dragon_cuartel_omi", secret_guests: 3, security: "fuerte_presencia_de_guardias" })
        @state.set_flag(:dragon_chamber_location_known, true)

        # 3. Llegada al cuartel: Kasuga observa camiones de catering y planean infiltrarse disfrazados
        transition_to(scene_disguise_plan, new_location: "Exterior del Cuartel General de la Omi - Osaka")
        emit("story.catering_infiltration_resolved", actor: :ichiban, data: { disguise: "camareros_de_catering", objective: "acceder_a_la_camara_del_dragon" })
        @state.set_flag(:catering_disguise_ready, true)
      end

      def generate_summary
        "Episodio 68_rumbo_a_sotenbori completado: Kasuga y su grupo viajan a Osaka en medio del clima de preguerra por la liberación de Watase. Desde el Cabaret Grand, Mitsuo les informa que Arakawa se encuentra en la Cámara del Dragón del cuartel de la Omi con tres misteriosos invitados. El grupo decide infiltrarse camuflados como personal de catering."
      end
    end
  end
end
