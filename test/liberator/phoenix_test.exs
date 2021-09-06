defmodule Liberator.PhoenixTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest Liberator.Phoenix

  defmodule HappyPathResource do
    use Liberator.Resource
    use Liberator.Phoenix
  end

  defmodule HappyPathView do
    use Phoenix.View, root: "test/support/templates"
  end

  test "handler returns result of view" do
    conn = conn(:get, "/")

    conn = HappyPathResource.call(conn, [])

    assert conn.resp_body == "OK (rendered from template)\n\n"
  end

  defmodule ExceptResource do
    use Liberator.Resource
    use Liberator.Phoenix, except: [:handle_ok]
  end

  defmodule ExceptView do
    use Phoenix.View, root: "test/support/templates"
  end

  test "handler can be excluded with :except option" do
    conn = conn(:get, "/")

    conn = ExceptResource.call(conn, [])

    assert conn.resp_body == "OK"
  end

  defmodule OnlyResource do
    use Liberator.Resource
    use Liberator.Phoenix, only: [:handle_ok]
  end

  defmodule OnlyView do
    use Phoenix.View, root: "test/support/templates"
  end

  test "handler can be include with :only option" do
    conn = conn(:get, "/")

    conn = OnlyResource.call(conn, [])

    assert conn.resp_body == "OK (rendered from template)\n\n"
  end

  defmodule OtherModuleResource do
    use Liberator.Resource, trace: :log
    use Liberator.Phoenix, view_module: Liberator.PhoenixTest.AnotherModule
  end

  defmodule AnotherModule do
    use Phoenix.View, root: "test/support/templates"
  end

  test "A different view module can be specified with the :view_module option" do
    conn = conn(:get, "/")

    conn = OtherModuleResource.call(conn, [])

    assert conn.resp_body == "OK (rendered from template)\n\n"
  end
end
