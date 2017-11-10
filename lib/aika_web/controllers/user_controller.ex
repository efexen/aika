defmodule AikaWeb.UserController do
  use AikaWeb, :controller
  alias Aika.{Accounts}
  import AikaWeb.DashboardView, only: [beginning_of_week: 1, end_of_week: 1]

  def index(conn, _params) do
    organisation = conn.assigns[:user].organisation

    users = Accounts.users(organisation)

    render conn, users: users, organisation: organisation
  end

  def show(conn, %{"id" => id, "date" => date}) do
    organisation = conn.assigns[:user].organisation

    parsed_date = parse_date(date)
    start_date = beginning_of_week(parsed_date)
    end_date = end_of_week(start_date)

    user = Accounts.user_show(organisation, id, start_date, end_date)

    render conn, show_user: user, date: start_date, entries: user.time_entries
  end
  def show(conn, %{"id" => id}) do
    show(conn, %{ "id" => id, "date" => Timex.today()})
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

  def delete(conn, %{"id" => id}) do
    organisation = conn.assigns[:user].organisation
    Accounts.remove_user(organisation, id)
    redirect(conn, to: user_path(conn, :index))
  end

  def set_admin(conn, %{"id" => id}) do
    organisation = conn.assigns[:user].organisation
    Accounts.set_admin(organisation, id)
    redirect(conn, to: user_path(conn, :index))
  end

  def generate_api_token(conn, _) do
    conn.assigns[:user]
    |> Accounts.create_api_token!()

    redirect(conn, to: dashboard_path(conn, :index))
  end

  defp format_error(errors) do
    errors
    |> Enum.map(fn {field, error} -> "#{field} #{elem(error, 0)}" end)
  end

  defp parse_date(date) when is_binary(date) do
    Timex.parse!(date, "%F", :strftime)
  end
  defp parse_date(date), do: date

end
