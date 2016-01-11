pandoc -S -o elixir.epub \
  introduction.markdown \
  modules.markdown

defmodule CounterAgent do

  def start_link(name) do
    Agent.start_link(fn -> 0 end, name: name)
  end

  def new do
    Agent.start_link(fn -> 0 end)
  end

  def click(pid) do
    Agent.get_and_update(pid, fn(n) -> n + 1 end)
  end

  def set(pid, new_value) do
    Agent.update(pid, fn(_n) -> new_value end)
  end

  def get(pid) do
    Agent.get(pid, fn(n) -> n end)
  end
end


defmodule Stack do
  use GenServer

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def handle_call(:pop, _from, [h|t]) do
    {:reply, h, t}
  end

  def handle_cast({:push, h}, t) do
    {:noreply, [h|t]}
  end
end

defmodule MySupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Stack, [[:hello], [name: :sup_stack]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end

MySupervisor.start_link
GenServer.call(:sup_stack, :pop)

defmodule CounterServer do
  use GenServer

  def start_link(opts \\ []) do
  	GenServer.start_link(__MODULE__, 0, opts)
  end	

  # GenServer callbacks
  def handle_call(:click, _from, n) do
    {:reply, n + 1, n + 1}
  end

  def handle_call(:get, _from, n) do
    {:reply, n, n}
  end
  def handle_call({:set, new_value}, _from, _n) do
    {:reply, :ok, new_value}
  end
end

defmodule MySupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  @counter_name CounterServer

  def init([]) do
    children = [
      worker(CounterServer, [[name: @counter_name]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end

{:ok, pid}=MySupervisor.start_link
GenServer.call(CounterServer, :click)
GenServer.call(CounterServer, {:set, "abc"})
## This will crash process
GenServer.call(CounterServer, :click)

CounterServer.click(pid)

defmodule CounterAgent do
  def start_link(opts \\ []) do
    Agent.start_link(fn -> 0 end, opts)
  end

  def click(pid) do
    Agent.get_and_update(pid, fn(n) -> {n + 1, n + 1} end)
  end

  def set(pid, new_value) do
    Agent.update(pid, fn(_n) -> new_value end)
  end

  def get(pid) do
    Agent.get(pid, fn(n) -> n end)
  end
end

defmodule MySupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  @counter_name CounterAgent

  def init([]) do
    children = [
      worker(CounterAgent, [[name: @counter_name]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end

{:ok, pid}=MySupervisor.start_link
CounterAgent.click(CounterAgent)


