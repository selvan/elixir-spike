pid=spawn(Test, :hello, [])
send pid, {:tamil, "selvan", self}

pid=spawn(Collection, :stack, [])
send pid, {:show, self}
send pid, {:pop, self}

send pid, {:push, 20, self}

do_receive = fn ->
receive do 
{:ok, msg} ->
IO.puts msg
end
end	

do_receive.()
