defmodule ActivityLog.Logger.Firehose do

  @behaviour ActivityLog.Logger

  def add(payload, opts \\ []) do
    defaults = [
      stream: Application.get_env(:activity_log, :firehose)[:delivery_stream] || "default",
      region: Application.get_env(:activity_log, :firehose)[:region] || "us-east-2",
    ]

    payload = payload
      |> Map.put(:"@timestamp", DateTime.utc_now() |> DateTime.to_iso8601())
      |> Poison.encode!

    opts = Keyword.merge(defaults, opts)

    ExAws.Firehose.put_record(opts[:stream], payload)
    |> ExAws.request(region: opts[:region])
  end
end
