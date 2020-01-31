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
      state =
        nil
        |> JOE.receive(%Profession{id: 1, category_name: "TECH"})
        |> JOE.receive(%Offer{profession_id: 1, continent: nil})
        |> JOE.receive(%Offer{profession_id: 1, continent: "EUROPE"})

      %{state: state}
    end

    test "&continents_stats/1 return total and offers with continent", %{state: state} do
      assert [
        %{name: "TOTAL", total: 2, categories: %{"TECH" => 2}},
        %{name: "EUROPE", total: 1, categories: %{"TECH" => 1}},
      ] = JOE.continents_stats(state)
    end

    test "&continents_stats/1 return continents specified in opts", %{state: state} do
      assert [
        %{name: "TOTAL", total: 2, categories: %{"TECH" => 2}},
        %{name: "EUROPE", total: 1, categories: %{"TECH" => 1}},
        %{name: "ASIA", total: 0, categories: %{}},
      ] = JOE.continents_stats(state, continents: ["EUROPE", "ASIA"])
    end
  end

  @professions_file Path.join([File.cwd!, "test/fixtures/professions.csv"])
  @offers_file Path.join([File.cwd!, "test/fixtures/jobs.csv"])

  describe "given a file with list of job offers and a file with list of professions" do
    test "&read_professions_file!/1 should return stream of professions" do
      assert [
        %Profession{category_name: "Business", id: "5", name: "Conseil"},
        %Profession{category_name: "Marketing / Comm'", id: "7", name: "Marketing"},
      ] = JOE.read_professions_file!(@professions_file) |> Enum.to_list()
    end

    test "&read_offers_file!/1 should return stream of professions" do
      assert [
        %JOE.Offer{
          continent: nil,
          contract_type: "INTERNSHIP",
          name: "[Louis Vuitton Germany] Praktikant (m/w) im Bereich Digital Retail (E-Commerce)",
          office_latitude: "48.1392154",
          office_longitude: "11.5781413",
          profession_id: "7"
        },
        %JOE.Offer{
          continent: nil,
          contract_type: "INTERNSHIP",
          name: "Bras droit de la fondatrice",
          office_latitude: "48.885247",
          office_longitude: "2.3566441",
          profession_id: "5"
        }
      ] = JOE.read_offers_file!(@offers_file) |> Enum.to_list()
    end
  end
end
