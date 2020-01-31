defmodule JOE.ContinentsTest do
  use ExUnit.Case

  alias JOE.Continents

  test "&get_continent_name/2" do
    assert "europe" = Continents.get_continent_name(48.885247, 2.3566441)
    assert "europe" = Continents.get_continent_name(48.1392154, 11.5781413)
    assert "africa" = Continents.get_continent_name(2.0211, 25.1367)
  end
end
