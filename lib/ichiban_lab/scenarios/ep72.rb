# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep72 < IchibanLab::BaseScenario
      protected

      def episode_id
        "72_la_noche_en_hamakita_y_el_golpe"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { arakawa: :father_figure, hoshino: :elder_ally },
          belongings: []
        )
        arakawa = Character.new(
          id: :masumi_arakawa,
          name: "Masumi Arakawa",
          attributes: { role: :reformed_patriarch },
          relationships: { ichiban: :beloved_subordinate },
          belongings: []
        )
        hoshino = Character.new(
          id: :ryuhei_hoshino,
          name: "Ryuhei Hoshino",
          attributes: { role: :seiryu_chairman },
          relationships: { arakawa: :ally },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "hamakita_park_night_reunion",
          location: "Hamakita Park - Yokohama",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            masumi_arakawa: arakawa,
            ryuhei_hoshino: hoshino
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
            dissolution_formally_filed: true,
            kiryu_guardian_revealed: true
          }
        )
      end

      def execute_scenario
        scene_night = Scene.new(
          id: :hamakita_park_night_reunion,
          title: "Encuentro íntimo nocturno en Hamakita Park con Masumi Arakawa",
          location: "Hamakita Park - Yokohama"
        )
        scene_night.add_precondition("La disolución de los clanes debe estar registrada") do |ws|
          ws.flag?(:dissolution_formally_filed)
        end

        scene_origins = Scene.new(
          id: :arakawa_dreams_and_origins_talk,
          title: "Conversación sobre orígenes, culpas del pasado y el futuro de Masato",
          location: "Hamakita Park - Yokohama"
        )

        scene_tragedy = Scene.new(
          id: :arakawa_murder_morning_shock,
          title: "La fatídica mañana siguiente: el mensaje de Ryuhei Hoshino",
          location: "Survive Bar - Yokohama"
        )

        # 1. Regreso a Yokohama: Arakawa se reúne a solas con Kasuga en Hamakita Park de noche
        scene_night.check_preconditions!(@state)
        transition_to(scene_night)
        emit("story.hamakita_nocturne_rendezvous", actor: :masumi_arakawa, target: :ichiban, data: {
          impact_on_aoki: "la_disolucion_arruina_el_apoyo_de_la_omi_a_aoki",
          heian_dinner_plan: "cena_pendiente_con_hoshino_en_heian_tower"
        })

        # 2. Reflexión sobre los orígenes de Kasuga, el destino cambiado con Masato y la reintegración laboral de los ex-yakuza
        transition_to(scene_origins)
        emit("story.father_and_son_bond_unspoken", actor: :masumi_arakawa, target: :ichiban, data: {
          reintegration_plan: "crear_una_agencia_de_colocacion_legal_para_ex_miembros_de_la_yakuza",
          dream_confession: "suenos_donde_kasuga_y_masato_intercambiaban_sus_posiciones_al_nacer",
          legacy: "arakawa_pide_perdon_y_kasuga_reafirma_que_siempre_sera_su_familia"
        })
        @state.set_flag(:arakawa_reconciliation_sealed, true)

        # 3. A la mañana siguiente en Survive Bar, Hoshino deja un trágico mensaje de voz
        transition_to(scene_tragedy, new_location: "Survive Bar - Yokohama", new_time: "2019 - Mañana")
        emit("story.arakawa_corpse_found_in_ocean", actor: :ryuhei_hoshino, target: :ichiban, data: {
          tragedy: "el_cuerpo_sin_vida_de_masumi_arakawa_fue_hallado_en_el_mar",
          devastation: "conmocion_absoluta_en_el_grupo_de_kasuga"
        })
        @state.set_flag(:arakawa_deceased, true)
        @state.set_flag(:chapter_12_completed, true)

        # Transición y frontera del Capítulo 12
        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 12, status: :concluded, next: :chapter_13 })
      end

      def generate_summary
        "Episodio 72_la_noche_en_hamakita_y_el_golpe completado: Tras disolver los clanes en Osaka, Kasuga se reúne en Hamakita Park con Masumi Arakawa, quien comparte confidencias sobre su plan de reinserción legal para ex-yakuzas y reflexiona sobre el nacimiento de Masato y Kasuga. Arakawa parte hacia Heian Tower para cenar con Hoshino. A la mañana siguiente, una llamada estremecedora de Hoshino anuncia que Masumi Arakawa ha sido asesinado y su cadáver arrojado al mar. Fin del Capítulo 12."
      end
    end
  end
end
