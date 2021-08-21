resourceRoot = getResourceRootElement(getThisResource()) 

function lendir(len, dir) -- LENDIR FUNCTION MTA SA MODEL
  if dir >= 0 and dir <= 90 then
    local delta = math.rad(dir)
    local rangle = math.rad(90)
    local a = len*math.sin(rangle-delta) --Positive Y
    local b = len*math.sin(delta) -- Negative X
    return -b, a
  end
  if dir > 90 and dir <= 180 then
    dir = dir - 90
    local delta = math.rad(dir)
    local rangle = math.rad(90)
    local a = len*math.sin(rangle-delta) --Negative X
    local b = len*math.sin(delta) -- Negative Y
    return -a, -b
  end
  if dir > 180 and dir <= 270 then
    dir = dir - 180
    local delta = math.rad(dir)
    local rangle = math.rad(90)
    local a = len*math.sin(rangle-delta) --Negative Y
    local b = len*math.sin(delta) -- Positive X
    return b, -a
  end
  if dir > 270 and dir <= 360 then
    dir = dir - 270
    local delta = math.rad(dir)
    local rangle = math.rad(90)
    local a = len*math.sin(rangle-delta) --Positive Y
    local b = len*math.sin(delta) -- Positive X
    return a, b
  end
end

function getPlayers()
  local players = {}
  for k,v in ipairs(getAlivePlayers()) do
    table.insert(players,v)
  end
  for k,v in ipairs(getDeadPlayers()) do
    table.insert(players,v)
  end
  return players
end

--[[local newfile = fileCreate("ROAD.txt")
roadmarkers = {}
fileWrite( newfile, "road = {")  
local posi = 1
function addpoint ( targetElem,command, carid )
    if ( isElement(targetElem) and getElementType (targetElem) == "player" ) then
        local x,y,z = getElementPosition(getPedOccupiedVehicle(targetElem))
        roadmarkers[posi] = createMarker ( x, y, z, "checkpoint", 4.0, 127, 127, 255, 255, player )
        posi = posi + 1
    end
end
addCommandHandler("addpoint",addpoint)

function clsfl ( player,command )
    posi = 1
    for k, v in ipairs(roadmarkers) do
      local x,y,z = getElementPosition ( roadmarkers[k] )
      outputChatBox("x "..x .. " y " ..  y .. " z " .. z)
      fileWrite(newfile, "["..posi.."] = {"..x ..", "..  y .. ", " .. z .. "},\n")
      destroyElement ( roadmarkers[k] )
      roadmarkers[k] = nil
      posi = posi + 1
    end
    fileClose(newfile)
end
addCommandHandler("doneroad",clsfl)

function dellast ( player,command )
    posi = posi - 1
    destroyElement ( roadmarkers[posi] )
    roadmarkers[posi] = nil
end
addCommandHandler("delmarker",dellast)]]