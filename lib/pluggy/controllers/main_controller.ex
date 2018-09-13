defmodule MainController do
    require IEx

    alias Pluggy.Fruit
    alias Pluggy.User
    import Pluggy.Template, only: [render: 2]
    import Plug.Conn



    def index(conn) do
        session_user = conn.private.plug_session["user_id"]
        IO.inspect session_user
        admin_status_user = Postgrex.query!(DB, "SELECT admin_status FROM users WHERE id = $1", [session_user],
        pool: DBConnection.Poolboy
        ).rows
        IO.inspect admin_status_user
        current_user = case session_user do
            nil -> nil
            _   -> User.get(session_user)
          end
    
        send_resp(conn, 200, render("index", user: current_user, admin_status: admin_status_user))
    end

    def register(conn) do
        session_usr = conn.private.plug_session["user_id"]
        if session_usr != nil do
            redirect(conn, "/")
        end
        send_resp(conn, 200, render("/register",[]))
    end

    defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end