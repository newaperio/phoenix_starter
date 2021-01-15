defmodule PhoenixStarterWeb.LiveHelpers do
  @moduledoc """
  Helper functions for dealing with `Phoenix.LiveView`.
  """
  import Phoenix.LiveView, only: [assign_new: 3]

  alias PhoenixStarter.Users

  def assign_defaults(socket, _params, session) do
    assign_new(socket, :current_user, fn ->
      Users.get_user_by_session_token(session["user_token"])
    end)
  end
end
