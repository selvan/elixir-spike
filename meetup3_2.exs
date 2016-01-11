defmodule Collection do
	def stack(list \\ [1, 2, 3, 4]) do
		receive do
			{:pop, pid} ->
				[head | tail] = list
				send pid, {:ok, head}
				stack(tail)
			{:push , item, pid} -> 
				send pid, {:ok, item}
				stack([item | list])
			{:show, pid} -> 
				send pid, {:ok, list}				
				stack(list)
		end
	end
end