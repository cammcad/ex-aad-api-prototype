defmodule Plug.AzureADPlug do
   import Plug.Conn
	
   def init(options) do
       # initialize options
	options
   end

   def call(conn, _opts), do: validateConn(conn)

   def validateConn(conn) do
    conn
    |> hasAuthHeader?
    |> bearerToken?
    |> hasAppropriatePermissions?
    |> backToController
   end

   defp access_denied(conn,msg) do
	send_resp(conn,401,msg) |> halt
   end

	
   defp backToController({conn,:denied}), do: access_denied(conn,"Ooops! You don't have permission to be here.")
   defp backToController({conn,headers}), do: conn
   defp backToController(conn), do: conn
	
   #parse out headers to check for authorization header
   defp hasAuthHeader?(conn) do
	headers = conn.req_headers
	headers = Enum.into(headers,HashDict.new)
	case Dict.has_key?(headers,"authorization") or Dict.has_key?(headers,"Authorization") do
		false -> {conn,:denied}
		true -> {conn, Dict.get(headers,"authorization")}
	end
   end
   #check for bearer token
   defp bearerToken?({conn,:denied}), do: {conn,:denied}
   defp bearerToken?({conn,"Bearer " <> token}) do
	case String.contains?(token,".") do
		false -> {conn,:denied}
		true ->
		  token_parts = String.split(token, ".")
		  case length(token_parts) == 3 do
			false -> {conn,:denied}
			true ->
			  [jwt,claims,_] = token_parts
			  case is_binary(jwt) and is_binary(claims) do
				false -> {conn,:denied}
				true ->
				  decoded_jwt = Base.url_decode64(jwt)
				  decoded_claims = Base.url_decode64(claims)
				  {conn,decoded_jwt,decoded_claims}
			  end
		  end
	end
   end
	
	
   defp bearerToken?({conn,_headers}), do: {conn, :denied}

   #check for appropriate permissions to allow the request though via (claims validation).
   #To take this step a bit further, we could call the azure active directory graph api
   #with the claims information to get more permission details about the user issuing this request.
   #For now... to illustrate the point we're just going to check to make sure that the first part of
   #the token is jwt compliant and that the request is only allowed for active directory user
   defp hasAppropriatePermissions?({conn,:denied}), do: {conn,:denied}
   defp hasAppropriatePermissions?({conn,{:ok,jwt},{:ok,claimsInfo}}) do
	case JSX.is_json?(jwt) and isValidJWT? (JSX.decode(jwt)) do
	  false -> {conn,:denied}
	  true ->
	    case JSX.is_json?(claimsInfo) and isValidClaim? (JSX.decode(claimsInfo)) do
	        false -> {conn,:denied}
		true -> conn
	    end
	end
   end
   defp hasAppropriatePermissions?({conn,_jwt,_claimsInfo}), do: {conn,:denied}
   #ensure that we have a valid jwt
   defp isValidJWT?({:ok,jwtMap}) do
	hasTyp = hasProp?(jwtMap,"typ")
	case hasTyp and jwtMap["typ"] == "JWT" do
	   true ->
	     hasAlg = hasProp?(jwtMap,"alg")
	     case hasAlg and jwtMap["alg"] == "RS256" do
		true -> hasProp?(jwtMap,"x5t")
		_ -> false
	     end
	   _ -> false
	end
   end
   #ensure that we have a valid claim, very simplistic implementation
   #that just ensures that the active directory user is the correct username
   #this is where we could call back to Azure AD for permissions that have been granted to the user
   #who issues this request.
   defp isValidClaim?({:ok,claimMap}) do
	hasUpn = hasProp?(claimMap,"upn")
	(hasUpn and claimMap["upn"] == "username-here")
   end
   #helper 
   defp hasProp?(map,key), do: Dict.has_key?(map,key)
end
