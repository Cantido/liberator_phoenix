defmodule Liberator.Phoenix do
  @moduledoc """
  Documentation for `Liberator.Phoenix`.
  """

  defmacro __using__(_opts) do
    quote do
      require Logger
      defp view do
        __MODULE__
        |> Atom.to_string()
        |> String.replace_trailing("Resource", "")
        |> Kernel.<>("View")
        |> String.to_atom()
      end

      defp render(view, template, format, assigns) do
        template_name = template <> "." <> format
        Phoenix.View.render(view(), template_name, assigns)
      end

      defp get_format do
        "text"
      end

      @impl Liberator.Resource
      def handle_ok(_conn), do: render(view(), "200", get_format(), [])
    end
  end
end
