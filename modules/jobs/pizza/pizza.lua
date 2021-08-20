local employer = createPed ( 155, 2104.513671875, -1804.1123046875, 13.5546875, 88.509948730469 ) -- pizza guy 155
createBlipAttachedTo ( employer, 29, 2, 0, 0, 0, 255, 0, 200 ) -- pizza blip 29

local pizzaDropZones = {
    [1] = {1479.0283203125, -1728.8955078125, 13.16086769104},
    [2] = {1392.7666015625, -1730.0673828125, 13.16489982605}
}

local pizza_markers = {}
local pizza_blips = {}

function getRandomPizzaDropZone()

    -- TODO: implement randomness
    return pizzaDropZones[1]
end

function startpizza(player,command)
    if employees[player] ~= true then
        outputChatBox("You are not hired yet!",player)
    end

    local pizzaScooter = getPedOccupiedVehicle ( player )
    if (pizzaScooter == false) then
        outputChatBox("You are not in a vehicle!",player)
    end

    if ( getElementModel(pizzaScooter) ~= 448 ) then
        outputChatBox("You are not in a pizza scooter!", player)
    end
    
    if pizza_markers[player] ~= nil then
        outputChatBox("Pizza delivery already in-progress",player)
    end

    outputChatBox("Pizza boy started",player)

    local v = getRandomPizzaDropZone()
    local marker = createMarker ( v[1], v[2], v[3], "checkpoint", 1.0, 255, 127, 0, 255, player )

    pizza_markers[player] = marker

    pizza_blips[player] = createBlipAttachedTo ( marker, 0, 2, 255, 127, 0, 255, 0, 99999.0, player)
    setMarkerTarget ( marker, road[2][1], road[2][2], road[2][3] )
    addEventHandler( "onMarkerHit", marker, busHit,false )
    working[player] = true
    



    --[[for k,v in ipairs(road) do
      marks[k] = createMarker ( v[1], v[2], v[3], "checkpoint", 4.0, 0, 127, 127, 127, player )
      addEventHandler( "onMarkerHit", marks[k], MarkerHit,false )
    end]]
  end
  addCommandHandler("startpizza", startpizza)