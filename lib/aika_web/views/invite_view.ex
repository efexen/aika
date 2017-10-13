defmodule AikaWeb.InviteView do
  use AikaWeb, :view

  defdelegate username(user), to: AikaWeb.UserView

end
