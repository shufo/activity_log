defmodule ActivityLog.Logger.Console do
  require Logger

  @behaviour ActivityLog.Logger

  def add(%{} = activity, _opts \\ []) do
    activity
    |> put_name
    |> put_summary
    |> put_context
    |> put_timestamp
    |> Poison.encode!
    |> Logger.info
  end

  defp put_name(%{actor: actor, object: object, target: nil, __struct__: mod} = activity) do
    if function_exported?(mod, :name, 2) do
      activity
      |> Map.put(:name, apply(activity.__struct__, :name, [actor, object]))
    else
      activity
    end
  end
  defp put_name(%{actor: actor, object: object, target: target, __struct__: mod} = activity) do
    if function_exported?(mod, :name, 3) do
      activity
      |> Map.put(:name, apply(activity.__struct__, :name, [actor, object, target]))
    else
      activity
    end
  end

  defp put_summary(%{actor: actor, object: object, target: nil, __struct__: mod} = activity) do
    if function_exported?(mod, :summary, 2) do
      activity
      |> Map.put(:summary, apply(activity.__struct__, :summary, [actor, object]))
    else
      activity
    end
  end
  defp put_summary(%{actor: actor, object: object, target: target, __struct__: mod} = activity) do
    if function_exported?(mod, :summary, 3) do
      activity
      |> Map.put(:summary, apply(activity.__struct__, :summary, [actor, object, target]))
    else
      activity
    end
  end

  defp put_context(%{} = activity) do
    activity
    |> Map.put(:"@context", "https://github.com/shufo/activity_log")
  end

  defp put_timestamp(%{} = activity) do
    activity
    |> Map.put(:"@timestamp", DateTime.utc_now() |> DateTime.to_iso8601())
  end
end
