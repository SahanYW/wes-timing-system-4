local service = {}

-- Modules
local _remoteHandler = require(script.Parent.TimingLocalRemoteHandler)
local _dataService = require(script.Parent.TimingLocalDataService)
local _popupService = require(script.Parent.GuiLogic.PopupService)
local _helpers = require(workspace.Wes_Timing_System_4.Modules.Helpers)
local _remotes = require(workspace.Wes_Timing_System_4.Modules.RemotesLocal)
local _config = require(workspace.Wes_Timing_System_4._Config)

-- Remotes
local updateSectorEvent = _remotes:GetRemoteEvent("UpdateSectorEvent")
local updateLapEvent = _remotes:GetRemoteEvent("UpdateLapEvent")

-- States
local currentSector = 0
local sectorIsValid = true
local lapIsValid = true
local nextLapIsValid = true
local LastCornerCutAt = 0

-- Timestamps
local lapStartAt = 0
local sector1At = 0
local sector2At = 0

--- Handles completing a sector
---@param sector number The sector number that was completed
function service:HandleSector(sector: number)

    if sector ~= currentSector then
        return
    end

    -- Get the sector time
    local sectorTime
    if sector == 1 then
        sectorTime = time() - lapStartAt
        sector1At = time()
    elseif sector == 2 then
        sectorTime = time() - sector1At
        sector2At = time()
	end
	
	-- Get delta time data
	local deltaTimeData = _dataService:GetDeltaTime(sector, sectorTime, sectorIsValid)
	
	-- Display delta time
	if deltaTimeData ~= nil then
		
		-- Popup data
		local frameColor = _helpers:GetStatePopupColor(deltaTimeData.state)
		local displayString = _helpers:ConvertTime(math.abs(deltaTimeData.delta))

		-- Improved sector
		if deltaTimeData.delta <= 0 then
			displayString = "- " .. displayString
			
		-- Slower sector
		else
			displayString = "+ " .. displayString
		end
		
		-- Display
		_popupService:NewPopup(displayString, frameColor)
	end
	

    -- Update states
    SubmitSectorTime(sector, sectorTime, sectorIsValid)
    currentSector += 1
    sectorIsValid = true

end

--- Handles completing a lap
function service:HandleLap()
    
    -- If in sector 3, complete the lap
    if currentSector == 3 then
        local lapTime = time() - lapStartAt
        local sectorTime = time() - sector2At

        -- Show prompt
        DisplayLapTime(lapTime, lapIsValid)

        -- Submit times
        SubmitSectorTime(3, sectorTime, sectorIsValid)
        SubmitLapTime(lapTime, lapIsValid)
    end

    -- Reset states
    currentSector = 1
    if nextLapIsValid then
        lapIsValid = true
        sectorIsValid = true
    else
        nextLapIsValid = true
        sectorIsValid = false
    end
    lapStartAt = time()

end

--- Adds a corner cut count to the player
--- @param nextLapInvalid boolean If the corner cut invalidates the next lap
function service:AddCornerCut(nextLapInvalid: boolean, cutsFromBlock: number)
    
	-- Check CC cooldown
	if time() - LastCornerCutAt < _config.CornerCutCooldownSeconds then
		return
	end

    if nextLapIsValid and nextLapInvalid then

        if lapIsValid then
            -- If this lap and the next lap has not been invalidated yet, show a popup
            _popupService:NewPopup(string.format("CORNER CUT x%d - LAP & NEXT LAP INVALIDATED",cutsFromBlock), _config.Styles.InvalidStatePopup, 350)
        else
            -- If the next lap has not been invalidated yet, show a popup
            _popupService:NewPopup(string.format("CORNER CUT x%d - NEXT LAP INVALIDATED",cutsFromBlock), _config.Styles.InvalidStatePopup, 320)
        end
        nextLapIsValid = false
        
    elseif lapIsValid then
        -- If the lap is invalidated for the first time, show a popup
        _popupService:NewPopup(string.format("CORNER CUT x%d - LAP INVALIDATED",cutsFromBlock), _config.Styles.InvalidStatePopup, 300)

    elseif _config.PopupEverycut then
        -- Otherwise show this popup instead
        _popupService:NewPopup(string.format("CORNER CUT x%d",cutsFromBlock), _config.Styles.InvalidStatePopup, 300)
    end
	LastCornerCutAt = time()

    -- Register Corner Cut and invalid sector and lap
    sectorIsValid = false
    lapIsValid = false
    
    _remoteHandler:RequestAddCornerCut(cutsFromBlock)

end

--- Calls the server to handle the lap time
---@param lapTime number The laptime that has been set
---@param isValid boolean Whether the laptime is valid
function SubmitLapTime(lapTime: number, isValid: boolean)

    updateLapEvent:FireServer(lapTime, isValid)

end

--- Calls the server to handle the sector time
---@param sector number The sector in which the time was set
---@param sectorTime number The sector time
---@param isValid boolean Whether the sector time is valid
function SubmitSectorTime(sector: number, sectorTime: number, isValid: boolean)

    updateSectorEvent:FireServer(sector, sectorTime, isValid)

end

--- Uses the popup service to display the given lap time
---@param lapTime number The lap time to be displayed
---@param isValid boolean Whether the lap time is valid
function DisplayLapTime(lapTime: number, isValid: boolean)
    
    local frameColor = _config.Styles.InvalidStatePopup
    if isValid then
        local state = _dataService:GetLapTimeStatus(lapTime)
        frameColor = _helpers:GetStatePopupColor(state)
    end

    _popupService:NewPopup(
        _helpers:ConvertTime(lapTime), 
        frameColor
    )

end

return service