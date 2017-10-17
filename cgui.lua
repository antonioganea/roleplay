local function toggleCursor(key,state)
  showCursor ( not isCursorShowing () )
end
bindKey ( "m", "down", function(key,state)
    showCursor ( not isCursorShowing () )
  end
)