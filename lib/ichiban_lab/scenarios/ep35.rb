# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep35 < IchibanLab::BaseScenario
      protected

      def episode_id
        "35_camino_a_restaurant_row"
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
        takabe = Character.new(
          id: :mamoru_takabe,
          name: "Mamoru Takabe",
          attributes: { role: :seiryu_captain, hp: 400 },
          relationships: { ichiban: :frenemy },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "restaurant_row_carnage_entry",
          location: "Restaurant Row - Entrada del Barrio Chino",
          time_period: "2019 - Noche",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, mamoru_takabe: takabe },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample],
          flags: { restaurant_row_objective_active: true, takabe_on_warpath: true }
        )
      end

      def execute_scenario
        scene_row = Scene.new(
          id: :restaurant_row_carnage_entry,
          title: "Incursión en el devastado Restaurant Row",
          location: "Restaurant Row - Entrada del Barrio Chino"
        )
        scene_row.add_precondition("El objetivo de frenar la guerra debe estar activo") do |ws|
          ws.flag?(:restaurant_row_objective_active)
        end

        scene_gunshot = Scene.new(
          id: :warning_shot_at_qing_jin,
          title: "El disparo de advertencia frente a Qing Jin",
          location: "Restaurante Qing Jin - Puertas Exteriores"
        )

        scene_duel = Scene.new(
          id: :bare_knuckle_duel_with_takabe,
          title: "Duelo a puño limpio contra el Capitán Takabe",
          location: "Restaurante Qing Jin - Puertas Exteriores"
        )

        # 1. Cruzar los callejones de Restaurant Row repletos de heridos
        scene_row.check_preconditions!(@state)
        transition_to(scene_row)
        emit("story.street_battle_crossing", actor: :ichiban, data: { status: "miembros_de_liumang_derrotados_en_las_calles", danger_level: :extreme })

        # 2. Llegada al exterior del restaurante Qing Jin y disparo de Takabe
        transition_to(scene_gunshot, new_location: "Restaurante Qing Jin - Puertas Exteriores")
        emit("story.gunshot_warning", actor: :mamoru_takabe, target: :ichiban, data: { projectile: "bala_a_los_pies_de_ichiban", stance: "dispuesto_a_la_guerra_por_sus_subordinados" })
        emit("story.truth_rejected", actor: :mamoru_takabe, data: { explanation: "aun_sabiendo_que_es_una_trampa_debe_vengar_la_sangre" })

        # 3. Duelo desarmado hombre a hombre entre Ichiban y Takabe
        transition_to(scene_duel)
        emit("story.honor_duel_initiated", actor: :ichiban, target: :mamoru_takabe, data: { terms: "combate_a_puño_limpio_sin_armas" })
        emit("story.boss_defeated", actor: :ichiban, target: :mamoru_takabe, data: { victory: true, condition: "takabe_contenido_por_la_fuerza" })
        @state.set_flag(:takabe_subdued, true)
      end

      def generate_summary
        "Episodio 35_camino_a_restaurant_row completado: Ichiban y sus compañeros se abren paso por los callejones ensangrentados de Restaurant Row hasta llegar a las puertas de Qing Jin. Takabe dispara cerca de Kasuga y afirma que irá a la guerra para vengar a sus muchachos aún sabiendo que es una trampa. Ichiban lo desafía a un combate desarmado y logra reducirlo a golpes."
      end
    end
  end
end
