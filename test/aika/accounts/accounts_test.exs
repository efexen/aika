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

end
