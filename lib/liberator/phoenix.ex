defmodule Liberator.Phoenix do
  @moduledoc """
  Documentation for `Liberator.Phoenix`.
  """

  def view_name(module) do
    module
    |> Atom.to_string()
    |> String.replace_trailing("Resource", "")
    |> Kernel.<>("View")
    |> String.to_atom()
  end

  def get_format(_conn) do
    "text"
  end

  def render(conn, template, assigns) do
    template_name = template <> "." <> get_format(conn)
    Phoenix.View.render(view_module(conn), template_name, assigns)
  end

  def view_module(conn) do
    view_name(conn.private.liberator_module)
  end

  defmacro __using__(_opts) do
    quote do
      import Liberator.Phoenix, only: [render: 3]

      @impl Liberator.Resource
      def handle_ok(conn), do: render(conn, "200", [])

      @impl Liberator.Resource
      def handle_options(conn), do: render(conn, "200-options", [])

      @impl Liberator.Resource
      def handle_created(conn), do: render(conn, "201", [])

      @impl Liberator.Resource
      def handle_accepted(conn), do: render(conn, "202", [])

      @impl Liberator.Resource
      def handle_no_content(conn), do: render(conn, "204", [])

      @impl Liberator.Resource
      def handle_multiple_representations(conn), do: render(conn, "300", [])

      @impl Liberator.Resource
      def handle_moved_permanently(conn), do: render(conn, "301", [])

      @impl Liberator.Resource
      def handle_see_other(conn), do: render(conn, "303", [])

      @impl Liberator.Resource
      def handle_not_modified(conn), do: render(conn, "304", [])

      @impl Liberator.Resource
      def handle_malformed(conn), do: render(conn, "400", [])

      @impl Liberator.Resource
      def handle_payment_required(conn), do: render(conn, "402", [])

      @impl Liberator.Resource
      def handle_unauthorized(conn), do: render(conn, "401", [])

      @impl Liberator.Resource
      def handle_forbidden(conn), do: render(conn, "403", [])

      @impl Liberator.Resource
      def handle_not_found(conn), do: render(conn, "404", [])

      @impl Liberator.Resource
      def handle_method_not_allowed(conn), do: render(conn, "405", [])

      @impl Liberator.Resource
      def handle_not_acceptable(conn), do: render(conn, "406", [])

      @impl Liberator.Resource
      def handle_conflict(conn), do: render(conn, "409", [])

      @impl Liberator.Resource
      def handle_gone(conn), do: render(conn, "410", [])

      @impl Liberator.Resource
      def handle_precondition_failed(conn), do: render(conn, "412", [])

      @impl Liberator.Resource
      def handle_request_entity_too_large(conn), do: render(conn, "413", [])

      @impl Liberator.Resource
      def handle_uri_too_long(conn), do: render(conn, "414", [])

      @impl Liberator.Resource
      def handle_unsupported_media_type(conn), do: render(conn, "415", [])

      @impl Liberator.Resource
      def handle_too_many_requests(conn), do: render(conn, "429", [])

      @impl Liberator.Resource
      def handle_unavailable_for_legal_reasons(conn), do: render(conn, "451", [])

      @impl Liberator.Resource
      def handle_error(conn, _error, _failed_step), do: render(conn, "500", [])

      @impl Liberator.Resource
      def handle_not_implemented(conn), do: render(conn, "501", [])

      @impl Liberator.Resource
      def handle_unknown_method(conn), do: render(conn, "501", [])

      @impl Liberator.Resource
      def handle_service_unavailable(conn), do: render(conn, "503", [])
    end
  end
end
