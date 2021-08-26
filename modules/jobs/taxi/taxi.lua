local employer = createPed ( 66, 1771.60546875, -1909.0625, 13.554491043091, 293.56192016602 ) -- taxi driver
createBlipAttachedTo ( employer, 53, 2, 0, 0, 0, 255, 0, 200 ) -- taxi blip

local taxi_markers = {}
local taxi_blips = {}

local taxiDropZones = {
    [1] = {1939.154296875, -1930.4619140625, 13.161773681641},
    [2] = {1800.5263671875, -1900.5458984375, 13.182072639465},
    [3] = {1837.890625, -1867.5869140625, 13.167282104492},
    [4] = {1759.66015625, -1667.087890625, 13.335603713989},
    [5] = {1627.8671875, -1679.7880859375, 13.165766716003},
    [6] = {1557.81640625, -1793.669921875, 13.326426506042},
    [7] = {1561.2900390625, -1849.458984375, 13.329266548157},
    [8] = {1571.2998046875, -1878.4658203125, 13.245143890381},
    [9] = {1220.34375, -1830.4013671875, 13.18318939209},
    [10] = {1222.123046875, -1711.1162109375, 13.160820960999},
    [11] = {1316.2822265625, -1707.923828125, 13.164664268494},
    [12] = {1095.267578125, -1382.703125, 13.565190315247},
    [13] = {1193.6728515625, -1323.318359375, 13.177730560303},
    [14] = {1097.5791015625, -1276.478515625, 13.271203041077},
    [15] = {1050.9189453125, -1266.0615234375, 13.679211616516},
    [16] = {1037.06640625, -1329.5166015625, 13.172206878662},
    [17] = {962.68359375, -1329.5263671875, 13.144923210144},
    [18] = {816.162109375, -1393.12109375, 13.16752910614},
    [19] = {748.5625, -1345.78515625, 13.295732498169},
    [20] = {1451.970703125, -1389.8896484375, 13.162353515625}, 
}

local pedDropZones = {
    [1] = {2094.58203125, -1824.5556640625, 13.154937744141},
    [2] = {1479.0283203125, -1728.8955078125, 13.16086769104},
    [3] = {1392.7666015625, -1730.0673828125, 13.16489982605},
    [4] = {2009.5087890625, -1733.1259765625, 13.143049240112},
    [5] = {2009.1875,       -1656.6708984375, 13.143666267395},
    [6] = {2484.45703125, -2002.13671875, 13.140234947205},
    [7] = {2271.9814453125, -1786.5986328125, 13.139427185059},
    [8] = {2293.0009765625, -1795.755859375, 13.144284248352},
    [9] = {2377.4921875, -1784.6962890625, 13.146448135376},
    [10] = {2246.9619140625, -1724.197265625, 13.144755363464},
    [11] = {2240.26171875, -1640.501953125, 15.157437324524},
    [12] = {2316.6123046875, -1651.1123046875, 13.850957870483},
    [13] = {2386.1484375, -1347.4267578125, 24.075021743774},
    [14] = {2459.2607421875, -1288.18359375, 23.59839630127},
    [15] = {2443.73046875, -1339.322265625, 23.596996307373},
    [16] = {2357.1083984375, -1532.1826171875, 23.597646713257},
    [17] = {2364.7041015625, -1666.197265625, 13.144180297852},
    [18] = {2413.0283203125, -1651.4111328125, 13.10652923584},
    [19] = {2508.646484375, -1654.8369140625, 13.195534706116},
    [20] = {2495.880859375, -1686.296875, 13.100707054138},
    [21] = {2376.51953125, -1785.779296875, 13.141532897949},
    [22] = {2141.2197265625, -1085.392578125, 24.153913497925},
    [23] = {2078.9970703125, -1056.3876953125, 30.403421401978},
    [24] = {2060.376953125, -1077.720703125, 24.487321853638},
    [25] = {2080.2177734375, -1121.587890625, 23.73653793335},
    [26] = {2049.5947265625, -1112.4521484375, 25.076053619385},
    [27] = {1955.7646484375, -1127.958984375, 25.470830917358},
    [28] = {1894.3662109375, -1052.5498046875, 23.454069137573},
    [29] = {1959.1044921875, -1058.3662109375, 24.05513381958}
}

local passengersSkins = {
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 7,
    [5] = 9,
    [6] = 11,
    [7] = 12,
    [8] = 13,
    [9] = 14,
    [10] = 15,
    [11] = 16,
    [12] = 17,
    [13] = 18,
    [14] = 19,
    [15] = 20,
    [16] = 55,
    [17] = 56,
    [18] = 63,
    [19] = 64,
    [20] = 192,
    [21] = 193,
    [22] = 194,
    [23] = 205,
    [24] = 219,
    [25] = 226,
    [26] = 237
}

function getRandomTaxiDropZone()
    return taxiDropZones[math.random(1,20)]
end

function getRandomPedDropZone()
    return pedDropZones[math.random(1,29)]
end

function getRandomSkin()
    return passengersSkins[math.random(1,26)]
end

local taxi_passengers = {}

function givePassenger(player)
    local taxi = getPedOccupiedVehicle(player)
    local passenger = createPed ( getRandomSkin(), 2105.513671875, -1804.1123046875, 13.5546875, 88.509948730469 )
    warpPedIntoVehicle ( passenger, taxi, math.random(2,3) )
    taxi_passengers[player] = passenger
end

function removePassenger(player)
    destroyElement(taxi_passengers[player])
    taxi_passengers[player] = nil
end

function pedMarkerHit(hitElement, matchingDimension ) 
    local elementType = getElementType( hitElement )-- get the hit element's type]
    if ( (elementType == "vehicle") and (getVehicleOccupant ( hitElement ) ~= nil) ) then -- "vehicle" is good?
      local player = getVehicleOccupant ( hitElement )
      if taxi_markers[player] == source then -- If the marker hit is the player's target marker
        -- destroy marker
        destroyElement(taxi_markers[player])
        taxi_markers[player] = nil

        -- destroy blip
        destroyElement(taxi_blips[player])
        taxi_blips[player] = nil

        givePassenger(player)
        allocateTaxiJob(player)
      end
    end
end

function taxiMarkerHit( hitElement, matchingDimension ) -- define MarkerHit function for the handler
    local elementType = getElementType( hitElement )-- get the hit element's type]
    if ( (elementType == "vehicle") and (getVehicleOccupant ( hitElement ) ~= nil) ) then -- "vehicle" is good?
      local player = getVehicleOccupant ( hitElement )
      if taxi_markers[player] == source then -- If the marker hit is the player's target marker
        -- destroy marker
        destroyElement(taxi_markers[player])
        taxi_markers[player] = nil

        -- destroy blip
        destroyElement(taxi_blips[player])
        taxi_blips[player] = nil

        -- reward player
        givePlayerMoney(player, 500)

        removePassenger(player)
        findPed(player)
      end
    end
end

function starttaxi(player,command)
    if not isEmployedAs(player,"taxi") then
        outputChatBox("You are not hired yet!",player)
        return
    end 

    local taxiCar = getPedOccupiedVehicle ( player )
    if (taxiCar == false) then
        outputChatBox("You are not in a vehicle!",player)
        return
    end

    if ( getElementModel(taxiCar) ~= 420 ) then
        outputChatBox("You are not in a taxi cab!", player)
        return
    end
    
    if taxi_markers[player] ~= nil then
        outputChatBox("Taxi driving already in-progress",player)
        return
    end

    outputChatBox("Taxi driver started!",player)

    findPed(player)
end
addCommandHandler("starttaxi", starttaxi)

function findPed(player)
    local v = getRandomPedDropZone()
    local marker = createMarker ( v[1], v[2], v[3] - 0.5, "cylinder", 2.0, 255, 0, 0, 255, player )

    taxi_markers[player] = marker

    taxi_blips[player] = createBlipAttachedTo ( marker, 0, 2, 255, 0, 0, 255, 0, 99999.0, player)

    addEventHandler( "onMarkerHit", marker, pedMarkerHit, false )
end

function allocateTaxiJob(player)
    local v = getRandomTaxiDropZone()
    local marker = createMarker ( v[1], v[2], v[3] - 0.5, "cylinder", 2.0, 255, 255, 0, 255, player )

    taxi_markers[player] = marker

    taxi_blips[player] = createBlipAttachedTo ( marker, 0, 2, 255, 255, 0, 255, 0, 99999.0, player)

    addEventHandler( "onMarkerHit", marker, taxiMarkerHit, false )
end

function employerClicked( theButton, theState, thePlayer )
    if theButton == "left" and theState == "down" and not isEmployedAs(thePlayer,"taxi") then
      local playerAccount = getPlayerAccount(thePlayer)
      if ( ( playerAccount ~= false ) and ( isGuestAccount(playerAccount) == false ) ) then-- if it's a valid account
        outputChatBox( "You are now hired as a taxi driver!", thePlayer )
        employAs(thePlayer, "taxi")
      else
        outputChatBox( "You are not logged in!", thePlayer)
      end
    end
end
addEventHandler( "onElementClicked", employer, employerClicked, false )

-- Taxi Spawner

local taxiSpawner = createMarker ( 1771.60546875 - 3, -1909.0625 + 15, 13.554491043091 - 0.9, "cylinder", 2.0, 255, 0, 0, 127 )

local playerTaxis = {}

local function taxiSpawnerHit(hitElement, matchingDimension)
  local elementType = getElementType( hitElement )-- get the hit element's type]
  if (elementType ~= "player") then
    return
  end

  if ( not isEmployedAs(hitElement, "taxi") ) then
    return
  end

  if getPedOccupiedVehicle ( hitElement ) ~= false then
    return
  end

  local x, y, z = getElementPosition(hitElement)
  local newTaxi = createVehicle(420, x, y, z)

  warpPedIntoVehicle(hitElement, newTaxi)

  if ( playerTaxis[hitElement] ) then
    destroyElement(playerTaxis[hitElement])
  end

  playerTaxis[hitElement] = newTaxi
end

addEventHandler( "onMarkerHit", taxiSpawner, taxiSpawnerHit, false )