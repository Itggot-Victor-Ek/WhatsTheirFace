defmodule GameController do

    alias Pluggy.User
    import Pluggy.Template, only: [render: 2]
    import Plug.Conn

    def start(conn) do
        user_groups = User.get_groups(conn.private.plug_session["user_id"])
        IO.inspect user_groups
        send_resp(conn, 200, render("game_start", groups: user_groups))
    end

    def quiz(conn, params) do
        pictures = Postgrex.query!(DB, 'SELECT picture_name FROM pictures_dir WHERE related_group = $1', [params["selected_group"]],
        pool: DBConnection.Poolboy
        ).rows
        IO.puts "Time to insert the pictures"
        Plug.Conn.put_session(conn, :picture_dirs, pictures)
        |> redirect("/games/quiz")
    end
    
    def rectify_answers(conn, params) do
        
    end

    def quiz_start(conn) do
        IO.inspect conn.private.plug_session
        send_resp(conn, 200, render("quiz", pictures: conn.private.plug_session["picture_dirs"]))
    end

    defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end