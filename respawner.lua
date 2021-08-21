local spawnPoint = {0, 0, 3}

addEventHandler( "onPlayerWasted", getRootElement( ),
	function()
		setTimer( spawnPlayer, 3000, 1, source, spawnPoint[1], spawnPoint[2], spawnPoint[3] )
	end
)