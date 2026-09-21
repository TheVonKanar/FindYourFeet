FindYourFeet = LibStub("AceAddon-3.0"):NewAddon("FindYourFeet", "AceEvent-3.0", "AceConsole-3.0")

FindYourFeet.DEFAULTS = {
	global = {
		verbose    = true,
		highlights = {
			circle  = true,
			icon    = true,
			outline = false
		},
		locations  = {
			party = true,
			raid  = true
		}
	}
}

function FindYourFeet:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("FindYourFeetDB", self.DEFAULTS, true)
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
		SetCVar("findYourselfModeOutline", self.db.global.highlights.outline)

		if self.db.global.verbose and not silent then
			self:Print("Self Highlight is currently active.")
		end
	else
		SetCVar("findYourselfModeCircle", false)
		SetCVar("findYourselfModeIcon", false)
		SetCVar("findYourselfModeOutline", false)

		if self.db.global.verbose and not silent then
			self:Print("Self Highlight is currently inactive.")
		end
	end
end

function FindYourFeet:ProcessSlashCommand(input)
	if input == "" then
		self:Print("available commands:\r" ..
			"/fyf circle : Toggle the circle highlight below your character (default: true)\r" ..
			"/fyf icon : Toggle the icon highlight above your character (default: true)\r" ..
			"/fyf outline : Toggle the outline highlight around your character (default: false)\r" ..
			"/fyf party : Toggle the automatic activation of enabled highlights while in 5-man instances (default: true)\r" ..
			"/fyf raid : Toggle the automatic activation of enabled highlights while in raids (default: true)\r" ..
			"/fyf verbose : Toggle the chat messages sent when Self highlights gets enabled or disabled (default: true)")
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

	if input == "outline" then
		if self.db.global.highlights.outline then
			self.db.global.highlights.outline = false
			self:Print("Outline Highlight is now disabled.")
		else
			self.db.global.highlights.outline = true
			self:Print("Outline Highlight is now enabled.")
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
