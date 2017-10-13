defmodule AikaWeb.InviteView do
  use AikaWeb, :view

  def username(user) do
    user.email
    |> String.split("@")
    |> hd()
  end
end
