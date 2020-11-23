defmodule PhoenixStarter.Users.UserRole do
  @moduledoc """
  Authorizations for `PhoenixStarter.Users.User`.

  `UserRole` is a struct with a `name` field as an atom and a `permissions`
  field, which is a list of strings.

  Permissions should be specified in the format: `"scope.action"`. For
  example, `"me.update_profile"` or `"users.update"`.
  """
  defstruct [:name, :permissions]

  @type t :: %__MODULE__{name: atom, permissions: list(String.t())}

  @doc """
  Returns a list of valid roles.
  """
  @spec roles :: list(atom)
  def roles do
    [:admin, :ops_admin, :user]
  end

  @doc """
  Returns a `PhoenixStarter.Users.UserRole` struct for the given role name.
  """
  @spec role(atom) :: t
  def role(role)

  def role(:admin) do
    %__MODULE__{
      name: :admin,
      permissions: ["me.update_profile"]
    }
  end

  def role(:ops_admin) do
    %__MODULE__{
      name: :ops_admin,
      permissions: ["ops.dashboard"]
    }
  end

  def role(:user) do
    %__MODULE__{
      name: :user,
      permissions: ["me.update_profile"]
    }
  end

  def role(role) do
    raise ArgumentError, """
    #{inspect(role)} given but no such role defined
    """
  end

  @spec permitted?(t, String.t()) :: boolean()
  def permitted?(%__MODULE__{} = role, permission), do: permission in role.permissions

  defmodule Type do
    @moduledoc """
    An `Ecto.ParameterizedType` representing a `PhoenixStarter.Users.UserRole`.

    Stored as a `string` in the database but expanded as a struct with
    hydrated `permissions` field, for easy usage.
    """
    use Ecto.ParameterizedType
    alias PhoenixStarter.Users.UserRole

    @impl true
    def type(_params), do: :string

    @impl true
    def init(opts) do
      roles = Keyword.get(opts, :roles, nil)

      unless is_list(roles) and Enum.all?(roles, &is_atom/1) do
        raise ArgumentError, """
        PhoenixStarter.Users.UserRole.Type must have a `roles` option specified as a list of atoms.
        For example:

            field :my_field, PhoenixStarter.Users.UserRole.Type, roles: [:admin, :user]
        """
      end

      on_load = Map.new(roles, &{Atom.to_string(&1), &1})
      on_dump = Map.new(roles, &{&1, Atom.to_string(&1)})

      %{on_load: on_load, on_dump: on_dump, roles: roles}
    end

    @impl true
    def cast(data, params) do
      case params do
        %{on_load: %{^data => as_atom}} -> {:ok, UserRole.role(as_atom)}
        %{on_dump: %{^data => _}} -> {:ok, UserRole.role(data)}
        _ -> :error
      end
    end

    @impl true
    def load(nil, _, _), do: {:ok, nil}

    def load(data, _loader, %{on_load: on_load}) do
      case on_load do
        %{^data => as_atom} -> {:ok, UserRole.role(as_atom)}
        _ -> :error
      end
    end

    @impl true
    def dump(nil, _, _), do: {:ok, nil}

    def dump(data, _dumper, %{on_dump: on_dump}) when is_atom(data) do
      case on_dump do
        %{^data => as_string} -> {:ok, as_string}
        _ -> :error
      end
    end

    def dump(%UserRole{name: data}, _dumper, %{on_dump: on_dump}) do
      case on_dump do
        %{^data => as_string} -> {:ok, as_string}
        _ -> :error
      end
    end

    @impl true
    def equal?(a, b, _params), do: a == b

    @impl true
    def embed_as(_, _), do: :self
  end
end
