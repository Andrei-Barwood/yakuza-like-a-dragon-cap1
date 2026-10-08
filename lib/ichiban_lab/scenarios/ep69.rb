# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep69 < IchibanLab::BaseScenario
      protected

      def episode_id
        "69_los_dragones_legendarios"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { arakawa: :father_figure },
          belongings: []
        )
        majima = Character.new(
          id: :goro_majima,
          name: "Goro Majima",
          attributes: { role: :mad_dog_of_shimano, status: :legendary_officer },
          relationships: { saejima: :sworn_brother },
          belongings: []
        )
        saejima = Character.new(
          id: :taiga_saejima,
          name: "Taiga Saejima",
          attributes: { role: :tojo_clan_lieutenant, status: :legendary_officer },
          relationships: { majima: :sworn_brother },
          belongings: []
        )
        arakawa = Character.new(
          id: :masumi_arakawa,
          name: "Masumi Arakawa",
          attributes: { role: :acting_captain_omi },
          relationships: { ichiban: :protector },
          belongings: []
        )
        daigo = Character.new(
          id: :daigo_dojima,
          name: "Daigo Dojima",
          attributes: { role: :sixth_chairman_tojo },
          relationships: { arakawa: :collaborator },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "corridor_guards_skirmish",
          location: "Cuartel General Omi - Pasillos de la Cámara del Dragón",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            goro_majima: majima,
            taiga_saejima: saejima,
            masumi_arakawa: arakawa,
            daigo_dojima: daigo
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
            catering_disguise_ready: true,
            dragon_chamber_location_known: true
          }
        )
      end

      def execute_scenario
        scene_guards = Scene.new(
          id: :corridor_guards_skirmish,
          title: "Descubrimiento en los pasillos y combate con los centinelas Omi",
          location: "Cuartel General Omi - Pasillos de la Cámara del Dragón"
        )
        scene_guards.add_precondition("El grupo debe haber penetrado disfrazado") do |ws|
          ws.flag?(:catering_disguise_ready)
        end

        scene_legendary_combat = Scene.new(
          id: :majima_and_saejima_trial_combat,
          title: "Duelo legendario: el Perro Rabioso Majima y el Tigre Saejima",
          location: "Cuartel General Omi - Cámara del Dragón"
        )

        scene_daigo_arakawa_intervention = Scene.new(
          id: :arakawa_and_daigo_halt_combat,
          title: "Intervención de Masumi Arakawa y Daigo Dojima: pacto de aliados",
          location: "Cuartel General Omi - Cámara del Dragón"
        )

        # 1. Los centinelas de la Omi descubren la verdadera identidad de Kasuga y son reducidos
        scene_guards.check_preconditions!(@state)
        transition_to(scene_guards)
        emit("story.omi_hall_guards_defeated", actor: :ichiban, data: { guard_status: "derrotados", recognition: "el_hombre_que_sobrevivio_al_disparo_de_arakawa" })

        # 2. Entrada a la Cámara del Dragón: Goro Majima y Taiga Saejima ponen a prueba al grupo
        transition_to(scene_legendary_combat, new_location: "Cuartel General Omi - Cámara del Dragón")
        emit("story.legendary_trial_combat_started", actor: :goro_majima, target: :ichiban, data: { opponent: "el_perro_rabioso_de_shimano", partner: "taiga_saejima" })
        emit("story.legendary_trial_combat_concluded", actor: :ichiban, data: { result: "resistencia_demostrada_ante_las_leyendas_del_tojo" })
        @state.set_flag(:majima_saejima_defeated, true)

        # 3. Arakawa y Daigo Dojima interrumpen el combate; revelan que no son enemigos
        transition_to(scene_daigo_arakawa_intervention)
        emit("story.daigo_and_arakawa_revealed_allies", actor: :masumi_arakawa, target: :ichiban, data: {
          sixth_chairman: "daigo_dojima",
          alliance_status: "todos_los_presentes_son_aliados_en_la_misma_mision",
          invitation: "reunion_secreta_en_la_camara_del_dragon"
        })
        @state.set_flag(:tojo_legends_alliance_confirmed, true)
      end

      def generate_summary
        "Episodio 69_los_dragones_legendarios completado: Kasuga penetra en el cuartel de la Omi y libra un combate legendario de prueba contra Goro Majima y Taiga Saejima. Justo antes de desatarse el golpe final, Masumi Arakawa y Daigo Dojima intervienen, revelando que los oficiales del Tojo han estado ocultos y que todos forman un frente secreto de aliados."
      end
    end
  end
end
