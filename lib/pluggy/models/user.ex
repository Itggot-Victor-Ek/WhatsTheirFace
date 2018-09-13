defmodule Pluggy.User do

	defstruct(id: nil, username: "")

	alias Pluggy.User
    import Pluggy.Template, only: [render: 2]
    import Plug.Conn

	def get(id) do
		Postgrex.query!(DB, "SELECT id, username FROM users WHERE id = $1 LIMIT 1", [id],
        pool: DBConnection.Poolboy
      ).rows |> to_struct
	end

	def get_groups(id) do
		IO.inspect Integer.to_string(id)
		Postgrex.query!(DB, 'SELECT name FROM groups WHERE "user" = $1', [id],
        pool: DBConnection.Poolboy
      ).rows
	end

	def to_struct([[id, username]]) do
		%User{id: id, username: username}
	end
end