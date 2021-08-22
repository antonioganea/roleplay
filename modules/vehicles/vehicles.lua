function addveh(player,command)
    local veh = getPedOccupiedVehicle ( player )
  if ( veh ~= false ) then
    addVehicleToDB(veh)
  else
    outputChatBox("You're not in a valid vehicle",player)
  end
end
addCommandHandler("addveh",addveh)

addCommandHandler("loadvehs",loadVehiclesFromDB)

function vehSpawn ( targetElem,command, carid, permanent )
    if ( isElement(targetElem) and getElementType (targetElem) == "player" ) then
        local rx,ry,rz = getElementRotation ( targetElem ) --z
        local x,y,z = getElementPosition(targetElem)
        local offx, offy = lendir(15,rz)
        local veh = createVehicle ( carid, x+offx, y+offy, z , 0, 0, rz)
        if ( veh ~= nil ) then
          if ( permanent == "permanent" ) then addVehicleToDB(veh) end
        else
          outputChatBox("FAILED TO SPAWN VEH", targetElem)
        end
    end
end
addCommandHandler("veh",vehSpawn)



addCommandHandler("delveh",function(_1,_2,vehID)
    deleteVehicle(vehID)
  end
)
addCommandHandler("updatevehs",function()
    for vehID,v in pairs(database.vehicles) do
      updateVehicleInDB(vehID)
    end
  end
)

addCommandHandler("owners",function(player,command,VID)
    VID = tonumber(VID)
    if ( database.owners[VID] ~= nil ) then
      outputChatBox("Listing owners")
      for k,v in pairs(database.owners[VID]) do
        outputChatBox(k .. " " .. v)
      end
    else
      outputChatBox("The owner list for this vehicle is empty")
    end
end)

function showCars()
  for key, veh in pairs(database.vehicles) do
    outputChatBox(key.."  " .. getVehicleName(veh))
  end
end
addCommandHandler("showcars",showCars)

addCommandHandler("isthis", function(player,command)
    local veh = getPedOccupiedVehicle(player)
    if (veh~=nil) then
      outputChatBox(tonumber(getVID(veh)) .. " is the Vehicle ID")
    end
end)

addCommandHandler("becomeowner", function(player,command)
  local veh = getPedOccupiedVehicle(player)

  if veh == false then
    return
  end

  local VID = tonumber(getVID(veh))

  if VID == -1 then
    return
  end

  local PID = database.players[player]

  if PID == nil then
    return
  end

  addOwnership( VID, PID )

  outputChatBox("Done!")
end)