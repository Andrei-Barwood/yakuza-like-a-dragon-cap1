# frozen_string_literal: true

module IchibanLab
  module Scenarios
    class Ep83 < IchibanLab::BaseScenario
      protected

      def episode_id
        "83_el_asesino_del_espejo"
      end

      def main_actor
        :ichiban
      end

      def default_initial_state
        ichiban = Character.new(
          id: :ichiban,
          name: "Ichiban Kasuga",
          attributes: { hp: 100, role: :party_leader },
          relationships: { seonhee: :informant, zhao: :intel_partner },
          belongings: []
        )
        seonhee = Character.new(
          id: :seonhee,
          name: "Seonhee",
          attributes: { role: :geomijul_queen },
          relationships: { ichiban: :strategist },
          belongings: []
        )
        kiryu = Character.new(
          id: :kazuma_kiryu,
          name: "Kazuma Kiryu",
          attributes: { role: :former_dragon, status: :bound_by_contract },
          relationships: { ichiban: :protector_from_shadows },
          belongings: []
        )
        zhao = Character.new(
          id: :tianyou_zhao,
          name: "Tianyou Zhao",
          attributes: { role: :party_member },
          relationships: { mirror_face: :recognized_hitman },
          belongings: []
        )

        WorldState.new(
          episode: episode_id,
          scene_id: "geomijul_surveillance_monitor_room",
          location: "Sala de Monitores de Geomijul",
          time_period: "2019 - Noche",
          money: 26300,
          characters: {
            ichiban: ichiban,
            seonhee: seonhee,
            kazuma_kiryu: kiryu,
            tianyou_zhao: zhao
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
            ep82_completed: true,
            geomijul_command_room_unlocked: true
          }
        )
      end

      def define_scenes
        scene_monitors = Scene.new(
          id: :geomijul_surveillance_monitor_room,
          title: "Vigilancia de CCTV: Zhao identifica a Mirror Face como el asesino a sueldo de Aoki",
          location: "Sala de Monitores de Geomijul"
        )
        scene_monitors.add_precondition("La sala de mandos de Geomijul debe estar desbloqueada") do |ws|
          ws.flag?(:ep82_completed) && ws.flag?(:geomijul_command_room_unlocked)
        end

        scene_kiryu_vow = Scene.new(
          id: :kiryu_oath_of_erasure,
          title: "Kiryu explica su contrato de desaparición y la necesidad de proteger a los suyos",
          location: "Sala de Monitores de Geomijul"
        )
        scene_kiryu_vow.add_precondition("Mirror Face debe haber sido descubierto") do |ws|
          ws.flag?(:mirror_face_identified)
        end

        scene_ishioda_lock = Scene.new(
          id: :bar_district_hideout_located,
          title: "Cámaras captan a Ishioda ingresando al escondite de Bar District",
          location: "Sala de Monitores de Geomijul"
        )
        scene_ishioda_lock.add_precondition("Kiryu debe haber tomado distancia") do |ws|
          ws.flag?(:kiryu_boundaries_explained)
        end

        [scene_monitors, scene_kiryu_vow, scene_ishioda_lock]
      end

      def execute_scenario
        scene_monitors, scene_kiryu_vow, scene_ishioda_lock = define_scenes

        # 1. Grabaciones de CCTV en Bar District y revelación de Mirror Face
        scene_monitors.check_preconditions!(@state)
        emit("story.mirror_face_footage_discovered", actor: :tianyou_zhao, target: :ichiban, data: {
          hitman: "mirror_face_el_asesino_camaleonico_maestro_del_disfraz",
          target: "aoki_planea_asesinar_a_sawashiro_en_prision_disfrazando_a_mirror_face_de_policia"
        })
        @state.set_flag(:mirror_face_identified, true)

        # 2. Despedida de Kiryu: la carga del borrado de identidad
        transition_to(scene_kiryu_vow)
        emit("story.kiryu_contract_of_erasure", actor: :kazuma_kiryu, target: :ichiban, data: {
          contract: "kiryu_no_puede_intervenir_abiertamente_sin_romper_su_acuerdo_de_muerte_fingida",
          reason: "borro_su_nombre_para_proteger_a_los_ninos_del_orfanato_de_okinawa"
        })
        @state.set_flag(:kiryu_boundaries_explained, true)

        # 3. Llegada de Ishioda en taxi a la esquina del Distrito de Bares
        transition_to(scene_ishioda_lock)
        emit("story.ishioda_hideout_pinpointed", actor: :seonhee, target: :ichiban, data: {
          location: "edificio_en_la_esquina_del_distrito_de_los_bares",
          reinforcements: "ishioda_y_mirror_face_acuartelados_en_el_4to_piso"
        })
        @state.set_flag(:bar_district_target_confirmed, true)
        @state.set_flag(:ep83_completed, true)
      end

      def generate_summary
        "Episodio 83_el_asesino_del_espejo completado: En la sala de monitores de Geomijul, Zhao reconoce en las grabaciones de seguridad a Mirror Face, el mítico sicario camaleónico contratado por Aoki para eliminar a Sawashiro en prisión disfrazado de policía. Kiryu explica que no puede pelear a su lado sin vulnerar el pacto que protegió a su familia en Okinawa. Minutos después, Seonhee localiza a Reiji Ishioda llegando en taxi al mismo edificio en el Distrito de Bares, fijando el asalto final."
      end
    end
  end
end
