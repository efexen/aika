defmodule Aika.OrganisationFactory do
  use ExMachina.Ecto, repo: Aika.Repo

  def organisation_factory do
    %Aika.Accounts.Organisation{
      name: "Acme",
      target_hours: 7 * 60
    }
  end

end
