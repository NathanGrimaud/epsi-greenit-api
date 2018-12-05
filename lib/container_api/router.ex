defmodule ContainerApi.Router do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    def fib(0) do 0 end
    def fib(1) do 1 end
    def fib(n) do 
        fib(n-1) + fib(n-2)
    end
  

    get ("/") do
        payload = Poison.encode!(%{
            "timestamp" => :os.system_time(:seconds)
        })
        send_resp(conn, 200, payload)
    end

    get ("/file") do
        {:ok, file} = File.read("static/cowboy-home.png")
        send_resp(conn, 200, file)
    end


    get ("/cpu") do 
        fibo_start = :os.system_time(:seconds)
        num = fib(30)
        fibo_end = :os.system_time(:seconds)
        time = fibo_end - fibo_start
        payload = Poison.encode!(%{
            "task_start" => fibo_start,
            "task_end" => fibo_end,
            "task_time" => fibo_end - fibo_start
        })
        send_resp(conn, 200, payload)
    end

    match (_) do
        send_resp(conn, 404, "oops")
    end
end