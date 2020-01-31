defmodule JOE do
  @moduledoc """
  offers offers exercise
  """

  defmodule Offer do
    defstruct [
      :profession_id,
      :contract_type,
      :name,
      :office_latitude,
      :office_longitude,
      :continent, # calculable
      :distance,  # calculable
    ]
  end

  defmodule Profession do
    defstruct [
      :id,
      :name,
      :category_name,
    ]
  end

  defmodule ContinentStat do
    defstruct [name: nil, total: 0, categories: %{}]
  end

  defmodule State do
    defstruct [category_name_by_prof_id: %{}, continents_stats: %{}, offers: []]
  end

  @total_stat_name "TOTAL"

  @doc """
  Updates state via received data. Currently only calculates stats.

  To simplify Professions must be processed before Offers
  """
  def receive(nil, data), do: receive(%State{}, data)

  def receive(state, %Profession{id: id, category_name: name}) do
    %{
      state
      | category_name_by_prof_id: Map.put(state.category_name_by_prof_id, id, name)
    }
  end

  def receive(state, %Offer{profession_id: prof_id} = offer) do
    category_name = state.category_name_by_prof_id[prof_id]
    %{continent: continent} = enrich_offer_with_continent_name(offer)
    increment_total_and_continent_category_count(state, continent, category_name)
    |> store_offer_for_search(offer)
  end

  @doc """
  Return count of job offers per profession category per continent.

  Total count across all of job offers is first line of the list
  """
  def continents_stats(state, opts \\ [])
  def continents_stats(nil, _opts), do: []
  def continents_stats(%{continents_stats: stats} = state, opts) do
    {total_stat, stats} = Map.pop(stats, @total_stat_name)

    stats_list =
      case Keyword.get(opts, :continents) do
        nil ->
          Map.values(stats)
        continents_order when is_list(continents_order) ->
          Enum.map(continents_order, &get_continent_stat(state, &1))
      end

    [total_stat | stats_list]
  end

  @doc """
  Return stream of professions
  """
  def read_professions_file!(file) do
    File.stream!(file)
    |> NimbleCSV.RFC4180.parse_stream()
    |> Stream.map(fn [id, name, category_name] ->
      %Profession{id: id, name: name, category_name: category_name}
    end)
  end

  @doc """
  Return stream of offers
  """
  def read_offers_file!(file) do
    File.stream!(file)
    |> NimbleCSV.RFC4180.parse_stream()
    |> Stream.map(fn [profession_id, contract_type, name, office_latitude, office_longitude] ->
      %Offer{profession_id: profession_id, contract_type: contract_type, name: name, office_latitude: office_latitude, office_longitude: office_longitude}
    end)
  end

  @doc """
  Return stream of offers
  """
  def categories(nil), do: []
  def categories(%{category_name_by_prof_id: category_name_by_prof_id}) do
    category_name_by_prof_id
    |> Map.values()
    |> Enum.dedup()
  end

  @doc "Return stat item name associated with total counter"
  def total_stat_name(), do: @total_stat_name

  def default_professions_file(), do: priv_file_path("technical-test-professions.csv")
  def default_offers_file(), do: priv_file_path("technical-test-jobs.csv")

  def professions_file(:test), do: Path.join([File.cwd!, "test/fixtures/professions.csv"])
  def professions_file(_), do: default_professions_file()

  def offers_file(:test), do: Path.join([File.cwd!, "test/fixtures/jobs.csv"])
  def offers_file(_), do: default_offers_file()

  @doc """
  List offers in given radius in kilometers
  """
  def offers_in_radius(%{offers: offers}, {lat, lon}, radius_in_km) do
    center = [lat, lon]
    radius_in_meters = radius_in_km * 1_000

    Enum.flat_map(offers, fn offer ->
      with [_, _] = point <- to_point(offer),
        distance = Geocalc.Calculator.distance_between(center, point),
        distance_in_km = distance / 1_000,
        true <- distance <= radius_in_meters do
          [%{offer | distance: distance_in_km}]
      else
        _ -> []
      end
    end)
    |> List.flatten()
  end

  defp to_point(%Offer{office_latitude: lat, office_longitude: lon}) when is_binary(lat) and is_binary(lon) do
    try do
      [String.to_float(lat), String.to_float(lon)]
    rescue
      ArgumentError -> nil
    end
  end
  defp to_point(%Offer{office_latitude: lat, office_longitude: lon}) when is_number(lat) and is_number(lon) do
    [lat, lon]
  end

  def enrich_offer_with_continent_name(%Offer{continent: nil} = offer) do
    %{offer | continent: JOE.Continents.get_continent_name(offer.office_latitude, offer.office_longitude)}
  end
  def enrich_offer_with_continent_name(%Offer{} = offer), do: offer

  defp get_continent_stat(state, name) do
    Map.get(state.continents_stats, name, %ContinentStat{name: name})
  end

  defp put_continent_stat(state, stat) do
    %{state | continents_stats: Map.put(state.continents_stats, stat.name, stat)}
  end

  defp increment_total_and_continent_category_count(state, nil, category_name) do
    state
    |> increment_continent_category_count(@total_stat_name, category_name)
  end
  defp increment_total_and_continent_category_count(state, continent, category_name) do
    state
    |> increment_continent_category_count(continent, category_name)
    |> increment_continent_category_count(@total_stat_name, category_name)
  end

  defp increment_continent_category_count(state, continent_name, category_name) do
    stat = get_continent_stat(state, continent_name)
    category_count = Map.get(stat.categories, category_name, 0)

    put_continent_stat(state, %{
      stat |
      total: stat.total + 1,
      categories: Map.put(stat.categories, category_name, category_count + 1)
    })
  end

  defp store_offer_for_search(state, offer) do
    %{state | offers: [offer | state.offers]}
  end

  defp priv_file_path(file_name) do
    Path.join(:code.priv_dir(:joe), file_name)
  end
end
