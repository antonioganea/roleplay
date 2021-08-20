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
    [3] = {1392.7666015625, -1730.0673828125, 13.16489982605}
}

local pizza_markers = {}
local pizza_blips = {}

pizza_employees = {}

function getRandomPizzaDropZone()
    -- implement somehow that you dont' get a blip in the same spot
    return pizzaDropZones[math.random(1,3)]
end


function pizzaMarkerHit( hitElement, matchingDimension ) -- define MarkerHit function for the handler
    outputChatBox("Marker HIT!!")
    local elementType = getElementType( hitElement )-- get the hit element's type]
    if ( (elementType == "vehicle") and (getVehicleOccupant ( hitElement ) ~= nil) ) then -- "vehicle" is good?
      outputChatBox( elementType.." inside myMarker", getRootElement(), 255, 255, 0 ) -- attach the element's type with the text, and output it
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
    local marker = createMarker ( v[1], v[2], v[3], "cylinder", 1.0, 255, 127, 0, 255, player )

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