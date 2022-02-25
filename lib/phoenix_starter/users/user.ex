defmodule PhoenixStarter.Users.User do
  @moduledoc """
  Represents a user who can authenticate with the system.
  """
  use PhoenixStarter.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias PhoenixStarter.Users.UserRole

  @derive {Inspect, except: [:password]}
  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :confirmed_at, :naive_datetime
    field :role, UserRole.Type, roles: UserRole.roles(), default: :user
    field :profile_image, {:array, :map}

    timestamps()
  end

  @doc """
  A `PhoenixStarter.Users.User` changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

  """
  @spec registration_changeset(t, map, list) :: Changeset.t()
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :password, :role])
    |> validate_email()
    |> validate_password(opts)
    |> validate_required([:role])
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, PhoenixStarter.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 80)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A `PhoenixStarter.Users.User` changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  @spec email_changeset(t, map) :: Changeset.t()
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{errors: [_ | _]} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A `PhoenixStarter.Users.User` changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

  """
  @spec password_changeset(t, map, list) :: Changeset.t()
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  @spec confirm_changeset(t | Changeset.t()) :: Changeset.t()
  def confirm_changeset(user) do
    now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no `PhoenixStarter.Users.User` or the `User` doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  @spec valid_password?(t, String.t() | nil) :: boolean()
  def valid_password?(%PhoenixStarter.Users.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  @spec validate_current_password(Changeset.t(), String.t() | nil) :: Changeset.t()
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  @doc """
  A `PhoenixStarter.Users.User` changeset for updating the profile.
  """
  @spec profile_changeset(t, map) :: Changeset.t()
  def profile_changeset(user, attrs) do
    cast(user, attrs, [:profile_image])
  end
end

defimpl Swoosh.Email.Recipient, for: PhoenixStarter.Users.User do
  @spec format(PhoenixStarter.Users.User.t()) :: {String.t(), String.t()}
  def format(%PhoenixStarter.Users.User{email: address}) do
    {"", address}
  end
end
