local function toggleCursor(key,state)
  showCursor ( not isCursorShowing () )
end
bindKey ( "m", "down", function(key,state)
    showCursor ( not isCursorShowing () )
  end
)

--[[local screenX, screenY = guiGetScreenSize ()

local myFont = dxCreateFont( "pricedown.ttf", 256 )

function drawTheme()
dxDrawText ( "Zenibryum\nBet on 12", 0, 0, screenX, screenY, tocolor(20,150,50), 1, myFont, "center", "center")
end

addEventHandler ( "onClientRender", root, drawTheme ) -- keep the text visible with onClientRender.
]]