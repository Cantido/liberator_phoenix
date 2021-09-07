# Liberator.Phoenix

[![Hex.pm](https://img.shields.io/hexpm/v/liberator_phoenix)](https://hex.pm/packages/liberator_phoenix/)
[![builds.sr.ht status](https://builds.sr.ht/~cosmicrose/liberator_phoenix.svg)](https://builds.sr.ht/~cosmicrose/liberator_phoenix?)

[Phoenix] integration for the [Liberator] library.

With this plugin, you can use Phoenix views to render the result of Liberator handlers.

[Phoenix]: https://github.com/phoenixframework/phoenix
[Liberator]: https://sr.ht/~cosmicrose/liberator

## Installation

This package is available in hex.
You can install it by adding `liberator_phoenix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:liberator_phoenix, "~> 0.1.0"}
  ]
end
```

Docs can be found at [https://hexdocs.pm/liberator_phoenix](https://hexdocs.pm/liberator_phoenix).

## Usage

This module implements Liberator handlers that render Phoenix views.
It infers your view name by replacing `Resource` in your module name with `View`.
For example, `MyPhoenixResource` will use `MyPhoenixView` as its view module.

```elixir
defmodule MyPhoenixResource do
  use Liberator.Resource
  use Liberator.Phoenix
end

defmodule MyPhoenixView do
  use MyProject, :view
end
```

If you need to override it, set the `:view_module` option in your `use` statement.

```elixir
defmodule MyPhoenixResource do
  use Liberator.Resource
  use Liberator.Phoenix, view_module: MyOtherView
end
```

You can also select only certain handlers to be overridden with the `:only` and `:except` options.

```elixir
defmodule MyPhoenixResource do
  use Liberator.Resource
  use Liberator.Phoenix, only: [:handle_ok]
end
```

The handlers will use the status code as the template name and the extension of the negotiated media type.
For example, the `handle_not_found` handler with a negotiated media type of `text/plain` will render `404.txt`.
The `handle_created` handler with a media type of `application/json` will render `201.json`.

The values set in `conn.assigns` will be given to the view as well.

## License

MIT License

Copyright 2020 Rosa Richter

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
