defmodule Aika.UserFactory do
  use ExMachina.Ecto, repo: Aika.Repo

  alias Aika.OrganisationFactory

  def user_factory do
    %Aika.Accounts.User{
      email: sequence(:email, &("user_#{&1}@acme.com")),
      password_digest: "nope",
      role: 0,
      organisation: OrganisationFactory.build(:organisation)
    }
  end
end
