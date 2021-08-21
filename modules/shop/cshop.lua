local rootNode = xmlLoadFile ( "modules/shop/vehiclePrices.xml" )
local nodes = xmlNodeGetChildren ( rootNode )

local cars = {}

for k,v in pairs( nodes ) do
  local price = tonumber( xmlNodeGetAttribute ( v, "price" ) )
  local id = tonumber( xmlNodeGetAttribute ( v, "id" ) )
  if price and id then
    cars[id] = price
  else
    outputChatBox("ERROR LOADING vehiclePrices.xml clientside")
  end
end

xmlUnloadFile ( rootNode )
nodes = nil

local screenW, screenH = guiGetScreenSize()
local window = guiCreateWindow((screenW - 377) / 2, (screenH - 568) / 2, 377, 568, "Car Shop", false)
guiWindowSetSizable(window, false)
local gridlist = guiCreateGridList(10, 30, 357, 480, false, window)
guiGridListAddColumn(gridlist, "Name", 0.3)
guiGridListAddColumn(gridlist, "ID", 0.3)
guiGridListAddColumn(gridlist, "Price", 0.3)
bclose = guiCreateButton(10, 517, 357, 50, "Close", false, window)

addEventHandler( "onClientGUIClick", bclose, function () guiSetVisible(window, false) end, false )

local i = 0;

for k,v in pairs(cars) do
  guiGridListAddRow(gridlist)
  guiGridListSetItemText(gridlist,i,1,getVehicleNameFromModel(k),false,false)
  guiGridListSetItemText(gridlist,i,2,k,false,true)
  guiGridListSetItemText(gridlist,i,3,v,false,true)
  
  if i % 2 == 0 then
    for j = 1, 3 do guiGridListSetItemColor(gridlist, i, j, 255, 225, 0, 255) end
  else
    for j = 1, 3 do guiGridListSetItemColor(gridlist, i, j, 0, 127, 255, 255) end
  end
  i = i + 1
end

confirm = guiCreateWindow((screenW - 337) / 2, (screenH - 174) / 2, 337, 174, "Car Shop", false)
guiWindowSetSizable(confirm, false)

label = guiCreateLabel(47, 31, 244, 48, "Are you sure you want to buy", false, confirm)
guiLabelSetHorizontalAlign(label, "center", false)
guiLabelSetVerticalAlign(label, "center")
byes = guiCreateButton(58, 98, 85, 25, "Yes", false, confirm)
bno = guiCreateButton(192, 98, 85, 25, "No", false, confirm)
guiSetProperty ( confirm, "AlwaysOnTop" , "True" )

local selectedCar = 0;

function doubleClickedCar( )
  if guiGetVisible(confirm) == false then
    local selectedRow, selectedCol = guiGridListGetSelectedItem( gridlist )
    local carID = tonumber( guiGridListGetItemText( gridlist, selectedRow, 2 ) )
    guiSetText ( label, "Do you want to buy the " .. getVehicleNameFromModel(carID) .. "?" )
    guiSetVisible(confirm, true)
    selectedCar = carID
    --guiBringToFront ( confirm )
  end
end
addEventHandler( "onClientGUIDoubleClick", gridlist, doubleClickedCar, false )

addEventHandler( "onClientGUIClick", byes, function()
  triggerServerEvent ( "onBuyCar", resourceRoot, selectedCar )
  guiSetVisible(confirm,false)
  guiSetVisible(window,false)
  end, false ) -- this is used to buy the car

addEventHandler( "onClientGUIClick", bno, function () guiSetVisible(confirm, false) end, false )

guiSetVisible(window, false)
guiSetVisible(confirm, false)

function openShop ()
  if guiGetVisible(window) == false then
    guiSetVisible(window,true)
  else
    guiSetVisible(window,false)
  end
end
addEvent( "onOpenShop", true )
addEventHandler( "onOpenShop", localPlayer, openShop )