local AceDB = LibStub("AceDB-3.0")

---@class WSA_DB
---@field db AceDBObject-3.0
WSA_DB = {}
WSA_DB.__index = WSA_DB

local currentVersion = PatchVariables.currentVersion

function WSA_DB:New()
    local self = setmetatable({}, WSA_DB)
    local defaults = PatchVariables[currentVersion] or {}

    defaults["global"] =  {
        inspectCache = {},
        cacheTimeout = PatchVariables.cacheTimeOut
    }
    
    self.db = AceDB:New("WoWArenaScoreDB", defaults, true)
    local _, _, _, tocVersion = GetBuildInfo()
    if not self.db.profile.version or self.db.profile.version < currentVersion or self.db.profile.tocVersion ~= tocVersion then
        self.db:ResetDB("Default")
        self.db.profile.version = currentVersion
    end

    return self
end

function WSA_DB:GetDB()
    return self.db
end

function WSA_DB:GetRatingWeight()
    return self.db.profile.ratingWeight
end

function WSA_DB:GetWinLossWeight()
    return self.db.profile.winLossWeight
end

function WSA_DB:GetItemLevelWeight()
    return self.db.profile.itemLevelWeight
end

function WSA_DB:GetMaxItemLevel()
    return self.db.profile.maxItemLevel
end

function WSA_DB:GetMaxMetric()
    return self.db.profile.maxMetric
end

function WSA_DB:GetMinMetric()
    return self.db.profile.minMetric
end

function WSA_DB:GetMaxRating()
    return self.db.profile.maxRating
end
