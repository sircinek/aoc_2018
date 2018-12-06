defmodule Aoc2018.Day6 do


  def a do
    points = parse_input()
    agg = self()

    {{min_x,_}, {max_x, _}} = Enum.min_max_by(points, fn({x,_y}) -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(points, fn({_x,y}) -> y end)

    result =
      Enum.flat_map(
        min_x..max_x,
        fn(x) ->
          Enum.map(
            min_y..max_y,
            fn(y) ->
              spawn_link(
                fn() ->
                  calculate_point({x, y}, points, agg)
                end
              )
            end
          )
        end
      )
      |> wait_for_results()

    points_to_count =
      Enum.reduce(
        result,
        points,
        fn({point, to_pop}, acc) ->
          case point do
            {^min_x, _} ->
              List.delete(acc, to_pop)
            {^max_x, _} ->
              List.delete(acc, to_pop)
            {_, ^min_y} ->
              List.delete(acc, to_pop)
            {_, ^max_y} ->
              List.delete(acc, to_pop)
            {_, _} ->
              acc
          end
        end
      )

    to_calc = Map.values(result)

    Enum.map(
      points_to_count,
      fn(p) ->
        spawn_link(
          fn() ->
            count =
              Enum.count(
                to_calc,
                fn(e) ->
                   e == p
                end
              )
            send(agg, {p, count})
          end
        )
      end
    )
    |> wait_for_results()
    |> Enum.max_by(fn({_p, c}) -> c end)

  end

  def b do
    points = parse_input()
    agg = self()

    {{min_x,_}, {max_x, _}} = Enum.min_max_by(points, fn({x,_y}) -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(points, fn({_x,y}) -> y end)

    Enum.flat_map(
      min_x..max_x,
      fn(x) ->
        Enum.map(
          min_y..max_y,
          fn(y) ->
            spawn_link(
              fn() ->
                distance_to_all_points({x, y}, points, agg)
              end
            )
          end
        )
      end
    )
    |> wait_for_results()
    |> Enum.filter(
        fn({_p, distances}) ->
          Enum.sum(distances) < 10_000
        end
    )
    |> length()
  end

  def wait_for_results(awaiting, acc \\ %{})
  def wait_for_results([], acc), do: acc
  def wait_for_results(awaiting, acc) do
    receive  do
      {point, {closest, _dist}} ->
        wait_for_results(Enum.drop(awaiting, 1), Map.put_new(acc, point, closest))
      {_point, :deuce} ->
        wait_for_results(Enum.drop(awaiting, 1), acc)
      {point, count} ->
        wait_for_results(Enum.drop(awaiting, 1), Map.put_new(acc, point, count))
    end
  end

  def parse_input(input \\ input()) do
    input
    |> String.split("\n")
    |> Enum.map(
        fn(x) ->
          x
          |> String.split(",")
          |> Enum.map(&String.trim/1)
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()
        end
    )
  end

  def distance({x1, y1}, {x2, y2}) do
    abs(x1-x2) + abs(y1-y2)
  end

  def calculate_point(point, all_points, agg) do
    min_distance =
      all_points
      |> Enum.reduce(nil,
          fn(p, nil) ->
             {p, distance(point, p)}
            (_p, :deuce) -> :deuce
            (p, {old_p, dist}) ->
              new_distance = distance(p, point)
              cond do
                new_distance < dist -> {p, new_distance}
                new_distance == dist -> :deuce
                new_distance > dist -> {old_p, dist}
              end
          end
      )

      send(agg, {point, min_distance})
  end

  def distance_to_all_points(point, all_points, agg) do
    distances =
      all_points
      |> Enum.map(
        fn(p) ->
          distance(p, point)
        end
      )
    send(agg, {point, distances})
  end

  def input do
    "66, 204
    55, 226
    231, 196
    69, 211
    69, 335
    133, 146
    321, 136
    220, 229
    148, 138
    42, 319
    304, 181
    101, 329
    72, 244
    242, 117
    83, 237
    169, 225
    311, 212
    348, 330
    233, 268
    99, 301
    142, 293
    239, 288
    200, 216
    44, 215
    353, 289
    54, 73
    73, 317
    55, 216
    305, 134
    343, 233
    227, 75
    139, 285
    264, 179
    349, 263
    48, 116
    223, 60
    247, 148
    320, 232
    60, 230
    292, 78
    247, 342
    59, 326
    333, 210
    186, 291
    218, 146
    205, 246
    124, 204
    76, 121
    333, 137
    117, 68"
  end

end
