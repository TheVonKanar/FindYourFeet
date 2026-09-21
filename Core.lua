FindYourFeet = LibStub("AceAddon-3.0"):NewAddon("FindYourFeet", "AceEvent-3.0", "AceConsole-3.0")

function FindYourFeet:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("FindYourFeetDB", {
		global = {
			verbose    = true,
			highlights = {
				circle = true,
				icon   = true
			},
			locations  = {
				party = true,
				raid  = true
			}
		}
	}, true)
	self:RegisterChatCommand("fyf", "ProcessSlashCommand")
end

function FindYourFeet:OnEnable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function FindYourFeet:OnDisable()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function FindYourFeet:PLAYER_ENTERING_WORLD(event, isInitialLogin, isReloadingUi)
	self:Refresh()
end

function FindYourFeet:Refresh(silent)
	silent = silent or false

	if (not self.db.global.highlights.circle and not self.db.global.highlights.icon) or
		 (not self.db.global.locations.party and not self.db.global.locations.raid) then
		return
	end

	local _, instanceType = IsInInstance()
	if (instanceType == "party" and self.db.global.locations.party) or
		 (instanceType == "raid" and self.db.global.locations.raid) then
		SetCVar("findYourselfModeCircle", self.db.global.highlights.circle)
		SetCVar("findYourselfModeIcon", self.db.global.highlights.icon)

		if self.db.global.verbose and not silent then
			self:Print("Self Highlight is currently active.")
		end
	else
		SetCVar("findYourselfModeCircle", false)
		SetCVar("findYourselfModeIcon", false)

		if self.db.global.verbose and not silent then
			self:Print("Self Highlight is currently inactive.")
		end
	end
end

function FindYourFeet:ProcessSlashCommand(input)
	if input == "" then
		self:Print("available commands:\r" ..
			"|cFFFF7139/fyf circle|r : Toggle the circle highlight around your feet\r" ..
			"|cFFFF7139/fyf icon|r : Toggle the icon highlight above your head\r" ..
			"|cFFFF7139/fyf party|r : Toggle the automatic activation of enabled highlights while in 5-man instances\r" ..
			"|cFFFF7139/fyf raid|r : Toggle the automatic activation of enabled highlights while in raids\r" ..
			"|cFFFF7139/fyf verbose|r : Toggle the chat messages sent when Self highlights gets enabled or disabled")
		return
	end

	if input == "circle" then
		if self.db.global.highlights.circle then
			self.db.global.highlights.circle = false
			self:Print("Circle Highlight is now disabled.")
		else
			self.db.global.highlights.circle = true
			self:Print("Circle Highlight is now enabled.")
		end
		self:Refresh(true)
		return
	end

	if input == "icon" then
		if self.db.global.highlights.icon then
			self.db.global.highlights.icon = false
			self:Print("Icon Highlight is now disabled.")
		else
			self.db.global.highlights.icon = true
			self:Print("Icon Highlight is now enabled.")
		end
		self:Refresh(true)
		return
	end

	if input == "party" then
		if self.db.global.locations.party then
			self.db.global.locations.party = false
			self:Print("Self Highlight is now disabled in 5-man instances.")
		else
			self.db.global.locations.party = true
			self:Print("Self Highlight is now enabled in 5-man instances.")
		end
		self:Refresh(true)
		return
	end

	if input == "raid" then
		if self.db.global.locations.raid then
			self.db.global.locations.raid = false
			self:Print("Self Highlight is now disabled in raids.")
		else
			self.db.global.locations.raid = true
			self:Print("Self Highlight is now enabled in raids.")
		end
		self:Refresh(true)
		return
	end

	if input == "verbose" then
		self.db.profile.verbose = not self.db.profile.verbose
		return
	end
end
