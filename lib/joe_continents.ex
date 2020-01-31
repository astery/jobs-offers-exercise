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

  def get_continent_name(lat, lon) when is_float(lat) and is_float(lon) do
    point = %Geo.Point{coordinates: {lon, lat}, srid: nil}

    @continents
    |> Enum.find(& Topo.contains?(&1, point))
    |> case do
      nil -> nil
      %{properties: %{"continent" => continent}} -> continent
    end
  end
  def get_continent_name(lat, lon) when is_binary(lat) and is_binary(lon) do
    get_continent_name(String.to_float(lat), String.to_float(lon))
  end
  def get_continent_name(nil, nil), do: nil
end
