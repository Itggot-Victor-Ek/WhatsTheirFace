defmodule Pluggy.Router do
  use Plug.Router

  alias Pluggy.FruitController
  alias Pluggy.UserController

  plug Plug.Static, at: "/", from: :pluggy
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get "/",                 do: MainController.index(conn)
  get "/register",         do: MainController.register(conn)
  get "/fruits",           do: FruitController.index(conn)
  get "/fruits/new",       do: FruitController.new(conn)
  get "/fruits/:id",       do: FruitController.show(conn, id)
  get "/fruits/:id/edit",  do: FruitController.edit(conn, id)

  get "/games/start",      do: GameController.start(conn)
  get "/games/quiz",       do: GameController.quiz_start(conn)
  post "/games/quiz",      do: GameController.quiz(conn, conn.body_params)
  post "rectify_answers",   do: GameController.rectify_answers(conn, conn.body_params)
  
  post "/fruits",          do: FruitController.create(conn, conn.body_params)
 
  # should be put /fruits/:id, but put/patch/delete are not supported without hidden inputs
  post "/fruits/:id/edit", do: FruitController.update(conn, id, conn.body_params)

  # should be delete /fruits/:id, but put/patch/delete are not supported without hidden inputs
  post "/fruits/:id/destroy", do: FruitController.destroy(conn, id)


  post "/users/login",     do: UserController.login(conn, conn.body_params)
  post "/users/logout",    do: UserController.logout(conn)
  post "/users/register",  do: UserController.register(conn, conn.body_params)

  post "/change_admin_status", do: AdminController.change_status(conn, conn.body_params)

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end


# D66B2-AD20-A05F
