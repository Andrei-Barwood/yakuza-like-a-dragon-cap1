# frozen_string_literal: true

gem "sinatra", "~> 2.2"
require "sinatra/base"
require "erb"
require_relative "../ichiban_lab"

# Cargar todos los escenarios para ejecución web
IchibanLab::Manifest.all.each do |ep|
  file = File.expand_path("scenarios/ep#{ep.id}.rb", __dir__)
  require file if File.exist?(file)
end

module IchibanLab
  class WebApp < Sinatra::Base
    set :port, 4567
    set :bind, "0.0.0.0"
    set :environment, :development
    set :views, File.expand_path("views", __dir__)

    helpers do
      def h(text)
        ERB::Util.html_escape(text)
      end

      def render_markdown(text)
        # Conversor minimalista de Markdown a HTML seguro sin dependencias extras
        escaped = h(text)
        # Headers
        escaped.gsub!(/^### (.*)$/, '<h3>\1</h3>')
        escaped.gsub!(/^## (.*)$/, '<h2>\1</h2>')
        escaped.gsub!(/^# (.*)$/, '<h1>\1</h1>')
        # Bold & Italic
        escaped.gsub!(/\*\*(.*?)\*\*/, '<strong>\1</strong>')
        escaped.gsub!(/\*(.*?)\*/, '<em>\1</em>')
        # Code inline & blocks
        escaped.gsub!(/`([^`]+)`/, '<code>\1</code>')
        # Lists
        escaped.gsub!(/^- (.*)$/, '<li>\1</li>')
        # Linebreaks
        escaped.gsub!("\n\n", '<br><br>')
        escaped
      end
    end

    get "/" do
      @episodes = Manifest.all
      @selected_id = params[:ep] || "01"
      @episode = Manifest.find(@selected_id)
      @outcome = nil
      @error = nil

      erb :index
    end

    post "/run" do
      ep_id = params[:episode_id]
      @episode = Manifest.find(ep_id)
      halt 404, "Episodio no encontrado" unless @episode

      begin
        scenario_class = Object.const_get(@episode.class_name)
        scenario = scenario_class.new
        @outcome = scenario.run
      rescue StandardError => e
        @error = e.message
      end

      @error ||= nil
      @episodes = Manifest.all
      @selected_id = @episode.id
      erb :index
    end

    get "/docs/:id/:section" do
      @episode = Manifest.find(params[:id])
      halt 404, "Episodio no encontrado" unless @episode

      section = params[:section]
      doc_path = File.expand_path("../../docs/episodios/ep#{@episode.id}_#{section}.md", __dir__)
      halt 404, "Documento no disponible" unless File.exist?(doc_path)

      @title = "#{@episode.title} — #{section.upcase}"
      @content = File.read(doc_path)
      erb :doc
    end
  end
end
