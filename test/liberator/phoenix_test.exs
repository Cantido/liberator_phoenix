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

  test "handler can be excluded with :except option" do
    defmodule ExceptResource do
      use Liberator.Resource
      use Liberator.Phoenix, except: [:handle_ok]
    end

    defmodule ExceptView do
      use Phoenix.View, root: "test/support/templates"
    end

    conn = conn(:get, "/")

    conn = ExceptResource.call(conn, [])

    assert conn.resp_body == "OK"
  end

  test "handler can be include with :only option" do
    defmodule OnlyResource do
      use Liberator.Resource
      use Liberator.Phoenix, only: [:handle_ok]
    end

    defmodule OnlyView do
      use Phoenix.View, root: "test/support/templates"
    end

    conn = conn(:get, "/")

    conn = OnlyResource.call(conn, [])

    assert conn.resp_body == "OK (rendered from template)\n\n"
  end
end
