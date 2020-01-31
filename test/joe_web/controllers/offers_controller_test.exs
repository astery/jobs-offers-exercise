defmodule JOEWeb.OffersControllerTest do
  use JOEWeb.ConnCase

  describe "index/2" do
    test "render error if no params given", %{conn: conn} do
      response =
        conn
        |> get(Routes.offers_path(conn, :index))
        |> json_response(400)

      expected = %{"error" => %{"lat" => ["can't be blank"], "lon" => ["can't be blank"], "radius" => ["can't be blank"]}}

      assert response == expected
    end

    test "list offers in radius if params given", %{conn: conn} do
      params = %{
        lat: "48.9",
        lon: "2.356",
        radius: 50,
      }

      response =
        conn
        |> get(Routes.offers_path(conn, :index, params))
        |> json_response(200)

      assert %{
        "data" => [
          %{
            "office_latitude" => "48.885247",
            "office_longitude" => "2.3566441",
            "distance" => 1.6411344414832527
          }
        ]
      } = response
    end
  end
end