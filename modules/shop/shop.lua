--car 1948.197265625 -1787.546875 13.475074768066
--0 0 272.57144165039
--1929.546875 -1776.294921875 13.546875
--0 0 270.49575805664

local sellerPosition = {1929.546875, -1776.294921875, 13.6, 270}

local seller = createPed ( 147, sellerPosition[1], sellerPosition[2], sellerPosition[3], sellerPosition[4] )
createBlipAttachedTo ( seller, 55, 2, 0, 0, 0, 255, 0, 200 )

function sellerClicked( theButton, theState, thePlayer )
    if theButton == "left" and theState == "down" then
        outputChatBox( "This is the shop!", thePlayer )
        triggerClientEvent ( thePlayer, "onOpenShop", thePlayer )
    end
end
addEventHandler( "onElementClicked", seller, sellerClicked, false )

local cars = {}

local function loadVehiclePrices()
  local rootNode = xmlLoadFile ( "modules/shop/vehiclePrices.xml" )
  local nodes = xmlNodeGetChildren ( rootNode )

  for k,v in pairs( nodes ) do
    local price = tonumber( xmlNodeGetAttribute ( v, "price" ) )
    local id = tonumber( xmlNodeGetAttribute ( v, "id" ) )
    if price and id then
      cars[id] = price
    else
      outputChatBox("ERROR LOADING vehiclePrices.xml serverside")
    end
  end

  xmlUnloadFile ( rootNode )
  nodes = nil
end
loadVehiclePrices()


function buyCar( carID ) -- PROBLEM WITH THIS FUNCTION : TWO SEPARATE TABLES FOR PRICES
  --You spawn the car, register it, also take the money from the GUY
  if getPlayerMoney ( client ) >= cars[carID] then
    local veh = createVehicle ( carID, 1948.197265625, -1787.546875, 14, 0, 0, 270 )
    addVehicleToDB(veh)
    addOwnership( getVID(veh), database.players[client] )
    takePlayerMoney ( client, cars[carID] )
    outputChatBox("You successfuly bought the ".. getVehicleNameFromModel(carID).."!", client)
  else
    outputChatBox("You don't afford this car : " .. cars[carID] .. "$", client)
  end
end
addEvent( "onBuyCar", true )
addEventHandler( "onBuyCar", resourceRoot, buyCar )