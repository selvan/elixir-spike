defmodule Test do
	def hello() do
		receive do
			{:english, name, pid} ->
				send pid, {:ok, "Hello #{name}"}

			{:tamil, name, pid} -> 
				send pid, {:ok, "Vanakam #{name}"}
		end
	end
end


