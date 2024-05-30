-- Tooltip.lua
WSA_Tooltip = {}

function WSA_Tooltip:Initialize(db, globals)
    self.db = db
    self.globals = globals
end

local function AddScoreTooltip(tooltip,  stats,  metric,  color)
    tooltip:AddLine(" ")
    WSA_Utilities.AddColoredLine(tooltip, "PVP Statistics:", Colors.WHITE)

    local hasTwosRating = false
    local hasThreesRating = false
    local hasSoloRating = false

    if stats.twosRating ~= nil and stats.twosRating > 0 then
        WSA_Utilities.AddColoredDoubleLine(tooltip, "2v2 Rating:", stats.twosRating, Colors.RED, Colors.WHITE)
        hasTwosRating = true
    end

    if stats.threesRating ~= nil and stats.threesRating > 0 then
        WSA_Utilities.AddColoredDoubleLine(tooltip, "3v3 Rating:", stats.threesRating, Colors.LIGHTRED, Colors.WHITE)
        hasThreesRating = true
    end

    if stats.soloRating ~= nil and stats.soloRating > 0 then
        WSA_Utilities.AddColoredDoubleLine(tooltip, "Solo Rating:", stats.soloRating, Colors.ORANGE, Colors.WHITE)
        hasSoloRating = true
    end

    if not hasSoloRating and not hasThreesRating and not hasTwosRating then
        WSA_Utilities.AddColoredDoubleLine(tooltip, "Warning", "No data available yet or there is no character pvp history!", Colors.YELLOW, Colors.RED)
    else
        local itemLevel = WSA_PVPStats:GetAverageItemLevel("player")
        local metric, color = WSA_Math:CalculateMetric(stats, itemLevel)
        WSA_Utilities.AddColoredDoubleLine(tooltip, "ArenaScore:", metric, Colors.YELLOW, color)
    end

    tooltip:Show()
end

function WSA_Tooltip:UpdateTooltip(stats)
    local tooltip = GameTooltip
    if tooltip and stats then
        local itemLevel = WSA_PVPStats:GetAverageItemLevel("player")
        local metric, color = WSA_Math:CalculateMetric(stats, itemLevel)
        AddScoreTooltip(tooltip, stats, metric, color)
    end
end

function WSA_Tooltip:ShowTooltip(tooltip)
    local _, unit = tooltip:GetUnit()
    if not unit or not UnitIsPlayer(unit) then return end

    local stats = WSA_PVPStats:GetPVPStats(unit)

    if stats then
        local itemLevel = WSA_PVPStats:GetAverageItemLevel(unit)
        local metric, color = WSA_Math:CalculateMetric(stats, itemLevel)
        AddScoreTooltip(tooltip, stats, metric, color)
    else
        tooltip:AddLine(" ")
        WSA_Utilities.AddColoredLine(tooltip, "Data not available yet ", Colors.RED)
        WSA_Utilities.AddColoredLine(tooltip, "or missing rated pvp history!", Colors.RED)
        tooltip:Show()
    end
end