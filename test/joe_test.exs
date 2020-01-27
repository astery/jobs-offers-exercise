defmodule JOETest do
  use ExUnit.Case

  alias JOE.Offer
  alias JOE.Profession

  describe "given a nil state" do
    test "&continents_stats/1 return empty stats" do
      assert [] = JOE.continents_stats(nil)
    end
  end

  describe "given a list of a job offers and a list of professions" do
    setup do
      nil
      |> JOE.receive(%Profession{id: 1, category_name: "TECH"})
      |> JOE.receive(%Offer{profession_id: 1, continent: nil})
      |> JOE.receive(%Offer{profession_id: 1, continent: "EUROPE"})
    end

    test "&continents_stats/1 return total and offers with continent", state do
      assert [
        %{name: "TOTAL", total: 2, categories: %{"TECH": 2}},
        %{name: "EUROPE", total: 1, categories: %{"TECH": 1}},
      ] = JOE.continents_stats(state)
    end

    test "&continents_stats/1 return ", state do
      assert [
        %{name: "TOTAL", total: 2, categories: %{"TECH": 2}},
        %{name: "EUROPE", total: 1, categories: %{"TECH": 1}},
        %{name: "ASIA", total: 0, categories: %{}},
      ] = JOE.continents_stats(state, continents: ["EUROPE", "ASIA"])
    end
  end
end
