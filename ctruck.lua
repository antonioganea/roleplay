local screenW, screenH = guiGetScreenSize()
local wtruck = guiCreateWindow((screenW - 506) / 2, (screenH - 584) / 2, 506, 584, "Window Title", false)
guiWindowSetSizable(wtruck, false)
guiSetVisible ( wtruck, false )


--outputChatBox("DEBUG CLIENT LOADED truckOrders.xml",255,255,0)

local gtruck = guiCreateGridList(9, 25, 487, 487, false, wtruck)
guiGridListAddColumn(gtruck, "no.", 0.2)
guiGridListAddColumn(gtruck, "Cargo Type", 0.2)
guiGridListAddColumn(gtruck, "Destination", 0.2)
guiGridListAddColumn(gtruck, "Base Pay", 0.2)


local rootNode = xmlLoadFile ( "truckOrders.xml" )
local nodes = xmlNodeGetChildren ( rootNode )

local orders = {}

for k,v in pairs( nodes ) do
  local no = tonumber( xmlNodeGetAttribute ( v, "no" ) )
  local from = tonumber( xmlNodeGetAttribute ( v, "from" ) )
  local to = tonumber( xmlNodeGetAttribute ( v, "to" ) )
  local cargo =  xmlNodeGetAttribute ( v, "cargo" )
  local payment = tonumber( xmlNodeGetAttribute ( v, "payment" ) )
  
  if no and from and to and cargo and payment then
    orders[no] = { from, to, cargo, payment }
  else
    outputChatBox("ERROR LOADING truckOrders.xml clientside! Address an admin")
  end
end

xmlUnloadFile ( rootNode )

--outputChatBox("DEBUG CLIENT LOADED truckOrders.xml",255,0,0)

rootNode = xmlLoadFile ( "truckPlaces.xml" )
nodes = xmlNodeGetChildren ( rootNode )

local places = {}

for k,v in pairs( nodes ) do
  local no = tonumber( xmlNodeGetAttribute ( v, "no" ) )
  local name = xmlNodeGetAttribute ( v, "name" )
  
  if no and name then
    places[no] = name
  else
    outputChatBox("ERROR LOADING truckPlaces.xml clientside! Address an admin")
  end
end

xmlUnloadFile ( rootNode )
nodes = nil

--outputChatBox("Debug Ctruck Worked TAG 1")

function showPanel(from)--from is a number
  --outputChatBox("Showpanel clientside worked")
  local rowNumber = 0
  
   guiSetText ( wtruck, places[from] )
  
  for k,v in pairs( orders ) do
    if (v[1] == from) then
      guiGridListAddRow(gtruck)
      
      guiGridListSetItemText( gtruck, rowNumber, 1, tostring(k), false, true )
      guiGridListSetItemText( gtruck, rowNumber, 2, v[3], false, false )
      guiGridListSetItemText( gtruck, rowNumber, 3, places[v[2]], false, false )
      guiGridListSetItemText( gtruck, rowNumber, 4, tostring(v[4]), false, true )
      
      rowNumber = rowNumber + 1
    end
  end
  guiSetVisible ( wtruck, true )
end
addEvent( "onTruckEnterBay", true )
addEventHandler( "onTruckEnterBay", localPlayer, showPanel )

--outputChatBox("Debug Ctruck Worked TAG 2")

function closePanel ( ) -- button, state, mouseX, mouseY (absolute)
    guiSetVisible ( wtruck, false )
    guiGridListClear ( gtruck )
end
local buttonClose = guiCreateButton(9, 516, 64, 58, "Close", false, wtruck)
addEventHandler( "onClientGUIClick", buttonClose, closePanel, false )

--outputChatBox("Debug Ctruck Worked TAG 3")
      
      --[[guiGridListAddRow(gtruck)
      guiGridListSetItemText( gtruck, 0, 1, 1, false, true )
      guiGridListSetItemText( gtruck, 0, 2, "Gravel", false, false )
      guiGridListSetItemText( gtruck, 0, 3, "LS DEPOT", false, false )
      guiGridListSetItemText( gtruck, 0, 4, 2000,false, true )
      
      guiGridListAddRow(gtruck)
      guiGridListSetItemText( gtruck, 1, 1, 5, false, true )
      guiGridListSetItemText( gtruck, 1, 2, "Armory", false, false )
      guiGridListSetItemText( gtruck, 1, 3, "GunShop L.V.", false, false )
      guiGridListSetItemText( gtruck, 1, 4, 4000,false, true )--]]

function requestLoad ( ) -- button, state, mouseX, mouseY (absolute)
  --outputChatBox("Actually Clicked That Button")
  local row,column = guiGridListGetSelectedItem ( gtruck )
  --outputChatBox("Selected Item : " .. row .." " .. column)
  local order = tonumber( guiGridListGetItemText ( gtruck, row, 1 ) )
  
  --outputChatBox(order)
  if order~=nil then
    triggerServerEvent ( "onTruckRequestLoad", resourceRoot, order )
  end
  closePanel()
end

local buttonLoad = guiCreateButton(77, 516, 419, 58, "Load Cargo", false, wtruck)
addEventHandler( "onClientGUIClick", buttonLoad, requestLoad, false )

--outputChatBox("Debug Ctruck Worked TAG 4")

--[[
Required Arguments

    gridList: The grid list element
    rowIndex: Row ID
    columnIndex: Column ID
    text: The text you want to put in (does NOT accept numbers, use tostring() for that)
    section: Determines if the item is a section
    number: Tells whether the text item is a number value or not (used for sorting)
]]--