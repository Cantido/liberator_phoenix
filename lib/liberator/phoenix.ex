# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule Liberator.Phoenix do
  @moduledoc """
  Phoenix Framework integration for the Liberator library.

  This module implements Liberator handlers that render Phoenix views.
  It infers your view name by replacing `Resource` in your module name with `View`.
  For example, `MyPhoenixResource` will use `MyPhoenixView` as its view module.

      defmodule MyPhoenixResource do
        use Liberator.Resource
        use Liberator.Phoenix
      end

      defmodule MyPhoenixView do
        use MyProject, :view
      end

  If you need to override it, set the `:view_module` option in your `use` statement.

      defmodule MyPhoenixResource do
        use Liberator.Resource
        use Liberator.Phoenix, view_module: MyOtherView
      end

  You can also select only certain handlers to be overridden with the `:only` and `:except` options.

      defmodule MyPhoenixResource do
        use Liberator.Resource
        use Liberator.Phoenix, only: [:handle_ok]
      end

  The handlers will use the status code as the template name and the extension of the negotiated media type.
  For example, the `c:Liberator.Resource.handle_not_found/1` handler with a negotiated media type of `text/plain` will render `404.txt`.
  The `c:Liberator.Resource.handle_created/1` handler with a media type of `application/json` will render `201.json`.

  The values set in `conn.assigns` will be given to the view as well.
  """

  def options_schema(module) do
    NimbleOptions.new!(
      only: [
        type: {:list, :atom},
        default: [],
        doc: "A list of handler functions that should render views."
      ],
      except: [
        type: {:list, :atom},
        default: [],
        doc: "A list of handler functions that should not render views."
      ],
      view_module: [
        type: :atom,
        default: view_name(module),
        doc: "The view module that should render views for this module."
      ]
    )
  end

  def view_name(module) do
    module
    |> Atom.to_string()
    |> String.replace_trailing("Resource", "")
    |> Kernel.<>("View")
    |> String.to_atom()
  end

  def get_format(conn) do
    if is_nil(conn.assigns[:media_type]) do
      "txt"
    else
      MIME.extensions(conn.assigns[:media_type]) |> Enum.at(0)
    end
  end

  def render(conn, template, opts) do
    view_module = Keyword.get(opts, :view_module, view_module(conn))
    template_name = template <> "." <> get_format(conn)
    Phoenix.View.render(view_module, template_name, conn.assigns)
  end

  def view_module(conn) do
    view_name(conn.private.liberator_module)
  end

  def handler_enabled?(handler, opts) do
    only = Keyword.get(opts, :only, [])
    except = Keyword.get(opts, :except, [])

    if Enum.empty?(only) do
      handler not in except
    else
      handler in only and handler not in except
    end
  end

  defmacro __using__(opts) do
    # credo:disable-for-next-line Credo.Check.Refactor.LongQuoteBlocks
    quote bind_quoted: [opts: opts] do
      opts = NimbleOptions.validate!(opts, Liberator.Phoenix.options_schema(__MODULE__))

      if Liberator.Phoenix.handler_enabled?(:handle_ok, opts) do
        @impl Liberator.Resource
        def handle_ok(conn), do: Liberator.Phoenix.render(conn, "200", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_options, opts) do
        @impl Liberator.Resource
        def handle_options(conn), do: Liberator.Phoenix.render(conn, "200-options", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_created, opts) do
        @impl Liberator.Resource
        def handle_created(conn), do: Liberator.Phoenix.render(conn, "201", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_accepted, opts) do
        @impl Liberator.Resource
        def handle_accepted(conn), do: Liberator.Phoenix.render(conn, "202", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_no_content, opts) do
        @impl Liberator.Resource
        def handle_no_content(conn), do: Liberator.Phoenix.render(conn, "204", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_multiple_representations, opts) do
        @impl Liberator.Resource
        def handle_multiple_representations(conn),
          do: Liberator.Phoenix.render(conn, "300", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_moved_permanently, opts) do
        @impl Liberator.Resource
        def handle_moved_permanently(conn),
          do: Liberator.Phoenix.render(conn, "301", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_see_other, opts) do
        @impl Liberator.Resource
        def handle_see_other(conn), do: Liberator.Phoenix.render(conn, "303", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_not_modified, opts) do
        @impl Liberator.Resource
        def handle_not_modified(conn), do: Liberator.Phoenix.render(conn, "304", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_malformed, opts) do
        @impl Liberator.Resource
        def handle_malformed(conn), do: Liberator.Phoenix.render(conn, "400", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_payment_required, opts) do
        @impl Liberator.Resource
        def handle_payment_required(conn),
          do: Liberator.Phoenix.render(conn, "402", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_unauthorized, opts) do
        @impl Liberator.Resource
        def handle_unauthorized(conn), do: Liberator.Phoenix.render(conn, "401", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_forbidden, opts) do
        @impl Liberator.Resource
        def handle_forbidden(conn), do: Liberator.Phoenix.render(conn, "403", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_not_found, opts) do
        @impl Liberator.Resource
        def handle_not_found(conn), do: Liberator.Phoenix.render(conn, "404", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_method_not_allowed, opts) do
        @impl Liberator.Resource
        def handle_method_not_allowed(conn),
          do: Liberator.Phoenix.render(conn, "405", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_not_acceptable, opts) do
        @impl Liberator.Resource
        def handle_not_acceptable(conn), do: Liberator.Phoenix.render(conn, "406", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_conflict, opts) do
        @impl Liberator.Resource
        def handle_conflict(conn), do: Liberator.Phoenix.render(conn, "409", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_gone, opts) do
        @impl Liberator.Resource
        def handle_gone(conn), do: Liberator.Phoenix.render(conn, "410", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_precondition_failed, opts) do
        @impl Liberator.Resource
        def handle_precondition_failed(conn),
          do: Liberator.Phoenix.render(conn, "412", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_request_entity_too_large, opts) do
        @impl Liberator.Resource
        def handle_request_entity_too_large(conn),
          do: Liberator.Phoenix.render(conn, "413", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_uri_too_long, opts) do
        @impl Liberator.Resource
        def handle_uri_too_long(conn), do: Liberator.Phoenix.render(conn, "414", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_unsupported_media_type, opts) do
        @impl Liberator.Resource
        def handle_unsupported_media_type(conn),
          do: Liberator.Phoenix.render(conn, "415", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_too_many_requests, opts) do
        @impl Liberator.Resource
        def handle_too_many_requests(conn),
          do: Liberator.Phoenix.render(conn, "429", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_unavailable_for_legal_reasons, opts) do
        @impl Liberator.Resource
        def handle_unavailable_for_legal_reasons(conn),
          do: Liberator.Phoenix.render(conn, "451", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_error, opts) do
        @impl Liberator.Resource
        def handle_error(conn, _error, _failed_step),
          do: Liberator.Phoenix.render(conn, "500", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_not_implemented, opts) do
        @impl Liberator.Resource
        def handle_not_implemented(conn), do: Liberator.Phoenix.render(conn, "501", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_unknown_method, opts) do
        @impl Liberator.Resource
        def handle_unknown_method(conn), do: Liberator.Phoenix.render(conn, "501", unquote(opts))
      end

      if Liberator.Phoenix.handler_enabled?(:handle_service_unavailable, opts) do
        @impl Liberator.Resource
        def handle_service_unavailable(conn),
          do: Liberator.Phoenix.render(conn, "503", unquote(opts))
      end
    end
  end
end
