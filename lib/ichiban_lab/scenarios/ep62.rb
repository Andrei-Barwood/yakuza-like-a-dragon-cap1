# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep62 < IchibanLab::BaseScenario
      protected

      def episode_id
        "62_el_refugio_de_hamako"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { hamako: :benefactor, adachi: :brother_in_arms },
          belongings: []
        )
        hamako = Character.new(
          id: :hamako,
          name: "Hamako",
          attributes: { role: :shelter_matron },
          relationships: { ichiban: :friend },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "hamako_call_and_arrival",
          location: "The Harbor Light - Entrada",
          time_period: "2019 - Mediodía",
          money: 26300,
          characters: {
            ichiban: ichiban,
            hamako: hamako
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
            waiting_for_hamako_contact: true,
            zhao_and_han_integrated: true
          }
        )
      end

      def execute_scenario
        scene_arrival = Scene.new(
          id: :hamako_call_and_arrival,
          title: "Llamada de Hamako y llegada a The Harbor Light",
          location: "The Harbor Light - Entrada"
        )
        scene_arrival.add_precondition("Hamako debe haber convocado al grupo") do |ws|
          ws.flag?(:waiting_for_hamako_contact)
        end

        scene_shelter = Scene.new(
          id: :bleach_japan_shelter_program_revealed,
          title: "El programa de refugios de Bleach Japan en Hamakita Park",
          location: "The Harbor Light - Salón"
        )

        scene_funeral_intel = Scene.new(
          id: :ogasawara_funeral_intel_gathered,
          title: "Información sobre el funeral público de Ogasawara",
          location: "The Harbor Light - Salón"
        )

        # 1. Llegada a The Harbor Light: el local está vacío sin trabajadoras
        scene_arrival.check_preconditions!(@state)
        transition_to(scene_arrival)
        emit("story.hamako_request_received", actor: :hamako, target: :ichiban, data: { status: "local_vacio", task: "ayudar_a_desmantelar_el_establecimiento" })

        # 2. Hamako revela la oferta de Bleach Japan: albergues en Hamakita Park con visados y capacitación
        transition_to(scene_shelter)
        emit("story.bleach_japan_shelters_exposed", actor: :hamako, data: { shelter_location: "hamakita_park", promises: "formacion_laboral_y_visados_gratuitos", dorm_mother: :hamako })
        emit("story.adachi_political_warning", actor: :adachi, data: { warning: "es_una_treta_de_aoki_para_captar_votos_y_blanquear_su_imagen" })
        @state.set_flag(:shelter_scam_suspected, true)

        # 3. Hamako menciona que Aoki asistirá al funeral de Ogasawara en Yokohama
        transition_to(scene_funeral_intel)
        emit("story.funeral_attendance_alerted", actor: :hamako, data: { deceased: :ogasawara, attendee: :ryo_aoki, location: "funeraria_de_ijincho" })
        @state.set_flag(:funeral_target_identified, true)
      end

      def generate_summary
        "Episodio 62_el_refugio_de_hamako completado: Kasuga ayuda a Hamako tras el desalojo de su bar. Ella revela que Bleach Japan reubica a mujeres inmigrantes en un albergue en Hamakita Park prometiendo visados. Adachi advierte el trasfondo electoral de Aoki y se enteran del funeral público de Ogasawara en la ciudad."
      end
    end
  end
end
