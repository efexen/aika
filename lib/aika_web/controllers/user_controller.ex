defmodule AikaWeb.UserController do
  use AikaWeb, :controller
  alias Aika.Accounts
  import AikaWeb.DashboardView, only: [beginning_of_week: 0, end_of_week: 0]

  def index(conn, _params) do
    organisation = conn.assigns[:user].organisation

    users = Accounts.users(organisation)

    render conn, users: users, organisation: organisation
  end

  def show(conn, %{"id" => id}) do
    organisation = conn.assigns[:user].organisation
    user = Accounts.user_show(organisation, id, beginning_of_week(), end_of_week())

    render conn, show_user: user
  end

  def new(conn, _params) do
    render conn
  end

  def create(conn, %{"registration" => registration}) do
    case Accounts.create_admin(registration) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> redirect(to: dashboard_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, format_error(changeset.errors))
        |> render("new.html")
    end
  end

  def invite(conn, %{"invite" => %{"email" => email}}) do
    org = conn.assigns[:user].organisation
    case Accounts.create_invite(org, email) do
      {:ok, _user} ->
        conn
        |> redirect(to: user_path(conn, :index))
      {:error, _ } ->
        conn
        |> put_flash(:error, "Error inviting")
        |> redirect(to: user_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    organisation = conn.assigns[:user].organisation
    Accounts.remove_user(organisation, id)
    redirect(conn, to: user_path(conn, :index))
  end

  defp format_error(errors) do
    errors
    |> Enum.map(fn {field, error} -> "#{field} #{elem(error, 0)}" end)
  end
end
