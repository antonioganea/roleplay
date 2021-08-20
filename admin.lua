addCommandHandler("givemoney", function (player,command,amount)
  setPlayerMoney ( player, tonumber( amount) )
end)

function getrot ( targetElem,command, carid )
    if ( isElement(targetElem) and getElementType (targetElem) == "player" ) then
      if getPedOccupiedVehicle ( targetElem ) then
        targetElem = getPedOccupiedVehicle ( targetElem )
      end
        local rx,ry,rz = getElementRotation ( targetElem )
        local x,y,z = getElementPosition(targetElem)
        outputChatBox("x "..x .. " y " ..  y .. " z " .. z)
        outputChatBox("rx "..rx .. " ry " ..  ry .. " rz " .. rz)
        local newFile = fileCreate("getrot.txt")
        if (newFile) then
          fileWrite(newFile, x .. " " .. y .. " " .. z .. "\n" .. rx .. " " .. ry .. " " .. rz)
          fileClose(newFile)
        end
      end
end
addCommandHandler("getrot",getrot)

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

  
addCommandHandler("warpbus",function(player,command)
      setElementPosition ( player, 1807.7138671875, -1917.837890625, 13.565902709961, true )
    end
 )
 
addCommandHandler("warptruck",function(player,command)
      setElementPosition ( player, -988.775390625, -679.8369140625, 32.0078125, true )
    end
 )

addCommandHandler("whoami",function(player,command)
      outputChatBox(tostring(database.players[player]) .. " is your PID!",player)
end
)

addCommandHandler("isthis", function(player,command)
    local veh = getPedOccupiedVehicle(player)
    if (veh~=nil) then
      outputChatBox(tonumber(getVID(veh)) .. " is the Vehicle ID")
    end
end)

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

function consoleGive ( thePlayer, commandName, weaponID, ammo )
	local status = giveWeapon ( thePlayer, weaponID, ammo, true )   -- attempt to give the weapon, forcing it as selected weapon
	if ( not status ) then                                          -- if it was unsuccessful
		outputConsole ( "Failed to give weapon.", thePlayer )   -- tell the player
	end
end
addCommandHandler ( "give", consoleGive )