defmodule PhoenixStarterWeb.TemplateHelpers do
  @moduledoc """
  Convenience functions for rendering data in templates.
  """

  @typedoc "Valid timestamp formats."
  @type timestamp_format :: :short | :date_and_time

  @doc """
  Returns given `Timex.Types.valid_datetime()` as a string according to the
  given format.

  ## Formats

  Formats are defined by the style guide. Current options are:

  - `:short` - "Mar. 06, 2019"
  - `:date_and_time` - "Mar. 06 @ 11:13pm"

  """
  @spec format_timestamp(Timex.Types.valid_datetime(), timestamp_format()) ::
          String.t()
  def format_timestamp(timestamp, :short), do: Timex.format!(timestamp, "%b. %d, %Y", :strftime)

  def format_timestamp(timestamp, :date_and_time),
    do: Timex.format!(timestamp, "%b. %d @ %-l:%M%P", :strftime)
end
