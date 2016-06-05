defmodule AwesomeLibsTest do
  use ExUnit.Case
  doctest AwesomeLibs
  doctest AwesomeLibs.MdParser

  test "the truth" do
    assert 1 + 1 == 2
  end
end
