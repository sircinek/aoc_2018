defmodule Aoc2018.Day10 do

  def a(input \\ input()) do
    points = prepare_points(input)
    {{smallest, _}, _} = find_smallest_area(points)
    cords = Enum.reduce(1..smallest, points, fn(_i, p) -> move_points(p) end)
    text = prepare_text(cords)
    IO.inspect(text, limit: :infinity, syntax_colors: [atom: :yellow, string: :green])
  end

  def b(input \\ input()) do
    points = prepare_points(input)
    {{time,_}, _} = find_smallest_area(points)
    time
  end

  def prepare_text(cords) do
    {cords, _velocities} = Enum.unzip(cords)
    map_cords = cords |> Enum.map(fn(x) -> {x, "*"} end) |> Enum.into(%{})
    {min_x, max_x} = min_max_x(cords)
    {min_y, max_y} = min_max_y(cords)

    Enum.reduce(
      min_x..max_x,
      [],
      fn(x, acc) ->
        ys =
          Enum.reduce(
            min_y..max_y,
            [],
            fn(y, acc) ->
              [Map.get(map_cords, {x,y}, nil)|acc]
            end
          )
          |> Enum.reverse()
        [ys|acc]
      end
    )
  end

  def find_smallest_area(points) do
    Enum.reduce(
      1..15_000,
      {nil, points},
      fn(i, {last_smallest, points}) ->
        new_points = move_points(points)
        area = calc_area(new_points)
        new_smallest = smallest_area(last_smallest, {i, area})
        {new_smallest, new_points}
      end
    )
  end

  def calc_area(points) do
    {cords, _velocities} = Enum.unzip(points)
    {min_x, max_x} = min_max_x(cords)
    {min_y, max_y} = min_max_y(cords)
    (max_x - min_x) * (max_y - min_y)
  end

  def move_points(points) do
    Enum.map(
      points,
      fn({{x,y}, vel = {v_x, v_y}}) ->
        {{x+v_x, y+v_y}, vel}
      end
    )
  end

  def min_max_x(cords) do
    {{min_x,_}, {max_x, _}} = Enum.min_max_by(cords, fn({x,_y}) -> x end)
    {min_x, max_x}
  end

  def min_max_y(cords) do
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(cords, fn({_x,y}) -> y end)
    {min_y, max_y}
  end

  def smallest_area(nil, area), do: area
  def smallest_area(last = {_, last_area}, new = {_, new_area}) do
    if last_area > new_area do
      new
    else
      last
    end
  end

  def prepare_points(input) do
    input
    |> String.split("\n")
    |> Enum.map(
        fn(x) ->
          x
          |> String.split("<", trim: true)
          |> Enum.flat_map(&String.split/1)
        end
    )
    |> Enum.map(
        fn(elem) ->
          x_pos = Enum.at(elem, 1) |> String.trim(",") |> String.to_integer()
          y_pos = Enum.at(elem, 2) |> String.trim(">") |> String.to_integer()
          x_vel = Enum.at(elem, 4) |> String.trim(",") |> String.to_integer()
          y_vel = Enum.at(elem, 5) |> String.trim(">") |> String.to_integer()
          {{x_pos, y_pos}, {x_vel, y_vel}}
        end
    )
  end

  def input do
    "position=< -9951, -50547> velocity=< 1,  5>
    position=< 40761, -20137> velocity=<-4,  2>
    position=<-30244,  30538> velocity=< 3, -3>
    position=< 20462,  -9999> velocity=<-2,  1>
    position=< 10357,  40672> velocity=<-1, -4>
    position=< 20445,  30540> velocity=<-2, -3>
    position=< 50844,  40679> velocity=<-5, -4>
    position=< 40721, -20136> velocity=<-4,  2>
    position=< 20480, -20144> velocity=<-2,  2>
    position=< 40751,  30545> velocity=<-4, -3>
    position=<-50480,  20404> velocity=< 5, -2>
    position=< -9916, -10006> velocity=< 1,  1>
    position=<-20076, -30273> velocity=< 2,  3>
    position=< 30596,  -9999> velocity=<-3,  1>
    position=<-40380, -40407> velocity=< 4,  4>
    position=<-40367,  50810> velocity=< 4, -5>
    position=< 40713, -50552> velocity=<-4,  5>
    position=<-40380, -10004> velocity=< 4,  1>
    position=< -9969,  40672> velocity=< 1, -4>
    position=< 30612, -30273> velocity=<-3,  3>
    position=< 20453, -20143> velocity=<-2,  2>
    position=< 40729,  30545> velocity=<-4, -3>
    position=<-50504,  30540> velocity=< 5, -3>
    position=<-30199, -40415> velocity=< 3,  4>
    position=< 50868,  40680> velocity=<-5, -4>
    position=<-50487, -50543> velocity=< 5,  5>
    position=< -9947,  50817> velocity=< 1, -5>
    position=< -9920, -40412> velocity=< 1,  4>
    position=< 30625,  50817> velocity=<-3, -5>
    position=<-50492,  50816> velocity=< 5, -5>
    position=< 20472, -40412> velocity=<-2,  4>
    position=<-50500,  10271> velocity=< 5, -1>
    position=<-40359,  30541> velocity=< 4, -3>
    position=< 30582,  50812> velocity=<-3, -5>
    position=< 10334,  50812> velocity=<-1, -5>
    position=< 40727, -40416> velocity=<-4,  4>
    position=<-20100,  20406> velocity=< 2, -2>
    position=<-30220,  50817> velocity=< 3, -5>
    position=< 20456, -30275> velocity=<-2,  3>
    position=<-40348,  30538> velocity=< 4, -3>
    position=<-20108, -20141> velocity=< 2,  2>
    position=<-30203, -10008> velocity=< 3,  1>
    position=<-30219,  30536> velocity=< 3, -3>
    position=< 20457,  10268> velocity=<-2, -1>
    position=<-40354, -10003> velocity=< 4,  1>
    position=< 30633,  30538> velocity=<-3, -3>
    position=< 50855,  30540> velocity=<-5, -3>
    position=< -9954,  50813> velocity=< 1, -5>
    position=< 50862,  20405> velocity=<-5, -2>
    position=< 50857, -40408> velocity=<-5,  4>
    position=< 10303,  40681> velocity=<-1, -4>
    position=<-20052,  10270> velocity=< 2, -1>
    position=<-50460,  40678> velocity=< 5, -4>
    position=< 20460,  50816> velocity=<-2, -5>
    position=<-30231,  10265> velocity=< 3, -1>
    position=<-40364,  50816> velocity=< 4, -5>
    position=< 20449,  20403> velocity=<-2, -2>
    position=< 40711, -10008> velocity=<-4,  1>
    position=<-20064, -20141> velocity=< 2,  2>
    position=< 30582,  20404> velocity=<-3, -2>
    position=<-40362,  40677> velocity=< 4, -4>
    position=<-20055, -50546> velocity=< 2,  5>
    position=<-40354, -30271> velocity=< 4,  3>
    position=<-20107, -50543> velocity=< 2,  5>
    position=< 50865,  50815> velocity=<-5, -5>
    position=< 30605,  30536> velocity=<-3, -3>
    position=< 50904, -20140> velocity=<-5,  2>
    position=<-30227,  40677> velocity=< 3, -4>
    position=< 40756, -40413> velocity=<-4,  4>
    position=< 50889,  30545> velocity=<-5, -3>
    position=< 50860,  -9999> velocity=<-5,  1>
    position=< 30620, -10002> velocity=<-3,  1>
    position=< 10313,  10271> velocity=<-1, -1>
    position=< 20494,  30536> velocity=<-2, -3>
    position=<-50466, -10004> velocity=< 5,  1>
    position=<-40324,  30543> velocity=< 4, -3>
    position=<-20067,  30542> velocity=< 2, -3>
    position=< 40709,  30540> velocity=<-4, -3>
    position=< 50861,  40673> velocity=<-5, -4>
    position=< 50876, -10006> velocity=<-5,  1>
    position=<-20052,  50813> velocity=< 2, -5>
    position=<-20087,  20403> velocity=< 2, -2>
    position=< 40721,  30541> velocity=<-4, -3>
    position=< 10300, -20137> velocity=<-1,  2>
    position=<-40376, -50552> velocity=< 4,  5>
    position=< 50876, -30276> velocity=<-5,  3>
    position=< 30609,  50810> velocity=<-3, -5>
    position=<-20076, -50550> velocity=< 2,  5>
    position=< -9943, -40414> velocity=< 1,  4>
    position=< 50865,  10266> velocity=<-5, -1>
    position=< 50897,  30543> velocity=<-5, -3>
    position=< 50871, -20144> velocity=<-5,  2>
    position=< -9956, -50543> velocity=< 1,  5>
    position=<-30240,  20409> velocity=< 3, -2>
    position=< 40765,  10264> velocity=<-4, -1>
    position=< -9916,  10268> velocity=< 1, -1>
    position=<-30186,  30540> velocity=< 3, -3>
    position=<-30209,  20400> velocity=< 3, -2>
    position=< 50893, -50548> velocity=<-5,  5>
    position=< 40724,  50813> velocity=<-4, -5>
    position=< 20484, -30280> velocity=<-2,  3>
    position=<-30219, -40416> velocity=< 3,  4>
    position=< 20492,  30545> velocity=<-2, -3>
    position=<-30209,  30540> velocity=< 3, -3>
    position=< 50872,  10267> velocity=<-5, -1>
    position=<-50484,  10268> velocity=< 5, -1>
    position=<-50492, -50545> velocity=< 5,  5>
    position=< 10308, -20139> velocity=<-1,  2>
    position=< 50880, -50552> velocity=<-5,  5>
    position=<-40339, -50543> velocity=< 4,  5>
    position=<-40353,  30540> velocity=< 4, -3>
    position=< 40708,  30542> velocity=<-4, -3>
    position=< 40740,  40681> velocity=<-4, -4>
    position=< 30604,  40677> velocity=<-3, -4>
    position=< 30628,  50811> velocity=<-3, -5>
    position=< 20465,  10265> velocity=<-2, -1>
    position=< 30631, -50552> velocity=<-3,  5>
    position=<-20088,  10265> velocity=< 2, -1>
    position=<-20087, -30278> velocity=< 2,  3>
    position=< -9943, -10006> velocity=< 1,  1>
    position=< 20438,  50812> velocity=<-2, -5>
    position=<-50483, -10004> velocity=< 5,  1>
    position=< -9943,  50810> velocity=< 1, -5>
    position=< 20457,  -9999> velocity=<-2,  1>
    position=<-40379, -30271> velocity=< 4,  3>
    position=<-20100,  40672> velocity=< 2, -4>
    position=< 50900,  10264> velocity=<-5, -1>
    position=< 10300, -50548> velocity=<-1,  5>
    position=<-30196, -20137> velocity=< 3,  2>
    position=< 10300,  30537> velocity=<-1, -3>
    position=< -9916, -50551> velocity=< 1,  5>
    position=< 10332, -20140> velocity=<-1,  2>
    position=< 10332,  30536> velocity=<-1, -3>
    position=< 10353, -50552> velocity=<-1,  5>
    position=< -9928,  50811> velocity=< 1, -5>
    position=< 10321, -20138> velocity=<-1,  2>
    position=<-20050, -50552> velocity=< 2,  5>
    position=<-20108,  40680> velocity=< 2, -4>
    position=< 50897, -10001> velocity=<-5,  1>
    position=<-40324, -50544> velocity=< 4,  5>
    position=<-40354, -30280> velocity=< 4,  3>
    position=<-20107,  50817> velocity=< 2, -5>
    position=< -9913,  50812> velocity=< 1, -5>
    position=< 20461,  50808> velocity=<-2, -5>
    position=<-30244, -50547> velocity=< 3,  5>
    position=< 50879,  20400> velocity=<-5, -2>
    position=< 50881,  30537> velocity=<-5, -3>
    position=< 50895,  20404> velocity=<-5, -2>
    position=<-20065, -10004> velocity=< 2,  1>
    position=< 50865, -50544> velocity=<-5,  5>
    position=< 20473, -10006> velocity=<-2,  1>
    position=<-40380, -30280> velocity=< 4,  3>
    position=<-40363,  40677> velocity=< 4, -4>
    position=<-50499,  30537> velocity=< 5, -3>
    position=< 30617,  50810> velocity=<-3, -5>
    position=< -9945, -40407> velocity=< 1,  4>
    position=<-40353, -40407> velocity=< 4,  4>
    position=< 50888,  10273> velocity=<-5, -1>
    position=< 20492, -30272> velocity=<-2,  3>
    position=<-40337, -40416> velocity=< 4,  4>
    position=< 40727, -30280> velocity=<-4,  3>
    position=< 50871,  10268> velocity=<-5, -1>
    position=<-40323,  40676> velocity=< 4, -4>
    position=< -9959,  10273> velocity=< 1, -1>
    position=< 50844, -40414> velocity=<-5,  4>
    position=<-50471,  30545> velocity=< 5, -3>
    position=< -9919,  20403> velocity=< 1, -2>
    position=< 20449, -40411> velocity=<-2,  4>
    position=< 30592,  50813> velocity=<-3, -5>
    position=< 30588,  10268> velocity=<-3, -1>
    position=< 30614,  20409> velocity=<-3, -2>
    position=< 30585,  50810> velocity=<-3, -5>
    position=<-30241, -50548> velocity=< 3,  5>
    position=< 20461, -10002> velocity=<-2,  1>
    position=<-20076,  30544> velocity=< 2, -3>
    position=<-20064,  20409> velocity=< 2, -2>
    position=<-50476,  30544> velocity=< 5, -3>
    position=< 10304,  10273> velocity=<-1, -1>
    position=<-50505, -10004> velocity=< 5,  1>
    position=< 40743,  50812> velocity=<-4, -5>
    position=<-30196, -20144> velocity=< 3,  2>
    position=< 20465,  -9999> velocity=<-2,  1>
    position=<-20055, -10008> velocity=< 2,  1>
    position=< 50873,  30545> velocity=<-5, -3>
    position=< -9972, -10002> velocity=< 1,  1>
    position=< 10300,  50811> velocity=<-1, -5>
    position=<-40337, -40412> velocity=< 4,  4>
    position=<-20096, -30276> velocity=< 2,  3>
    position=<-50515,  40672> velocity=< 5, -4>
    position=<-50484,  40678> velocity=< 5, -4>
    position=< 50860, -20139> velocity=<-5,  2>
    position=< -9916,  50809> velocity=< 1, -5>
    position=< 40753, -40416> velocity=<-4,  4>
    position=<-40351, -20144> velocity=< 4,  2>
    position=< 50892, -40413> velocity=<-5,  4>
    position=<-50473, -40407> velocity=< 5,  4>
    position=< 50857, -50548> velocity=<-5,  5>
    position=< 40732, -50552> velocity=<-4,  5>
    position=<-30231, -40410> velocity=< 3,  4>
    position=<-40378, -30280> velocity=< 4,  3>
    position=< 20470, -30276> velocity=<-2,  3>
    position=< 40761,  40673> velocity=<-4, -4>
    position=< 30615, -40416> velocity=<-3,  4>
    position=< 20462,  20400> velocity=<-2, -2>
    position=< 30616,  -9999> velocity=<-3,  1>
    position=< 20469, -10004> velocity=<-2,  1>
    position=< 40764, -40413> velocity=<-4,  4>
    position=< 20481,  10265> velocity=<-2, -1>
    position=< -9924, -20139> velocity=< 1,  2>
    position=< 10319,  20405> velocity=<-1, -2>
    position=< 30617, -20135> velocity=<-3,  2>
    position=< 30621,  20404> velocity=<-3, -2>
    position=<-20050, -40416> velocity=< 2,  4>
    position=<-40372,  50810> velocity=< 4, -5>
    position=< 20464,  20409> velocity=<-2, -2>
    position=< 20478,  20405> velocity=<-2, -2>
    position=<-40327,  10266> velocity=< 4, -1>
    position=<-50500,  30542> velocity=< 5, -3>
    position=< -9919, -50552> velocity=< 1,  5>
    position=< -9956,  30544> velocity=< 1, -3>
    position=< -9951, -40409> velocity=< 1,  4>
    position=< 10334,  10268> velocity=<-1, -1>
    position=<-40321,  20400> velocity=< 4, -2>
    position=<-50468,  10266> velocity=< 5, -1>
    position=<-40340,  20400> velocity=< 4, -2>
    position=<-50516,  40680> velocity=< 5, -4>
    position=< 50844,  10268> velocity=<-5, -1>
    position=< 50886, -20139> velocity=<-5,  2>
    position=< 30628, -30272> velocity=<-3,  3>
    position=< 30623, -30276> velocity=<-3,  3>
    position=< 10313, -20142> velocity=<-1,  2>
    position=< 10321,  20404> velocity=<-1, -2>
    position=< -9972, -40407> velocity=< 1,  4>
    position=<-30196, -20140> velocity=< 3,  2>
    position=<-30203, -10008> velocity=< 3,  1>
    position=< 30612, -50543> velocity=<-3,  5>
    position=<-20055,  50813> velocity=< 2, -5>
    position=<-50463, -50548> velocity=< 5,  5>
    position=< -9924,  30537> velocity=< 1, -3>
    position=< 30576,  40676> velocity=<-3, -4>
    position=<-20080,  10273> velocity=< 2, -1>
    position=< 20460,  20400> velocity=<-2, -2>
    position=< 20468,  30545> velocity=<-2, -3>
    position=<-50483,  30540> velocity=< 5, -3>
    position=<-40319,  40673> velocity=< 4, -4>
    position=< -9964,  40680> velocity=< 1, -4>
    position=<-30203, -30280> velocity=< 3,  3>
    position=< 40724,  20405> velocity=<-4, -2>
    position=<-20052, -20142> velocity=< 2,  2>
    position=<-20095, -10007> velocity=< 2,  1>
    position=<-30228, -40409> velocity=< 3,  4>
    position=<-30196, -10006> velocity=< 3,  1>
    position=< -9944,  40672> velocity=< 1, -4>
    position=<-40340,  20409> velocity=< 4, -2>
    position=< 10343, -30271> velocity=<-1,  3>
    position=< 40764, -10005> velocity=<-4,  1>
    position=<-30243,  30536> velocity=< 3, -3>
    position=< 10336,  10268> velocity=<-1, -1>
    position=< -9967,  50817> velocity=< 1, -5>
    position=<-20047, -10005> velocity=< 2,  1>
    position=< 20484, -10006> velocity=<-2,  1>
    position=<-30231,  30540> velocity=< 3, -3>
    position=<-50456, -50552> velocity=< 5,  5>
    position=<-40377, -10008> velocity=< 4,  1>
    position=< -9960,  10268> velocity=< 1, -1>
    position=< -9964,  50817> velocity=< 1, -5>
    position=<-30212, -50549> velocity=< 3,  5>
    position=< -9964, -50549> velocity=< 1,  5>
    position=< 50884,  30543> velocity=<-5, -3>
    position=< 20444,  50808> velocity=<-2, -5>
    position=<-40364,  20402> velocity=< 4, -2>
    position=< 40748,  20400> velocity=<-4, -2>
    position=< 50881, -40414> velocity=<-5,  4>
    position=<-50503, -50549> velocity=< 5,  5>
    position=<-40378,  40681> velocity=< 4, -4>
    position=< 20477,  30542> velocity=<-2, -3>
    position=< 30601,  50808> velocity=<-3, -5>
    position=< 40711, -30276> velocity=<-4,  3>
    position=<-50516,  50814> velocity=< 5, -5>
    position=< 40708,  20405> velocity=<-4, -2>
    position=<-30220,  20407> velocity=< 3, -2>
    position=< 40724, -20138> velocity=<-4,  2>
    position=<-40380, -50549> velocity=< 4,  5>
    position=<-40372, -50547> velocity=< 4,  5>
    position=< 10308, -40415> velocity=<-1,  4>
    position=< 10316, -50546> velocity=<-1,  5>
    position=< 10353,  40674> velocity=<-1, -4>
    position=<-50508, -10007> velocity=< 5,  1>
    position=< 10356, -20144> velocity=<-1,  2>
    position=< 50892, -30276> velocity=<-5,  3>
    position=<-30240,  -9999> velocity=< 3,  1>
    position=< 10358,  10268> velocity=<-1, -1>
    position=< 10360,  50812> velocity=<-1, -5>
    position=< 20480,  20403> velocity=<-2, -2>
    position=<-40370,  30540> velocity=< 4, -3>
    position=< 20478,  50808> velocity=<-2, -5>
    position=<-30207, -10005> velocity=< 3,  1>
    position=<-40372, -20143> velocity=< 4,  2>
    position=<-20076,  30542> velocity=< 2, -3>
    position=< 50869, -40410> velocity=<-5,  4>
    position=<-30200,  50808> velocity=< 3, -5>
    position=<-20089,  40677> velocity=< 2, -4>
    position=<-20051, -30280> velocity=< 2,  3>
    position=<-50455, -50549> velocity=< 5,  5>
    position=<-20076, -30279> velocity=< 2,  3>
    position=<-40329, -20140> velocity=< 4,  2>
    position=<-50498, -40416> velocity=< 5,  4>
    position=< -9940,  10272> velocity=< 1, -1>
    position=< 40724,  50811> velocity=<-4, -5>
    position=< 10313,  20400> velocity=<-1, -2>
    position=< 10345, -40415> velocity=<-1,  4>
    position=<-30210,  50808> velocity=< 3, -5>
    position=<-20052, -20137> velocity=< 2,  2>
    position=< 30601, -10007> velocity=<-3,  1>
    position=<-30218,  50813> velocity=< 3, -5>
    position=< 10348,  20401> velocity=<-1, -2>
    position=< 40716,  30540> velocity=<-4, -3>
    position=< 30597, -20138> velocity=<-3,  2>
    position=< 10308, -40412> velocity=<-1,  4>
    position=< 20484,  50809> velocity=<-2, -5>
    position=< -9971, -20144> velocity=< 1,  2>
    position=<-30244, -20137> velocity=< 3,  2>
    position=<-40372,  50815> velocity=< 4, -5>
    position=< 30588, -10001> velocity=<-3,  1>
    position=<-40332, -30272> velocity=< 4,  3>
    position=<-50468,  30545> velocity=< 5, -3>
    position=< 20484,  50813> velocity=<-2, -5>
    position=< 30589,  20405> velocity=<-3, -2>
    position=<-40327,  50816> velocity=< 4, -5>
    position=< 50873,  10265> velocity=<-5, -1>
    position=< 10356, -40409> velocity=<-1,  4>
    position=<-50473,  20404> velocity=< 5, -2>
    position=< 20457, -20138> velocity=<-2,  2>
    position=<-40359,  20409> velocity=< 4, -2>
    position=< -9923, -30276> velocity=< 1,  3>
    position=<-20081,  -9999> velocity=< 2,  1>
    position=< 30631,  50812> velocity=<-3, -5>
    position=<-20087, -50547> velocity=< 2,  5>
    position=<-30231, -40415> velocity=< 3,  4>
    position=< 20461,  30545> velocity=<-2, -3>
    position=<-30212,  30536> velocity=< 3, -3>
    position=<-20068,  30536> velocity=< 2, -3>
    position=< 40711, -30276> velocity=<-4,  3>"
  end
end
