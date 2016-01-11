defmodule CounterAgent do
  def start_link(name) do
    Agent.start_link(fn -> 0 end, name: name)
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

{:ok, pid}=CounterAgent.start_link(:xyz)
CounterAgent.click(pid)


defmodule CounterAgent do
  def start_link(opts \\ []) do
    list = Enum.map(1..1, fn(i) -> "#{i}" end)
    Agent.start_link(fn -> list end, name: __MODULE__)
  end

  def get() do
    Agent.get(__MODULE__, fn(list) -> list end)
  end

  def set() do
    Agent.update(__MODULE__, fn(list) -> list ++ [2] end)
  end  
end

CounterAgent.start_link
CounterAgent.set

defmodule Client do
  def start_link(name) do
    Agent.start_link(fn -> end, name: name)
  end

  def click(pid) do
    Agent.update(pid, fn(list) -> CounterAgent.set; CounterAgent.get end)
  end

  def get(pid) do
    Agent.get(pid, fn(list) -> CounterAgent.get end)
  end
end

{:ok, pid}=Client.start_link(:xyz4)
Client.click(pid)

{:ok, pid}=Client.start_link(:abc)
Client.click(pid)


list = Enum.map(1..2, fn(i) -> "#{i} abcdefghijklmnopqrstuvwxyz"; end)


:timer.sleep(1000)


list = Enum.map(1..10000, fn(i) -> "#{i} abcdefghijklmonpqrstuvwxyz" end)
x=spawn(fn -> x= list ++ []; length(x); :timer.sleep(500000) end)
x=spawn(fn -> x= list ++ Enum.map(1..10000, fn(i) -> "#{i} abcdefghijklmonpqrstuvwxyz" end); length(x); :timer.sleep(500000) end)
x=spawn(fn -> x= length(list); :timer.sleep(500000) end)
x=spawn(fn -> :timer.sleep(500000) end)
x=spawn(fn -> list :timer.sleep(500000) end)



