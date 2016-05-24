defmodule CliTest do
  use ExUnit.Case
  doctest AwesomeLibs.CLI

  import AwesomeLibs.CLI, only: [ parse_args: 1, process: 1, run: 1 ]

  test ":help returned when -h or --help provided" do
    assert parse_args(["-h", ""]) == :help
    assert parse_args(["--help", ""]) == :help
  end

  test "two parameters returned when :library or :category provided" do
    assert parse_args(["--library", "6", "library name"]) == {:library, 6, "library name"}
    assert parse_args(["-l", "6", "library name"]) == {:library, 6, "library name"}
    assert parse_args(["--category", "category name"]) == {:category, "category name", nil}
    assert parse_args(["-c", "category name"]) == {:category, "category name", nil}
  end

  test "print the right information based on the args" do
    assert process({:library, "cFilter", "lFilter"}) == :ok
    assert process({:category, "filter"}) == :ok
  end
end
