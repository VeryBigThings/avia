defmodule Snitch.Domain.Account do
  @moduledoc """
  Exposes domain functions for authentication.
  """
  alias Snitch.Data.Model.User
  alias Snitch.Data.Schema.User, as: UserSchema
  alias Snitch.Core.Tools.MultiTenancy.Repo

  @type update_info_params :: %{
          optional(:first_name) => String.t(),
          optional(:last_name) => String.t()
        }

  @type change_password_params :: %{
          optional(:password) => String.t(),
          optional(:password_confirmation) => String.t()
        }

  @doc """
  Registers a `user` with supplied `params`.

  Takes a `params` map as input.
  """
  @spec register(map) :: {:ok, UserSchema.t()} | {:error}
  def register(params) do
    User.create(params)
  end

  @spec update_info(UserSchema.t(), update_info_params()) ::
          {:ok, UserSchema.t()} | {:error, Ecto.Changeset.t()}
  def update_info(user, params), do: User.update_info(user, params)

  @spec change_password(UserSchema.t(), change_password_params()) ::
          {:ok, UserSchema.t()} | {:error, Ecto.Changeset.t()}
  def change_password(user, params), do: User.change_password(user, params)

  @spec authenticate(String.t(), String.t()) :: {:ok, UserSchema.t()} | {:error, :not_found}
  def authenticate(email, password) do
    user =
      case User.get(%{email: email, state: :active}) do
        {:ok, user} ->
          user |> Repo.preload(:role)

        {:error, _} ->
          nil
      end

    verify_email(user, password)
  end

  defp verify_email(nil, _) do
    # To make user enumeration difficult.
    Argon2.no_user_verify()
    {:error, :not_found}
  end

  defp verify_email(user, password), do: Argon2.check_pass(user, password)
end
