defmodule Aika.AccountsTest do
  use Aika.DataCase

  alias Aika.{Accounts, UserFactory}

  describe "user_with_organisation/1" do

    test "Returns error for nil id" do
      assert Accounts.user_with_organisation(nil) == {:error, nil}
    end

    test "Returns user by id" do
      user = UserFactory.insert(:user)

      assert Accounts.user_with_organisation(user.id) == user
    end

    test "Preloads the organisation for the user" do
      user = UserFactory.insert(:user)

      assert Accounts.user_with_organisation(user.id).organisation == user.organisation
    end

  end

  describe "id_for_email_and_password/2" do

    test "returns error no match for non existing email" do
      assert Accounts.id_for_email_and_password("whatever@acme.com", "password1") == {:error, "No match"}
    end

    test "returns error no match for incorrect password" do
      UserFactory.insert(:user, email: "test@acme.com")

      assert Accounts.id_for_email_and_password("test@acme.com", "password1") == {:error, "No match"}
    end

    test "returns user id for correct email and password combo" do
      user = UserFactory.insert(:user,
        email: "test@acme.com",
        password_digest: Bcrypt.hash_pwd_salt("password123")
      )

      assert Accounts.id_for_email_and_password("test@acme.com", "password123") == {:ok, user.id}
    end

  end

  describe "user_for_invite/1" do

    test "returns nil for non existing token" do
      assert Accounts.user_for_invite("fake_token") == nil
    end

    test "returns user for existing token" do
      user = UserFactory.insert(:user, token: "test_token123")

      assert Accounts.user_for_invite("test_token123").id == user.id
    end

  end

end
