defmodule Liberator.PhoenixTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest Liberator.Phoenix

  test "handler returns result of view" do
    defmodule HappyPathResource do
      use Liberator.Resource
      use Liberator.Phoenix
    end

    defmodule HappyPathView do
      use Phoenix.View, root: "test/support/templates"
    end

    conn = conn(:get, "/")

    conn = HappyPathResource.call(conn, [])

    assert conn.resp_body == "OK (rendered from template)\n\n"
  end
end
