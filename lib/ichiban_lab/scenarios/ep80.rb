# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep80 < IchibanLab::BaseScenario
      protected

      def episode_id
        "80_la_aparicion_del_dragon"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader, emotional_state: :blinded_by_rage },
          relationships: { kume: :evading_target },
          belongings: []
        )
        kiryu = Character.new(
          id: :kazuma_kiryu,
          name: "Kazuma Kiryu (Hombre Misterioso)",
          attributes: { role: :legendary_dragon, status: :guardian },
          relationships: { ichiban: :disciplinarian },
          belongings: []
        )
        saeko = Character.new(
          id: :saeko_mukoda,
          name: "Saeko Mukoda",
          attributes: { role: :party_member },
          relationships: { ichiban: :voice_of_reason },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "hakuryo_building_empty_office",
          location: "Edificio Hakuryo - Yokohama",
          time_period: "2019 - Día",
          money: 26300,
          characters: {
            ichiban: ichiban,
            kazuma_kiryu: kiryu,
            saeko_mukoda: saeko
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :seiryu_crest,
            :raw_pork_buns,
            :zhao_cooking_recipe,
            :survive_bar_master_cup,
            :hamako_warm_handkerchief,
            :commemorative_photo_osaka
          ],
          flags: {
            ep79_completed: true,
            target_hakuryo_building_set: true
          }
        )
      end

      def define_scenes
        scene_empty = Scene.new(
          id: :hakuryo_building_empty_office,
          title: "Oficina vacía de Bleach Japan y combate callejero frente al edificio",
          location: "Edificio Hakuryo - Yokohama"
        )
        scene_empty.add_precondition("El objetivo de Hakuryo debe estar fijado") do |ws|
          ws.flag?(:ep79_completed) && ws.flag?(:target_hakuryo_building_set)
        end

        scene_interrogation = Scene.new(
          id: :brutal_interrogation_restrained,
          title: "Interrogatorio violento al sicario y freno providencial de Kazuma Kiryu",
          location: "Exterior del Edificio Hakuryo"
        )
        scene_interrogation.add_precondition("Los matones de Hakuryo deben haber sido reducidos") do |ws|
          ws.flag?(:hakuryo_omi_thugs_defeated)
        end

        scene_geomijul_invitation = Scene.new(
          id: :kiryu_geomijul_rendezvous_set,
          title: "Kiryu cita a Kasuga en Geomijul al caer la noche",
          location: "Exterior del Edificio Hakuryo"
        )
        scene_geomijul_invitation.add_precondition("Kiryu debe haber detenido a Kasuga") do |ws|
          ws.flag?(:kiryu_intervened_rage_halted)
        end

        [scene_empty, scene_interrogation, scene_geomijul_invitation]
      end

      def execute_scenario
        scene_empty, scene_interrogation, scene_geomijul_invitation = define_scenes

        # 1. En Hakuryo, oficinas abiertas y combate contra la Tokyo Omi exterior
        scene_empty.check_preconditions!(@state)
        emit("story.hakuryo_office_deserted", actor: :ichiban, data: { status: "kume_no_esta_en_la_oficina" })
        emit("story.combat_resolved", actor: :ichiban, target: :hakuryo_tokyo_omi, data: { result: :thugs_subdued })
        @state.set_flag(:hakuryo_omi_thugs_defeated, true)

        # 2. Kasuga pierde el control moliendo a golpes al matón hasta que Kiryu lo detiene con una mano
        transition_to(scene_interrogation)
        emit("story.thug_confesses_kume_flight", actor: :tokyo_omi_thug, target: :ichiban, data: {
          intel: "kume_huyo_a_kamurocho_bajo_escolta"
        })
        emit("story.kiryu_stops_ichiban_rage", actor: :kazuma_kiryu, target: :ichiban, data: {
          restraint: "kiryu_frena_el_punetazo_mortal_de_kasuga_advirtiendo_que_la_ira_lo_cega"
        })
        @state.set_flag(:kiryu_intervened_rage_halted, true)

        # 3. Citación en la red Geomijul tras el anochecer
        transition_to(scene_geomijul_invitation)
        emit("story.kiryu_geomijul_summons", actor: :kazuma_kiryu, target: :ichiban, data: {
          warning: "el_siguiente_movimiento_de_aoki_ocurrira_en_ijincho",
          rendezvous: "reunirse_en_geomijul_al_anochecer_cuando_seonhee_restaure_el_sistema"
        })
        @state.set_flag(:geomijul_meeting_scheduled, true)
        @state.set_flag(:ep80_completed, true)
      end

      def generate_summary
        "Episodio 80_la_aparicion_del_dragon completado: En el edificio Hakuryo, Kume ya se ha marchado y la Tokyo Omi cerca el lugar. Tras derrotarlos, Kasuga pierde los estribos moliendo a golpes a un subordinado hasta enterarse de que Kume huyó a Kamurocho. Kazuma Kiryu interviene con fuerza imponente deteniendo la furia descontrolada de Kasuga, advirtiéndole que Aoki atacará en Ijincho y convocándolo a un encuentro en la base recuperada de Geomijul tras el anochecer."
      end
    end
  end
end
