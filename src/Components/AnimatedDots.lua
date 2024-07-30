-- Components:AnimatedDots.lua
WSA_AnimatedDots = {}

function WSA_AnimatedDots:Initialize(globals)
    self.globals = globals
    self.loadingDotsFrame = nil
    self.dotCounter = 0
    self.ticker = nil
    self.loadingLineIndex = nil
end

--- Starts the loading dots animation
--- @return nil
function WSA_AnimatedDots:StartLoadingDots()
    if self.loadingLineIndex == nil then
        -- Add a new line to the tooltip for the loading dots and store the line index
        WSA_Utilities.AddColoredLine(self.globals.unitToolTip, "Loading", Colors.YELLOW)
        self.loadingLineIndex = self.globals.unitToolTip:NumLines()
        self.globals.unitToolTip:Show()
    end

    if self.ticker then
        return
    end

    -- Use C_Timer.NewTicker to update the loading dots at regular intervals
    self.ticker = C_Timer.NewTicker(1, function()
        self.dotCounter = self.dotCounter + 1
        local dots = string.rep(".", (self.dotCounter) % 4)
        local loadingText = string.format("Loading%s", dots)

        if  self.loadingLineIndex == nil then
            return
        end

        local loadingLine = _G[self.globals.unitToolTip:GetName() .. "TextLeft" .. self.loadingLineIndex]
        if loadingLine then
            loadingLine:SetText(loadingText)
            self.globals.unitToolTip:SetHeight(loadingLine:GetHeight() + 120) -- Adjust height
            self.globals.unitToolTip:SetWidth(math.max(self.globals.unitToolTip:GetWidth(), loadingLine:GetStringWidth() + 120)) -- Adjust width
            self.globals.unitToolTip:Show() -- Update the tooltip display
        end

        self.globals.unitToolTip:Show() -- Update the tooltip display
    end)
end

--- Stops the loading dots animation
--- @return nil
function WSA_AnimatedDots:StopLoadingDots()
    if self.ticker and not self.ticker:IsCancelled() then
        self.ticker:Cancel()
        self.ticker = nil
    end

    if self.loadingLineIndex ~= nil then
        self.loadingLineIndex = nil
    end
end