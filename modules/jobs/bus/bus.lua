local employer = createPed ( 308, 1809.9599609375, -1900.0771484375, 13.57726764679, 86.279693603516 )
createBlipAttachedTo ( employer, 56, 2, 0, 0, 0, 255, 0, 200 )

local employees = {}
local working = {}

local buses = {}
for i = 0,7 do
      local newBus = createVehicle(431,1804.6-i*4,-1929.5,13.5) -- 1804 -1929.5 13.5
      table.insert(buses,newBus)
end

function employ(player,job)
  if (job == "bus") then
    employees[player] = true
  elseif (job=="pizza") then
    pizza_employees[player] = true
  end
end

function employerClicked( theButton, theState, thePlayer )
    if theButton == "left" and theState == "down" and employees[thePlayer] == nil then
      local playerAccount = getPlayerAccount(thePlayer)
      if ( ( playerAccount ~= false ) and ( isGuestAccount(playerAccount) == false ) ) then-- if it's a valid account
        outputChatBox( "You are now hired as a bus driver!", thePlayer )
        employees[thePlayer] = true
        setAccountData(playerAccount,"job","bus")
      else
        outputChatBox( "You are not logged in!", thePlayer)
      end
    end
end
addEventHandler( "onElementClicked", employer, employerClicked, false )

function jobinfo(thePlayer, command)
  if employees[thePlayer] ~= nil then
    outputChatBox("You are hired as a bus driver",thePlayer)
  else
    outputChatBox("You are not hired",thePlayer)
  end
end
addCommandHandler("jobinfo",jobinfo)

road = {[1] = {1810.8017578125, -1889.666015625, 13.189101219177},
[2] = {1823.873046875, -1738.1337890625, 13.16269493103},
[3] = {1479.0283203125, -1728.8955078125, 13.16086769104},
[4] = {1392.7666015625, -1730.0673828125, 13.16489982605},
[5] = {1386.9423828125, -1862.9228515625, 13.161231994629},
[6] = {1214.3408203125, -1850.7373046875, 13.164318084717},
[7] = {1185.90234375, -1850.79296875, 13.180327415466},
[8] = {1182.314453125, -1727.4365234375, 13.209520339966},
[9] = {1152.8603515625, -1699.4658203125, 13.560468673706},
[10] = {1136.1865234375, -1571.095703125, 13.083074569702},
[11] = {1040.423828125, -1558.70703125, 13.141379356384},
[12] = {1078.216796875, -1408.458984375, 13.30432510376},
[13] = {1209.18359375, -1381.427734375, 13.039852142334},
[14] = {1208.5986328125, -1322.9248046875, 13.177968025208},
[15] = {1222.5126953125, -1282.8564453125, 13.161402702332},
[16] = {1360.5419921875, -1264.634765625, 13.162334442139},
[17] = {1360.2158203125, -1130.0703125, 23.442375183105},
[18] = {1382.599609375, -1038.3427734375, 25.878452301025},
[19] = {1461.5625, -1036.7900390625, 23.433975219727},
[20] = {1523.919921875, -1043.2333984375, 23.411672592163},
[21] = {1592.8681640625, -1162.7578125, 23.685876846313},
[22] = {1728.01953125, -1162.6396484375, 23.420541763306},
[23] = {1865.1494140625, -1179.3955078125, 23.436080932617},
[24] = {1872.6513671875, -1059.873046875, 23.460832595825},
[25] = {1992.21875, -1059.544921875, 24.191251754761},
[26] = {2127.2275390625, -1113.6044921875, 24.963550567627},
[27] = {2173.9404296875, -1137.435546875, 24.829425811768},
[28] = {2171.830078125, -1234.23828125, 23.598560333252},
[29] = {2164.8759765625, -1314.5771484375, 23.599533081055},
[30] = {2153.048828125, -1380.8505859375, 23.605667114258},
[31] = {2110.482421875, -1397.74609375, 23.608594894409},
[32] = {2097.341796875, -1459.537109375, 23.597417831421},
[33] = {2003.80859375, -1458.560546875, 13.171507835388},
[34] = {1845.7998046875, -1481.1259765625, 13.151683807373},
[35] = {1818.6533203125, -1682.4765625, 13.161371231079},
[36] = {1810.8984375, -1889.5341796875, 13.188749313354},
}

road["len"] = 36

stations = {
  [3] = true,
  [6] = true,
  [14]= true,
  [16]= true,
  [19]= true,
  [26]= true,
  [33]= true,
  [35]= true
}

--[[addCommandHandler("getstation", function(player,command)
    outputChatBox(marks[player])
    table.insert(stations,marks[player])
  end
)
addCommandHandler("outputlist", function(player,command)
    outputChatBox("Printing List")
    local s = ""
    for k,v in ipairs(stations) do
      s = s .. "[" .. v .. "], "
    end
    
    
  end
  )]]

marks = {}
markers = {}
blips = {}
timers = {}

function busLeave( leaveElement, matchingDimension )
  local elementType = getElementType( leaveElement )-- get the hit element's type]
  if ( (elementType == "vehicle") and (getVehicleOccupant ( leaveElement ) ~= nil) ) then -- "vehicle" is good?
    local player = getVehicleOccupant ( leaveElement )
    if markers[player] == source then -- If the marker hit is the player's target marker
      if (timers[player] ~= nil) then
        killTimer(timers[player])
        outputChatBox("Nu ai asteptat in statie",player)
      end
    end
  end
end

function proceed(player,hitMarker)
  local r = 127
  local g = 127
  local b = 0
  if (stations[marks[player]+1]) then
    b = 255
  end
  
  marks[player] = marks[player] + 1
  if marks[player] <= road.len then
    local v = road[marks[player]]
    local marker = createMarker ( v[1], v[2], v[3], "checkpoint", 4.0, r, g, b, 255, player )
    if (blips[player] ~= nil) then
      destroyElement(blips[player])
    end
    blips[player] = createBlipAttachedTo ( marker, 0, 2, r, g, b, 255, 0, 99999.0, player)
    if (marks[player] < road.len) then
      v = road[marks[player]+1]
      setMarkerTarget ( marker, v[1], v[2], v[3] )
    end
    if (stations[marks[player]]) then -- if it is station
      addEventHandler( "onMarkerLeave", marker, busLeave )
    end
    markers[player] = marker
    addEventHandler( "onMarkerHit", marker, busHit,false )
    destroyElement(hitMarker)
  else
    outputChatBox("Bus Route finished!",player)
    givePlayerMoney ( player, 1500 ) --give the player the money
    destroyElement(hitMarker)
    destroyElement(blips[player])
    marks[player] = nil
    working[player] = nil
  end
end

function busHit( hitElement, matchingDimension ) -- define MarkerHit function for the handler
    local elementType = getElementType( hitElement )-- get the hit element's type]
    if ( (elementType == "vehicle") and (getVehicleOccupant ( hitElement ) ~= nil) ) then -- "vehicle" is good?
      --outputChatBox( elementType.." inside myMarker", getRootElement(), 255, 255, 0 ) -- attach the element's type with the text, and output it
      local player = getVehicleOccupant ( hitElement )
      if markers[player] == source then -- If the marker hit is the player's target marker
        if (stations[marks[player]] == nil) then
          proceed(player,source, false)-- JUST PROCEED
        else
          outputChatBox("Wait for any passengers to enter the bus",player)
          timers[player] = setTimer ( proceed, 3000, 1, player, source ) -- WAIT IN THE STATION
        end
      end
    end
end

function startbus(player,command)
  if employees[player] == true then
    local theBus = getPedOccupiedVehicle ( player )
    if (theBus ~= false) then
      if ( getElementModel(theBus) == 431 ) then
        if marks[player] == nil then
          outputChatBox("Route started",player)
          marks[player] = 1
          local v = road[1]
          local marker = createMarker ( v[1], v[2], v[3], "checkpoint", 4.0, 127, 127, 0, 255, player )
          markers[player] = marker
          blips[player] = createBlipAttachedTo ( marker, 0, 2, 127, 127, 0, 255, 0, 99999.0, player)
          setMarkerTarget ( marker, road[2][1], road[2][2], road[2][3] )
          addEventHandler( "onMarkerHit", marker, busHit,false )
          working[player] = true
        else
          outputChatBox("Bus Route already started",player)
        end
      else
        outputChatBox("You are not in a bus!", player)
      end
    else
      outputChatBox("You are not in a vehicle!",player)
    end
  else
    outputChatBox("You are not hired yet!",player)
  end
  --[[for k,v in ipairs(road) do
    marks[k] = createMarker ( v[1], v[2], v[3], "checkpoint", 4.0, 0, 127, 127, 127, player )
    addEventHandler( "onMarkerHit", marks[k], MarkerHit,false )
  end]]
end
addCommandHandler("startbus", startbus)

function cancelbus(player,command)
  outputChatBox("Bus Route Canceled")
  marks[player] = nil
  destroyElement(blips[player])
  destroyElement(markers[player])
  working[player] = nil
end
addCommandHandler("cancelbus", cancelbus)

function exitBus ( vehicle, seat, jacked )
  if (working[source]) then
    cancelbus(source,"exitedBus")
  end
end
addEventHandler ( "onPlayerVehicleExit", getRootElement(), exitBus )