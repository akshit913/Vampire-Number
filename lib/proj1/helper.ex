defmodule VampireNum do
  use GenServer
  def start_link([n1,n2]) do
      GenServer.start_link(__MODULE__, [n1,n2])
  end
  def vamp(:pname) do
      GenServer.call(:pname,:vamp)
  end
  # Server (callbacks)

  def init([n1,n2]) do
      VampireNum.initt(n1,n2)
      {:ok, [n1,n2]}
  end
  def handle_call(:vamp, _from, [n1,n2]) do
      VampireNum.initt(n1,n2)
      {:reply, n1, n2}
  end
  def start() do
      var = System.argv
      n1 = String.to_integer(List.first(var))
      n2 = String.to_integer(List.last(var))
      VampireNum.initt(n1,n2)
  end
  def initt(n1, n2) when n1 <= n2 do
      pid = spawn(&Childi.maker/0)
      send(pid, {:msg , n1 , n2})
      VampireNum.initt(n1+1 , n2)
  end
  def initt(n1, n2) when n1 > n2 do
  end
  def factors(n) do
      head = trunc(n / :math.pow(10, div(Integer.to_charlist(n) |> length, 2)))
      tail  = :math.sqrt(n) |> round
      digits_list = Enum.sort(Integer.digits(n))
      digits = Enum.count(digits_list)
      fang_size = digits/2
      for i <- head .. tail do
          if rem(n, i) == 0 do
              if rem(digits,2) == 0 do
                  if (rem(i,10) == 0 and rem(div(n, i),10) != 0) || (rem(i,10) != 0 and rem(div(n, i),10) == 0) || (rem(div(n, i),10) != 0 and rem(div(n, i),10)!=0) do
                      if (Enum.count(Integer.digits(i)) == fang_size && Enum.count(Integer.digits(div(n, i))) == fang_size) do
                          fang_digits = Enum.sort(Enum.concat(Integer.digits(i),Integer.digits(div(n, i))))
                          if (digits_list == fang_digits) do
                              [] ++ [i,div(n,i)]
                          end
                      end
                  end
              end
          end
      end
  end
  def display(n) do
      li = Enum.filter(factors(n), & !is_nil(&1))
      if(li != []) do
          li = List.flatten(li)
          li = [n] ++ li
          str = Enum.join(li, " ")
          #IO.puts "#{n} #{str}"
          pid = spawn(&Proj1.Application.recv/0)
          send(pid, {:msg , str})
      end
  end
end
defmodule Childi do
    def maker do
        receive do
            {:msg , n1, _n2} ->
            VampireNum.display(n1)
        end
    end
  end
