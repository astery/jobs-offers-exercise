defmodule JOE do
  @moduledoc """
  Jobs offers exercise
  """

  defmodule Offer do
    defstruct [
      :profession_id,
      :contract_type,
      :name,
      :office_latitude,
      :office_longitude,
      :continent,
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
    defstruct [name: nil, total: 0, categories: []]
  end

  @doc """
  Updates state via received data

  To simplify Professions must be processed before Offers
  """
  def receive(state, data) do
  end

  @doc """
  Return count of job offers per profession category per continent
  """
  def continents_stats(state) do
  end
end
