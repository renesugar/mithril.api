defmodule Mithril.AppAPITest do
  use Mithril.DataCase

  alias Mithril.AppAPI
  alias Mithril.AppAPI.App
  alias Scrivener.Page

  @create_attrs %{scope: "some scope"}
  @update_attrs %{scope: "some updated scope"}
  @invalid_attrs %{scope: nil}

  test "list_apps/1 returns all apps" do
    app = insert(:app)
    assert %Page{entries: [^app]} = AppAPI.list_apps(%{})
  end

  test "get_app! returns the app with given id" do
    app = insert(:app)
    assert AppAPI.get_app!(app.id) == app
  end

  test "create_app/1 with valid data creates a app" do
    user = insert(:user)
    client = insert(:client)

    attrs = Map.merge(@create_attrs, %{user_id: user.id, client_id: client.id})
    assert {:ok, %App{} = app} = AppAPI.create_app(attrs)
    assert app.scope == "some scope"
  end

  test "create_app/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = AppAPI.create_app(@invalid_attrs)
  end

  test "update_app/2 with valid data updates the app" do
    app = insert(:app)
    assert {:ok, app} = AppAPI.update_app(app, @update_attrs)
    assert %App{} = app
    assert app.scope == "some updated scope"
  end

  test "update_app/2 with invalid data returns error changeset" do
    app = insert(:app)
    assert {:error, %Ecto.Changeset{}} = AppAPI.update_app(app, @invalid_attrs)
    assert app == AppAPI.get_app!(app.id)
  end

  test "delete_app/1 deletes the app" do
    app = insert(:app)
    assert {:ok, _} = AppAPI.delete_app(app)
    assert_raise Ecto.NoResultsError, fn -> AppAPI.get_app!(app.id) end
  end

  test "change_app/1 returns a app changeset" do
    app = insert(:app)
    assert %Ecto.Changeset{} = AppAPI.change_app(app)
  end
end
