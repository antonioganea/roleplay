local trucks = {}
local trailers = {}
local blips = {}
local bays = {}

for i = 0,17 do
      local newTruck = createVehicle(515, -982.5166015625, -688.765625+i*4, 33.028331756592, 0, 0, 90)
      table.insert(trucks,newTruck)
end

function isTruck(veh)
  for k,v in pairs(trucks) do
    if v == veh then
      return true
    end
  end
  return false
end

function isTrailer(veh)
  for k,v in pairs(trailers) do
    if k == veh then
      return true
    end
  end
  return false
end

function unloadCargo(hitElement, matchingDimension)
  if getElementType(hitElement) == "vehicle" then
    if isTruck(hitElement) then
      local trailer = getVehicleTowedByVehicle ( hitElement )
      if trailer ~= nil then
        if isTrailer(trailer) then
          local bay = 0
        
          for k,v in pairs(bays) do
            if v == source then
              bay = k
              break
            end
          end
          
          if trailers[trailer][1] == bay then
            detachTrailerFromVehicle ( hitElement, trailer )
            local player = getVehicleOccupant ( hitElement )
            if player ~= nil then
              givePlayerMoney(player,trailers[trailer][3])
            end
            trailers[trailer] = nil
            destroyElement(trailer)
          end
        end
      end
    end
  end
end

local places = {
[1] = {2747.1337890625, -2405.341796875, 13.465926170349, "L.S. Docks"}, --LS DEPOSIT

[2] = {2482.9697265625, 2773.1708984375, 10.759768486023, "K.A.C.C."}, -- KACC

[3] = {350.0361328125, 871.541015625, 20.40625, "Quarry"}, -- QUARRY

[4] = {2468.2529296875, 1922.6953125, 9.765625, "L.V. Building Site"}, --Building site

[5] = {-46.779296875, 105.73046875, 3.1171875, "Blueberry Acres"}, --FARM

[6] = {286.71875, 1411.513671875, 10.395555496216, "L.V. Oil Works"}, --Oil works

[7] = {-1031.0400390625, -649.8505859375, 31, "S.F. Chemicals"},

[8] = {1024.7080078125, 2110.4619140625, 9.6, "L.V. Deposit"}
}

local orders = {--from to cargo payment
  [1] = {7, 5, "Chemicals", 2000},
  
  [2] = {3, 4, "Gravel", 2000},
  
  [3] = {5, 1, "Plants", 2000},
  
  [4] = {1, 2, "Weapons", 3000},
  
  [5] = {6, 7, "Petrol", 2000},
  
}

function showPanel( hitElement, matchingDimension ) -- define MarkerHit function for the handler
  if getElementType(hitElement) == "vehicle" then
    if isTruck(hitElement) then
      local bay = 0
        
      for k,v in pairs(bays) do
        if v == source then
          bay = k
          break
        end
      end
          
      local player = getVehicleOccupant ( hitElement )
          
      
      if player ~= nil and bay ~= 0 then
        --outputChatBox("Debug, marker hit : " .. getPlayerName(player) .. " at bay number " .. bay)
        triggerClientEvent ( player, "onTruckEnterBay", player, bay )
      end
      
    end
  end
end

for k,v in pairs(places) do
  bays[k] = createMarker(v[1],v[2],v[3],"cylinder", 4, 0 ,0 ,255, 127)
  --setElementVisibleTo(bays[k],root,false)
  addEventHandler("onMarkerHit",bays[k],unloadCargo)
  addEventHandler( "onMarkerHit", bays[k], showPanel ) -- attach markerHit for showPanel
  
  blips[k] = createBlipAttachedTo (bays[k], 0, 2, 0, 0, 255, 255)
  setElementVisibleTo(blips[k],root,false)
end

function loadCargo( order )
  if orders[order] ~= nil then
    local truck = getPedOccupiedVehicle(client)
    if (truck ~= false) and ( getPedOccupiedVehicleSeat ( client ) == 0 ) then -- if the player is in a valid vehicle and it is the driver
      if isElementWithinMarker ( truck, bays[orders[order][1]] ) then
        if isTruck(truck) then
          if getVehicleTowedByVehicle ( truck ) == false then
        
            local bay = orders[order][1]
        
                  local rx, ry, rz = getElementRotation(truck)
                  local trailer = createVehicle ( 584, 0, 0, 4, rx, ry , rz ) -- create a trailer
                  trailers[trailer] = { orders[order][2], orders[order][3], orders[order][4] } -- DESTINATION, CARGO_TYPE, REWARD
                  attachTrailerToVehicle ( truck, trailer )   -- attach trailer
          end
        end
      else
        outputChatBox("You are not in the marker zone!", client)
      end
    end
  end
end
addEvent( "onTruckRequestLoad", true )
addEventHandler( "onTruckRequestLoad", resourceRoot, loadCargo ) -- Bound to this resource only, saves on CPU usage.

function addTruckBlip(theTruck)
    if isTruck(theTruck) then
      if isTrailer(source) then
        local driver = getVehicleOccupant ( theTruck )
        --setElementVisibleTo ( bays[trailers[source][1]], driver, true )
        setElementVisibleTo ( blips[trailers[source][1]], driver, true )
      end
    end
 end
addEventHandler("onTrailerAttach", getRootElement(), addTruckBlip)

function delTruckBlip(theTruck)
    if isTruck(theTruck) then
      if isTrailer(source) then
        local driver = getVehicleOccupant ( theTruck )
        --setElementVisibleTo ( bays[trailers[source][1]], driver, false )
        setElementVisibleTo ( blips[trailers[source][1]], driver, false )
      end
    end
 end
addEventHandler("onTrailerDetach", getRootElement(), delTruckBlip)

function enterTruck ( driver, seat, jacked )
  if isTruck(source) then
    if seat == 0 then
      local trailer = getVehicleTowedByVehicle ( source )
      if trailer ~= nil and isTrailer(trailer) then
        --setElementVisibleTo ( bays[trailers[trailer][1]], driver, true )
        setElementVisibleTo ( blips[trailers[trailer][1]], driver, true )
      end
    end
  end
end
addEventHandler ( "onVehicleEnter", getRootElement(), enterTruck )

function exitTruck ( driver, seat, jacked )
  if isTruck(source) then
    if seat == 0 then
      local trailer = getVehicleTowedByVehicle ( source )
      if trailer ~= nil and isTrailer(trailer) then
        --setElementVisibleTo ( bays[trailers[trailer][1]], driver, false )
        setElementVisibleTo ( blips[trailers[trailer][1]], driver, false )
      end
    end
  end
end
addEventHandler ( "onVehicleExit", getRootElement(), exitTruck )

function getTrailerCount(player,command) -- used for debug and monitorization
  local count = 0
  for k,v in pairs(trailers) do
    count = count + 1
  end
  outputChatBox(count,player)
end
addCommandHandler("tcount",getTrailerCount)