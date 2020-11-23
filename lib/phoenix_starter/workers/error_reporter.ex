defmodule PhoenixStarter.Workers.ErrorReporter do
  @moduledoc """
  Receives exception events in `Oban.Worker` for error reporting.
  """
  alias PhoenixStarter.Workers.Reportable

  @spec handle_event(
          :telemetry.event_name(),
          :telemetry.event_measurements(),
          :telemetry.event_metadata(),
          :telemetry.handler_config()
        ) :: any()
  def handle_event(
        [:oban, :job, :exception],
        measure,
        %{attempt: attempt, worker: worker} = meta,
        _
      ) do
    if Reportable.reportable?(worker, attempt) do
      extra =
        meta
        |> Map.take([:id, :args, :queue, :worker])
        |> Map.merge(measure)

      Sentry.capture_exception(meta.error, stacktrace: meta.stacktrace, extra: extra)
    end
  end

  def handle_event([:oban, :circuit, :trip], _measure, meta, _) do
    Sentry.capture_exception(meta.error, stacktrace: meta.stacktrace, extra: meta)
  end
end
