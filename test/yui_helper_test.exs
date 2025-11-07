defmodule YuiHelperTest do
  use ExUnit.Case
  doctest YuiHelper

  test "greets the world" do
    assert YuiHelper.hello() == :world
  end
end
