defmodule Aoc2018.Day11 do

  def a(range \\ 1..300, offset \\ 2) do
    xs = Enum.drop(range, offset)
    ys = xs

    Enum.reduce(
      xs,
      {{0,0}, 0},
      fn(x, {_, x_l} = x_a) ->
        {y, power_level} =
          Enum.reduce(
            ys,
            {0, 0},
            fn(y, {_, y_l} = y_a) ->
              cords = {x,y}
              power = area_power(cords, offset)
              if power > y_l do
                {y, power}
              else
                y_a
              end
            end
          )

        if power_level > x_l do
          {{x,y}, power_level}
        else
          x_a
        end
      end
    )
  end

  def b do
    reductor = 5..20

    {:ok,{size, {{x,y}, _power}}} =
      reductor
      |> Task.async_stream(fn(i) -> {i, a(1..300, i)} end, timeout: :infinity)
      |> Enum.max_by(fn({:ok, {_,{_cords, power}}}) -> power end)

    IO.puts "#{x},#{y},#{size+1}"

  end

  def area_power({x, y}, offset) do
    Enum.reduce(
      x..x+offset,
      0,
      fn(x, a) ->
        a + Enum.reduce(
          y..y+offset,
          0,
          fn(y, a) ->
            cell_power({x, y}) + a
          end
        )
      end
    )
  end

  def cell_power({x,y}) do
    rack_id = x + 10

    rack_id
    |> multiply_by_y(y)
    |> add_serial_number()
    |> multiply_by_rack_id(rack_id)
    |> return_hundred_digit()
    |> substract_five()

  end

  def return_hundred_digit(value) do
    value
    |> Integer.digits()
    |> Enum.at(-3, 0)
  end

  def add_ten(x), do: x + 10

  def substract_five(x), do: x - 5

  def multiply_by_y(rack_id, y), do: rack_id * y

  def multiply_by_rack_id(power_level, rack_id),
    do: power_level * rack_id

  def add_serial_number(power_level), do: power_level + input()

  def example_input do
    18
  end

  def input do
    5235
  end
end
