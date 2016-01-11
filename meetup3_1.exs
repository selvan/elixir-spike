defmodule Test do
	def hello({:english, name}) do
		IO.puts "Hello #{name}"
	end

	def hello({:tamil, name}) do
		IO.puts "Vanakam #{name}"
	end
end
