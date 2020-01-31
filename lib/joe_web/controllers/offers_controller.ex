defmodule JOEWeb.OffersController do
  use JOEWeb, :controller

  alias Ecto.Changeset

  def index(conn, %{} = params) do
    types = %{lat: :float, lon: :float, radius: :float}
    changeset =
      {%{}, types}
      |> Changeset.cast(params, Map.keys(types))
      |> Changeset.validate_required([:lat, :lon, :radius])

    if changeset.valid? do
      %{lat: lat, lon: lon, radius: radius} = Changeset.apply_changes(changeset)

      offers =
        JOE.Application.get_state()
        |> JOE.offers_in_radius({lat, lon}, radius)
        |> Enum.map(& Map.take(&1, [
          :profession_id,
          :contract_type,
          :name,
          :office_latitude,
          :office_longitude,
          :continent,
          :distance,
        ]))

      json(conn, %{data: offers})
    else
      conn
      |> put_status(400)
      |> json(%{error: JOEWeb.ErrorHelpers.translate_errors(changeset)})
    end
  end
end