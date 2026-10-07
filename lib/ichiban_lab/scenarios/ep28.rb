# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep28 < IchibanLab::BaseScenario
      protected

      def episode_id
        "28_la_resistencia_vecinal"
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
        kume = Character.new(
          id: :kume,
          name: "Sota Kume",
          attributes: { role: :bleach_japan_branch_leader },
          relationships: {},
          belongings: []
        )
        bleach_mob = Character.new(
          id: :bleach_mob,
          name: "Manifestantes de Bleach Japan",
          attributes: { hp: 180 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "bleach_japan_otohime_protest",
          location: "Exterior de Otohime Land",
          time_period: "2019 - Mañana",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, kume: kume, bleach_mob: bleach_mob },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key],
          flags: { dock_infiltration_active: true }
        )
      end

      def execute_scenario
        scene_protest = Scene.new(id: :bleach_japan_otohime_protest, title: "Celebración y burla de Bleach Japan frente al soapland", location: "Exterior de Otohime Land")
        scene_protest.add_precondition("La infiltración inicial en el muelle debe estar activa") do |ws|
          ws.flag?(:dock_infiltration_active)
        end

        scene_brawl = Scene.new(id: :slap_and_brawl_with_kume, title: "La bofetada de Saeko y combate callejero", location: "Exterior de Otohime Land")
        scene_community = Scene.new(id: :community_standing_ovation, title: "Solidaridad vecinal y rechazo a los puritanos", location: "Barrio de Otohime Land")

        # 1. Hostigamiento de Kume celebrando el suicidio de Nonomiya
        scene_protest.check_preconditions!(@state)
        transition_to(scene_protest)
        emit("story.provocation_detected", actor: :kume, target: :saeko, data: { words: "Nonomiya hizo un favor a la sociedad quitándose la vida" })

        # 2. Reacción inmediata: bofetada de Saeko, puñetazo de Ichiban y combate
        transition_to(scene_brawl)
        emit("story.moral_retaliation", actor: :saeko, target: :kume, data: { action: "bofetada_a_kume" })
        emit("story.combat_resolved", actor: :ichiban, target: :bleach_mob, data: { assisted_by: [:nanba, :adachi, :saeko], victory: true })
        @state.set_flag(:bleach_japan_humiliated, true)

        # 3. La comunidad local de comerciantes y vecinos apoya al grupo de Ichiban
        transition_to(scene_community, new_time: "2019 - Tarde")
        emit("story.community_solidarity", actor: :ichiban, data: { message: "comerciantes_y_vecinos_expulsan_a_bleach_japan", gratitude: true })
        @state.set_flag(:local_community_allies, true)

        emit("story.objective_completed", actor: :ichiban, data: { objective: "regresar_a_la_investigacion_del_almacen" })
      end

      def generate_summary
        "Episodio 28_la_resistencia_vecinal completado: Saeko e Ichiban responden con fuerza ante las burlas de Sota Kume frente al cadáver de Nonomiya. La comunidad de comerciantes de Ijincho se moviliza en su apoyo y expulsa a Bleach Japan."
      end
    end
  end
end
