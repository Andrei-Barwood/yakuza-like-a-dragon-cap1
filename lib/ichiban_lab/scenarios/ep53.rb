# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep53 < IchibanLab::BaseScenario
      protected

      def episode_id
        "53_el_voto_de_eomeoni"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { adachi: :brother_in_arms, saeko: :protectee },
          belongings: []
        )
        adachi = Character.new(
          id: :adachi,
          name: "Koichi Adachi",
          attributes: { role: :party_member },
          relationships: { ichiban: :brother_in_arms },
          belongings: []
        )
        saeko = Character.new(
          id: :saeko,
          name: "Saeko Mukoda",
          attributes: { role: :party_member },
          relationships: { ichiban: :ally },
          belongings: []
        )
        han = Character.new(
          id: :joon_gi_han,
          name: "Joon-gi Han",
          attributes: { role: :geomijul_lieutenant },
          relationships: {},
          belongings: []
        )
        seonhee = Character.new(
          id: :seonhee,
          name: "Seonhee",
          attributes: { role: :geomijul_leader },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "han_radio_contact",
          location: "Koreatown - Callejón Trasero",
          time_period: "2019 - Mediodía",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
            joon_gi_han: han,
            seonhee: seonhee
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
            geomijul_perimeter_breached: true
          }
        )
      end

      def execute_scenario
        scene_contact = Scene.new(
          id: :han_radio_contact,
          title: "Contacto secreto con Joon-gi Han",
          location: "Koreatown - Callejón Trasero"
        )
        scene_contact.add_precondition("El perímetro exterior de Geomijul debe haber caído") do |ws|
          ws.flag?(:geomijul_perimeter_breached)
        end

        scene_restaurant = Scene.new(
          id: :eomeoni_vow_passage,
          title: "Infiltración por el restaurante Eomeoni's Vow",
          location: "Eomeoni's Vow - Cocina y Pasaje Oculto"
        )

        scene_pact = Scene.new(
          id: :seonhee_bow_and_scorched_earth,
          title: "La reverencia de Seonhee y el pacto de tierra quemada",
          location: "Base Central de Geomijul - Sala de Control"
        )

        # 1. Joon-gi Han contacta al grupo y los cita en el restaurante Eomeoni's Vow
        scene_contact.check_preconditions!(@state)
        transition_to(scene_contact)
        emit("story.precious_gift_call", actor: :joon_gi_han, target: :ichiban, data: { rendezvous: "Eomeoni's Vow Restaurant", message: "les_mostrare_un_regalo_precioso" })

        # 2. Entrada por el pasadizo subterráneo secreto del restaurante
        transition_to(scene_restaurant, new_location: "Eomeoni's Vow - Cocina y Pasaje Oculto")
        emit("story.secret_passage_unlocked", actor: :ichiban, data: { route: "pasadizo_residencial_subterraneo_hacia_la_base" })

        # 3. Reencuentro con Seonhee: ella se inclina pidiendo ayuda para incendiar y destruir la imprenta antes de que la Omi incrimine a Ogikubo
        transition_to(scene_pact, new_location: "Base Central de Geomijul - Sala de Control")
        emit("story.ogikubo_orders_acknowledged", actor: :seonhee, data: { order: "destruir_las_pruebas_y_la_imprenta_para_salvar_a_ogikubo" })
        emit("story.leader_bow_witnessed", actor: :seonhee, target: :ichiban, data: { gesture: "seonhee_hace_una_reverencia_pidiendo_ganar_tiempo" })
        emit("story.defense_agreement_sealed", actor: :ichiban, target: :seonhee, data: { commitment: "frenar_a_la_omi_mientras_incendian_la_base" })
        @state.set_flag(:geomijul_scorched_earth_active, true)
      end

      def generate_summary
        "Episodio 53_el_voto_de_eomeoni completado: Joon-gi Han guía a Kasuga al restaurante Eomeoni's Vow, cuyo pasadizo secreto conecta con el refugio de Geomijul. Allí, una conmovida Seonhee se inclina pidiendo que contengan a la Omi mientras le prenden fuego a la imprenta para cumplir la orden de Ogikubo y borrar toda evidencia inculpatoria."
      end
    end
  end
end
