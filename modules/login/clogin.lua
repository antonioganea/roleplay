function clientSubmitLogin(button,state)
	if button == "left" and state == "up" then
		-- get the text entered in the 'username' field
		local username = guiGetText(edtUser)
		-- get the text entered in the 'password' field
		local password = guiGetText(edtPass)
 
		-- if the username and password both exist
		if username and password then
			-- trigger the server event 'submitLogin' and pass the username and password to it
			triggerServerEvent("submitLogin", getRootElement(), username, password)
 
			-- hide the gui, hide the cursor and return control to the player
			guiSetInputEnabled(false)
			guiSetVisible(wdwLogin, false)
			showCursor(false)
		else
			-- otherwise, output a message to the player, do not trigger the server
			-- and do not hide the gui
			outputChatBox("Please enter a username and password.")
		end
	end
end

function clientSubmitRegister(button,state)
	if button == "left" and state == "up" then
		-- get the text entered in the 'username' field
		local username = guiGetText(edtUser)
		-- get the text entered in the 'password' field
		local password = guiGetText(edtPass)
 
		-- if the username and password both exist
		if username and password then
			-- trigger the server event 'submitLogin' and pass the username and password to it
			triggerServerEvent("submitRegister", getRootElement(), username, password)
 
			-- hide the gui, hide the cursor and return control to the player
			guiSetInputEnabled(false)
			guiSetVisible(wdwLogin, false)
			showCursor(false)
		else
			-- otherwise, output a message to the player, do not trigger the server
			-- and do not hide the gui
			outputChatBox("Please enter a username and password.")
		end
	end
end


function createLoginWindow()
	local X = 0.375
	local Y = 0.375
	local Width = 0.25
	local Height = 0.25
	wdwLogin = guiCreateWindow(X, Y, Width, Height, "Please Log In", true)
 
	-- define new X and Y positions for the first label
	X = 0.0825
	Y = 0.2
	-- define new Width and Height values for the first label
	Width = 0.25
	Height = 0.25
	-- create the first label, note the final argument passed is 'wdwLogin' meaning the window
	-- we created above is the parent of this label (so all the position and size values are now relative to the position of that window)
	guiCreateLabel(X, Y, Width, Height, "Username", true, wdwLogin)
	-- alter the Y value, so the second label is slightly below the first
	Y = 0.5
	guiCreateLabel(X, Y, Width, Height, "Password", true, wdwLogin)
 
 
	X = 0.415
	Y = 0.2
	Width = 0.5
	Height = 0.15
	edtUser = guiCreateEdit(X, Y, Width, Height, "", true, wdwLogin)
	Y = 0.5
	edtPass = guiCreateEdit(X, Y, Width, Height, "", true, wdwLogin)
	-- set the maximum character length for the username and password fields to 50
	guiEditSetMaxLength(edtUser, 50)
	guiEditSetMaxLength(edtPass, 50)
 
	X = 0.415
	Y = 0.7
	Width = 0.25
	Height = 0.2
	btnLogin = guiCreateButton(X, Y, Width, Height, "Log In", true, wdwLogin)
  btnRegister = guiCreateButton(X,0.9,Width,Height,"Register",true,wdwLogin)
 
	-- make the window invisible
	guiSetVisible(wdwLogin, false)
  addEventHandler("onClientGUIClick", btnLogin, clientSubmitLogin, false)
  addEventHandler("onClientGUIClick", btnRegister, clientSubmitRegister, false)
end

addEventHandler("onClientResourceStart", getResourceRootElement(), 
	function ()
		createLoginWindow()-- create the log in window and its components
	  if (wdwLogin == nil) then
			-- if the GUI hasnt been properly created, tell the player
			outputChatBox("An unexpected error has occurred and the log in GUI has not been created.")
	  end
    triggerServerEvent ( "onPlayerLoginLoaded", getRootElement() )
	end
)

--Just in case the password / username was not right
addEvent("retryLogin",true)
addEventHandler("retryLogin",getRootElement(),function()
    guiSetInputEnabled(true)
    guiSetVisible(wdwLogin, true)
		showCursor(true)
end)

addEvent("retryRegister",true)
addEventHandler("retryRegister",getRootElement(),function()
    guiSetInputEnabled(true)
    guiSetVisible(wdwLogin, true)
		showCursor(true)
end)


--if the user is already logged in
function ignoreLogin ( )
    outputChatBox("YOU ARE ALREADY LOGGED IN, IGNORING LOGIN")
    guiSetInputEnabled(false)
    guiSetVisible(wdwLogin, false)
		showCursor(false)
end
addEvent( "ignoreLogin", true )
addEventHandler( "ignoreLogin", localPlayer, ignoreLogin )