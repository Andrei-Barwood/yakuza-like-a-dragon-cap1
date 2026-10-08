# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep57 < IchibanLab::BaseScenario
      protected

      def episode_id
        "57_el_dragon_y_el_tigre"
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
          attributes: { role: :party_member },
          relationships: { ichiban: :reinforcement },
          belongings: []
        )
        mabuchi = Character.new(
          id: :akira_mabuchi,
          name: "Akira Mabuchi",
          attributes: { role: :usurper_boss, hp: 600 },
          relationships: {},
          belongings: []
        )
        tendo = Character.new(
          id: :yosuke_tendo,
          name: "Yosuke Tendo",
          attributes: { role: :omi_lieutenant },
          relationships: {},
          belongings: []
        )
        ishioda = Character.new(
          id: :reiji_ishioda,
          name: "Reiji Ishioda",
          attributes: { role: :omi_lieutenant, hp: 550 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "qing_jin_tiger_gauntlet",
          location: "Restaurante Qing Jin - Planta Baja",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
            joon_gi_han: han,
            akira_mabuchi: mabuchi,
            yosuke_tendo: tendo,
            reiji_ishioda: ishioda
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
            qing_jin_infiltrated: true,
            han_joined_party: true
          }
        )
      end

      def execute_scenario
        scene_tiger = Scene.new(
          id: :qing_jin_tiger_gauntlet,
          title: "El foso y el ataque del tigre en Qing Jin",
          location: "Restaurante Qing Jin - Patio Central"
        )
        scene_tiger.add_precondition("Qing Jin debe haber sido infiltrado") do |ws|
          ws.flag?(:qing_jin_infiltrated)
        end

        scene_tendo = Scene.new(
          id: :top_floor_summit_with_tendo_and_mabuchi,
          title: "Encuentro en la cima con Mabuchi, Ishioda y Yosuke Tendo",
          location: "Restaurante Qing Jin - Salón Superior"
        )

        scene_mabuchi_fall = Scene.new(
          id: :mabuchi_final_overthrow,
          title: "Derrota definitiva de Akira Mabuchi",
          location: "Restaurante Qing Jin - Salón Superior"
        )

        # 1. Asalto a Qing Jin y combate contra la bestia (el tigre de Qing Jin)
        scene_tiger.check_preconditions!(@state)
        transition_to(scene_tiger, new_location: "Restaurante Qing Jin - Patio Central")
        emit("story.beast_unleashed", actor: :ichiban, data: { opponent: "Tigre de combate de Qing Jin", status: "superado" })
        @state.set_flag(:tiger_defeated, true)

        # 2. Encuentro en la planta alta con Mabuchi, Ishioda y la presentación de Yosuke Tendo
        transition_to(scene_tendo, new_location: "Restaurante Qing Jin - Salón Superior")
        emit("story.tendo_introduced", actor: :yosuke_tendo, data: { grudge: "rencor_hacia_masumi_arakawa_por_arrebatarle_su_puesto" })
        emit("story.tendo_withheld_combat", actor: :yosuke_tendo, target: :ichiban, data: { verdict: "aun_no_estas_listo_para_pelear_conmigo" })

        # 3. Batalla definitiva contra Akira Mabuchi y su caída final
        transition_to(scene_mabuchi_fall)
        emit("story.boss_defeated", actor: :ichiban, target: :akira_mabuchi, data: { victory: true, condition: "mabuchi_vencido_definitivamente" })
        @state.set_flag(:mabuchi_overthrown, true)
      end

      def generate_summary
        "Episodio 57_el_dragon_y_el_tigre completado: En las entrañas de Qing Jin, Kasuga y sus compañeros vencen al tigre de combate que les corta el paso y alcanzan el salón superior. Allí son recibidos por Mabuchi y los altos mandos de la Omi: Ishioda y Yosuke Tendo. Tendo decide no pelear por considerarlos verdes, pero el grupo abate a Akira Mabuchi de manera definitiva."
      end
    end
  end
end
