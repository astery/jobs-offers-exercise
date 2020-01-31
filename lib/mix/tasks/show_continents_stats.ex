defmodule Mix.Tasks.ShowContinentsStats do
  use Mix.Task

  @default_professions_file "technical-test-professions.csv"
  @default_offers_file "technical-test-jobs.csv"

  @shortdoc "Print continent statistic based on jobs.csv and professions.csv files"
  def run(args) do
    {parsed, _} = OptionParser.parse!(args, switches: [
      professions_file: :string,
      offers_file: :string,
    ])
    professions_file = Keyword.get(parsed, :professions_file, priv_file_path(@default_professions_file))
    offers_file = Keyword.get(parsed, :offers_file, priv_file_path(@default_offers_file))

    [state] =
      professions_file
      |> JOE.read_professions_file!()
      |> Stream.scan(nil, &on_profession_scan/2)
      |> Stream.take(-1)
      |> Enum.to_list()

    [state] =
      offers_file
      |> JOE.read_offers_file!()
      |> Stream.scan(state, &on_offer_scan/2)
      |> Stream.take(-1)
      |> Enum.to_list()

    print_stats(state)
  end

  defp on_profession_scan(profession, state) do
    JOE.receive(state, profession)
  end

  defp on_offer_scan(offer, state) do
    JOE.receive(state, offer)
  end

  defp print_stats(state) do
    stats = JOE.continents_stats(state)
    categories = JOE.categories(state)

    header = ["" | ["TOTAL" | categories]]
    rows = stats
      |> Enum.map(fn stat_item ->
        total = stat_item.total
        categories_counters = Enum.map(categories, & stat_item.categories[&1])
        [String.upcase(stat_item.name) | [total | categories_counters]]
      end)

    TableRex.quick_render!(rows, header)
    |> Mix.shell.info()
  end

  defp priv_file_path(file_name) do
    Path.join(:code.priv_dir(:joe), file_name)
  end
end