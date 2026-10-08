# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep58 < IchibanLab::BaseScenario
      protected

      def episode_id
        "58_el_retorno_de_nanba"
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
          relationships: { ichiban: :comrade },
          belongings: []
        )
        ishioda = Character.new(
          id: :reiji_ishioda,
          name: "Reiji Ishioda",
          attributes: { role: :omi_lieutenant, hp: 600 },
          relationships: {},
          belongings: []
        )
        nanba = Character.new(
          id: :nanba,
          name: "Yu Nanba",
          attributes: { role: :returning_brother },
          relationships: { ichiban: :sworn_brother },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "ishioda_rematch_showdown",
          location: "Restaurante Qing Jin - Salón Superior",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            adachi: adachi,
            saeko: saeko,
            joon_gi_han: han,
            reiji_ishioda: ishioda,
            nanba: nanba
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
            mabuchi_overthrown: true
          }
        )
      end

      def execute_scenario
        scene_ishioda = Scene.new(
          id: :ishioda_rematch_showdown,
          title: "Revancha a muerte contra Reiji Ishioda",
          location: "Restaurante Qing Jin - Salón Superior"
        )
        scene_ishioda.add_precondition("Mabuchi debe haber sido derrocado en Qing Jin") do |ws|
          ws.flag?(:mabuchi_overthrown)
        end

        scene_nanba_return = Scene.new(
          id: :nanba_dramatic_return,
          title: "El regreso decisivo de Nanba a la batalla",
          location: "Restaurante Qing Jin - Salón Superior"
        )

        scene_reunion = Scene.new(
          id: :brotherhood_handshake_and_shoichi_update,
          title: "Apretón de manos de hermandad y noticias de Shoichi",
          location: "Restaurante Qing Jin - Salón Superior"
        )

        # 1. Ishioda ataca con furia asesina
        scene_ishioda.check_preconditions!(@state)
        transition_to(scene_ishioda)
        emit("story.lieutenant_duel_initiated", actor: :reiji_ishioda, target: :ichiban, data: { status: "combate_a_muerte_sin_maquinaria" })

        # 2. Nanba regresa a la contienda disculpándose y apoyando al grupo
        transition_to(scene_nanba_return)
        emit("story.nanba_rejoined_combat", actor: :nanba, target: :ichiban, data: { declaration: "estaba_preocupado_por_ustedes_me_quedo_definitivamente" })
        emit("story.boss_defeated", actor: :ichiban, target: :reiji_ishioda, data: { victory: true, status: "ishioda_doblegado" })
        @state.set_flag(:ishioda_subdued, true)

        # 3. Abrazo y apretón de manos: Nanba se reintegra al grupo y relata el buen trato hacia su hermano
        transition_to(scene_reunion)
        emit("story.brotherhood_restored", actor: :ichiban, target: :nanba, data: { pact: "hermandad_sellada_con_apreton_de_manos" })
        emit("story.shoichi_marriage_news", actor: :nanba, data: { update: "shoichi_bien_cuidado_por_geomijul_planea_casarse_con_su_cuidadora" })
        @state.set_flag(:nanba_permanently_rejoined, true)
      end

      def generate_summary
        "Episodio 58_el_retorno_de_nanba completado: Tras la caída de Mabuchi, Reiji Ishioda desata un combate a muerte. En el clímax, Nanba regresa para pelear hombro con hombro junto a sus amigos. Tras derrotar a Ishioda, Kasuga y Nanba estrechan sus manos restaurando su hermandad inquebrantable, y Nanba confirma que su hermano Shoichi planea casarse con su cuidadora de Geomijul."
      end
    end
  end
end
