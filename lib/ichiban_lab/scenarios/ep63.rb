# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep63 < IchibanLab::BaseScenario
      protected

      def episode_id
        "63_el_funeral_de_ogasawara"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { saeko: :protectee, adachi: :brother_in_arms },
          belongings: []
        )
        aoki = Character.new(
          id: :ryo_aoki,
          name: "Ryo Aoki",
          attributes: { role: :governor_and_party_chair },
          relationships: {},
          belongings: []
        )
        kume = Character.new(
          id: :sota_kume,
          name: "Sota Kume",
          attributes: { role: :political_candidate },
          relationships: { aoki: :mentor },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "funeral_home_exterior_and_restriction",
          location: "Funeraria de Ijincho - Exterior",
          time_period: "2019 - Tarde",
          money: 26300,
          characters: {
            ichiban: ichiban,
            ryo_aoki: aoki,
            sota_kume: kume
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
            funeral_target_identified: true,
            shelter_scam_suspected: true
          }
        )
      end

      def execute_scenario
        scene_exterior = Scene.new(
          id: :funeral_home_exterior_and_restriction,
          title: "Exterior de la funeraria y restricción de acceso",
          location: "Funeraria de Ijincho - Exterior"
        )
        scene_exterior.add_precondition("El grupo debe conocer la ubicación del funeral") do |ws|
          ws.flag?(:funeral_target_identified)
        end

        scene_eulogy = Scene.new(
          id: :aoki_crocodile_tears_and_kume_endorsement,
          title: "Panegírico de Aoki: lágrimas de cocodrilo y respaldo a Sota Kume",
          location: "Funeraria de Ijincho - Capilla Ardiente"
        )

        scene_media_block = Scene.new(
          id: :media_swarm_and_underground_clue,
          title: "Acoso de la prensa y pista del aparcamiento subterráneo",
          location: "Funeraria de Ijincho - Explanada"
        )

        # 1. Llegada a la funeraria (el mismo lugar del velatorio de Nonomiya) y bloqueo por guardia privada
        scene_exterior.check_preconditions!(@state)
        transition_to(scene_exterior)
        emit("story.funeral_hall_restricted", actor: :ichiban, data: { location: "misma_sala_que_nonomiya", access_rule: "solo_familiares_y_cupula_de_bleach_japan" })

        # 2. Aoki pronuncia su discurso entre lágrimas falsas y postula a Kume al parlamento
        transition_to(scene_eulogy)
        emit("story.aoki_eulogy_delivered", actor: :ryo_aoki, target: :sota_kume, data: { rhetoric: "continuar_el_legado_de_ogasawara", endorsement: "kume_candidato_a_la_dieta_nacional", emotion: "lagrimas_de_cocodrilo" })
        @state.set_flag(:kume_candidacy_announced, true)

        # 3. La prensa asedia a Aoki; Saeko deduce que escapará por el garaje subterráneo junto al río
        transition_to(scene_media_block)
        emit("story.media_swarm_interception_failed", actor: :ichiban, data: { reason: "bloqueo_de_camaras_y_reporteros" })
        emit("story.underground_parking_route_deduced", actor: :saeko, data: { deduction: "los_politicos_usan_aparcamientos_subterraneos_junto_al_rio_para_evadir_la_prensa" })
        @state.set_flag(:underground_parking_target_active, true)
      end

      def generate_summary
        "Episodio 63_el_funeral_de_ogasawara completado: El grupo asiste al velatorio de Ogasawara. Aoki ofrece un hipócrita panegírico postulando a Sota Kume al parlamento. La prensa rodea a Aoki impidiendo el contacto directo, pero Saeko deduce que huirá por el aparcamiento subterráneo ribereño."
      end
    end
  end
end
