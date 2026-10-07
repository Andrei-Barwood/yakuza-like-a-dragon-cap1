# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep33 < IchibanLab::BaseScenario
      protected

      def episode_id
        "33_el_duelo_de_la_excavadora"
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
        yan = Character.new(
          id: :yan,
          name: "Yan",
          attributes: { role: :excavator_pilot, hp: 350 },
          relationships: {},
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "smuggling_tunnel_climb",
          location: "Túneles de Contrabando Subterráneo - B2F",
          time_period: "2019 - Noche",
          money: 26300,
          characters: { ichiban: ichiban, nanba: nanba, adachi: adachi, saeko: saeko, yan: yan },
          inventory: [:nick_ogata_business_card, :counterfeit_10k_bill, :seiryu_clan_key, :counterfeit_yuan_sample],
          flags: { gear_recovered: true, party_freed: true }
        )
      end

      def execute_scenario
        scene_ascent = Scene.new(
          id: :smuggling_tunnel_climb,
          title: "Ascenso por la ruta subterránea de contrabando",
          location: "Túneles de Contrabando Subterráneo - B2F"
        )
        scene_ascent.add_precondition("El grupo debe haber recuperado su equipamiento y libertad") do |ws|
          ws.flag?(:gear_recovered) && ws.flag?(:party_freed)
        end

        scene_excavator = Scene.new(
          id: :excavator_boss_battle,
          title: "Combate contra la excavadora pesada de Yan",
          location: "Cámara Subterránea de Extracción - B1F"
        )

        scene_surface = Scene.new(
          id: :surface_breakthrough,
          title: "Salida a la superficie de Ijincho",
          location: "Distrito Comercial de Isezaki Ijincho - Callejón Trasero"
        )

        # 1. Combates por los túneles hasta B1F
        scene_ascent.check_preconditions!(@state)
        transition_to(scene_ascent)
        emit("story.tunnel_navigation", actor: :ichiban, data: { status: "abriendo_paso_entre_patrullas_de_liumang" })

        # 2. Batalla de jefe contra Yan montado en la excavadora pesada
        transition_to(scene_excavator, new_location: "Cámara Subterránea de Extracción - B1F")
        emit("story.heavy_machinery_assault", actor: :yan, target: :ichiban, data: { vehicle: "excavadora_de_construccion_pesada", threat: "cucharón_hidráulico" })
        emit("story.boss_defeated", actor: :ichiban, target: :yan, data: { defeat_type: "excavadora_inutilizada_y_yan_noqueado", assisted_by: [:nanba, :adachi, :saeko] })
        @state.set_flag(:yan_excavator_defeated, true)

        # 3. Retorno a la superficie; Adachi confirma que era un túnel de contrabando
        transition_to(scene_surface, new_location: "Distrito Comercial de Isezaki Ijincho - Callejón Trasero")
        emit("story.surface_reached", actor: :adachi, data: { discovery: "red_de_contrabando_de_liumang_conectada_a_los_muelles" })
        @state.set_flag(:reached_surface, true)
      end

      def generate_summary
        "Episodio 33_el_duelo_de_la_excavadora completado: El grupo asciende a través de los túneles subterráneos de contrabando hasta B1F, donde Yan intenta aplastarlos a bordo de una excavadora pesada. Tras inutilizar la maquinaria y noquear a Yan, logran salir con vida a la superficie de Isezaki Ijincho."
      end
    end
  end
end
