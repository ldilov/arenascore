-- PVPStats.lua

WSA_PVPStats = {}
local inspectLock = false

function WSA_PVPStats:Initialize(db, globals)
    self.db = db
    self.globals = globals
end

function WSA_PVPStats:ProcessPVPStats()
    local unit = self.globals.pendingInspectUnit

    if not UnitIsPlayer(unit) then
        inspectLock = false
        return nil
    end

    local twosRating, twosSeasonPlayed, twosSeasonWon,  _, _ = GetInspectArenaData(1)
    local threesRating, threesSeasonPlayed, threesSeasonWon,  _, _  = GetInspectArenaData(2)

    local soloShuffleData = C_PaperDollInfo.GetInspectRatedSoloShuffleData()
    local soloRating = soloShuffleData and soloShuffleData.rating or nil
    local soloSeasonPlayed = soloShuffleData and soloShuffleData.roundsPlayed or 0
    local soloSeasonWon = soloShuffleData and soloShuffleData.roundsWon or 0

    local stats = {
        twosRating = tonumber(twosRating) > 0 and tonumber(twosRating) or nil,
        threesRating = tonumber(threesRating) > 0 and tonumber(threesRating) or nil,
        soloRating = tonumber(soloRating) > 0 and tonumber(soloRating) or nil,
        twosSeasonPlayed = tonumber(twosSeasonPlayed) > 0 and tonumber(twosSeasonPlayed) or 0,
        twosSeasonWon = tonumber(twosSeasonWon) > 0 and tonumber(twosSeasonWon) or 0,
        threesSeasonPlayed = tonumber(threesSeasonPlayed) > 0 and tonumber(threesSeasonPlayed) or 0,
        threesSeasonWon = tonumber(threesSeasonWon) > 0 and tonumber(threesSeasonWon) or 0,
        soloSeasonPlayed = tonumber(soloSeasonPlayed) > 0 and tonumber(soloSeasonPlayed) or 0,
        soloSeasonWon = tonumber(soloSeasonWon) > 0 and tonumber(soloSeasonWon) or 0,
    }

    WSA_Cache:UpdateCache(unit, stats)

    if not (stats.twosRating or stats.threesRating or stats.soloRating) then
        inspectLock = false
        return {}
    end

    inspectLock = false
    return stats
end

function WSA_PVPStats:GetAverageItemLevel(unit)
    WSA_AnimatedDots:StopLoadingDots()

    local totalItemLevel = 0
    local itemCount = 0
    
    for i = 1, 17 do
        local itemLink = GetInventoryItemLink(unit, i)
        if itemLink then
            local itemLevel = GetDetailedItemLevelInfo(itemLink) -- Normal effective item level
            local pvpItemLevelOverride = nil
            local data = C_TooltipInfo.GetInventoryItem(unit, i)

            if data and data.lines then
                for _, line in ipairs(data.lines) do
                    if line.leftText then
                        local pvpLevel = WSA_Utilities:GetPVPItemLevelFromEffect(line.leftText, Effects.WSA_PVP_ITEM_LEVEL_SCALE)
                        if pvpLevel then
                            pvpItemLevelOverride = pvpLevel
                            break
                        end
                    end
                end
            end

            if itemLevel then
                itemCount = itemCount + 1
                if pvpItemLevelOverride and pvpItemLevelOverride >= itemLevel then
                    totalItemLevel = totalItemLevel + pvpItemLevelOverride
                else
                    totalItemLevel = totalItemLevel + itemLevel
                end
            end
        end
    end

    return itemCount > 0 and (totalItemLevel / itemCount) or 0
end

function WSA_PVPStats:GetPVPStats(unit)
    local cachedStats = WSA_Cache:GetCachedData(unit)
    if cachedStats then
        inspectLock = false
        WSA_AnimatedDots:StopLoadingDots()
        return cachedStats
    end

    if inspectLock then
        return nil
    end

    NotifyInspect(unit)
    WSA_AnimatedDots:StartLoadingDots()
    self.globals.pendingInspectUnit = unit

    return nil
end
