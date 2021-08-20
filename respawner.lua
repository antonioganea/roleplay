addEventHandler( "onPlayerWasted", getRootElement( ),
	function()
		setTimer( spawnPlayer, 3000, 1, source, 0, 0, 3 )
	end
)