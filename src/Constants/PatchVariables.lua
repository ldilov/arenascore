-- PatchVariables.lua

-- Update current version below
PatchVariables = {
    currentVersion = 100207,
    cacheTimeOut = 300
}

local retail_100207 = {
    ratingWeight = 0.8,
    winLossWeight = 0.05,
    itemLevelWeight = 0.15,
    maxItemLevel = 528,
    maxMetric = 6000,
    minMetric = 0,
    maxRating = 3000,
    version = 100207
}

-- Add patch variables below
PatchVariables[100207] =  {
    profile = retail_100207
}