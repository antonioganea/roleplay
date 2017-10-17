function checkLogged()--maybe the player is already logged in
  for k,player in ipairs(getPlayers()) do
    local account = getPlayerAccount ( player )
    if ( ( account and isGuestAccount ( getPlayerAccount ( player ) ) ) ~= false ) then
      triggerClientEvent( player, "retryLogin", player) -- open the window for him
      outputChatBox("Please log in or register!", player)
    end
  end
end
addEventHandler("onResourceStart", getRootElement(), function() setTimer(checkLogged, 1000, 1) end)

function playerJoin()
  if ( account ~= false ) then
    if ( isGuestAccount ( getPlayerAccount ( client ) ) ) then
      triggerClientEvent( client, "retryLogin", client) -- open the window for him
    end
  end
end
addEvent ( "onPlayerLoginLoaded", true )
addEventHandler("onPlayerLoginLoaded", getRootElement(), playerJoin)


 addEventHandler("onPlayerJoin", getRootElement(), function() 
    local account = getPlayerAccount ( source )
    if ( ( account and isGuestAccount ( getPlayerAccount ( source ) ) ) ~= false ) then
      triggerClientEvent( source, "retryLogin", source) -- open the window for him
      outputChatBox("Please log in or register!", source)
    end
end)

addCommandHandler("testing",function(player, command) triggerClientEvent( player, "ignoreLogin", player) end)

function loginHandler(username,password)
	-- check that the username and password are correct
  local account = getAccount ( username, password ) -- Return the account
	if ( account ~= false ) then -- If the account exists.
		logIn ( client, account, password ) -- Log them in.
  	spawnPlayer(client, 1933.8125, -1785.7998046875, 13.3828125)
		fadeCamera(client, true)
    setCameraTarget(client, client)
    outputChatBox("Welcome to My Server.", client)
	else
		outputChatBox ( "Wrong username or password!", client, 255, 255, 0 ) -- Output they got the details wrong.
    triggerClientEvent ( client, "retryLogin", client )
	end
end
 
addEvent("submitLogin",true)
addEventHandler("submitLogin",root,loginHandler)


function registerHandler(username,password)
	-- check that the username and password are correct
  local account = getAccount(username)
  if ( account == false ) then -- if there is no account with the same username
    local newaccount = addAccount(username,password) -- Create a new account
    if ( newaccount ~= false ) then -- If the newly created account exists..
      logIn ( client, newaccount, password ) -- Log them in.
      spawnPlayer(client, 1933.7880859375, -1762.0673828125, 13.546875)
      fadeCamera(client, true)
      setCameraTarget(client, client)
      outputChatBox("Welcome to My Server.", client)
    else
      outputChatBox ( "Wrong username or password!", client, 255, 255, 0 ) -- Output they got the details wrong.
      triggerClientEvent ( client, "retryRegister", client )
    end
  else--In case there is already an account with the given username..
    outputChatBox ( "Account already registered!", client, 255, 255, 0 ) -- Output they got the details wrong.
    triggerClientEvent ( client, "retryRegister", client )
  end
end
 
addEvent("submitRegister",true)
addEventHandler("submitRegister",root,registerHandler)

function loggedOut()
	outputChatBox( "You have successfully logged out!", source )
  triggerClientEvent( source, "retryLogin", source )
end
addEventHandler("onPlayerLogout",getRootElement(),loggedOut)