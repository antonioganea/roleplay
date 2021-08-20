database = {}
database.connection = dbConnect( "sqlite", "roleplay.db" ) --initialize database
dbExec( database.connection, [[CREATE TABLE IF NOT EXISTS VEHICLES(
    VID INTEGER PRIMARY KEY ASC,
    MODEL INTEGER NOT NULL,
    R INTEGER, SR INTEGER,
    G INTEGER, SG INTEGER,
    B INTEGER, SB INTEGER,
    X REAL,
    Y REAL,
    Z REAL,
    RX REAL,
    RY REAL,
    RZ REAL,
    PLATE CHAR(8)
  )
]])

dbExec( database.connection, [[CREATE TABLE IF NOT EXISTS OWNERS(
    PID INTEGER,
    VID INTEGER
  )
]]
)

dbExec( database.connection, [[CREATE TABLE IF NOT EXISTS PLAYERS(
    PID INTEGER PRIMARY KEY ASC,
    ACCOUNT CHAR(64) UNIQUE
  )
]]
)

resourceRoot = getResourceRootElement(getThisResource()) 


--PID - player ID
-- VID - vehicle ID

database.vehicles = {} -- vehicles[VID] = vehicle
database.owners = {} -- owners[VID] = {PID1, PID2, PID3, .. , PIDn}
database.players = {} -- players[player] = PID

function getNewVID()
  local i = 1
  while true do
    if (database.vehicles[i] == nil) then
      return i
    end
    i = i + 1
  end
end
--
function addOwnership( VID, PID )
  dbExec( database.connection, "INSERT INTO OWNERS (PID,VID) VALUES (?,?)", PID, VID )
  table.insert ( database.owners[VID], PID ) -- Insert in the vehicle's owner list the PlayerIDs
end

--
function addVehicleToDB(veh)
  if ( veh ~= false ) then
    local r,g,b,sr,sg,sb = getVehicleColor ( veh, true )
    local model = getElementModel( veh )
    local x,y,z = getElementPosition ( veh )
    local rx,ry,rz = getElementRotation ( veh )
    local plate = getVehiclePlateText ( veh )
    local VID = getNewVID()
    dbExec( database.connection, "INSERT INTO VEHICLES (VID,MODEL,R,G,B,SR,SG,SB,X,Y,Z,RX,RY,RZ,PLATE) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", VID,model,r,g,b,sr,sg,sb,x,y,z,rx,ry,rz,plate)
    database.vehicles[VID] = veh
    database.owners[getVID(veh)] = {}
    outputChatBox("Vehicle added to the database")
  else
    outputChatBox("addVehicleToDB - REJECTED")
  end
end
--
function loadVehiclesFromDB()
  outputChatBox("Requesting Vehicles information")
  local qh = dbQuery( database.connection, "SELECT * FROM VEHICLES" )
  local result = dbPoll( qh, -1 )
  if result == false then
    outputChatBox("The result table from the query is empty/nil")
  end
  for k,v in pairs(result) do--k number of the car(entry), v table with the attributes
    if ( database.vehicles[v.VID] ~= nil ) then outputChatBox("Vehicle with id " .. tostring(v.VID) .. " already exists.. error") end
    local veh = createVehicle ( v.MODEL, v.X, v.Y, v.Z, v.RX, v.RY, v.RZ, v.PLATE ) 
    database.vehicles[ v.VID ] = veh
    database.owners[tonumber(v.VID)] = {}
    if ( veh ~= false ) then
      setVehicleColor ( veh, v.R, v.G, v.B, v.SR, v.SG, v.SB )
    else
      outputChatBox( "Certain car in the database couldn't be spawned : ".. v.VID )
    end
    --for i,j in pairs(v) do--i name of the attribute, j attribute value
    --end
  end
  outputChatBox("Cars have been spawned")
end
addEventHandler("onResourceStart", resourceRoot, loadVehiclesFromDB )
--
function loadOwnersFromDB()
  outputChatBox("Requesting Owner information")
  local qh = dbQuery( database.connection, "SELECT * FROM OWNERS" )
  local result = dbPoll( qh, -1 )
  if result == false then
    outputChatBox("The result table from the query is empty/nil")
  end
  for k,v in pairs(result) do--k number of the property document(entry), v table with the attributes
    if ( ( v.PID ~= false ) and (v.VID ~= false) ) then
      table.insert ( database.owners[tonumber(v.VID)], tonumber(v.PID) ) -- Insert in the vehicle's owner list the PlayerIDs
    else
      outputChatBox("Errors while loading a property document : " .. k .. "(entry)")
    end
  end
  outputChatBox("Owner list loaded!")
end
addEventHandler("onResourceStart", resourceRoot, loadOwnersFromDB )
--
function loadPlayersFromDB()
  outputChatBox("Requesting Player information")
  local qh = dbQuery( database.connection, "SELECT * FROM PLAYERS" )
  local result = dbPoll( qh, -1 )
  if result == false then
    outputChatBox("The result table from the query is empty/nil")
  else
    for k,v in pairs(result) do--k number of the property document(entry), v table with the attributes
      if ( ( v.PID ~= false )  and (v.ACCOUNT ~= "")) then
        local account = getAccount(v.ACCOUNT)
        if (account ~= false) then
          local player = getAccountPlayer(account)
          if (player ~= false) then
            database.players[player] = tonumber(v.PID) -- Insert in the vehicle's owner list the PlayerIDs
            outputChatBox(v.ACCOUNT .. " " .. database.players[player])
          end
        end
      else
        outputChatBox("Errors while loading a player PID : " .. k .. "(entry)")
      end
    end
  end
  outputChatBox("Player list loaded!")
end
addEventHandler("onResourceStart", resourceRoot, loadPlayersFromDB )
--
function findVehicleID(veh)
  if (testveh ~= nil) then
    for id, car in pairs(database.vehicles) do
      if ( testveh == car ) then
        return id
      end
    end
    return nil -- if nothing found
  end
end
--
function updateVehicleInDB(VID)
  local veh = database.vehicles[VID]
  if ( veh ~= nil ) then
    local r,g,b,sr,sg,sb = getVehicleColor ( veh, true )
    local model = getElementModel( veh )
    local x,y,z = getElementPosition ( veh )
    local rx,ry,rz = getElementRotation ( veh )
    local plate = getVehiclePlateText ( veh )
    dbExec( database.connection, "UPDATE VEHICLES SET MODEL=?, R=?, G=?, B=?, SR=?, SG=?, SB=?, X=?, Y=?, Z=?, RX=?, RY=?, RZ=?, PLATE=? WHERE VID=?", model,r,g,b,sr,sg,sb,x,y,z,rx,ry,rz,plate,VID)
    outputChatBox("Vehicle Updated ("..VID..")")
  else
    outputChatBox("addVehicleToDB - REJECTED")
  end
end
--
function deleteVehicle(VID)
  VID = tonumber(VID)
  if ( database.vehicles[VID] ~= nil ) then
    dbExec( database.connection, "DELETE FROM VEHICLES WHERE VID=?", VID)--delete it from database
    dbExec( database.connection, "DELETE FROM OWNERS WHERE VID=?", VID)--delete it from owner list DB
    destroyElement(database.vehicles[VID])--delete element
    database.vehicles[VID] = nil--delete if from vector
    database.owners[VID] = nil--delete it from owner list
    outputChatBox("Vehicle ("..VID..") deleted from database!")
  else
    outputChatBox("Vehicle("..VID..") not found in database!")
  end
end
--
function getVID(veh)
  if (veh ~= nil) then
    for id, car in pairs(database.vehicles) do
      if (veh == car) then
        return id
      end
    end
  end
  return -1
end