# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep52 < IchibanLab::BaseScenario
      protected

      def episode_id
        "52_la_bola_de_demolicion"
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
        ishioda = Character.new(
          id: :reiji_ishioda,
          name: "Reiji Ishioda",
          attributes: { role: :omi_lieutenant, hp: 500 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "wrecking_ball_arrival",
          location: "Koreatown - Entrada a Geomijul",
          time_period: "2019 - Mediodía",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
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
            kume_vanguard_dispersed: true
          }
        )
      end

      def execute_scenario
        scene_crane = Scene.new(
          id: :wrecking_ball_arrival,
          title: "Llegada de la grúa con bola de demolición",
          location: "Koreatown - Entrada a Geomijul"
        )
        scene_crane.add_precondition("La vanguardia de Kume debe haber sido dispersada") do |ws|
          ws.flag?(:kume_vanguard_dispersed)
        end

        scene_boss = Scene.new(
          id: :ishioda_crane_battle,
          title: "Batalla de jefe contra Reiji Ishioda y su grúa",
          location: "Koreatown - Entrada a Geomijul"
        )

        scene_aftermath = Scene.new(
          id: :breach_and_escape,
          title: "Destrucción de la barricada y repliegue de emergencia",
          location: "Koreatown - Callejón Trasero"
        )

        # 1. Aparición de Reiji Ishioda a bordo de una grúa con bola de demolición
        scene_crane.check_preconditions!(@state)
        transition_to(scene_crane)
        emit("story.crane_operator_revealed", actor: :reiji_ishioda, data: { vehicle: "grua_con_bola_de_demolicion", objective: "derribar_el_bastion_de_geomijul" })
        emit("story.kasuga_recognized", actor: :reiji_ishioda, target: :ichiban, data: { memory: "el_hombre_al_que_arakawa_disparo_en_kamurocho" })

        # 2. Batalla contra Ishioda manejando la maquinaria pesada
        transition_to(scene_boss)
        emit("story.wrecking_ball_boss_battle", actor: :ichiban, target: :reiji_ishioda, data: { victory: true, status: "vehiculo_danado_temporalmente" })
        @state.set_flag(:ishioda_crane_repelled, true)

        # 3. Ishioda estrella la bola contra la fachada exterior rompiendo la barricada
        transition_to(scene_aftermath, new_location: "Koreatown - Callejón Trasero")
        emit("story.barrier_demolished", actor: :reiji_ishioda, data: { impact: "fachada_destruida_abriendo_paso_a_cientos_de_matones" })
        emit("story.three_lieutenants_briefing", actor: :adachi, data: { lieutenants: ["Reiji Ishioda", "Jo Sawashiro", "Yosuke Tendo"] })
        @state.set_flag(:geomijul_perimeter_breached, true)
      end

      def generate_summary
        "Episodio 52_la_bola_de_demolicion completado: El lugarteniente de la Omi Reiji Ishioda asalta la entrada de Geomijul conduciendo una grúa con bola de demolición. Al reconocer a Kasuga como el superviviente del disparo de Arakawa, desata un feroz combate mecánico. Kasuga logra neutralizar la máquina, pero Ishioda colapsa el edificio con un último impacto, obligando al grupo a replegarse."
      end
    end
  end
end
