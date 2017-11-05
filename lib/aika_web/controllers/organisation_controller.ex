defmodule AikaWeb.OrganisationController do
  use AikaWeb, :controller

  alias Aika.Accounts.Management

  def edit(conn, _) do
    org = conn.assigns[:user].organisation
    changeset = Ecto.Changeset.change(org)
    render conn, org: org, changeset: changeset
  end

  def update(conn, %{"organisation" => org_attrs}) do
    org = conn.assigns[:user].organisation

    case Management.update_organisation(org, org_attrs) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Settings updated")
        |> redirect(to: organisation_path(conn, :edit))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error updating settings")
        |> render("edit.html", org: org, changeset: changeset)
    end
  end

end
