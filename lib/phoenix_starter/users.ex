defmodule PhoenixStarter.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias PhoenixStarter.Repo
  alias PhoenixStarter.Users.User
  alias PhoenixStarter.Users.UserNotifier
  alias PhoenixStarter.Users.UserRole
  alias PhoenixStarter.Users.UserToken

  ## Database getters

  @doc """
  Gets a `PhoenixStarter.Users.User` by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  @spec get_user_by_email(String.t()) :: User.t() | nil
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a `PhoenixStarter.Users.User` by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  @spec get_user_by_email_and_password(String.t(), String.t()) :: User.t() | nil
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  @doc """
  Gets a single `PhoenixStarter.Users.User`.

  Raises `Ecto.NoResultsError` if the `User` does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_user!(Ecto.UUID.t()) :: User.t()
  def get_user!(id), do: Repo.get!(User, id)

  ## User registration

  @doc """
  Registers a `PhoenixStarter.Users.User`.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec register_user(map()) :: Repo.result()
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking `PhoenixStarter.Users.User` changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user_registration(User.t(), map) :: Ecto.Changeset.t()
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the `PhoenixStarter.Users.User` email.

  ## Examples

      iex> change_user_email(user, current_password)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user_email(User.t(), String.t() | nil, map()) :: Ecto.Changeset.t()
  def change_user_email(user, current_password \\ nil, attrs \\ %{}) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(current_password)
    |> attach_action_if_current_password(current_password)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}

      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  @spec apply_user_email(User.t(), String.t(), map) :: Repo.result()
  def apply_user_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the `PhoenixStarter.Users.User` email using the given token.

  If the token matches, the `PhoenixStarter.Users.User` email is updated and
  the token is deleted. The confirmed_at date is also updated to the current
  time.
  """
  @spec update_user_email(User.t(), String.t()) :: :ok | :error
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset = user |> User.email_changeset(%{email: email}) |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, [context]))
  end

  @doc """
  Delivers the update email instructions to the given `PhoenixStarter.Users.User`.

  ## Examples

      iex> deliver_update_email_instructions(user, current_email, &Routes.user_update_email_url(conn, :edit, &1))
      {:ok, %Swoosh.Email{}}

  """
  @spec deliver_update_email_instructions(
          User.t(),
          String.t(),
          (String.t() -> String.t()),
          boolean
        ) :: UserNotifier.notifier_result()
  def deliver_update_email_instructions(
        %User{} = user,
        current_email,
        update_email_url_fun,
        async \\ true
      )
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)

    UserNotifier.deliver_update_email_instructions(
      user,
      update_email_url_fun.(encoded_token),
      async
    )
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the `PhoenixStarter.Users.User` password.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user_password(User.t(), String.t() | nil, map) :: Ecto.Changeset.t()
  def change_user_password(user, current_password \\ nil, attrs \\ %{}) do
    user
    |> User.password_changeset(attrs)
    |> User.validate_current_password(current_password)
    |> attach_action_if_current_password(current_password)
  end

  @doc """
  Updates the `PhoenixStarter.Users.User` password.

  ## Examples

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user_password(User.t(), String.t(), map) :: Repo.result()
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
  Applies update action for changing a `PhoenixStarter.Users.User`'s password.

  ## Examples

      iex> apply_user_password(user, valid_current_password, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> apply_user_password(user, invalid_current_password, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  @spec apply_user_password(User.t(), String.t(), map) :: Repo.result()
  def apply_user_password(user, password, attrs) do
    user
    |> User.password_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  defp attach_action_if_current_password(changeset, nil),
    do: changeset

  defp attach_action_if_current_password(changeset, _),
    do: Map.replace!(changeset, :action, :validate)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking `PhoenixStarter.Users.User` changes.

  ## Examples

      iex> change_user_profile(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user_profile(User.t(), map) :: Ecto.Changeset.t()
  def change_user_profile(%User{} = user, attrs \\ %{}) do
    User.profile_changeset(user, attrs)
  end

  @doc """
  Updates a `PhoenixStarter.Users.User`'s profile.

  ## Examples

      iex> update_user_profile(user, %{password: ...})
      {:ok, %User{}}

      iex> update_user_profile(user, %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user_profile(User.t(), map) :: Repo.result()
  def update_user_profile(user, attrs) do
    user
    |> User.profile_changeset(attrs)
    |> Repo.update()
  end

  ## Session

  @doc """
  Generates a session token.
  """
  @spec generate_user_session_token(User.t()) :: binary
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the `PhoenixStarter.Users.User` with the given signed token.
  """
  @spec get_user_by_session_token(String.t()) :: User.t() | nil
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  @spec delete_session_token(String.t()) :: :ok
  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc """
  Delivers the confirmation email instructions to the given `PhoenixStarter.Users.User`.

  ## Examples

      iex> deliver_user_confirmation_instructions(user, &Routes.user_confirmation_url(conn, :confirm, &1))
      {:ok, %Swoosh.Email{}}

      iex> deliver_user_confirmation_instructions(confirmed_user, &Routes.user_confirmation_url(conn, :confirm, &1))
      {:error, :already_confirmed}

  """
  @spec deliver_user_confirmation_instructions(User.t(), (String.t() -> String.t()), boolean) ::
          UserNotifier.notifier_result() | {:error, atom()}
  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun, async \\ true)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
      Repo.insert!(user_token)

      UserNotifier.deliver_confirmation_instructions(
        user,
        confirmation_url_fun.(encoded_token),
        async
      )
    end
  end

  @doc """
  Confirms a `PhoenixStarter.Users.User` by the given token.

  If the token matches, the `User` account is marked as confirmed
  and the token is deleted.
  """
  @spec confirm_user(String.t()) :: {:ok, User.t()} | :error
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  @doc """
  Delivers the reset password email to the given `PhoenixStarter.Users.User`.

  ## Examples

      iex> deliver_user_reset_password_instructions(user, &Routes.user_reset_password_url(conn, :edit, &1))
      {:ok, %Swoosh.Email{}}

  """
  @spec deliver_user_reset_password_instructions(User.t(), (String.t() -> String.t()), boolean) ::
          UserNotifier.notifier_result()
  def deliver_user_reset_password_instructions(
        %User{} = user,
        reset_password_url_fun,
        async \\ true
      )
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)

    UserNotifier.deliver_reset_password_instructions(
      user,
      reset_password_url_fun.(encoded_token),
      async
    )
  end

  @doc """
  Gets the `PhoenixStarter.Users.User` by reset password token.

  ## Examples

      iex> get_user_by_reset_password_token("validtoken")
      %User{}

      iex> get_user_by_reset_password_token("invalidtoken")
      nil

  """
  @spec get_user_by_reset_password_token(String.t()) :: User.t() | nil
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the `PhoenixStarter.Users.User` password.

  ## Examples

      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  @spec reset_user_password(User.t(), map) :: Repo.result()
  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
  Checks if the given `PhoenixStarter.Users.User` is permitted to the `permission`.

  ## Examples

      iex> permitted?(%User{role: "admin"}, "users.update")
      true

      iex> permitted?(%User{role: "user"}, "users.update")
      false

  """
  @spec permitted?(User.t(), String.t()) :: boolean
  def permitted?(%User{role: role}, permission) do
    UserRole.permitted?(role, permission)
  end
end
