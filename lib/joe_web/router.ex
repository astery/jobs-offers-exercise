defmodule JOEWeb.Router do
  use JOEWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", JOEWeb do
    pipe_through :api
  end
end
