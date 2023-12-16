local _config = require(script.Parent.Parent._Config)

local SectorTime = {}
SectorTime.__index = SectorTime

function SectorTime.new(sectorTime: number, state: number, player: Player | nil)
	
	local sector = {}
	setmetatable(sector, SectorTime)
	
	sector.Time = sectorTime
	sector.State = state

	if player then
		if _config.ShowDisplayNames then
			sector.DisplayName = player.DisplayName
		else
			sector.DisplayName = player.Name
		end
		sector.UserId = player.UserId
	end
	
	return sector
	
end

return SectorTime