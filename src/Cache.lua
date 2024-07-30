local AceTimer = LibStub("AceTimer-3.0")
local AceEvent = LibStub("AceEvent-3.0")

--- @class WSA_Cache
--- @field inspectCache table<string, { stats: InspectArenaData, timestamp: number }>
--- @field cacheTimeout number
WSA_Cache = {
    inspectCache = {},
    cacheTimeout = PatchVariables.cacheTimeOut
}

WSA_Cache.__index = WSA_Cache

--- Initialize the cache, loading data from the database if available
--- @param db WSA_DB
function WSA_Cache:Initialize(db)
    self.db = db
    self.inspectCache = self.db:GetDB().global.inspectCache or {}
    self.cacheTimeout = self.db:GetDB().global.cacheTimeout or PatchVariables.cacheTimeOut
    -- Register event to save data to the database on logout or UI reload
    AceEvent:RegisterEvent("PLAYER_LOGOUT", function()
        self:SaveCache()
    end)
end

--- Save the current cache to the database
function WSA_Cache:SaveCache()
    self.db:GetDB().global.inspectCache = self.inspectCache
    self.db:GetDB().global.cacheTimeout = self.cacheTimeout
end

--- Function to get cached data
--- @param unit Unit
--- @return InspectArenaData
function WSA_Cache:GetCachedData(unit)
    local guid = UnitGUID(unit)
    local data = self.inspectCache[guid]
    if data and (GetTime() - data.timestamp) < self.cacheTimeout then
        return data.stats
    end
    return nil
end

--- Function to update cache
--- @param unit Unit
--- @param stats InspectArenaData
--- @return nil
function WSA_Cache:UpdateCache(unit, stats)
    local guid = UnitGUID(unit)
    self.inspectCache[guid] = {
        stats = stats,
        timestamp = GetTime()
    }

    -- Set a timer to clear the cache entry after the timeout period
    AceTimer:ScheduleTimer(function()
        self.inspectCache[guid] = nil
    end, self.cacheTimeout)
end

--- Function to clear all cache
--- @return nil
function WSA_Cache:ClearCache()
    self.inspectCache = {}
end

--- Function to check if the unit is cached
--- @param unit Unit
--- @return boolean, InspectArenaData
function WSA_Cache:IsUnitCached(unit)
    local guid = UnitGUID(unit)
    local data = self.inspectCache[guid]
    if data and (GetTime() - data.timestamp) < self.cacheTimeout then
        return true, data.stats
    end
    return false, nil
end