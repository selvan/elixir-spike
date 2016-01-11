defmodule GenCounter do
  # API
  def start_link(_opts \\ []) do
    spawn(fn -> loop(0) end)
  end

  def click(pid) do
    make_call(pid, :click)
  end

  def get(pid) do
    make_call(pid, :get)
  end

  def set(pid, new_value) do
    make_call(pid, {:set, new_value})
  end

  # message handlers
  # handle_msg(message, current_state) -> {reply, new_state}
  defp handle_msg(:click, n), do: {n + 1, n + 1}
  defp handle_msg(:get, n), do: {n, n}
  defp handle_msg({:set, new_value}, _n), do: {:ok, new_value}

  # main state loop
  defp loop(state) do
    receive do
      {from, msg} ->
        {reply, new_state} = handle_msg(msg, state)
        send(from, reply)
        loop(new_state)
    end
  end

  # call helper
  defp make_call(pid, msg) do
    send(pid, {self(), msg})
    receive do x -> x end
  end
end

defmodule MySupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  @counter_name GenCounter

  def init([]) do
    children = [
      worker(GenCounter, [[name: @counter_name]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end

{:ok, pid}=MySupervisor.start_link
GenServer.call(GenCounter, :click)
