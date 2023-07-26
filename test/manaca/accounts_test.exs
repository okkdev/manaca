defmodule Manaca.AccountsTest do
  use Manaca.DataCase

  alias Manaca.Accounts

  describe "users" do
    alias Manaca.Accounts.User

    import Manaca.AccountsFixtures

    @invalid_attrs %{tokens: nil, firstname: nil, lastname: nil, email: nil, card_id: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{tokens: 42, firstname: "some firstname", lastname: "some lastname", email: "some email", card_id: "some card_id"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.tokens == 42
      assert user.firstname == "some firstname"
      assert user.lastname == "some lastname"
      assert user.email == "some email"
      assert user.card_id == "some card_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{tokens: 43, firstname: "some updated firstname", lastname: "some updated lastname", email: "some updated email", card_id: "some updated card_id"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.tokens == 43
      assert user.firstname == "some updated firstname"
      assert user.lastname == "some updated lastname"
      assert user.email == "some updated email"
      assert user.card_id == "some updated card_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
