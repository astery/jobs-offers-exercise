defmodule Mix.Tasks.ShowContinentsStatsTest do
  use ExUnit.Case

  setup do
    Mix.shell(Mix.Shell.Process)
  end

  test "with no args should print following stats" do
    Mix.Tasks.ShowContinentsStats.run([])
    assert_received {:mix_shell, :info, ["hello"]}
  end
end
