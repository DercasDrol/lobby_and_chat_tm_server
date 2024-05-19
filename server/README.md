# <a name="README"> Server

To work with the server, you need to have a running postgreSQL server and write its settings in the .env file if you use Docker or config.json if you launch the server directly.

The server automatically creates a database structure when it starts.
If you need to change the database structure, use v_sql.go file.