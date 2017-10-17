local fgui = {}
fgui.gl = {}
fgui.tabpanel = {}
fgui.tab = {}
fgui.button = {}
fgui.memo = {}


--GridList == gridlist

local screenW, screenH = guiGetScreenSize()
fwindow = guiCreateWindow((screenW - 1317) / 2, (screenH - 798) / 2, 1317, 798, "You don't have a faction", false)
guiWindowSetSizable(fwindow, false)

fgui.tabpanel[1] = guiCreateTabPanel(10, 25, 902, 763, false, fwindow)

fgui.tab[1] = guiCreateTab("Members", fgui.tabpanel[1])

fgui.gl[1] = guiCreateGridList(10, 10, 882, 718, false, fgui.tab[1])
guiGridListAddColumn(fgui.gl[1], "no.", 0.2)
guiGridListAddColumn(fgui.gl[1], "Name", 0.2)
guiGridListAddColumn(fgui.gl[1], "Rank", 0.2)
guiGridListAddColumn(fgui.gl[1], "Wage", 0.2)
guiGridListAddColumn(fgui.gl[1], "Activity", 0.2)

fgui.tab[2] = guiCreateTab("Help", fgui.tabpanel[1])

fgui.memo[1] = guiCreateMemo(10, 10, 882, 719, "ad", false, fgui.tab[2])
fgui.button[1] = guiCreateButton(1209, 730, 98, 58, "Close", false, fwindow)
fgui.button[2] = guiCreateButton(983, 577, 261, 26, "", false, fwindow)
fgui.button[3] = guiCreateButton(983, 577, 261, 26, "Kick Player", false, fwindow)
fgui.button[4] = guiCreateButton(983, 608, 261, 26, "Add Player To Faction", false, fwindow)
fgui.button[5] = guiCreateButton(983, 546, 261, 26, "Give Leader Rights", false, fwindow)
fgui.button[6] = guiCreateButton(983, 514, 261, 26, "Promote", false, fwindow)
fgui.button[7] = guiCreateButton(983, 479, 261, 31, "Demote", false, fwindow)
fgui.button[8] = guiCreateButton(983, 454, 261, 21, "Modify Faction Structure", false, fwindow)


guiSetVisible ( fwindow, false )

function togGridListeGUI( GUIElement )
  guiSetVisible ( GUIElement, not guiGetVisible ( GUIElement ) )
end

 bindKey ( "F3", "down", function()
  togGridListeGUI(fwindow)
  showCursor ( guiGetVisible ( fwindow ) )
end
)

local ranks = {}
local wages = {}

function receiveFactionData( dataTable, factionTable ) -- Can't we just use the ReceiveChange function with the dataTable as argument??
  --dataTable[accountName] = { ["rank"]=v.rank, ["wage"]=v.wage, ["leader"]=v.leader }
  
  if type(factionTable) == "table" then
    ranks = factionTable.ranks or ranks -- ranks is an empty table already
    wages = factionTable.wages or wages -- wages is an empty table already
    guiSetText ( fwindow, factionTable.name ) -- set the window's title the name of the faction
  end
  
  guiGridListClear ( fgui.gl[1] )
  
  local currentRow = 0
  
  for k,v in pairs(dataTable) do
    guiGridListAddRow(fgui.gl[1])
    guiGridListSetItemText(fgui.gl[1], currentRow, 1, tostring(currentRow+1), false, false)
    guiGridListSetItemText(fgui.gl[1], currentRow, 2, k, false, false)
    guiGridListSetItemText(fgui.gl[1], currentRow, 3, ranks[v.rank] or tostring(v.rank), false, false) -- or "-" if the rank passed is not a member of the ranks table SHOULD VERIFY IF THIS IS NEEDED
    guiGridListSetItemText(fgui.gl[1], currentRow, 4, wages[v.rank] or "error", false, false) -- same
    guiGridListSetItemText(fgui.gl[1], currentRow, 5, "-", false, false)
    if v.leader == 1 then
      guiGridListSetItemColor ( fgui.gl[1], currentRow, 2, 35, 230, 95 )
    end
    currentRow = currentRow+1
  end
  outputChatBox("Received Faction Data",255,255,0)
end
addEvent("onClientReceiveFactionData",true)
addEventHandler("onClientReceiveFactionData",localPlayer,receiveFactionData)

function onGettingKicked( ) -- Can't we just use the ReceiveChange function with the dataTable as argument??
  guiGridListClear ( fgui.gl[1] )
  guiSetText ( fwindow, "You don't have a faction" ) -- set the window's title the name of the faction
end
addEvent("onClientGetKickedFromFaction",true)
addEventHandler("onClientGetKickedFromFaction",localPlayer,onGettingKicked)

function receiveChange( changeTable ) -- changeTable[accountName] = { ["rank"]=v.rank, ["wage"]=v.wage, ["leader"]=v.leader }
  local rowCount = guiGridListGetRowCount ( fgui.gl[1] ) - 1
  
  local changes = 0
  
  for currentRow = 0, rowCount do
    local rowName = guiGridListGetItemText ( fgui.gl[1], currentRow, 2 )
    if changeTable[rowName] ~= nil then
      local v = changeTable[rowName] -- set an alias
      changes = changes+1
      guiGridListSetItemText(fgui.gl[1], currentRow, 3, ranks[v.rank] or tostring(v.rank), false, false) -- or "-" if the rank passed is not a member of the ranks table SHOULD VERIFY IF THIS IS NEEDED
      guiGridListSetItemText(fgui.gl[1], currentRow, 4, wages[v.rank] or "error", false, false) -- same
      guiGridListSetItemText(fgui.gl[1], currentRow, 5, "-", false, false)
      --outputChatBox("HOPA")
      if v.leader == 1 then
        --outputChatBox(rowName .. " " .. v.leader)
        guiGridListSetItemColor ( fgui.gl[1], currentRow, 2, 35, 230, 95 )
      else
        --outputChatBox(rowName .. " non " .. v.leader)
        guiGridListSetItemColor ( fgui.gl[1], currentRow, 2, 255, 255, 255 ) -- get actual color...
      end
      
      changeTable[rowName] = nil -- set change value to false if solved..
      --outputChatBox("DEBUG MODE")
    end
  end
  
  local currentRow = rowCount+1
  
  for k,v in pairs(changeTable) do
    guiGridListAddRow(fgui.gl[1])
    guiGridListSetItemText(fgui.gl[1], currentRow, 1, tostring(currentRow+1), false, false)
    guiGridListSetItemText(fgui.gl[1], currentRow, 2, k, false, false)
    guiGridListSetItemText(fgui.gl[1], currentRow, 3, ranks[v.rank] or tostring(v.rank), false, false) -- or "-" if the rank passed is not a member of the ranks table SHOULD VERIFY IF THIS IS NEEDED
    guiGridListSetItemText(fgui.gl[1], currentRow, 4, wages[v.rank] or "error", false, false) -- same
    guiGridListSetItemText(fgui.gl[1], currentRow, 5, "-", false, false)
    if v.leader == 1 then
      guiGridListSetItemColor ( fgui.gl[1], currentRow, 2, 35, 230, 95 )
    end
    currentRow = currentRow+1
  end
end
addEvent("onClientReceiveFactionChange",true)
addEventHandler("onClientReceiveFactionChange",localPlayer,receiveChange)

function receiveDelete( deleteTable ) -- changeTable[accountName] = { ["rank"]=v.rank, ["wage"]=v.wage, ["leader"]=v.leader }
  local rowCount = guiGridListGetRowCount ( fgui.gl[1] ) - 1
  
  local deletes = 0
  
  for currentRow = 0, rowCount do
    local rowName = guiGridListGetItemText ( fgui.gl[1], currentRow, 2 )
    if deleteTable[rowName] ~= nil then -- if it exist in the deletitionTable..
      deletes = deletes+1
      guiGridListRemoveRow ( fgui.gl[1], currentRow )
      
      --changeTable[rowName] = nil -- set change value to false if solved..
    end
  end
end
addEvent("onClientReceiveFactionDelete",true)
addEventHandler("onClientReceiveFactionDelete",localPlayer,receiveDelete) -- server side is only called for one player at a time...............................

--[[
pickPlayers = guiCreateWindow((screenW - 550) / 2, (screenH - 581) / 2, 550, 581, "Players", false)
guiWindowSetSizable(pickPlayers, false)
guiSetProperty(pickPlayers, "AlwaysOnTop", "True")

fgui.gl[2] = guiCreateGridList(9, 30, 531, 483, false, pickPlayers)
guiGridListAddColumn(fgui.gl[2], "PID", 0.3)
guiGridListAddColumn(fgui.gl[2], "Name", 0.3)
guiGridListAddColumn(fgui.gl[2], "Account Name", 0.3)
for i = 1, 2 do
    guiGridListAddRow(fgui.gl[2])
end
guiGridListSetItemText(fgui.gl[2], 0, 1, "2", false, false)
guiGridListSetItemText(fgui.gl[2], 0, 2, "#FF302FZenibryum", false, false)
guiGridListSetItemText(fgui.gl[2], 0, 3, "Zenibryum", false, false)
guiGridListSetItemText(fgui.gl[2], 1, 1, "-", false, false)
guiGridListSetItemText(fgui.gl[2], 1, 2, "-", false, false)
guiGridListSetItemText(fgui.gl[2], 1, 3, "-", false, false)
fgui.button[9] = guiCreateButton(11, 520, 263, 51, "Close", false, pickPlayers)
fgui.button[10] = guiCreateButton(277, 519, 263, 52, "Choose Player", false, pickPlayers)

guiSetVisible ( pickPlayers, false )
]]
