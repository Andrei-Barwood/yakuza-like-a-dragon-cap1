# frozen_string_literal: true

require_relative "test_helper"
require "open3"

class TestDispatcher < Minitest::Test
  def test_manifest_contains_seven_episodes
    assert_equal 42, IchibanLab::Manifest.all.size
    assert_equal %w[01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42], IchibanLab::Manifest.ids
    assert IchibanLab::Manifest.valid_id?("01")
    assert IchibanLab::Manifest.valid_id?("08")
    assert IchibanLab::Manifest.valid_id?(13)
    assert IchibanLab::Manifest.valid_id?("14")
    assert IchibanLab::Manifest.valid_id?(18)
    assert IchibanLab::Manifest.valid_id?("19")
    assert IchibanLab::Manifest.valid_id?(24)
    assert IchibanLab::Manifest.valid_id?("25")
    assert IchibanLab::Manifest.valid_id?(30)
    assert IchibanLab::Manifest.valid_id?("31")
    assert IchibanLab::Manifest.valid_id?(36)
    assert IchibanLab::Manifest.valid_id?("37")
    assert IchibanLab::Manifest.valid_id?(42)
    refute IchibanLab::Manifest.valid_id?("43")
    refute IchibanLab::Manifest.valid_id?("unknown")
  end

  def test_bin_episodio_no_arguments_exits_with_code_3
    _stdout, _stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio")
    assert_equal 3, status.exitstatus
  end

  def test_bin_episodio_invalid_id_exits_with_code_3
    _stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "99")
    assert_equal 3, status.exitstatus
    assert_includes stderr, "no reconocido en el catálogo"
  end

  def test_bin_episodio_help_exits_with_code_0
    stdout, _stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "--help")
    assert_equal 0, status.exitstatus
    assert_includes stdout, "CAPÍTULO 1: LIGHT AND SHADOW"
    assert_includes stdout, "CAPÍTULO 2: BLOODY REUNION"
  end

  def test_bin_episodio_execution_error_exits_with_code_2
    # Simular ejecución fallida inyectando un error
    code = 'require "ichiban_lab"; ARGV.replace(["01"]); require "ichiban_lab/scenarios/ep01"; IchibanLab::Scenarios::Ep01.class_eval { def execute_scenario; raise IchibanLab::ExecutionError, "Fallo simulado"; end }; load "bin/episodio"'
    _stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "-e", code)
    assert_equal 2, status.exitstatus
    assert_includes stderr, "Error de ejecución en 01: Fallo simulado"
  end
end
