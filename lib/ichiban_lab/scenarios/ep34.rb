# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep34 < IchibanLab::BaseScenario
      protected

      def episode_id
        "34_la_chispa_del_conflicto"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { nanba: :sworn_partner, adachi: :brother_in_arms, saeko: :protectee },
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :party_member },
          relationships: { ichiban: :sworn_partner },
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

        WorldState.new(
          episode: episode_id,
          scene_id: "phone_call_with_hoshino",
          location: "Isezaki Ijincho - Isezaki Road",
          time_period: "2019 - Noche",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample],
          flags: { reached_surface: true }
        )
      end

      def execute_scenario
        scene_call = Scene.new(
          id: :phone_call_with_hoshino,
          title: "Llamada urgente al Patriarca Hoshino",
          location: "Isezaki Ijincho - Isezaki Road"
        )
        scene_call.add_precondition("El grupo debe haber alcanzado la superficie con señal telefónica") do |ws|
          ws.flag?(:reached_surface)
        end

        scene_murders = Scene.new(
          id: :street_killings_and_takabe_departure,
          title: "Los asesinatos en Isezaki Road y la partida de Takabe",
          location: "Isezaki Ijincho - Isezaki Road"
        )

        scene_deduction = Scene.new(
          id: :deduction_of_mabuchi_conspiracy,
          title: "Desentrañando la conspiración de Mabuchi",
          location: "Isezaki Ijincho - Isezaki Road"
        )

        # 1. Kasuga llama de inmediato al presidente Ryuhei Hoshino
        scene_call.check_preconditions!(@state)
        transition_to(scene_call)
        emit("story.intel_warning_relayed", actor: :ichiban, target: :ryuhei_hoshino, data: { warning: "mabuchi_planea_destruir_el_gran_muro_del_musculo" })

        # 2. Hoshino revela los asesinatos en plena vía pública y la represalia de Takabe
        transition_to(scene_murders)
        emit("story.yakuza_murders_reported", actor: :ryuhei_hoshino, target: :ichiban, data: { victims: "dos_oficiales_del_clan_seiryu", location: "Isezaki Road", culprits: "sicarios_de_liumang" })
        emit("story.unauthorized_retaliation", actor: :mamoru_takabe, data: { action: "conduce_camion_hacia_restaurant_row", purpose: "venganza_sin_autorizacion_del_patriarca" })
        @state.set_flag(:takabe_on_warpath, true)

        # 3. Deducción del grupo: Nonomiya fue sólo el cebo para arrastrarlos y culpar al Seiryu
        transition_to(scene_deduction)
        emit("story.conspiracy_deduced", actor: :adachi, data: { deduction: "mabuchi_uso_la_muerte_de_nonomiya_para_provocar_la_guerra_sin_recibir_represalia_directa" })
        emit("story.objective_started", actor: :ichiban, data: { objective: "detener_la_guerra_en_restaurant_row" })
        @state.set_flag(:restaurant_row_objective_active, true)
      end

      def generate_summary
        "Episodio 34_la_chispa_del_conflicto completado: Kasuga contacta al Patriarca Hoshino para advertirle del plan de Mabuchi, enterándose de que dos miembros del Seiryu fueron ejecutados públicamente por los Liumang y que el capitán Takabe conduce un camión hacia Restaurant Row en busca de venganza. El grupo deduce la trama y corre a impedir la matanza."
      end
    end
  end
end
