# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep49 < IchibanLab::BaseScenario
      protected

      def episode_id
        "49_el_perfil_de_aoki"
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
        bartender = Character.new(
          id: :bartender,
          name: "Bartender de Survive",
          attributes: { role: :ally },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "survive_bar_aoki_profile_analysis",
          location: "Survive Bar - Salón Principal",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
            bartender: bartender
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
            chapter_8_completed: true,
            masato_arakawa_identity_revealed: true
          }
        )
      end

      def execute_scenario
        scene_analysis = Scene.new(
          id: :survive_bar_aoki_profile_analysis,
          title: "Análisis del perfil de Ryo Aoki en Survive Bar",
          location: "Survive Bar - Salón Principal"
        )
        scene_analysis.add_precondition("El grupo debe poseer el recorte de los fundadores del Capítulo 8") do |ws|
          ws.flag?(:chapter_8_completed) && ws.has_item?(:bleach_japan_founders_clipping)
        end

        scene_deductions = Scene.new(
          id: :kamurocho_3k_and_family_register,
          title: "El Plan 3K de Kamurocho y la usurpación de registro familiar",
          location: "Survive Bar - Salón Principal"
        )

        scene_night = Scene.new(
          id: :safehouse_rest_2f,
          title: "Descanso y refugio en la segunda planta de Survive",
          location: "Survive Bar - Planta 2F"
        )

        # 1. Análisis en Survive Bar: perfil público de Aoki, Harvard y operación motriz en EE.UU.
        scene_analysis.check_preconditions!(@state)
        transition_to(scene_analysis)
        emit("story.profile_scrutiny", actor: :ichiban, data: { public_bio: "confinado_hasta_los_20_harvard_economia_cirugia_motriz_exitosa" })
        emit("story.disability_recovery_analyzed", actor: :adachi, data: { conclusion: "masato_obtuvo_cirugia_en_eeuu_para_volver_a_caminar" })

        # 2. Conexión con el Plan 3K, comisionado Horinouchi y caída del Clan Tojo
        transition_to(scene_deductions)
        emit("story.kamurocho_3k_plan_analyzed", actor: :adachi, data: { horinouchi_collusion: "comisionado_policial_en_la_foto", tojo_fall: "arakawa_filtro_informacion_interna_para_aoki" })
        emit("story.family_register_theft_deduced", actor: :ichiban, data: { hypothesis: "adopcion_o_compra_de_registro_familiar_para_borrar_a_masato" })
        @state.set_flag(:aoki_background_uncovered, true)

        # 3. Permiso del barman para usar la segunda planta como refugio seguro ante la crisis
        transition_to(scene_night, new_location: "Survive Bar - Planta 2F", new_time: "2019 - Medianoche")
        emit("story.safehouse_granted", actor: :bartender, target: :ichiban, data: { privilege: "uso_de_segunda_planta_como_cuartel_general" })
        @state.set_flag(:survive_hideout_unlocked, true)
      end

      def generate_summary
        "Episodio 49_el_perfil_de_aoki completado: En Survive Bar, Ichiban, Adachi y Saeko desmenuzan el historial público de Ryo Aoki, deduciendo cómo Masato Arakawa se operó en EE.UU., usurpó una nueva identidad mediante un registro familiar comprado y ejecutó el Plan 3K de Kamurocho para liquidar al Clan Tojo con la complicidad de Horinouchi. El barman les autoriza a pernoctar en la segunda planta."
      end
    end
  end
end
