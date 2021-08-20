local employer = createPed ( 155, 2104.513671875, -1804.1123046875, 13.5546875, 88.509948730469 ) -- pizza guy 155
createBlipAttachedTo ( employer, 29, 2, 0, 0, 0, 255, 0, 200 ) -- pizza blip 29

-- TODO LIST:
-- 1. Make sure that you don't get the same dropzone twice
-- 2. Limit the pizza you can carry to a maximum of five, and then you have to reload at the pizza store
-- 3. Make the cylinder markers appear lower ( because now they're floating )
-- 4. There must be a way for players to spawn their pizzaboy scooter
-- 5. Multiple and appropriate pizza zone drops locations
-- 6. What happens if you drop out of the scooter while doing a pizza job?
-- 7. What happens if you drop out and jump back in while doing a pizza job?
-- 8. Should there be a counter?
-- 9. Pizza boy skin for workers

local pizzaDropZones = {
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

local pizza_markers = {}
local pizza_blips = {}

pizza_employees = {}

function getRandomPizzaDropZone()
    -- implement somehow that you dont' get a blip in the same spot
    return pizzaDropZones[math.random(1,29)]
end


function pizzaMarkerHit( hitElement, matchingDimension ) -- define MarkerHit function for the handler
    local elementType = getElementType( hitElement )-- get the hit element's type]
    if ( (elementType == "vehicle") and (getVehicleOccupant ( hitElement ) ~= nil) ) then -- "vehicle" is good?
      --outputChatBox( elementType.." inside myMarker", getRootElement(), 255, 255, 0 ) -- attach the element's type with the text, and output it
      local player = getVehicleOccupant ( hitElement )
      if pizza_markers[player] == source then -- If the marker hit is the player's target marker
        -- destroy marker
        destroyElement(pizza_markers[player])
        pizza_markers[player] = nil

        -- destroy blip
        destroyElement(pizza_blips[player])
        pizza_blips[player] = nil

        -- reward player
        givePlayerMoney(player, 300)

        allocatePizzaJob(player)
      end
    end
end


function startpizza(player,command)
    if pizza_employees[player] ~= true then
        outputChatBox("You are not hired yet!",player)
        return
    end

    local pizzaScooter = getPedOccupiedVehicle ( player )
    if (pizzaScooter == false) then
        outputChatBox("You are not in a vehicle!",player)
        return
    end

    if ( getElementModel(pizzaScooter) ~= 448 ) then
        outputChatBox("You are not in a pizza scooter!", player)
        return
    end
    
    if pizza_markers[player] ~= nil then
        outputChatBox("Pizza delivery already in-progress",player)
        return
    end

    outputChatBox("Pizza boy started!",player)

    allocatePizzaJob(player)
end
addCommandHandler("startpizza", startpizza)

function allocatePizzaJob(player)
    local v = getRandomPizzaDropZone()
    local marker = createMarker ( v[1], v[2], v[3] - 0.5, "cylinder", 2.0, 255, 127, 0, 255, player )

    pizza_markers[player] = marker

    pizza_blips[player] = createBlipAttachedTo ( marker, 0, 2, 255, 127, 0, 255, 0, 99999.0, player)

    addEventHandler( "onMarkerHit", marker, pizzaMarkerHit, false )
end


function employerClicked( theButton, theState, thePlayer )
    if theButton == "left" and theState == "down" and pizza_employees[thePlayer] == nil then
      local playerAccount = getPlayerAccount(thePlayer)
      if ( ( playerAccount ~= false ) and ( isGuestAccount(playerAccount) == false ) ) then-- if it's a valid account
        outputChatBox( "You are now hired as a pizza delivery boy!", thePlayer )
        pizza_employees[thePlayer] = true
        setAccountData(playerAccount,"job","pizza")
      else
        outputChatBox( "You are not logged in!", thePlayer)
      end
    end
end
addEventHandler( "onElementClicked", employer, employerClicked, false )