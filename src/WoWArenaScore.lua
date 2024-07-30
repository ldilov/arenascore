---@class AceAddon
WSA = LibStub("AceAddon-3.0"):NewAddon("WoWArenaScore", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

function WSA:OnInitialize()
    WSA_Core:InitializeDependencies()

    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld")
    self:RegisterEvent("INSPECT_READY", "OnInspectReady")
end

function WSA:OnPlayerEnteringWorld()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:ScheduleTimer(function()
        self:HookTooltips()
    end, 1)
end

function WSA:OnInspectReady(event, inspecteeGUID)
    if WSA_Core:IsUnitInspectRequestPending(inspecteeGUID) then
        local stats = WSA_PVPStats:ProcessPVPStats()
        WSA_Core:ResetGlobalContextField("pendingInspectUnit")
        WSA_Tooltip:UpdateTooltip(stats)
    end
end

function WSA:HookTooltips()
    if GameTooltip then
        hooksecurefunc(GameTooltip, "SetUnit", function(tooltip, ...)
            self:OnTooltipSetUnit(tooltip)
        end)
    else
        self:ScheduleTimer(function()
            self:HookTooltips()
        end, 1)
    end
end


function WSA:OnTooltipSetUnit(tooltip)
    WSA_Core:SetUnitToolTip(tooltip)
    WSA_Tooltip:ShowTooltip(tooltip)
end

-- Register the addon
WSA:RegisterEvent("PLAYER_ENTERING_WORLD", "OnInitialize")
