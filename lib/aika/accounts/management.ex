defmodule Aika.Accounts.Management do

  alias Aika.Accounts.Organisation
  alias Aika.{Repo, Duration}

  def update_organisation(org, %{"target_hours" => target_hours}) do
    org
    |> Organisation.changeset(%{ target_hours: Duration.hours_to_minutes(target_hours)})
    |> Repo.update
  end

end
