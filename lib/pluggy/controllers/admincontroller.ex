defmodule AdminController do
    require IEx

    alias Pluggy.Fruit
    alias Pluggy.User
    import Pluggy.Template, only: [render: 2]
    import Plug.Conn

    def change_status(conn, params) do
        username = params["name"]
        new_admin_status = String.to_integer(params["new_admin_status"])
        IO.inspect username
        IO.inspect new_admin_status
        Postgrex.query!(DB, "UPDATE users SET admin_status = $2 WHERE username = $1", [username, new_admin_status], pool: DBConnection.Poolboy)

        redirect(conn, "/")
    end


    defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")




end    