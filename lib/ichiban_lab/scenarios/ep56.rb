# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep56 < IchibanLab::BaseScenario
      protected

      def episode_id
        "56_el_rescate_de_zhao"
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
        han = Character.new(
          id: :joon_gi_han,
          name: "Joon-gi Han",
          attributes: { role: :geomijul_vanguard },
          relationships: { ichiban: :reinforcement },
          belongings: []
        )
        seonhee = Character.new(
          id: :seonhee,
          name: "Seonhee",
          attributes: { role: :geomijul_leader },
          relationships: {},
          belongings: []
        )
        zheng = Character.new(
          id: :zheng,
          name: "Zheng",
          attributes: { role: :liumang_traitor, hp: 350 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "geomijul_reinforcement_delegation",
          location: "Campamento de Indigentes - Salida Norte",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
            joon_gi_han: han,
            seonhee: seonhee,
            zheng: zheng
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
            zhao_rescue_mission_active: true
          }
        )
      end

      def execute_scenario
        scene_delegation = Scene.new(
          id: :geomijul_reinforcement_delegation,
          title: "Asignación de Joon-gi Han como refuerzo",
          location: "Campamento de Indigentes - Salida Norte"
        )
        scene_delegation.add_precondition("La misión de rescate de Zhao debe estar activa") do |ws|
          ws.flag?(:zhao_rescue_mission_active)
        end

        scene_bounty = Scene.new(
          id: :restaurant_row_bounty_hunters,
          title: "Recompensa de Mabuchi y choque con Zheng en Restaurant Row",
          location: "Restaurant Row - Entrada a Qing Jin"
        )

        scene_qing_jin_gate = Scene.new(
          id: :qing_jin_entry,
          title: "Incursión a la fortaleza de Qing Jin",
          location: "Restaurante Qing Jin - Planta Baja"
        )

        # 1. Seonhee debe custodiar Geomijul y comisiona a Joon-gi Han como refuerzo de combate
        scene_delegation.check_preconditions!(@state)
        transition_to(scene_delegation)
        emit("story.party_reinforcement_joined", actor: :joon_gi_han, target: :ichiban, data: { sender: "Seonhee", mission: "rescatar_a_zhao_en_qing_jin" })
        @state.set_flag(:han_joined_party, true)

        # 2. Incursión en Restaurant Row: Zheng revela la recompensa de ¥100 millones por cabeza
        transition_to(scene_bounty, new_location: "Restaurant Row - Entrada a Qing Jin")
        emit("story.bounty_announced", actor: :zheng, target: :ichiban, data: { bounty: 100_000_000, sponsor: "Akira Mabuchi" })
        emit("story.combat_resolved", actor: :ichiban, target: :zheng, data: { victory: true, status: "zheng_derrotado" })
        emit("story.zhao_hostage_confirmed", actor: :zheng, data: { location: "Qing Jin - Planta Superior", motive: "mabuchi_exige_entrega_de_todos_los_activos" })

        # 3. Acceso al interior del restaurante Qing Jin
        transition_to(scene_qing_jin_gate, new_location: "Restaurante Qing Jin - Planta Baja")
        emit("story.building_infiltrated", actor: :ichiban, data: { fortress: "Qing Jin" })
        @state.set_flag(:qing_jin_infiltrated, true)
      end

      def generate_summary
        "Episodio 56_el_rescate_de_zhao completado: Seonhee envía a Joon-gi Han como refuerzo del equipo mientras ella sostiene la retaguardia de Geomijul. En Restaurant Row, el grupo supera la emboscada de Zheng, quien confiesa que Mabuchi puso una recompensa de ¥100 millones sobre sus cabezas y retiene a Zhao en Qing Jin para quedarse con sus activos."
      end
    end
  end
end
