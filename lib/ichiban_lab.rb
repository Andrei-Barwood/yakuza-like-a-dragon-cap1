# frozen_string_literal: true

module IchibanLab
  class Error < StandardError; end
  class PreconditionError < Error; end
  class ExecutionError < Error; end
  class InvalidEpisodeError < Error; end
end

require_relative "ichiban_lab/character"
require_relative "ichiban_lab/world_state"
require_relative "ichiban_lab/event_log"
require_relative "ichiban_lab/scene"
require_relative "ichiban_lab/manifest"
require_relative "ichiban_lab/base_scenario"
