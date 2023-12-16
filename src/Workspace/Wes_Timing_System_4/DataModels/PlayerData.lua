local LapTime = require(script.Parent.LapTime)
local _config = require(script.Parent.Parent._Config)

local PlayerData = {}
PlayerData.__index = PlayerData

function PlayerData.new(player: Player)
	
	local playerData = {}
	setmetatable(playerData, PlayerData)
	if _config.ShowDisplayNames then
		playerData.DisplayName = player.DisplayName
	else
		playerData.DisplayName = player.Name
	end
	playerData.UserId = player.UserId
	playerData.CurrentLap = LapTime.new()
	playerData.CornerCuts = 0
	playerData.LastCornerCutAt = time()
	playerData.BestLap = LapTime.new()
	playerData.Laps = 0
	playerData.LapTimes = {}
	playerData.LastUpdatedAt = time()
	
	return playerData
	
end

return PlayerData
