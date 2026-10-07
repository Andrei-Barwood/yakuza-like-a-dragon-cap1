# frozen_string_literal: true

gem "sinatra", "~> 2.2"
$LOAD_PATH.unshift File.expand_path("lib", __dir__)
require "ichiban_lab/web_app"

run IchibanLab::WebApp
