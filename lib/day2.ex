defmodule Aoc2018.Day2 do

  def a(input \\ input()) do
    input
    |> parse_input()
    |> Enum.reduce({0, 0},
      fn(elem, {twos, threes}) ->
        res =
          Enum.reduce(elem, %{},
            fn(s, acc) ->
              case Map.get(acc, s) do
                nil -> Map.put_new(acc, s, 1)
                value -> Map.replace!(acc, s, value + 1)
              end
            end
          )

        values = Map.values(res)

        new_twos =
          case Enum.member?(values, 2) do
            false -> twos
            true -> twos + 1
          end

        new_threes =
          case Enum.member?(values, 3) do
            false -> threes
            true -> threes + 1
          end
        {new_twos, new_threes}
      end
    )
    |> multiply()

  end

  def multiply({a, b}), do: a * b

  def b(input \\ input()) do
    p_i = parse_input(input)
    try do
      Enum.each(p_i,
        fn(e) ->
          elems = p_i -- [e]
          Enum.each(elems,
            fn(e_r) ->
              diffs =
                Enum.reduce(0..25, [],
                fn(i, acc) ->
                  case Enum.at(e_r, i) == Enum.at(e, i) do
                    false -> [Enum.at(e_r, i)|acc]
                    true -> acc
                  end
                end
                )
              if length(diffs) == 1 do
                throw({:found, {e_r, e}})
              end
            end
          )
        end
      )
        # end
    catch _, v -> v
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
  end

  def input do
   "rvefnvyxzbodgpnpkumawhijsc
rvefqtyxzsddglnppumawhijsc
rvefqtywzbodglnkkubawhijsc
rvefqpyxzbozglnpkumawhiqsc
rvefqtyxzbotgenpkuyawhijsc
rvefqtyxzbodglnlkumtphijsc
rwefqtykzbodglnpkumawhijss
rvynqtyxzbodglnpkumawrijsc
rvefqtyxlbodgcnpkumawhijec
rvefqtyxzbodmlnpnumawhijsx
rvefqtyxzbqdbdnpkumawhijsc
rvefqtyxzlodblnpkuiawhijsc
rvefqtyizrodelnpkumawhijsc
rveffjyxzgodglnpkumawhijsc
rvefqjyxzbodalnpkumadhijsc
rvefqtidzbodglnpkumawhdjsc
hvefqtygzbodglnpkumawhijfc
rzefqtyxzbodglfhkumawhijsc
rmefqtyxzbolglnpkumaehijsc
rnefqqyxzbodglnhkumawhijsc
rvwfqvyxzbodglnpcumawhijsc
rvefqtyxzbokgltpkumavhijsc
rvefciyxzbodglnmkumawhijsc
rvefptyxzbodglnpkuhashijsc
rvefqtyxzrodglnpkxmawhiqsc
rvefqtyxzbotglnpkumawriwsc
rvufqtyxzbodglnplumawhijvc
rvefutykzbodglnpkumaahijsc
rvefqtyxqbodgllprumawhijsc
rvegqttxzbodgllpkumawhijsc
dvefqtyxzsodglnpkumawdijsc
rvefqtyxkbodglnfkumawhijsj
rvefqtyxzbodnlnpcumawhijnc
rvefqtyxzbodglfpkuocwhijsc
rvecqtyxzbbdganpkumawhijsc
rvefytyxzbodglnpkubgwhijsc
rvefxtyazbomglnpkumawhijsc
rvefqgyxzbodglnpkumawyiksc
avefqtyxzbodglnfkummwhijsc
fvefqtyxzbbdglnpkumswhijsc
rvefqtyxzxodglnpkumuuhijsc
rvezqtyxzbydclnpkumawhijsc
rvefqtyxzbohglnpkumawdijjc
rvejqtyxzbodrlnpkumawhijsd
rvefitzxzbxdglnpkumawhijsc
rvefutyxzbvdglnikumawhijsc
rvefqtyazbodgqnbkumawhijsc
rvefqtyxzbolglnpkwmajhijsc
rvefqtyxzjodglnpgwmawhijsc
rvefhtyxzbodglbpaumawhijsc
mvexqtyxzbodglnpkumawrijsc
rvefqtyxwbodglnpkumawhbxsc
rvefqtyxzbodgsnpkudawsijsc
rvwfqtyxzbonglnwkumawhijsc
rvefqtyxzjodglnpkfmawhwjsc
rvefqtyxzbodglntkumughijsc
rvefctyxzbodglnpkumawhiwsx
avefqtyvzbodglnpkumawhijsb
rfefqtyxzlodglnphumawhijsc
rvefqtyxzfowglnpkumaehijsc
rvhfvtyxzbodgqnpkumawhijsc
rfefqtyxzbodglapkumuwhijsc
rvefqclxzbodglnzkumawhijsc
qvefqtyxzbodglnckumcwhijsc
rvefqtyxzkodglnpkymawgijsc
rvefqtyxzbodgfnpkumafhizsc
rvefqtyxzbodglnxkumavhijsf
rvevqtyxzbodgpnpkurawhijsc
rvefqtyxziodglnpkubawhijss
rrefqtpxzyodglnpkumawhijsc
rvefqfyxzbodglcpkxmawhijsc
rvefdtyxzbodglnpkumvwhijsn
rverqtyxzbodglnpkwmawhijuc
rvecjtyxzboxglnpkumawhijsc
rvefqtyxzbodglnpkqmaxhifsc
rtnfqtyxzbodglnpkumawhijmc
lvefqtyxzbodelnpkumawhijsz
dvefqtyxzbbdgvnpkumawhijsc
rvefqlyhzbodglnpkumtwhijsc
roefqtyxlbodglnpkumawhyjsc
rvefqsydzjodglnpkumawhijsc
rveybtyxzbodglnpkumawhijsn
rvefqtyhzbodgvnpmumawhijsc
rvefqxyazboddlnpkumawhijsc
vvefqtyxzbohglqpkumawhijsc
reefhtyxzbodglnpkkmawhijsc
rvefqtyxzbodglnpkulowhijrc
rveqqtyxzbodgknpkumawhijsk
jvefqtqxzbodglnpkumawiijsc
rvefqtyxzboxglnpvuqawhijsc
rvefquyxzbodglwwkumawhijsc
rvefqtyxzbodnlnpkumawhgjbc
rvdfqthxdbodglnpkumawhijsc
rvefqtyxzbodllnpkumawhujsb
evefqtyxzboyglnpkumowhijsc
rvefktyxzbomglnpzumawhijsc
rvefqtyxzbodhlnnkrmawhijsc
rvefqtyxrbodglnpkujaehijsc
rvefqtyzzbodglnpkumrwhijsb
evefqtyxzpodglfpkumawhijsc
rvefqtyxibodglkpyumawhijsc
rrefqtyxzbodglnpkudawhajsc
rvifqtyxzbodglxpkumawhijlc
rxefqtyxzbedglnpkumawhijsp
rvnfqtyxzbopglnpkuqawhijsc
rvefqtyxkbodglnpoumawoijsc
dvefwtyxzbodglnpksmawhijsc
rvkfqtyxzbodglnpkdmawhijsa
rcefytyxzzodglnpkumawhijsc
rvefqtkxzbodglnpktqawhijsc
nvezqhyxzbodglnpkumawhijsc
rrefqtyxzbodgunpkumpwhijsc
rvefqtaxzbodgknpkumawhijic
pvefqtyxzbodglnpkuxawsijsc
rvefqtyxzbodglkpvumawhjjsc
wvefqtyxzkodglnpkumawhhjsc
rzefqtyxzbotglnpkumawhxjsc
rvefqtxpzbodglnpkumawzijsc
bgefqtyxzbodglnpkrmawhijsc
rvefqlyxzbodglnpkumilhijsc
cbefqtyxzbodglnpkumawhiesc
rvefqtyxzbydelnpkumahhijsc
rvefntyxzbodglnpkumaehijsw
rverqtyxztodglopkumawhijsc
rvefqtyxzdodgwrpkumawhijsc
rvefqtyxibodglnikumawhtjsc
qvafqtyxzbodglnpkurawhijsc
rvefqtyxwbodglnpaumawoijsc
rvefqtyxzoodglndknmawhijsc
rvdfqtlxzyodglnpkumawhijsc
rvefqtyxzbodglngfumawhinsc
rsefqtyxzbodglnpkumawhijek
rvoestyxzbodglnpkumawhijsc
svefqtyxzboaglnprumawhijsc
rvefqtybzbodgwnpkumawwijsc
rvefqtyxzdwdglnpkvmawhijsc
rvlfqtyxzbodglnpkrmawhixsc
rvefqtyxwbodglepkumawhijsd
rvefqtbxzbodglnqkumawhijmc
rvefqtzxzbodglnpkumuzhijsc
rvefqtyxzbodglnpkumawzwnsc
rvwfqtyxzboiglnpkumawhijsg
rtehotyxzbodglnpkudawhijsc
rvegqtyxzbodglnpyumawhijsl
rvecqtyxzbsdglnpkumawhojsc
rvefqtyxzbodmlnpkumaghijfc
rvefqtyxzxodglnpkumanvijsc
rvefqtyxzbodglnbiugawhijsc
lvefqtlxzbodglnplumawhijsc
rvefqtyxvbodglnpkumaldijsc
rmefqtyxzbodgvnpkuuawhijsc
rvefqtyxzbodglnpkymeuhijsc
rvefqtyxzuodganpsumawhijsc
rxefqtyxzbodglnpkumgwhijwc
rvefgtyxzbodglnpkudawxijsc
ahefqtyxzbodglnpkumawhejsc
rfefqtyxzbzdglnpkusawhijsc
rvefqtyszqodgljpkumawhijsc
rvefqtylzboiglnpkumrwhijsc
rvefqtyxzltdglnpkumawhijsu
rbefqtyxzbodglnpqumawhijsi
rvefqtyozpodglnpkumawhijsa
zvefqtyxzpopglnpkumawhijsc
rvefqtyxzbodglnfkqmawhijsp
rvefqtyxzbodgliakumawhijsf
rvefqtymzrodgfnpkumawhijsc
ivejqtyxzbodglnpkumawhijuc
rvefqtyxzbodflnpkxwawhijsc
dvrfqtyxzbodglnpkumashijsc
rqefqtyxzbwdglnpkumawvijsc
tvefqtkxzbodgltpkumawhijsc
rvefdtyxzbodguxpkumawhijsc
rveqqtyxvbodglnykumawhijsc
rvefqtypzcovglnpkumawhijsc
rvefqnyxzbosglnpkumdwhijsc
rvefstjxzbodslnpkumawhijsc
rvefqzyxzpodglnpkummwhijsc
rvefqkyxzbodglnhgumawhijsc
rvufqvyxzbodklnpkumawhijsc
rvefotyxzhodglnpkumawhijsk
rvefqtyxzbokglnpkumawvcjsc
lvefqtyxzbolglnpkumawoijsc
rvefqtywzoodglfpkumawhijsc
rvehqtqxzbodglnpkumawhcjsc
rqefqtyxzbodolnpkumjwhijsc
rvefqtyxzbodglrpkunawgijsc
rvefqtyxzbodglamkumawdijsc
rvefvtyzzbodllnpkumawhijsc
rvefqtyxzbldglnpfcmawhijsc
rvefppyxzbodglnpkucawhijsc
rvefquyuzbodglnpkumkwhijsc
rvefqtyxzbodgqxpkumawhivsc
rtefotyxzbodglnpkudawhijsc
rvefqtyxzbodgbnmkuzawhijsc
ivefqtyxzbodgsnpkumzwhijsc
rvhfqtyxzbodolnpkumawhijsz
rvefvtyxzbodwlnpkusawhijsc
riemqtyxzbodglnpkumawhiasc
rvtfqtyxzbqdglnpkumawuijsc
raesqtyxzbodglnpkumawhijsj
rvefqtyxzbodalmpkumawhihsc
rvefqtlxzbodgznpkkmawhijsc
rvefqbyxzbodglgpkubawhijsc
rvefqtyxnbodgxnpkumswhijsc
rvefqtyxzkodvlnukumawhijsc
rvefqtyzzbocglnpkumafhijsc
rvhfqtyxzbodglmpkumgwhijsc
rvsfrtyxzbodnlnpkumawhijsc
rvefqtyxzbxdglnpkujcwhijsc
rvefqtyvzrodglnphumawhijsc
reetatyxzbodglnpkumawhijsc
rvefqtyxzbodglnpzumaoqijsc
ovefqtyyzbodglnvkumawhijsc
rvefqbyxzbodnlnpkumawhijsi
xvefqtyxzbodgrnpkumawrijsc
rvebqtyxzbodglnpkumazhiasc
rqeretyxzbodglnpkumawhijsc
rvefqtyxzyodglapkumvwhijsc
rvesqxyxzbodglnpvumawhijsc
rvefqtyxeborglnpkufawhijsc
rvecqtyxzbodflnpkumawnijsc
rvefdpyxtbodglnpkumawhijsc
rvefqtyfzbodclnpkymawhijsc
rvefqtywzbodglnpxumawhiusc
rvefqtyxzbodglnpkumawzbjwc
rvewqtyxdbodglnpxumawhijsc
rvefqtyxzgocglnpkgmawhijsc
rvufqtyxzbodggnpkuzawhijsc
rvefqtynzlodgllpkumawhijsc
rvedqtyxzbodghnpkumawhujsc
rvefqtyxlbodgnnpkpmawhijsc
rvefqtyxzboqglnpkzmawhijec
rvefqtyxzbodglnpkfmwwyijsc
rwefqtkxzbodzlnpkumawhijsc
rvefqtyxvbodglnpkufawhyjsc
rvefqtyxzbodgltpkumawhqmsc
rvefctyxzbodglfpkumathijsc
rvefqtyxzbodgfnpkuuawhijfc
rvefqttxzbodglnpmumawhijwc
rvefqtyxzbodglnpkqmawhihsj
rvefqtyxzbsdglcnkumawhijsc
rvbiqtyxzbodglnpkumawhijlc
rnefqtylzvodglnpkumawhijsc
mvefqtyxzbddglnpkumcwhijsc
rvefwtyxzbodglnpkgmawhijxc
rvefqtyxljodglnpkumxwhijsc
rvefqtyxzbodglnpkuprwhijsd
rcxfqtyxzbldglnpkumawhijsc
rvetqtyxzbojglnpkumewhijsc
rvxfqtyxzbtdglnpkbmawhijsc"
  end
end
