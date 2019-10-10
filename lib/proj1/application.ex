defmodule Proj1.Application do
  @moduledoc false

  use Application
  def start(_type, [n1,n2]) do
    children = [
      %{id: :child1, start: {VampireNum, :start_link, [[n1, n1 + div(n2-n1,5)]]}
      },
      %{id: :child2, start: {VampireNum, :start_link, [[n1 + div(n2-n1,5), n1 + 2*div(n2-n1,5)]]}
      },
      %{id: :child3, start: {VampireNum, :start_link, [[n1 + 2*div(n2-n1,5), n1 + 3*div(n2-n1,5)]]}
      },
      %{id: :child4, start: {VampireNum, :start_link, [[n1 + 3*div(n2-n1,5), n1 + 4*div(n2-n1,5)]]}
      },
      %{id: :child5, start: {VampireNum, :start_link, [[n1 + 4*div(n2-n1,5), n1 + 5*div(n2-n1,5)]]}
      }
    ]
    opts = [strategy: :one_for_one, name: Proj1.Supervisor]
    Supervisor.start_link(children, opts)
  end
  def recv do
    receive do
      {:msg, value} ->
        final_values = [] ++ [value]
        pid = spawn(&Proj1.Application.print/0)
        send(pid, {:msg , final_values})
    end
  end
  def print do
    receive do
      {:msg, value} ->
      Enum.each(value, fn x -> IO.puts x end)
    end
  end
end
