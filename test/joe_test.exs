defmodule JOETest do
  use ExUnit.Case
  doctest JOE

  test "greets the world" do
    assert JOE.hello() == :world
  end
end
