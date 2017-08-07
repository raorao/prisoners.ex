defmodule PrisonersTest do
  use ExUnit.Case
  alias Prisoners.Score
  alias Prisoners.Simulation.{HeadToHead}
  alias Prisoners.Personas.{
    AlwaysDefect,
    AlwaysCooperate,
    MonkeySeeMonkeyDo,
    BackStabber,
    Envious
  }

  describe "scenarios" do
    test "AlwaysDefect <-> AlwaysCooperate" do
      score = HeadToHead.simulate %{
        left: AlwaysDefect,
        right: AlwaysCooperate,
        runs: 10
      }

      assert score == %Score{left: 30, right: 0}
    end

    test "AlwaysCooperate <-> AlwaysDefect" do
      score = HeadToHead.simulate %{
        left: AlwaysCooperate,
        right: AlwaysDefect,
        runs: 10
      }

      assert score == %Score{left: 0, right: 30}
    end

    test "AlwaysDefect <-> AlwaysDefect" do
      score = HeadToHead.simulate %{
        left: AlwaysDefect,
        right: AlwaysDefect,
        runs: 10,
      }

      assert score == %Score{left: 10, right: 10}
    end

    test "AlwaysCooperate <-> AlwaysCooperate" do
      score = HeadToHead.simulate %{
        left: AlwaysCooperate,
        right: AlwaysCooperate,
        runs: 10,
      }

      assert score == %Score{left: 20, right: 20}
    end

    test "AlwaysDefect <-> MonkeySeeMonkeyDo" do
      score = HeadToHead.simulate %{
        left: AlwaysDefect,
        right: MonkeySeeMonkeyDo,
        runs: 10,
      }

      # (d / c) == (3 / 0)
      # (d / d) x 9 == (9 / 9)

      assert score == %Score{left: 12, right: 9}
    end

    test "MonkeySeeMonkeyDo <-> AlwaysCooperate" do
      score = HeadToHead.simulate %{
        left: MonkeySeeMonkeyDo,
        right: AlwaysCooperate,
        runs: 10,
      }

      assert score == %Score{left: 20, right: 20}
    end

    test "BackStabber <-> MonkeySeeMonkeyDo" do
      score = HeadToHead.simulate %{
        left: BackStabber,
        right: MonkeySeeMonkeyDo,
        runs: 10,
      }

      # c / c
      # d / c
      # c / d
      # d / c
      # c / d
      # d / c
      # c / d
      # d / c
      # c / d
      # d / c

      assert score == %Score{left: 17, right: 14}
    end

    test "MonkeySeeMonkeyDo <-> Envious" do
      score = HeadToHead.simulate %{
        left: AlwaysCooperate,
        right: Envious,
        runs: 10,
      }

      # 0. c / c - 2 / 2 - 2  / 2
      # 1. c / d - 0 / 3 - 2  / 5
      # 2. c / c - 2 / 2 - 4  / 7
      # 3. c / c - 2 / 2 - 6  / 9
      # 4. c / c - 2 / 2 - 8  / 11
      # 5. c / c - 2 / 2 - 10 / 13
      # 6. c / c - 2 / 2 - 12 / 15
      # 7. c / c - 2 / 2 - 14 / 17
      # 8. c / c - 2 / 2 - 16 / 19
      # 9. c / c - 2 / 2 - 18 / 21

      assert score == %Score{left: 18, right: 21}
    end
  end
end
