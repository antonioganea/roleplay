local factions = {}
local members = {}

-- factions[factionID] = { string name, int type, table ranks {}, ["wages"] = {}, team ["team"] }
----------- OLD : members[no] = { ["name"]=accountName, ["faction"]=factionID, ["rank"]=rank, ["leader"]=leader }

--NEW : members[accountName] = { ["faction"]=factionID, ["rank"]=rank, ["leader"]=leader }

-------------------------------------------------------------------------------------------
--                                       IDEEA 
--  REFORMAT THE members.xml file...
--  So it's not main nodes of factions, then the members
--  It's the members with the faction number as the attribute .. can speed up things
-------------------------------------------------------------------------------------------

types = {
  [1] = "government",
  [2] = "law",
  [3] = "medical",
  [4] = "transport",
  [5] = "criminal",
}

local rootNode = xmlLoadFile ( "/modules/factions/factions.xml" )
local nodes = xmlNodeGetChildren ( rootNode )

for k, v in pairs( nodes ) do
  local no = tonumber( xmlNodeGetAttribute ( v, "no" ) )
  local name = xmlNodeGetAttribute ( v, "name" )
  local ftype = tonumber ( xmlNodeGetAttribute ( v, "type" ) )
  
  local r = tonumber( xmlNodeGetAttribute ( v, "r" ) )
  local g = tonumber( xmlNodeGetAttribute ( v, "g" ) )
  local b = tonumber( xmlNodeGetAttribute ( v, "b" ) )
  
  if no and name and ftype then
    local team = createTeam ( name, r, g, b )
    factions[no] = { ["name"] = name, ["type"] = ftype, ["ranks"]= {}, ["wages"] = {}, ["team"]=team }
    local ranks = xmlNodeGetChildren ( v )
    for i, j in pairs( ranks ) do
      local number = tonumber( xmlNodeGetAttribute ( j, "no" ) )
      name = xmlNodeGetAttribute ( j, "name" )
      local wage = tonumber( xmlNodeGetAttribute ( j, "wage"))
      factions[no]["ranks"][number] = name
      factions[no]["wages"][number] = wage
      --outputChatBox(name)
    end
    
  else
    outputChatBox("ERROR LOADING factions.xml serverside!")
  end
end

xmlUnloadFile ( rootNode )

rootNode = xmlLoadFile ( "/modules/factions/members.xml" )
nodes = xmlNodeGetChildren ( rootNode )

--<member accountName="Zenibryum" faction="1" rank="15" leader="1"/>

for k, v in pairs( nodes ) do
  local factionID = tonumber( xmlNodeGetAttribute ( v, "faction" ) )
  local accountName = xmlNodeGetAttribute ( v, "accountName" )
  local rank = tonumber( xmlNodeGetAttribute ( v, "rank" ) )
  local leader = tonumber( xmlNodeGetAttribute ( v, "leader" ) )
  
  members[accountName] = { ["faction"]=factionID, ["rank"]=rank, ["leader"]=leader }
  --outputChatBox("FACTION 1 : " ..accountName)
end

--xmlUnloadFile ( rootNode )
--nodes = nil


function isFaction ( faction ) -- return true if factions exists, given an int
  if factions[faction] ~= nil then
    return true
  else
    return false
  end
end


cache = {} -- Generate a cache table of the form : cache[factionID] = { ["accountName"] = { ["rank"]=rank, ["wage"]=wage, ["leader"]=leader } }

function sendFactionDataToPlayer ( player )
  local faction = playerGetFaction( player ) -- get player faction
  
  if isFaction(faction) then
    
    local dataTable = cache[faction] -- set an alias for the cache location
    
    --Test if there is any cache already generated, else generate
    if dataTable == nil then
      dataTable = {} -- create the table
      for k, v in pairs( members ) do
        if v.faction == faction then -- create a cache table only with the members of that faction
          outputChatBox( k .. " " .. v.rank .. " " .. v.leader )
          dataTable[k] = { ["rank"]=v.rank, ["leader"]=v.leader } -- reformat the contents, do not send factionID again..
        end
      end
    end
    
    outputChatBox("Sending faction data to player " .. getPlayerName(player) )
    
    --trigger client event sending the "dataTable"
    triggerClientEvent ( player, "onClientReceiveFactionData", player, dataTable, factions[faction] )
    
  end
end


function playerRegisterInFaction( player, faction )
  setPlayerTeam ( player, factions[faction]["team"] )
  --setTimer ( sendFactionDataToPlayer, 1000, 1, player ) -- maybe ?? ------------------------------------------------------------------------------------------------------- CHECK IF OKAY...
  outputChatBox("Registered" .. getPlayerName(player) .. " " .. getTeamName(factions[faction]["team"]))
  --outputChatBox(faction)
  --outputChatBox("Registered " .. getPlayerName(player) )
end

function playerUnregisterFaction( player )
  setPlayerTeam ( player, nil )
end

function playerGetFaction( player )
  local account = getPlayerAccount( player )
  local name = getAccountName( account )
  return members[name].faction
end

function playerGetRank( player )
  local account = getPlayerAccount( player )
  local name = getAccountName( account )
  return members[name].rank
end

--IMPLEMENTING THE API
function playerKickFromFaction(player)
  local account = getPlayerAccount( player )
  local name = getAccountName( account )
  local faction = members[name].faction
  
  members[name] = nil -- remove from members list
  playerUnregisterFaction(player) -- unregister from faction
  
  if cache[faction] ~= nil then -- if there is cache for the faction..
    cache[name] = nil -- unregister player from cache
  end
  
  local deleteTable = {}
  deleteTable[name] = true
  local peers = getPlayersInTeam ( factions[faction]["team"] )
  for k,v in pairs(peers) do
    triggerClientEvent ( v, "onClientReceiveFactionDelete", player, deleteTable ) -- send deleteTable to peers..
  end
  --deleteTable = nil
  
  --Now.. delete it from the files..
  for k, v in pairs( nodes ) do
    local accountName = xmlNodeGetAttribute ( v, "accountName" )
    if accountName == name then
      xmlDestroyNode ( v ) -- destroy the node..
      xmlSaveFile ( rootNode )
      break
    end
  end
  triggerClientEvent ( player, "onClientGetKickedFromFaction", player ) -- set empty table
end

addCommandHandler("leavefaction",playerKickFromFaction)

function playerSetFaction(player,faction,rank)
  local leader = 0
  local account = getPlayerAccount( player )
  local name = getAccountName( account )
  
  members[name] = { ["faction"]=faction, ["rank"]=rank, ["leader"]=leader }
  playerRegisterInFaction( player, faction ) -- unregister from faction
  
  if cache[faction] ~= nil then -- if there is cache for the faction..
    --dataTable[k] = { ["rank"]=v.rank, ["leader"]=v.leader }
    cache[faction][name] = { ["rank"]=rank, ["leader"]=leader } -- unregister player from cache
  end
  
  local changeTable = {}
  changeTable[name] = { ["rank"]=rank, ["leader"]=leader }
  local peers = getPlayersInTeam ( factions[faction]["team"] )
  for k,v in pairs(peers) do
    triggerClientEvent ( v, "onClientReceiveFactionChange", player, changeTable ) -- send deleteTable to peers..
  end
  --changeTable = nil
  
  --Now.. delete it from the files..
  local notchanged = true
  for k, v in pairs( nodes ) do
    local accountName = xmlNodeGetAttribute ( v, "accountName" )
    if accountName == name then
      xmlNodeSetAttribute ( v, "faction", tostring(faction) )
      xmlNodeSetAttribute ( v, "rank", tostring(rank) )
      xmlNodeSetAttribute ( v, "leader", tostring(leader) )
      notchanged = false
      break
    end
  end
  if notchanged then
    local v = xmlCreateChild ( rootNode, "member" ) -- create a node.. if it doesn't already exist
    --accountName="HeadShot2015" faction="1" rank="5" leader="0" 
    xmlNodeSetAttribute ( v, "accountName", name )
    xmlNodeSetAttribute ( v, "rank", tostring(rank) )
    xmlNodeSetAttribute ( v, "faction", tostring(faction) )
    xmlNodeSetAttribute ( v, "leader", tostring(leader) )
  end
  xmlSaveFile ( rootNode )
  sendFactionDataToPlayer ( player )
  outputChatBox("PLAYER IS IN FACTION!")
end

addCommandHandler("getinpd",function(player)
    playerSetFaction(player,1,15)
end)

--playerPromote
--playerDemote
--playerSetFaction
--playerKickFromFaction

--playerGiveLeaderRights ... later

local membersToRegister = getPlayers()

for k,v in pairs(membersToRegister) do -- ipairs?
  local accountName = getAccountName ( getPlayerAccount(v) )
  if members[accountName] ~= nil then
    local faction = members[accountName].faction
    if faction ~= false and isFaction(faction) then
      playerRegisterInFaction( v, faction )
    end
  end
end

membersToRegister = nil

addEventHandler("onPlayerLoginLoaded", getRootElement(), -- it's like.. when the client's resource loads...
function ()
  local account = getPlayerAccount(client)
  if ( account ~= false ) then
    if ( not isGuestAccount ( account ) ) then
      local accountName = getAccountName(account)
      if members[accountName] ~= nil then
        local faction = members[accountName].faction
  
        if faction ~= false and isFaction(faction) then
          playerRegisterInFaction( client, faction )
          sendFactionDataToPlayer ( client )
        end
      end
    end
  end
end
)

addEventHandler ( 'onPlayerLogin', getRootElement ( ),
function (_, account ) -- acount == currentAccount
  if ( account ~= false ) then
    if ( not isGuestAccount ( account ) ) then
      local accountName = getAccountName(account)
      if members[accountName] ~= nil then
        local faction = members[accountName].faction
  
        if faction ~= false and isFaction(faction) then
          playerRegisterInFaction( source, faction )
          sendFactionDataToPlayer ( source )
        end
      end
    end
  end
end)

addEventHandler ( 'onPlayerLogout', getRootElement ( ),
function ( )
  playerUnregisterFaction( source ) -- just temporarily.
end)

addEventHandler ( "onPlayerQuit", getRootElement(),
function()
  playerUnregisterFaction( source ) -- just temporarily.
end
)

function testFactions(player,command)
  local faction = playerGetFaction( player )
  local rank = playerGetRank( player )
  --outputChatBox("Player " .. getPlayerName( player ) .. faction .. " " .. rank)
  outputChatBox("Player " .. getPlayerName( player ) .. " belongs to the " .. factions[faction]["name"] .. " as " .. factions[faction]["ranks"][rank] )
  sendFactionDataToPlayer ( player )
end
addCommandHandler("gf",testFactions)

function testFunction(player,command)
  
  changeTable = {}
  --changeTable["Zenibryum"] = { ["rank"]=15, ["wage"]=50000, ["leader"]=1 }
  changeTable["TheoTode"] = { ["rank"]=15, ["leader"]=1 }
  
  triggerClientEvent ( player, "onClientReceiveFactionChange", player, changeTable )
  
end
addCommandHandler("tf",testFunction)

function testFunction2(player,command)
  
  changeTable = {}
  changeTable["Zenibryum"] = true
  --changeTable["TheoTode"] = { ["rank"]=15, ["leader"]=1 }
  
  triggerClientEvent ( player, "onClientReceiveFactionDelete", player, changeTable )
  
end
addCommandHandler("tff",testFunction2)


--[[function playerSetFaction( player, faction, rank )
  local playeraccount = getPlayerAccount ( player )
  if ( playeraccount ) and not isGuestAccount ( playeraccount ) then -- if the player is logged in
    if faction ~= false and rank ~= false and isFaction(faction) then
      
      setAccountData ( playeraccount, "faction", faction ) -- save it in his account
      setAccountData ( playeraccount, "rank", rank ) -- save it in his account
      
      playerRegisterInFaction( player, faction, rank ) -- register the player in the members{} table
      
    end
  end
end

function playerKickFromFaction( player )
  local playeraccount = getPlayerAccount ( player )
  if ( playeraccount ) and not isGuestAccount ( playeraccount ) then -- if the player is logged in
    
      setAccountData ( playeraccount, "faction", false ) -- save it in his account
      setAccountData ( playeraccount, "rank", false ) -- save it in his account
      
      playerUnregisterFaction( player )
      
  end
end]]