# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep13 < IchibanLab::BaseScenario
      protected

      def episode_id
        "13_reunion_sangrienta"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :former_convict },
          relationships: {},
          belongings: []
        )
        arakawa = Character.new(
          id: :arakawa,
          name: "Masumi Arakawa",
          attributes: { role: :omi_captain_leader },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "the_patriarch_audience",
          location: "Puertas del Despacho",
          time_period: "2019 - Medianoche",
          money: 3500,
          characters: { ichiban: ichiban, arakawa: arakawa },
          inventory: [:nick_ogata_business_card],
          flags: { path_to_arakawa_opened: true }
        )
      end

      def execute_scenario
        scene_audience = Scene.new(id: :the_patriarch_audience, title: "Audiencia con el Patriarca", location: "Despacho Presidencial de la Omi")
        scene_audience.add_precondition("El camino al despacho debe estar abierto") do |ws|
          ws.flag?(:path_to_arakawa_opened)
        end

        scene_shot = Scene.new(id: :the_point_blank_shot, title: "El disparo a quemarropa", location: "Despacho Presidencial de la Omi")
        scene_trash = Scene.new(id: :trash_heap_awakening, title: "Despertar en la basura", location: "Isezaki Ijincho - Vertedero de basura")
        scene_trash.add_precondition("El disparo de Arakawa debe haber ocurrido") do |ws|
          ws.flag?(:shot_by_arakawa)
        end

        scene_salvation = Scene.new(id: :nanba_medical_salvation, title: "La salvación de Nanba", location: "Isezaki Ijincho - Campamento de Vagabundos")

        # 1. Audiencia
        scene_audience.check_preconditions!(@state)
        transition_to(scene_audience, new_location: "Despacho Presidencial de la Omi")
        @state.set_flag(:faced_arakawa, true)

        # 2. El disparo a quemarropa
        transition_to(scene_shot)
        emit("story.arakawa_betrayal_shot", actor: :arakawa, target: :ichiban, data: { caliber: "lethal", location: "chest" })
        ichiban = @state.character(:ichiban)
        ichiban.set_attribute(:hp, 1)
        ichiban.set_attribute(:status, :critically_wounded)
        ichiban.set_relationship(:arakawa, :betrayed_by_father)
        @state.set_flag(:shot_by_arakawa, true)

        # 3. Vertedero de Yokohama
        transition_to(scene_trash, new_location: "Isezaki Ijincho - Vertedero de basura", new_time: "2019 - Madrugada")
        @state.set_flag(:dumped_in_yokohama, true)

        # 4. Asistencia médica de Nanba y cierre del Capítulo 2
        nanba = Character.new(id: :nanba, name: "Yu Nanba", attributes: { role: :homeless_medic })
        @state.add_character(nanba)
        transition_to(scene_salvation, new_location: "Isezaki Ijincho - Campamento de Vagabundos")

        emit("story.medical_treatment", actor: :nanba, target: :ichiban, data: { procedure: "extracted_bullet", saved: true })
        ichiban.set_relationship(:nanba, :savior)
        @state.set_flag(:saved_by_nanba, true)
        @state.set_flag(:chapter_2_completed, true)

        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 2, status: :concluded, next: :chapter_3 })
      end

      def generate_summary
        "Episodio 13_reunion_sangrienta completado: Arakawa dispara al pecho de Ichiban, quien es arrojado en Yokohama y salvado milagrosamente por Nanba. Fin del Capítulo 2."
      end
    end
  end
end
