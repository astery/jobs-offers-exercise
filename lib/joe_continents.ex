defmodule JOE.Continents do
  @moduledoc """
  Contains utility functions related with continents geo data
  """

  @continents :code.priv_dir(:joe)
    |> Path.join("continents.json")
    |> File.read!()
    |> Jason.decode!()
    |> Geo.JSON.decode!()
    |> Map.get(:geometries)

  def get_continent_name(lat, lon) do
    point = %Geo.Point{coordinates: {lon, lat}, srid: nil}

    @continents
    |> Enum.find(& Topo.contains?(&1, point))
    |> case do
      nil -> nil
      %{properties: %{"continent" => continent}} -> continent
    end
  end
end
