defmodule Pluggy.UserController do

	require IEx

	#import Pluggy.Template, only: [render: 2]
	import Plug.Conn, only: [send_resp: 3]

	def login(conn, params) do
		username = params["username"]
		password = params["pwd"]

		result =
		  Postgrex.query!(DB, "SELECT id, password_hash FROM users WHERE username = $1", [username],
		    pool: DBConnection.Poolboy
		  )

		case result.num_rows do
		  0 -> #no user with that username
		    redirect(conn, "/")
		  _ -> #user with that username exists
		    [[id, password_hash]] = result.rows

		    #make sure password is correct
		    if Bcrypt.verify_pass(password, password_hash) do
		      Plug.Conn.put_session(conn, :user_id, id)
		      |>redirect("/")
		    else
		      redirect(conn, "/")
		    end
		end
	end

	defp register_confirmed(conn, params, first_name, [last_name | _]) do
		IO.puts "register_confirmed"
		hashed_password = Bcrypt.hash_pwd_salt(params["pwd"])
		IO.puts "det var inget fel på hashen"
		Postgrex.query!(DB, "INSERT INTO users (username, password_hashed, email, first_name, last_name) VALUES ($1, $2, $3, $4, $5)", [params["username"], hashed_password, params["email"], first_name, last_name], [pool: DBConnection.Poolboy])
     	redirect(conn, "/")
	end

	def register(conn, params) do
		username = params["username"]
		password = params["pwd"]
		email = String.split(params["email"],"@")

		[hd|tl] = email
		[first_name | last_name] = String.split(params["email"], ~r/([@].*|[.\d])/)
		IO.inspect first_name
		IO.inspect last_name

		cond do
		Postgrex.query!(DB, "SELECT username FROM users WHERE username = $1", [username], [pool: DBConnection.Poolboy]).rows == [[username]] ->	redirect(conn, "/register")
		#IO.inspect "hejhej"
		Postgrex.query!(DB, "SELECT email FROM confirmed_emails WHERE email LIKE $1", tl, [pool: DBConnection.Poolboy]).rows != [tl] -> redirect(conn, "/register")
		true -> register_confirmed(conn, params, first_name, last_name)
		end
	end

	def logout(conn) do
		Plug.Conn.configure_session(conn, drop: true)
		|> redirect("/")
	end

	def create(conn, params) do
		#pseudocode
		 #in db table users with password_hash CHAR(60)
			hashed_password = Bcrypt.hash_pwd_salt(params["password"])
     	 Postgrex.query!(DB, "INSERT INTO users (username, password_hash) VALUES ($1, $2)", [params["username"], hashed_password], [pool: DBConnection.Poolboy])
     	redirect(conn, "/")
	end

	defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
