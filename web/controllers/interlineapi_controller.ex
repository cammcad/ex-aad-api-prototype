defmodule InterlineAPI.InterlineAPIController do
	use InterlineAPI.Web, :controller

	plug :action

	def index(conn, _params) do
	  send_resp(conn,200,"\"{\"ok\":\"hello interline!\"}\"")
	end
	
	
end 
