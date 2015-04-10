defmodule InterlineAPI.PageController do
  use InterlineAPI.Web, :controller

  plug :action

  def index(conn, _params) do
    IO.inspect get_req_header(conn,:authorization)
    IO.inspect get_req_header(conn, :foo)
    render conn, "index.html"
  end

  def api(conn,_params) do
    send_resp(conn,200,"Hello Interline!")
  end
end
