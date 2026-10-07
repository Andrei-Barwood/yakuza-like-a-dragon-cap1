# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep37 < IchibanLab::BaseScenario
      protected

      def episode_id
        "37_el_barrio_coreano"
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
          scene_id: "koreatown_investigation",
          location: "Yokohama Koreatown - Calles Principales",
          time_period: "2019 - Medianoche",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample],
          flags: { chapter_6_completed: true, geomijul_lead_unlocked: true, temporary_ceasefire_active: true }
        )
      end

      def execute_scenario
        scene_koreatown = Scene.new(
          id: :koreatown_investigation,
          title: "Incursión en Koreatown",
          location: "Yokohama Koreatown - Calles Principales"
        )
        scene_koreatown.add_precondition("La tregua y la pista de Geomijul deben estar activas") do |ws|
          ws.flag?(:geomijul_lead_unlocked) && ws.flag?(:temporary_ceasefire_active)
        end

        scene_guide = Scene.new(
          id: :mysterious_woman_guidance,
          title: "El encuentro con la guía enigmática",
          location: "Yokohama Koreatown - Callejones Oscuros"
        )

        scene_spider_threshold = Scene.new(
          id: :spider_web_entrance,
          title: "A las puertas de la telaraña",
          location: "Edificio Abandonado de Geomijul - Fachada"
        )

        # 1. Llegada a Koreatown en busca de la red de espionaje
        scene_koreatown.check_preconditions!(@state)
        transition_to(scene_koreatown)
        emit("story.intel_mission_started", actor: :ichiban, data: { target: "Geomijul", motive: "obtener_evidencia_definitiva_contra_mabuchi" })

        # 2. Encuentro con la mujer misteriosa
        transition_to(scene_guide, new_location: "Yokohama Koreatown - Callejones Oscuros")
        emit("story.mysterious_guide_contacted", actor: :mysterious_woman, target: :ichiban, data: { warning: "pueden_dar_media_vuelta_si_lo_desean" })
        @state.set_flag(:mysterious_woman_followed, true)

        # 3. Llegada al edificio ruinoso envuelto en cables eléctricos
        transition_to(scene_spider_threshold, new_location: "Edificio Abandonado de Geomijul - Fachada")
        emit("story.spider_web_discovered", actor: :adachi, data: { etymology: "Geomijul significa Telaraña en coreano", structure: "edificio_decrépito_blindado" })
        @state.set_flag(:geomijul_entrance_reached, true)
      end

      def generate_summary
        "Episodio 37_el_barrio_coreano completado: El grupo se interna en Koreatown para buscar a la red Geomijul antes de que expire la tregua de Zhao. Una mujer enigmática los guía por callejones oscuros hasta un edificio decrépito cubierto de cableado eléctrico, advirtiéndoles que la verdad se encuentra en la cima."
      end
    end
  end
end
