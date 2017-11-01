defmodule Mithril.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Mithril.Repo

  def token_factory do
    user = insert(:user)
    client = insert(:client)
    %Mithril.TokenAPI.Token{
      details: %{
        scope: "app:authorize",
        client_id: client.id,
        grant_type: "password",
        redirect_uri: "http://localhost",
      },
      user_id: user.id,
      expires_at: 2000000000,
      name: sequence("authorization_code-"),
      value: "some_short_lived_code"
    }
  end

  def client_factory do
    user = insert(:user)
    client_type = insert(:client_type)

    %Mithril.ClientAPI.Client{
      name: "some client",
      user_id: user.id,
      client_type_id: client_type.id,
      redirect_uri: "http://localhost",
      secret: sequence("secret-"),
      priv_settings: %{
        "access_type" => Mithril.ClientAPI.access_type(:direct)
      },
      is_blocked: false,
      block_reason: nil,
    }
  end

  def client_type_factory do
    %Mithril.ClientTypeAPI.ClientType{
      name: "some name",
      scope: "some scope",
    }
  end

  def user_factory do
    %Mithril.UserAPI.User{
      email: sequence("mail@example.com-"),
      password: "some password",
      settings: %{}
    }
  end

  def role_factory do
    %Mithril.RoleAPI.Role{
      name: "some name",
      scope: "some scope"
    }
  end

  def user_role_factory do
    %Mithril.UserRoleAPI.UserRole{
      user_id: insert(:user).id,
      client_id: insert(:client).id,
      role_id: insert(:role).id
    }
  end
end