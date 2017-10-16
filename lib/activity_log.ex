defmodule ActivityLog do
  @moduledoc """
  Documentation for ActivityLog.
  """

  defmacro __using__(_) do
    quote do
      import ActivityLog, only: [activity: 2, actor: 1, object: 1, target: 1]
    end
  end

  defmacro activity(name, [do: block]) do
    quote do
      defstruct type: unquote(name) |> String.to_atom,
                name: "",
                actor: nil,
                object: nil,
                target: nil

      def payload(actor, object), do: %__MODULE__{name: name(actor, object), actor: actor, object: object}
      def payload(actor, object, target), do: %__MODULE__{name: name(actor, object, target), actor: actor, object: object, target: target}

      def name(actor, object), do: "#{actor.name} #{unquote(name) <> "ed"} #{object.name}"
      def name(actor, object, target), do: "#{actor.name} #{unquote(name) <> "ed"} #{object.name} to #{target.name}"

      defoverridable [name: 2, name: 3]

      unquote(block)
    end
  end

  defmacro actor(type) do
    quote do
      defmodule Actor do
        defstruct id: nil,
                  type: unquote(type),
                  name: ""

        def payload(fields \\ []), do: struct(__MODULE__, fields)

        defoverridable [payload: 1]
      end
    end
  end

  defmacro object(type) do
    quote do
      defmodule Object do
        defstruct id: nil,
                  type: unquote(type),
                  name: ""

        def payload(fields \\ []), do: struct(__MODULE__, fields)

        defoverridable [payload: 1]
      end
    end
  end

  defmacro target(type) do
    quote do
      defmodule Target do
        defstruct  id: nil,
                  type: unquote(type),
                  name: ""

        def payload(fields \\ []), do: struct(__MODULE__, fields)

        defoverridable [payload: 1]
      end
    end
  end

  def add(activities, opts \\ [])
  def add(activities, opts) when length(activities) > 0, do: Task.async_stream(activities, __MODULE__, :add, [opts]) |> Enum.to_list
  def add(%{} = activity, opts) when is_map(activity) and is_list(opts) do
    backends = ActivityLog.Config.get(:activity_log, :backends, [ActivityLog.Logger.Console])

    for backend when is_atom(backend) <- backends do
      if Keyword.has_key?(backend.__info__(:functions), :add) do
        apply(backend, :add, [activity, opts])
      end
    end
    |> case do
      result when length(result) == 1 -> result |> List.first
      res -> res
    end
  end
end
