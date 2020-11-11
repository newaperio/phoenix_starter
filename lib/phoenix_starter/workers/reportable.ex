defprotocol PhoenixStarter.Workers.Reportable do
  @moduledoc """
  Determines if errors encountered by `Oban.Worker` should be reported.

  By default all errors are reported. However some workers have an
  expectation of transient errors, such as those that send email, because of
  flaky third-party providers. By implementing this protocol for a given
  worker, you can customize error reporting.

  ## Example

      defmodule PhoenixStarter.Workers.EmailWorker do
        use Oban.Worker

        defimpl PhoenixStarter.Workers.Reportable do
          @threshold 3

          # Will only report the error after 3 attempts
          def reportable?(_worker, attempt), do: attempt > @threshold
        end

        @impl true
        def perform(%{args: %{"email" => email}}) do
          PhoenixStarter.Email.deliver(email)
        end
      end

  """
  @fallback_to_any true
  @spec reportable?(Oban.Worker.t(), integer) :: boolean
  def reportable?(worker, attempt)
end

defimpl PhoenixStarter.Workers.Reportable, for: Any do
  def reportable?(_worker, _attempt), do: true
end
