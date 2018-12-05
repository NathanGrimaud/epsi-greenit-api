defmodule ContainerApiTest do
  use ExUnit.Case
  doctest ContainerApi

  test "greets the world" do
    assert ContainerApi.hello() == :world
  end
end
