defmodule AikaWeb.CategoryController do
  use AikaWeb, :controller

  alias Aika.Timesheets.Category

  def index(conn, _) do
    organisation = conn.assigns[:user].organisation

    categories = Category.Queries.categories_for(organisation)

    render conn, categories: categories, organisation: organisation
  end

  def create(conn, %{"category" => %{"name" => name}}) do
    organisation = conn.assigns[:user].organisation

    case Category.Queries.create_for(organisation, name) do
      {:ok, _category} ->
        redirect conn, to: category_path(conn, :index)
      {:error, cs} ->
        conn
        |> put_flash(:error, "Error creating category")
        |> redirect to: category_path(conn, :index)
    end
  end

  def delete(conn, %{"id" => id}) do
    organisation = conn.assigns[:user].organisation
    Category.Queries.remove_for(organisation, id)
    redirect conn, to: category_path(conn, :index)
  end

end
