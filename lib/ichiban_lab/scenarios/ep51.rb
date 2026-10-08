# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep51 < IchibanLab::BaseScenario
      protected

      def episode_id
        "51_la_marcha_de_los_mil"
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
        kume = Character.new(
          id: :sota_kume,
          name: "Sota Kume",
          attributes: { role: :bleach_japan_branch_leader },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "zhao_urgent_call",
          location: "Distrito Comercial - Alrededores de la Residencia",
          time_period: "2019 - Mañana",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
            tianyou_zhao: zhao,
            sota_kume: kume
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
            totsuka_subdued: true,
            hamako_protected: true
          }
        )
      end

      def execute_scenario
        scene_call = Scene.new(
          id: :zhao_urgent_call,
          title: "Llamada urgente de Tianyou Zhao",
          location: "Distrito Comercial - Alrededores de la Residencia"
        )
        scene_call.add_precondition("Hamako debe haber sido protegida del asedio de Totsuka") do |ws|
          ws.flag?(:hamako_protected)
        end

        scene_approach = Scene.new(
          id: :koreatown_perimeter_approach,
          title: "Aproximación al perímetro de Koreatown",
          location: "Isezaki Road - Perímetro de Koreatown"
        )

        scene_kume = Scene.new(
          id: :kume_clash_and_revelation,
          title: "Choque con Sota Kume y revelación de la infiltración de la Omi",
          location: "Isezaki Road - Perímetro de Koreatown"
        )

        # 1. Llamada de Zhao: golpe de estado interno en Liumang y 1.000 miembros de Bleach Japan/Omi marchando hacia Geomijul
        scene_call.check_preconditions!(@state)
        transition_to(scene_call)
        emit("story.zhao_intelligence_relayed", actor: :tianyou_zhao, target: :ichiban, data: { threat: "1000_manifestantes_de_bleach_japan_infiltrados_por_omi_avanzan_a_geomijul", liunang_status: "zhao_lidiando_con_el_golpe_de_estado_de_mabuchi", deal: "olvidar_a_nanba_si_defienden_a_geomijul" })
        @state.set_flag(:zhao_pact_honored, true)

        # 2. Desplazamiento urgente hacia el barrio coreano
        transition_to(scene_approach, new_location: "Isezaki Road - Perímetro de Koreatown")
        emit("story.march_witnessed", actor: :ichiban, data: { crowd_size: 1000, banners: "Bleach Japan Yokohama Division" })

        # 3. Enfrentamiento con los matones de Kume y confesión de Kume
        transition_to(scene_kume)
        emit("story.kume_thugs_defeated", actor: :ichiban, target: :sota_kume, data: { victory: true })
        emit("story.kume_ignorance_admitted", actor: :sota_kume, data: { admission: "kume_desconocia_que_los_manifestantes_eran_yakuza_de_la_omi" })
        @state.set_flag(:kume_vanguard_dispersed, true)
      end

      def generate_summary
        "Episodio 51_la_marcha_de_los_mil completado: Zhao telefonea a Kasuga revelando que Mabuchi provocó un golpe de estado en los Liumang y que mil manifestantes de Bleach Japan —en su mayoría matones de la Alianza Omi enviados por Ogasawara— avanzan hacia Geomijul. Al interceptar a la vanguardia, Kasuga vence a los matones de Kume, quien admite anonadado no saber que sus reclutas eran yakuza."
      end
    end
  end
end
