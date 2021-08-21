setGarageOpen ( 11, true )

local garage = {1025.09, -1030.52 + 6, 32.04 -1}

local marker = createMarker ( garage[1], garage[2], garage[3], "cylinder", 4.0, 0, 255, 0, 127 )

createBlipAttachedTo ( marker, 63, 2, 0, 0, 0, 255, 0, 200 ) -- pizza blip 29


local resprayFee = 300

function pizzaMarkerHit( hitElement, matchingDimension ) -- define MarkerHit function for the handler
    local elementType = getElementType( hitElement )-- get the hit element's type]
    if ( (elementType == "vehicle") and (getVehicleOccupant ( hitElement ) ~= nil) ) then -- "vehicle" is good?
      --outputChatBox( elementType.." inside myMarker", getRootElement(), 255, 255, 0 ) -- attach the element's type with the text, and output it
      local player = getVehicleOccupant ( hitElement )
      
      if getPlayerMoney(player) > resprayFee then
        takePlayerMoney(player, resprayFee)
        fixVehicle(hitElement)
      end

    end
end

addEventHandler( "onMarkerHit", marker, pizzaMarkerHit, false )