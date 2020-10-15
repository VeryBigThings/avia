defmodule SnitchApi.Accounts do
  alias Snitch.Data.Model.Role, as: RoleModel
  alias Snitch.Data.Schema.User
  alias Snitch.Domain.Account
  alias Snitch.Core.Tools.MultiTenancy.Repo
  alias SnitchApi.Guardian

  @moduledoc """
  The Accounts context.
  """

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    raise "TODO"
  end

  @doc """
  Gets a single user.

  Raises if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, "User not found."}
      user -> {:ok, user}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, ...}

  """
  def create_user(attrs \\ %{}) do
    role_id =
      "user"
      |> RoleModel.get_role_by_name()
      |> Map.get(:id)

    attrs
    |> Map.put("role_id", role_id)
    |> Account.register()
  end

  @spec update_info(User.t(), map()) :: {:ok, User.t()} | {:error}
  def update_info(user, attrs \\ %{}), do: Account.update_info(user, attrs)

  def token_sign_in(email, password) do
    case Account.authenticate(email, password) do
      {:ok, user} ->
        user = Repo.preload(user, [:role])
        Guardian.encode_and_sign(user, %{}, ttl: {3, :days})

      _ ->
        {:error, :unauthorized}
    end
  end

  def resource_from_token(token) do
    case Guardian.resource_from_token(token) do
      {:ok, resource, _claims} ->
        resource

      {:error, :token_expired} ->
        :expired
    end
  end

  def refresh_token(token) do
    {:ok, _old_stuff, {new_token, new_claims}} = Guardian.refresh(token)
    {new_token, new_claims}
  end

  # checks the validity of the token
  def verify_token(token) do
    Guardian.decode_and_verify(token)
  end
end
