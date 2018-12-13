defmodule Aoc2018.Day12 do

  def a(state \\ init_state(), trans \\ transformations()) do
    state_map = state_map(state)
    trans_table = trans_table(trans)

    1..20
    |> Enum.reduce(state_map, reduce_generation(trans_table))
    |> Enum.reduce(0, &calculate_pots/2)
  end

  def b(state \\ init_state(), trans \\ transformations()) do
    state_map = state_map(state)
    trans_table = trans_table(trans)
    {gen, count, diff} = find_steady_growth_generation(state_map, trans_table)
    rem = (50_000_000_000 - gen) * diff
    count + rem
  end

  def find_steady_growth_generation(state_map, trans_table) do
    try do
      Enum.reduce(1..50_000_000_000, {state_map, {0, Map.new()}},
      fn(i, {s, {c, d}}) ->
        reductor = reduce_generation(trans_table)
        new_generation = reductor.(i, s)
        count = Enum.reduce(new_generation, 0, &calculate_pots/2)
        diff = count - c
        new_d =
          Map.update(d, diff, 1,
            fn(10) ->
                throw({:steady, {i, count, diff}})
              (j) ->
                j + 1
            end
          )
        {new_generation, {count, new_d}}
      end
    )
    catch
      {:steady, p} ->
        p
    end
  end

  def calculate_pots({pot, :plant}, acc), do: pot + acc
  def calculate_pots(_, acc), do: acc

  def reduce_generation(trans_table) do
    fn(_i, generation_state) ->
      transform = transform_pot(generation_state, trans_table)
        generation_state
        |> Enum.map(transform)
        |> Enum.into(%{})
        |> new_plants(transform)
    end
  end

  def new_plants(new_generation, transform) do
    {{min, _}, {max, _}} = Enum.min_max(new_generation)
    plants = [transform.({min - 1, nil}), transform.({max + 1, nil})]
    add_new_plants(new_generation, plants)
  end

  def add_new_plants(generation, plants) do
    plants
    |> Enum.reject(fn({_, state}) -> state == nil end)
    |> Enum.reduce(generation, fn({p, s}, g) -> Map.put_new(g, p, s) end)
  end

  def match_transformations(l1, l2, r1, r2, c) do
    fn(%{0 => ^c, -1 => ^l1, -2 => ^l2, 1 => ^r1, 2 => ^r2}) ->
        true
      (_) ->
        false
    end
  end

  def transform_pot(generation_state, trans_table) do
    fn({pot, state}) ->
      {left, right} = {&Kernel.-/2, &Kernel.+/2}
      l1_pot = Map.get(generation_state , left.(pot,1))
      l2_pot = Map.get(generation_state, left.(pot,2))
      r1_pot = Map.get(generation_state, right.(pot, 1))
      r2_pot = Map.get(generation_state, right.(pot, 2))
      matcher = match_transformations(l1_pot, l2_pot, r1_pot, r2_pot, state)

      %{new: new_state} = Enum.find(trans_table, %{new: nil}, matcher)

      {pot, new_state}
    end
  end

  def state_map(state \\ init_state()) do
    {map, _i} =
      state
      |> String.graphemes()
      |> Enum.reduce({%{}, 0},
            fn("#", {a, i}) ->
                {Map.put_new(a, i, :plant), i + 1}
              (".", {a, i}) ->
                {Map.put_new(a, i, nil), i + 1}
            end
      )
    map
  end

  def trans_table(trans \\ transformations()) do
    trans
    |> String.split("\n", trim: true)
    |> Enum.map(
        fn(x) ->
          x
          |> String.graphemes()
          |> Enum.reject(fn(i) -> i == " " end)
        end
    )
    |> Enum.reduce(
        [],
        fn(line, acc) ->
          [left2, left1, current, right1, right2, _, _, new_current] = line
          new_trans =
            %{
              :new => sign_to_atom(new_current),
              -2 => sign_to_atom(left2),
              -1 => sign_to_atom(left1),
              0  => sign_to_atom(current),
              1  => sign_to_atom(right1),
              2  => sign_to_atom(right2)
            }
          [new_trans|acc]
        end
    )

  end


  def sign_to_atom("#"), do: :plant
  def sign_to_atom("."), do: nil

  def init_state do
    "##.#....#..#......#..######..#.####.....#......##.##.##...#..#....#.#.##..##.##.#.#..#.#....#.#..#.#"
  end

  def example_init_state do
    "#..#.#..##......###...###"
  end

  def example_transformations do
    "...## => #
    ..#.. => #
    .#... => #
    .#.#. => #
    .#.## => #
    .##.. => #
    .#### => #
    #.#.# => #
    #.### => #
    ##.#. => #
    ##.## => #
    ###.. => #
    ###.# => #
    ####. => #"
  end

  def transformations do
    "#.#.. => .
    ..##. => .
    ...#. => .
    ..#.. => .
    ##### => #
    .#.#. => .
    ####. => .
    ###.. => .
    .#..# => #
    #..#. => #
    #.#.# => .
    #...# => #
    ..### => .
    ...## => #
    ##..# => #
    #.... => .
    .#.## => #
    #.### => #
    .##.# => #
    #..## => .
    .#... => #
    .###. => .
    ##... => #
    ##.## => #
    ##.#. => #
    #.##. => #
    .##.. => .
    ..#.# => .
    ....# => .
    ###.# => .
    ..... => .
    .#### => ."
  end
end
