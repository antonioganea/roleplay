addCommandHandler("givemoney", function (player,command,amount)
    givePlayerMoney ( player, tonumber( amount) )
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

addCommandHandler("whoami",function(player,command)
    outputChatBox(tostring(database.players[player]) .. " is your PID!",player)
end
)

function consoleGive ( thePlayer, commandName, weaponID, ammo )
  local status = giveWeapon ( thePlayer, weaponID, ammo, true )   -- attempt to give the weapon, forcing it as selected weapon
  if ( not status ) then                                          -- if it was unsuccessful
      outputConsole ( "Failed to give weapon.", thePlayer )   -- tell the player
  end
end
addCommandHandler ( "give", consoleGive )