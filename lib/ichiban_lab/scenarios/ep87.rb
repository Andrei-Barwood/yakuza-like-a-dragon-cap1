# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep87 < IchibanLab::BaseScenario
      protected

      def episode_id
        "87_la_trampa_del_camaleon"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { aoki: :puppet_master, mirror_face: :unexpected_ally },
          belongings: []
        )
        aoki = Character.new(
          id: :ryo_aoki,
          name: "Ryo Aoki",
          attributes: { role: :tokyo_governor },
          relationships: { tendo: :enforcer, ichiban: :thorn_in_flesh },
          belongings: []
        )
        mirror_face = Character.new(
          id: :mirror_face,
          name: "Mirror Face",
          attributes: { role: :master_of_disguise },
          relationships: { ichiban: :debt_of_honor, aoki: :former_client },
          belongings: []
        )
        han = Character.new(
          id: :joon_gi_han,
          name: "Joon-gi Han",
          attributes: { role: :covert_specialist },
          relationships: { ichiban: :tactical_partner },
          belongings: []
        )
        saeko = Character.new(
          id: :saeko_mukoda,
          name: "Saeko Mukoda",
          attributes: { role: :intel_gatherer },
          relationships: { ichiban: :sworn_companion },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "election_night_headquarters",
          location: "Tokio - Sede Central del CLP (Noche Electoral)",
          time_period: "2019 - Noche Electoral",
          money: 26300,
          characters: {
            ichiban: ichiban,
            ryo_aoki: aoki,
            mirror_face: mirror_face,
            joon_gi_han: han,
            saeko_mukoda: saeko
          },
          inventory: [
            :nick_ogata_business_card,
            :counterfeit_10k_bill,
            :legendary_hero_bat,
            :masumi_arakawa_incense
          ],
          flags: {
            ep86_completed: true,
            tendo_defeated: true
          }
        )
      end

      def define_scenes
        scene_clp = Scene.new(
          id: "election_night_headquarters",
          title: "El Escándalo en la Sede del CLP",
          location: "Tokio - Gran Salón del CLP"
        )
        scene_clp.add_precondition do |state|
          state.flag?(:ep86_completed) && state.flag?(:tendo_defeated)
        end

        scene_office_ambush = Scene.new(
          id: "millennium_penthouse_ruse",
          title: "El Despacho Arakawa y el Rostro del Camaleón",
          location: "Kamurocho - Millennium Tower (Despacho Arakawa)"
        )
        scene_office_ambush.add_precondition do |state|
          state.flag?(:aoki_fled_clp_hq)
        end

        scene_live_broadcast = Scene.new(
          id: "incrimination_broadcast",
          title: "La Confesión Grabada ante el Mundo",
          location: "Kamurocho - Millennium Tower (Despacho Arakawa)"
        )
        scene_live_broadcast.add_precondition do |state|
          state.flag?(:mirror_face_impersonation_triggered)
        end

        [scene_clp, scene_office_ambush, scene_live_broadcast]
      end

      def execute_scenario
        scene_clp, scene_office_ambush, scene_live_broadcast = define_scenes

        # 1. Triunfo del CLP interrumpido por la orden de arresto de Nick Ogata
        transition_to(scene_clp)
        emit("story.clp_victory_celebration_disrupted", actor: :ryo_aoki, data: {
          event: "el_primer_ministro_cede_el_microfono_a_aoki_tras_arrasar_en_las_urnas",
          breaking_news: "noticia_de_urgencia_filtra_una_orden_de_arresto_por_homicidio_contra_aoki",
          nick_outcry: "nick_ogata_grita_en_plena_transmision_el_verdadero_nombre_masato_arakawa"
        })
        @state.set_flag(:aoki_fled_clp_hq, true)

        # 2. Aoki viaja en pánico a la Torre Milenio creyendo hablar con Tendo
        transition_to(scene_office_ambush, new_location: "Kamurocho - Millennium Tower (Despacho Arakawa)")
        emit("story.aoki_arrival_at_penthouse", actor: :ryo_aoki, target: :mirror_face, data: {
          deception: "aoki_encuentra_a_tendo_de_pie_y_al_grupo_de_kasuga_aparentemente_muerto_en_el_suelo",
          execution_order: "aoki_ordena_a_sangre_fria_eliminar_a_todos_los_involucrados_y_deshacerse_de_los_cuerpos"
        })
        @state.set_flag(:mirror_face_impersonation_triggered, true)

        # 3. Desenmascaramiento de Mirror Face y transmisión en directo
        transition_to(scene_live_broadcast, new_location: "Kamurocho - Millennium Tower (Despacho Arakawa)")
        emit("story.mirror_face_unmasked", actor: :mirror_face, target: :ryo_aoki, data: {
          twist: "el_tendo_frente_a_aoki_se_revela_como_mirror_face_quien_cambio_de_bando",
          real_tendo: "el_autentico_tendo_yace_amordazado_e_inconsciente_en_la_habitacion_trasera"
        })
        emit("story.hidden_cameras_live_stream", actor: :joon_gi_han, target: :ryo_aoki, data: {
          evidence: "saeko_y_han_revelan_que_la_orden_de_ejecucion_fue_filmada_en_alta_definicion",
          viral_broadcast: "el_video_se_retransmite_en_directo_a_todas_las_pantallas_gigantes_de_la_nacion"
        })
        @state.set_flag(:aoki_publicly_exposed, true)
        @state.set_flag(:ep87_completed, true)
      end

      def generate_summary
        "Episodio 87_la_trampa_del_camaleon completado: La noche electoral del CLP se convierte en caos cuando Nick Ogata hackea la emisión anunciando una orden de arresto y desvelando la verdadera identidad de Ryo Aoki como Masato Arakawa. Preso del pánico, Aoki huye en automóvil hacia Millennium Tower. Al ingresar al despacho de Arakawa, cree ver a Tendo victorioso y al equipo de Kasuga aniquilado. Con absoluta soberbia, Aoki ordena rematarlos y desaparecer todo rastro; en ese instante, Tendo se desmaquilla revelando ser Mirror Face, y el grupo fingiendo su muerte se pone en pie. Joon-gi Han y Saeko muestran las cámaras ocultas: la orden criminal de Aoki ha sido transmitida en directo al mundo entero."
      end
    end
  end
end
