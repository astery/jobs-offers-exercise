defmodule Mix.Tasks.ShowContinentsStatsTest do
  use ExUnit.Case

  @professions_file Path.join([File.cwd!, "test/fixtures/professions.csv"])
  @offers_file Path.join([File.cwd!, "test/fixtures/jobs.csv"])

  @default_args ["--professions-file", @professions_file, "--offers-file", @offers_file]

  setup do
    Mix.shell(Mix.Shell.Process)
  end

  # TODO: Add continents
  test "should print stats" do
    Mix.Tasks.ShowContinentsStats.run(@default_args)
    assert_receive {:mix_shell, :info, [
    """
    +-------+-------+----------+-------------------+
    |       | TOTAL | Business | Marketing / Comm' |
    +-------+-------+----------+-------------------+
    | TOTAL | 2     | 1        | 1                 |
    +-------+-------+----------+-------------------+
    """]}, 1000
  end
end
