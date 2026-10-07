# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep24 < IchibanLab::BaseScenario
      protected

      def episode_id
        "24_el_dragon_del_seiryu"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { nanba: :sworn_partner, adachi: :brother_in_arms },
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
        hoshino = Character.new(
          id: :hoshino,
          name: "Ryuhei Hoshino",
          attributes: { role: :seiryu_clan_chairman },
          relationships: {},
          belongings: []
        )
        takabe = Character.new(
          id: :takabe,
          name: "Mamoru Takabe",
          attributes: { role: :seiryu_clan_captain },
          relationships: {},
          belongings: []
        )
        nanoha = Character.new(
          id: :nanoha,
          name: "Nanoha Mukoda",
          attributes: { role: :relieved_daughter },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "seiryu_headquarters_infiltration",
          location: "Sede del Clan Seiryu - Pasillos interiores",
          time_period: "2019 - Mediodía",
          money: 6300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, hoshino: hoshino, takabe: takabe, nanoha: nanoha },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill],
          flags: { escorting_totsuka_to_seiryu: true, tatsuro_mukoda_rescued: true }
        )
      end

      def execute_scenario
        scene_infil = Scene.new(id: :seiryu_headquarters_infiltration, title: "Infiltración y rescate en la ventana", location: "Sede del Clan Seiryu - Pasillos interiores")
        scene_infil.add_precondition("Tatsuro debe haber sido rescatado y Totsuka llevado al clan") do |ws|
          ws.flag?(:escorting_totsuka_to_seiryu)
        end

        scene_hoshino = Scene.new(id: :hoshino_audience_and_counterfeit, title: "Audiencia con el Patriarca Hoshino y el billete", location: "Sede del Clan Seiryu - Despacho del Presidente")
        scene_nanoha_restitution = Scene.new(id: :nanoha_restitution, title: "Restitución de fondos a Nanoha Mukoda", location: "Exterior de Sunlight Castle")
        scene_tragedy = Scene.new(id: :nonomiya_tragic_discovery, title: "El trágico destino de Nonomiya", location: "Otohime Land Soapland")

        # 1. Infiltración en la sede del Seiryu y acrobacia en la ventana
        scene_infil.check_preconditions!(@state)
        transition_to(scene_infil)
        emit("story.crisis_averted", actor: :ichiban, target: :nanba, data: { action: "salvar_a_nanba_y_adachi_colgados_de_la_ventana" })
        emit("story.item_acquired", actor: :ichiban, data: { item: :seiryu_clan_key })
        @state.add_item(:seiryu_clan_key)

        # 2. Encuentro con el Patriarca Ryuhei Hoshino y descubrimiento del billete falso
        transition_to(scene_hoshino, new_location: "Sede del Clan Seiryu - Despacho del Presidente")
        emit("story.counterfeit_bill_inspected", actor: :takabe, target: :ichiban, data: { reaction: "el_presidente_hoshino_reconoce_el_billete_falso_defectuoso" })
        emit("story.patriarch_verdict", actor: :hoshino, data: { decree: "expulsion_de_totsuka_y_cierre_de_sunlight_castle", respect_for_arakawa: true })
        @state.set_flag(:hoshino_respected_ichiban, true)

        # 3. Restitución a Nanoha y despedida de Otohime Land
        transition_to(scene_nanoha_restitution, new_location: "Exterior de Sunlight Castle", new_time: "2019 - Tarde")
        emit("story.money_restituted", actor: :takabe, target: :nanoha, data: { reason: "fondos_estafados_devueltos_tatsuro_a_salvo" })
        emit("story.nanoha_freed", actor: :ichiban, target: :nanoha, data: { resolution: "ya_no_necesita_trabajar_en_otohime_land" })
        @state.modify_money if respond_to?(:modify_money)
        @state.adjust_money(20000) # recompensa / bono prometido por el rescate
        emit("story.money_acquired", actor: :ichiban, data: { amount: 20000, total: @state.money, source: :nonomiya_bonus })

        # 4. Regreso a Otohime Land y shock: Nonomiya ahorcado
        transition_to(scene_tragedy, new_location: "Otohime Land Soapland", new_time: "2019 - Anochecer")
        emit("story.tragedy_discovered", actor: :ichiban, target: :nonomiya, data: { state: "hallado_ahorcado", mystery: "aparente_suicidio_o_ejecucion" })
        @state.set_flag(:nonomiya_found_dead, true)
        @state.set_flag(:chapter_4_completed, true)

        # Cierre y frontera del Capítulo 4
        emit("story.chapter_boundary", actor: :ichiban, data: { chapter: 4, status: :concluded, next: :chapter_5 })
      end

      def generate_summary
        "Episodio 24_el_dragon_del_seiryu completado: Ichiban confronta al presidente Ryuhei Hoshino mostrando el billete falso; Sunlight Castle es clausurado y los fondos devueltos a Nanoha. Al regresar a Otohime Land descubren el cadáver de Nonomiya ahorcado. Fin del Capítulo 4."
      end
    end
  end
end
