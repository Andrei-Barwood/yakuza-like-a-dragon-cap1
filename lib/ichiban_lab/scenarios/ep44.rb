# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep44 < IchibanLab::BaseScenario
      protected

      def episode_id
        "44_el_dilema_de_la_lealtad"
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
        zhao = Character.new(
          id: :tianyou_zhao,
          name: "Tianyou Zhao",
          attributes: { role: :liumang_leader },
          relationships: {},
          belongings: []
        )
        han = Character.new(
          id: :joon_gi_han,
          name: "Joon-gi Han",
          attributes: { role: :geomijul_lieutenant },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "nanba_ultimatum_discussion",
          location: "Heian Tower - Mirador Panorámico",
          time_period: "2019 - 02:45 AM",
          money: 26300,
          characters: { ichiban: ichiban, adachi: adachi, saeko: saeko, tianyou_zhao: zhao, joon_gi_han: han },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample, :shoichi_investigative_notes],
          flags: { ogikubo_system_fully_understood: true }
        )
      end

      def execute_scenario
        scene_ultimatum = Scene.new(
          id: :nanba_ultimatum_discussion,
          title: "El ultimátum sobre Nanba",
          location: "Heian Tower - Mirador Panorámico"
        )
        scene_ultimatum.add_precondition("El sistema de Ogikubo debe haber sido comprendido") do |ws|
          ws.flag?(:ogikubo_system_fully_understood)
        end

        scene_refusal = Scene.new(
          id: :kasuga_loyalty_stand,
          title: "La rotunda negativa de Kasuga a traicionar a su amigo",
          location: "Heian Tower - Mirador Panorámico"
        )

        scene_deduction = Scene.new(
          id: :bleach_japan_lead_deduction,
          title: "La pista de Bleach Japan y el edificio Hakuryo",
          location: "Heian Tower - Mirador Panorámico"
        )

        # 1. Zhao declara que Nanba es una amenaza existencial y debe ser silenciado
        scene_ultimatum.check_preconditions!(@state)
        transition_to(scene_ultimatum)
        emit("story.silence_order_issued", actor: :tianyou_zhao, target: :nanba, data: { status: "perseguido_por_sicarios_de_liumang" })

        # 2. Kasuga rechaza entregar a Nanba a cualquier costo
        transition_to(scene_refusal)
        emit("story.loyalty_refusal", actor: :ichiban, target: :tianyou_zhao, data: { choice: "rechazar_la_traicion_a_un_amigo", boundary: "el_gran_muro_no_me_importa_si_debo_sacrificar_a_nanba" })
        emit("story.omi_shield_reminder", actor: :tianyou_zhao, target: :ichiban, data: { warning: "el_muro_de_ijin_te_mantuvo_con_vida_frente_a_la_alianza_omi" })
        @state.set_flag(:kasuga_rejected_betrayal, true)

        # 3. Joon-gi Han deduce el paradero de Nanba: Bleach Japan en el edificio Hakuryo
        transition_to(scene_deduction)
        emit("story.deduction_relayed", actor: :joon_gi_han, target: :ichiban, data: { deduction: "nanba_no_puede_ir_a_la_policia_corrrupta_acudira_a_Bleach_Japan", target_location: "Edificio Hakuryo - Carriage Hwy" })
        @state.set_flag(:hakuryo_building_target_active, true)
      end

      def generate_summary
        "Episodio 44_el_dilema_de_la_lealtad completado: Zhao y Hoshino exigen que Kasuga entregue a Nanba para silenciar la fuga del secreto bajo amenaza de muerte. Kasuga se niega categóricamente a vender a su amigo. Joon-gi Han interviene deduciendo que, acorralado sin poder confiar en la policía, Nanba buscará refugio en la sede de Bleach Japan en el Edificio Hakuryo."
      end
    end
  end
end
