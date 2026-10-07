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
    assert_includes response.body, "Capítulos 1, 2, 3, 4 y 5"
    assert_includes response.body, "Capítulo 1: Light & Shadow"
    assert_includes response.body, "Capítulo 2: Bloody Reunion"
    assert_includes response.body, "Capítulo 3: The Town at Rock Bottom"
    assert_includes response.body, "Capítulo 4: The Dragon of Yokohama"
    assert_includes response.body, "Capítulo 5: The Liumang's Web"
    assert_includes response.body, "01_origen"
    assert_includes response.body, "08_liberacion"
    assert_includes response.body, "14_la_ciudad_en_el_fondo"
    assert_includes response.body, "19_el_empleo_prometido"
    assert_includes response.body, "25_la_heredera_de_otohime"
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
