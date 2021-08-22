addEventHandler ( "onPlayerLogout", getRootElement(),
function (thePreviousAccount)
  setAccountData( thePreviousAccount, "money", getPlayerMoney( source ) )
  setPlayerMoney(source,0,true)
  
  --delete from PIDS list
  database.players[source] = nil
end
)

addEventHandler ( "onPlayerQuit", getRootElement(),
  function()
  local thePreviousAccount = getPlayerAccount ( source )
  if (thePreviousAccount and (isGuestAccount(thePreviousAccount) == false) ) then
    setAccountData( thePreviousAccount, "money", getPlayerMoney( source ) )
    setPlayerMoney(source,0,true)
    
    --delete from PIDS list
    database.players[source] = nil
  end
end
)

addEventHandler ( 'onPlayerLogin', getRootElement ( ),
function ( _, theCurrentAccount )
  if ( theCurrentAccount and not isGuestAccount(theCurrentAccount) ~= false ) then
    local money = getAccountData( theCurrentAccount, "money" )
    money = money or 0
    setPlayerMoney(source,money)
    
    if ( database.players[source] == nil ) then
        outputChatBox("You are logging on the server, getting you your PID : ")
        local qh = dbQuery( database.connection, "SELECT * FROM PLAYERS WHERE ACCOUNT=?",getAccountName(theCurrentAccount) )
        local result = dbPoll( qh, -1 )
        if (result[1] ~= nil) then
          database.players[source] = result[1].PID
          outputChatBox("Logged in as PID : " .. result[1].PID)
        else
          outputChatBox("Setting you a new PID...")
          dbExec( database.connection, "INSERT INTO PLAYERS (ACCOUNT) VALUES (?)", getAccountName(theCurrentAccount) )
          qh = dbQuery( database.connection, "SELECT * FROM PLAYERS WHERE ACCOUNT=?",getAccountName(theCurrentAccount) )
          result = dbPoll( qh, -1 )
          database.players[source] = result[1].PID
          outputChatBox("Registered "..getAccountName(theCurrentAccount) .. " with PID : " .. database.players[source])
        end
    end
    
  end
end
)

addEventHandler( 'onResourceStart', resourceRoot,
  function()
    --[[
    for k,player in ipairs(getPlayers()) do
      local account = getPlayerAccount ( player )
      if ( account and not isGuestAccount(account) ~= false ) then
        local job = getAccountData(account,"job")
        reestablishJob(player, job)
      end
    end
    ]]
  end
)
addEventHandler ( "onResourceStop", resourceRoot, 
    function ( resource )
    for vehID,v in pairs(database.vehicles) do
      updateVehicleInDB(vehID)
    end

    for k,player in ipairs(getPlayers()) do
      local account = getPlayerAccount ( player )
      if ( account and not isGuestAccount(account) ~= false ) then
        setAccountData( account, "money", getPlayerMoney( player ) )
        --setPlayerMoney(player, 0, true)
      end
    end
   end 
)