local config = {
	
	-- Admin users
	-- List of users who are able to reset the timing board
	AdminUsers = {"Wesley1041", "SomebodyElse"},
	-- List of groups and ranks that are able to reset the timing board
	AdminRoles = {
		{
			GroupId = 12345678,
			Rank = 200
		},
		{
			GroupId = 23456789,
			Rank = 150
		},
	},

	-- Settings
	-- Whether the player must be seated or not
	PlayerMustBeSeated = true,
	-- How much time must be elapsed between two CCs in order for them to count twice
	CornerCutCooldownSeconds = 1,
	-- Whether or not a popup appears per cut, rather than once per lap
	PopupEverycut = false,
	-- Whether or not the name displayed on the leaderboard is the username or display name
	ShowDisplayNames = false,

	-- Anti Cheat
	-- Whether anti-cheat should be used
	CheckForAntiCheat = true,
	-- Lap times below this time will be considered as cheating
	MinimumLapTime = 1,
	-- Sector times below this time will be considered as cheating
	MinimumSectorTime = 1,
	-- Whether to kick a user when they are caught cheating
	KickWhenCheat = true,

	-- Input mapping
	-- Which key should be used in order to view the table GUI on the player's screen
	-- Can be set to nil if you wish to disable this function
	ToggleBoardGuiKey = Enum.KeyCode.Q,

	-- References
	Board = script.Parent.Board:WaitForChild("Board"),

	-- Styling
	Styles = {
		PositionBoxBackground = Color3.fromRGB(255, 255, 255),
		PositionBoxText = Color3.fromRGB(0, 0, 0),
		PositionFirstBoxBackground = Color3.fromRGB(146, 12, 255),
		PositionFirstBoxText = Color3.fromRGB(255, 255, 255),

		DefaultState = Color3.fromRGB(255, 255, 255),
		InvalidState = Color3.fromRGB(240, 30, 30),
		PersonalBestState = Color3.fromRGB(71, 255, 71),
		OverallBestState = Color3.fromRGB(146, 12, 255),

		DefaultStateText = Color3.fromRGB(255, 255, 255),
		InvalidStateText = Color3.fromRGB(240, 30, 30),
		PersonalBestStateText = Color3.fromRGB(71, 255, 71),
		OverallBestStateText = Color3.fromRGB(169, 63, 255),

		DefaultStatePopup = Color3.fromRGB(0, 0, 0),
		InvalidStatePopup = Color3.fromRGB(170, 41, 41),
		PersonalBestStatePopup = Color3.fromRGB(44, 175, 44),
		OverallBestStatePopup = Color3.fromRGB(118, 45, 177),
	},
}

return config
