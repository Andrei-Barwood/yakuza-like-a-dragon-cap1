# frozen_string_literal: true

require_relative "test_helper"
gem "sinatra", "~> 2.2"
require "ichiban_lab/web_app"
require "rack/mock"

class TestWebApp < Minitest::Test
  def app
    IchibanLab::WebApp.new
  end

  def test_index_route
    request = Rack::MockRequest.new(app)
    response = request.get("/")
    assert_equal 200, response.status
    assert_includes response.body, "Capítulos 1 al 12"
    assert_includes response.body, "Capítulo 1: Light & Shadow"
    assert_includes response.body, "Capítulo 2: Bloody Reunion"
    assert_includes response.body, "Capítulo 3: The Town at Rock Bottom"
    assert_includes response.body, "Capítulo 4: The Dragon of Yokohama"
    assert_includes response.body, "Capítulo 5: The Liumang's Web"
    assert_includes response.body, "Capítulo 6: Ignition"
    assert_includes response.body, "Capítulo 7: The Spider's Web"
    assert_includes response.body, "Capítulo 8: Bleached Black"
    assert_includes response.body, "Capítulo 9: House of Cards"
    assert_includes response.body, "Capítulo 10: Justice Bracket"
    assert_includes response.body, "Capítulo 11: The Odds"
    assert_includes response.body, "Capítulo 12: The End of the Yakuza"
    assert_includes response.body, "01_origen"
    assert_includes response.body, "08_liberacion"
    assert_includes response.body, "14_la_ciudad_en_el_fondo"
    assert_includes response.body, "19_el_empleo_prometido"
    assert_includes response.body, "25_la_heredera_de_otohime"
    assert_includes response.body, "31_el_despertar_encadenado"
    assert_includes response.body, "37_el_barrio_coreano"
    assert_includes response.body, "43_el_pacto_de_los_tres"
    assert_includes response.body, "49_el_perfil_de_aoki"
    assert_includes response.body, "55_el_interrogatorio_de_ogasawara"
    assert_includes response.body, "61_el_ascenso_de_aoki"
    assert_includes response.body, "67_el_despacho_del_gobernador"
  end

  def test_post_run_episode
    request = Rack::MockRequest.new(app)
    response = request.post("/run", params: { episode_id: "01" })
    assert_equal 200, response.status
    assert_includes response.body, "Escenario Ejecutado Exitosamente"
    assert_includes response.body, "story.sacrifice_recorded"
  end

  def test_docs_view_route
    request = Rack::MockRequest.new(app)
    response = request.get("/docs/01/briefing")
    assert_equal 200, response.status
    assert_includes response.body, "Briefing — Episodio 01"
  end

  def test_nonexistent_episode_returns_404
    request = Rack::MockRequest.new(app)
    response = request.get("/docs/99/briefing")
    assert_equal 404, response.status
  end
end
