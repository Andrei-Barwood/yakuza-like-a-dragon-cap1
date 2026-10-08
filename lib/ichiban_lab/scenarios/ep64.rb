# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep64 < IchibanLab::BaseScenario
      protected

      def episode_id
        "64_el_estacionamiento_subterraneo"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { adachi: :brother_in_arms },
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :ex_detective, party_member: true },
          relationships: { ichiban: :partner },
          belongings: []
        )
        aoki = Character.new(
          id: :ryo_aoki,
          name: "Ryo Aoki",
          attributes: { role: :governor_and_party_chair },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "hidden_elevator_search",
          location: "Callejón entre Harbor Light y Bar Rodriguez",
          time_period: "2019 - Tarde",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
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
            underground_parking_target_active: true,
            kume_candidacy_announced: true
          }
        )
      end

      def execute_scenario
        scene_elevator = Scene.new(
          id: :hidden_elevator_search,
          title: "Búsqueda del montacargas secreto hacia el garaje",
          location: "Callejón entre Harbor Light y Bar Rodriguez"
        )
        scene_elevator.add_precondition("El grupo debe buscar la ruta subterránea") do |ws|
          ws.flag?(:underground_parking_target_active)
        end

        scene_clash = Scene.new(
          id: :omi_security_escorts_clash,
          title: "Enfrentamiento con los falsos escoltas de la Alianza Omi",
          location: "Aparcamiento Subterráneo Ribereño"
        )

        scene_rendezvous = Scene.new(
          id: :aoki_secret_rendezvous_offered,
          title: "Propuesta de cita clandestina a solas en Otohime Land",
          location: "Aparcamiento Subterráneo Ribereño"
        )

        # 1. Adachi localiza el montacargas secreto entre The Harbor Light y Bar Rodriguez
        scene_elevator.check_preconditions!(@state)
        transition_to(scene_elevator)
        emit("story.hidden_elevator_found", actor: :adachi, data: { location: "entre_harbor_light_y_bar_rodriguez", access: "acceso_al_garaje_subterraneo" })

        # 2. Llegada al garaje: los escoltas hablan dialecto de Kansai y desenfundan armas
        transition_to(scene_clash, new_location: "Aparcamiento Subterráneo Ribereño")
        emit("story.omi_escorts_unmasked", actor: :ichiban, data: { dialect: "kansai_ben", identity: "yakuza_de_la_alianza_omi_disfrazados_de_seguridad_privada" })
        emit("story.adachi_disarm_and_combat", actor: :adachi, target: :omi_security, data: { outcome: "guardias_sometidos", weapon: "pistola_confiscada" })

        # 3. Aoki reprende a sus hombres y le susurra a Kasuga que acuda solo a Otohime Land
        transition_to(scene_rendezvous)
        emit("story.aoki_private_summons_issued", actor: :ryo_aoki, target: :ichiban, data: { meeting_place: "Otohime Land", condition: "solo_y_de_noche", nanba_warning: "podria_ser_una_trampa" })
        @state.set_flag(:otohime_meeting_scheduled, true)
      end

      def generate_summary
        "Episodio 64_el_estacionamiento_subterraneo completado: El grupo desciende por un montacargas oculto y halla a Aoki en el aparcamiento subterráneo. Descubren que sus escoltas son matones de la Omi y Adachi los desarma en combate. Aoki ofrece una disculpa forzada y convoca a Kasuga a solas en Otohime Land esa misma noche."
      end
    end
  end
end
