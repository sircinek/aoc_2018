defmodule Aoc2018.Day9 do


  def a(input \\ input()) do
    {players_count, marbles_count} = player_and_marble_count(input)
    marbles = 1..marbles_count |> Enum.to_list()
    players = 1..players_count |> Enum.to_list() |> CList.list_to_clist()

    marbles
    |> reduce_marbles(players)
    |> Enum.max()
    |> elem(1)
  end

  def b do
    a(second_input())
  end


  def reduce_marbles(marbles, players, acc \\ CList.list_to_clist([0]), score \\ %{})
  def reduce_marbles([], _players, _acc, score), do: score
  def reduce_marbles([m|marbles], players, acc, score) do
    {acc, score} =
      if rem(m, 23) == 0 do
        acc = cycle_prev(7, acc)
        {value, acc} = CList.pop(acc)
        {acc, add_score(score, CList.current(players), value + m)}
      else
        acc = insert_marble(acc, m)
        {acc, score}
      end

      reduce_marbles(marbles, CList.next(players), acc, score)
  end


  def add_score(scores, player, score) do
      Map.update(
        scores,
        player,
        score,
        fn(p_score) ->
          score + p_score
        end
      )
  end

  def player_and_marble_count(input) do
    list = String.split(input, " ")
    players = Enum.at(list, 0) |> String.trim() |> String.to_integer()
    marbles = Enum.at(list, -2) |> String.trim() |> String.to_integer()
    {players, marbles}
  end

  def insert_marble(clist, marble) do
    clist
    |> CList.next()
    |> CList.next()
    |> CList.insert(marble)
  end

  def cycle_prev(times, clist) do
    Enum.reduce(1..times, clist, fn(_,a) -> CList.prev(a) end)
  end

  def example_input do
    "13 players; last marble is worth 1104 points"
  end

  def input do
    "441 players; last marble is worth 71032 points"
  end
  def second_input do
    "441 players; last marble is worth 7103200 points"
  end

end
