defmodule SnitchApiWeb.UserControllerTest do
  use SnitchApiWeb.ConnCase, async: true

  import Snitch.Factory

  alias SnitchApi.Accounts
  alias Snitch.Core.Tools.MultiTenancy.Repo

  @invalid_attrs %{email: nil, password: nil}

  setup %{conn: conn} do
    user = build(:user_with_no_role)
    role = build(:role, name: "user")

    Repo.insert(role, on_conflict: :nothing)

    user = %{
      "data" => %{
        "attributes" => user
      }
    }

    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn, user: user}
  end

  describe "User Registration" do
    test "creation and sign in with valid data", %{conn: conn, user: user} do
      conn = post(conn, user_path(conn, :create), user)
      assert %{"id" => _id} = json_response(conn, 200)["data"]

      conn =
        post(
          conn,
          user_path(conn, :login, user)
        )

      response = json_response(conn, 200)
      assert response["data"]["attributes"]["token"]
    end

    test "render errors when data is invalid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "login with empty parameters", %{conn: conn} do
      conn = post(conn, user_path(conn, :login))
      assert json_response(conn, 404)["errors"] == %{"detail" => "no login credentials"}
    end

    test "missing parameter in user registration", %{conn: conn} do
      user = %{
        "data" => %{
          "attributes" => build(:user_with_no_role) |> Map.delete("email")
        }
      }

      conn = post(conn, user_path(conn, :create), user)
      assert json_response(conn, 422)["errors"] == %{"email" => ["can't be blank"]}
    end
  end

  describe "User info update" do
    setup %{conn: conn, user: user}, do: authorize_conn(conn, user)

    test "updates user account information", %{conn: conn, user: user} do
      params = %{first_name: "Changed", last_name: "Names"}
      refute user.first_name == "Changed"
      refute user.last_name == "Names"

      assert resp =
               conn
               |> update_user_req(user, params)
               |> doc()
               |> json_response(200)

      assert %{"first_name" => "Changed", "last_name" => "Names"} = resp["data"]["attributes"]
    end

    test "can't update with empty fields", %{conn: conn, user: user} do
      params = %{first_name: "Changed", last_name: ""}

      assert resp =
               conn
               |> update_user_req(user, params)
               |> doc()
               |> json_response(422)

      assert %{"last_name" => ["should be at least 1 character(s)"]} = resp["errors"]
    end

    test "can't update email", %{conn: conn, user: user} do
      params = %{email: "change@email.test"}

      assert resp =
               conn
               |> update_user_req(user, params)
               |> doc()
               |> json_response(200)

      assert resp["data"]["attributes"]["email"] != params.email
    end
  end

  describe "Change password when logged in" do
    setup %{conn: conn, user: user}, do: authorize_conn(conn, user)

    test "changes user password", %{conn: conn, user: user} do
      change_params = %{password: "new_password", password_confirmation: "new_password"}
      login_params = %{email: user.email, password: "new_password"}
      assert json_response(login_req(conn, login_params), 404)

      assert resp =
               conn
               |> change_password_req(user, change_params)
               |> doc()
               |> json_response(200)

      assert json_response(login_req(conn, login_params), 200)
    end

    test "enters too short password", %{conn: conn, user: user} do
      params = %{password: "short", password_confirmation: "short"}

      assert resp =
               conn
               |> change_password_req(user, params)
               |> doc()
               |> json_response(422)

      assert %{"password" => ["should be at least 8 character(s)"]} = resp["errors"]
    end

    test "passwords don't match", %{conn: conn, user: user} do
      params = %{password: "new_password", password_confirmation: "mismatch_password"}

      assert resp =
               conn
               |> change_password_req(user, params)
               |> doc()
               |> json_response(422)

      assert %{"password_confirmation" => ["does not match confirmation"]} = resp["errors"]
    end
  end

  describe "Authenticated routing" do
    setup %{conn: conn, user: user}, do: authorize_conn(conn, user)

    test "fetching logged in user", %{conn: conn, user: user} do
      conn = get(conn, user_path(conn, :current_user))
      assert user.id == json_response(conn, 200)["data"]["id"]
    end

    test "logging out user", %{conn: conn} do
      conn = post(conn, user_path(conn, :logout))
      assert %{"status" => "logged out"} = json_response(conn, 204)
    end

    test "authenticated user details", %{conn: conn} do
      conn = get(conn, user_path(conn, :authenticated))
      assert json_response(conn, 200)["data"]
    end
  end

  defp update_user_req(conn, user, params),
    do: patch(conn, user_path(conn, :update, user.id), params)

  defp change_password_req(conn, user, params),
    do: patch(conn, user_path(conn, :change_password, user.id), params)

  defp login_req(conn, params), do: post(conn, user_path(conn, :login), params)

  defp authorize_conn(conn, user_params) do
    {:ok, user} =
      user_params
      |> JaSerializer.Params.to_attributes()
      |> Accounts.create_user()

    {:ok, token, _claims} = SnitchApi.Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> Plug.Conn.assign(:current_user, user)

    {:ok, conn: conn, user: user}
  end
end
