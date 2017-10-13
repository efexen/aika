defmodule AikaWeb.UserView do
  use AikaWeb, :view

  def role_name(role) do
    case role do
      1 -> "Admin"
      0 -> "User"
    end
  end
end
