y=12
_fn = fn -> IO.puts y end 
defmodule X do
def hello(_fn) do
y=10
_fn.()
end
end



defmodule X do
defmacro hello(q) do
k=unquote do: q 
quote do: k.()
end
end
require X
X.hello(quote(do: fn -> IO.puts y end))


defmodule X do
defmacro hello(q) do 
quote do: unquote do: q
end
end
require X
X.hello(IO.puts "123")


defmodule X do
defmacro hello(q) do 
quote do
var!(y) = 100
_fn=unquote q
_fn.()
end
end
end
require X
X.hello(fn -> y end)

defmodule X do
defmacro hello(q) do 
quote do
var!(y) = 100
_fn=unquote q
_fn.()
end
end
end
require X
X.hello(fn -> y end)

defmodule X do
defmacro hello(q) do 
var = Macro.var(:y, nil)
value=100
quote do
unquote(var) = unquote(value)
_fn=unquote q
_fn.()
end
end
end
require X
X.hello(fn -> y end)
