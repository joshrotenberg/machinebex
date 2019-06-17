defmodule MachinebExTest do
  use ExUnit.Case
  doctest MachinebEx

  test "greets the world" do
    assert MachinebEx.hello() == :world
  end
end
