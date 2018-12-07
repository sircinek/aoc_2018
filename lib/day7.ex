defmodule Aoc2018.Day7 do

  def a do
    pairs = parse_input()

    grouped =
      Enum.group_by(
        pairs,
        fn({_,x}) -> x end,
        fn({l, _}) -> l end
      )

    missing_keys = Enum.map(65..90, fn(x) -> [x] end) -- Map.keys(grouped)
    Enum.reduce(missing_keys, grouped, fn(k, a) -> Map.put_new(a, k, []) end)
    |> reduce()
    |> Enum.reverse()
    |> Enum.join()

  end

  def b do
    pairs = parse_input()

    grouped =
      Enum.group_by(
        pairs,
        fn({_,x}) -> x end,
        fn({l, _}) -> l end
      )

    missing_keys = Enum.map(65..90, fn(x) -> [x] end) -- Map.keys(grouped)
    keys = Enum.reduce(missing_keys, grouped, fn(k, a) -> Map.put_new(a, k, []) end)
    reduce_many(keys, {[1,2,3,4,5], []}, 0)
  end

  @time 60
  def reduce_many(keys, {_, []}, time) when map_size(keys) == 0, do: time - 1
  def reduce_many(keys, workers, time = 0) do
    steps =
      keys
      |> Enum.group_by(fn({_k, l}) -> length(l) end)
      |> Map.fetch!(0)
      |> Enum.map(fn({k,_})-> k end)

    workers =
      Enum.reduce(
        steps,
        workers,
        fn(s = [v], {[f|free], busy}) ->
          {free, [{f, lock_time(v, time), s}|busy]}
        end
      )
    new_keys = Enum.reduce(steps, keys, fn(s, a) -> Map.delete(a, s) end)
    new_time = time + 1
    reduce_many(new_keys, workers, new_time)
  end

  def reduce_many(keys, {_, b} = workers, time) do
    case Enum.filter(b, fn({_, t, _}) -> t == time end) do
      [] ->
        reduce_many(keys, workers, time + 1)
      release ->
        {new_keys, new_workers} =
          Enum.reduce(
            release,
            {keys, workers},
            fn({worker, _, step}, {keys, {f, b}}) ->
              new_keys =
                Enum.map(
                  keys,
                  fn({k, v}) ->
                    {k, Enum.reject(v, fn(i) -> i == step end)}
                  end
                )
                |> Enum.into(%{})

              new_workers =
                {
                  [worker|f],
                  Enum.reject(
                    b,
                    fn({w,_,_}) -> w == worker end
                  )
                }
              {new_keys, new_workers}
            end
          )

          steps = Enum.group_by(new_keys, fn({_k, l}) -> length(l) end)

          case Map.fetch(steps, 0) do
            :error ->
              reduce_many(new_keys, new_workers, time + 1)
            {:ok, steps} ->
              steps = Enum.map(steps, fn({s,_}) -> s end)
              min_step = Enum.sort_by(steps, fn([v]) -> v end)
              {new_keys, new_workers} = get_workers(min_step, new_keys, new_workers, time)
              reduce_many(new_keys, new_workers, time + 1)
          end
    end
  end

  def lock_time(v, time) do
    @time + time + (v-64)
  end

  def get_workers([], keys, workers, _) do
    {keys, workers}
  end
  def get_workers(_, keys, w = {[],_}, _) do
    {keys, w}
  end

  def get_workers([s = [v]|steps], keys, {[f|free], busy}, time) do
    get_workers(steps, Map.delete(keys, s), {free, [{f, lock_time(v, time), s} | busy]}, time)
  end

  def parse_input(input \\ input()) do
    input
    |> String.split("\n")
    |> Enum.map(
        fn(e) ->
          e
          |> String.split(" ", trim: true)
          |> Enum.map(&String.trim/1)
          |> (fn(list) ->
                prerequisite = Enum.at(list, 1) |> String.to_charlist()
                dependant = Enum.at(list, 7) |> String.to_charlist()
                {prerequisite, dependant}
              end
          ).()
        end
    )
  end

  def reduce(map, acc \\ [])
  def reduce(map, acc) when map_size(map) == 0, do: acc
  def reduce(map, acc) do
    {s, _} =
      map
      |> Enum.group_by(fn({_k, l}) -> length(l) end)
      |> Map.fetch!(0)
      |> Enum.min_by(fn({[v], _}) -> v end)

    new_map =
      map
      |> Enum.map(
          fn({k, p}) ->
             {k, Enum.reject(p, fn(e) -> e == s end)}
          end
      )
      |> Enum.into(%{})
      |> Map.delete(s)

    reduce(new_map, [s|acc])
  end

  def input do
    "Step Y must be finished before step L can begin.
    Step N must be finished before step D can begin.
    Step Z must be finished before step A can begin.
    Step F must be finished before step L can begin.
    Step H must be finished before step G can begin.
    Step I must be finished before step S can begin.
    Step M must be finished before step U can begin.
    Step R must be finished before step J can begin.
    Step T must be finished before step D can begin.
    Step U must be finished before step D can begin.
    Step O must be finished before step X can begin.
    Step B must be finished before step D can begin.
    Step X must be finished before step V can begin.
    Step J must be finished before step V can begin.
    Step D must be finished before step A can begin.
    Step K must be finished before step P can begin.
    Step Q must be finished before step C can begin.
    Step S must be finished before step E can begin.
    Step A must be finished before step V can begin.
    Step G must be finished before step L can begin.
    Step C must be finished before step W can begin.
    Step P must be finished before step W can begin.
    Step V must be finished before step W can begin.
    Step E must be finished before step W can begin.
    Step W must be finished before step L can begin.
    Step P must be finished before step E can begin.
    Step T must be finished before step K can begin.
    Step A must be finished before step G can begin.
    Step G must be finished before step P can begin.
    Step N must be finished before step S can begin.
    Step R must be finished before step D can begin.
    Step M must be finished before step G can begin.
    Step Z must be finished before step L can begin.
    Step M must be finished before step T can begin.
    Step S must be finished before step L can begin.
    Step S must be finished before step W can begin.
    Step O must be finished before step J can begin.
    Step Z must be finished before step D can begin.
    Step A must be finished before step C can begin.
    Step P must be finished before step V can begin.
    Step A must be finished before step P can begin.
    Step B must be finished before step C can begin.
    Step R must be finished before step S can begin.
    Step X must be finished before step S can begin.
    Step T must be finished before step P can begin.
    Step Y must be finished before step E can begin.
    Step G must be finished before step E can begin.
    Step Y must be finished before step K can begin.
    Step J must be finished before step P can begin.
    Step I must be finished before step Q can begin.
    Step E must be finished before step L can begin.
    Step X must be finished before step J can begin.
    Step T must be finished before step X can begin.
    Step M must be finished before step O can begin.
    Step K must be finished before step A can begin.
    Step D must be finished before step W can begin.
    Step H must be finished before step C can begin.
    Step F must be finished before step R can begin.
    Step B must be finished before step Q can begin.
    Step M must be finished before step Q can begin.
    Step D must be finished before step S can begin.
    Step Y must be finished before step I can begin.
    Step M must be finished before step K can begin.
    Step S must be finished before step G can begin.
    Step X must be finished before step L can begin.
    Step D must be finished before step V can begin.
    Step B must be finished before step X can begin.
    Step C must be finished before step L can begin.
    Step V must be finished before step L can begin.
    Step Z must be finished before step Q can begin.
    Step Z must be finished before step H can begin.
    Step M must be finished before step S can begin.
    Step O must be finished before step C can begin.
    Step B must be finished before step A can begin.
    Step U must be finished before step V can begin.
    Step U must be finished before step A can begin.
    Step X must be finished before step G can begin.
    Step K must be finished before step C can begin.
    Step T must be finished before step S can begin.
    Step K must be finished before step G can begin.
    Step U must be finished before step B can begin.
    Step A must be finished before step E can begin.
    Step F must be finished before step V can begin.
    Step Q must be finished before step A can begin.
    Step F must be finished before step Q can begin.
    Step J must be finished before step L can begin.
    Step O must be finished before step E can begin.
    Step O must be finished before step Q can begin.
    Step I must be finished before step K can begin.
    Step I must be finished before step P can begin.
    Step J must be finished before step D can begin.
    Step Q must be finished before step P can begin.
    Step S must be finished before step C can begin.
    Step U must be finished before step P can begin.
    Step S must be finished before step P can begin.
    Step O must be finished before step B can begin.
    Step Z must be finished before step F can begin.
    Step R must be finished before step V can begin.
    Step D must be finished before step L can begin.
    Step Y must be finished before step T can begin.
    Step G must be finished before step C can begin."
  end
end
