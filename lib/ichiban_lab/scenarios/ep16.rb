# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep16 < IchibanLab::BaseScenario
      protected

      def episode_id
        "16_en_busca_de_empleo"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :unemployed_jobseeker },
          relationships: { nanba: :companion },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :companion_jobseeker },
          relationships: { ichiban: :companion },
          belongings: []
        )
        ririka = Character.new(
          id: :ririka,
          name: "Ririka",
          attributes: { role: :hello_work_clerk },
          relationships: {},
          belongings: []
        )
        kanbe = Character.new(
          id: :kanbe,
          name: "Director Shuichi Kanbe",
          attributes: { role: :hello_work_director },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "speech_and_rally",
          location: "Campamento de Vagabundos",
          time_period: "2019 - Mediodía",
          money: 1300,
          characters: { ichiban: ichiban, nanba: nanba, ririka: ririka, kanbe: kanbe },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill],
          flags: { counterfeit_bill_revealed: true }
        )
      end

      def execute_scenario
        scene_rally = Scene.new(id: :speech_and_rally, title: "Discurso en el campamento", location: "Campamento de Vagabundos")
        scene_rally.add_precondition("El misterio del billete falso debe estar iniciado") do |ws|
          ws.flag?(:counterfeit_bill_revealed)
        end

        scene_reception = Scene.new(id: :hello_work_interview, title: "Entrevista en Hello Work y choque burocrático", location: "Oficina de Hello Work Yokohama")
        scene_offer = Scene.new(id: :director_kanbe_offer, title: "La oferta encubierta del Director Kanbe", location: "Oficina de Hello Work Yokohama")

        # 1. Discurso de Ichiban y debate de realidades con Nanba
        scene_rally.check_preconditions!(@state)
        transition_to(scene_rally)
        emit("story.dialogue_resolved", actor: :ichiban, target: :nanba, data: { topic: "buscar_trabajo_formal_para_salir_de_la_calle" })
        emit("story.party_chats_unlocked", actor: :ichiban, data: { system: :party_chat })
        @state.set_flag(:party_chats_active, true)

        # 2. Entrevista frustrada ante Ririka en Hello Work por falta de domicilio
        transition_to(scene_reception, new_location: "Oficina de Hello Work Yokohama", new_time: "2019 - Tarde")
        emit("story.bureaucratic_obstacle", actor: :ririka, target: :ichiban, data: { reason: "sin_direccion_fija_ni_documentacion" })
        @state.set_flag(:lacked_official_address, true)

        # 3. Intervención del Director Kanbe y encargo en The Harbor Light
        transition_to(scene_offer)
        emit("story.unofficial_job_offered", actor: :kanbe, target: :ichiban, data: { establishment: "The Harbor Light", reward: 5000, role: "vigilante_nocturno" })
        @state.set_flag(:harbor_light_job_accepted, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "ir_a_the_harbor_light" })
      end

      def generate_summary
        "Episodio 16_en_busca_de_empleo completado: Ichiban y Nanba acuden a Hello Work, chocan contra la barrera de no tener domicilio y reciben del Director Kanbe un trabajo informal de vigilancia en The Harbor Light por ¥5,000."
      end
    end
  end
end
