defmodule MainController do
    require IEx

    alias Pluggy.Fruit
    alias Pluggy.User
    import Pluggy.Template, only: [render: 1]
    import Plug.Conn, only: [send_resp: 3]

    def index(conn) do
        send_resp(conn, 200, render("index"))
    end
end