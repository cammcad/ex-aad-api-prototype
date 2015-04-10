defmodule InterlineAPI.Router do
  use Phoenix.Router
	
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug Plug.AzureADPlug
  end

	
  #scope "/", InterlineAPI do
   # pipe_through :browser # Use the default browser stack
   # get "/", PageController, :index
  #end

  # Other scopes may use custom stacks.
  scope "/", InterlineAPI do		
    pipe_through :api
    
    get "/api", InterlineAPIController, :index
  end 
end
