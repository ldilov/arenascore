--- @class WSA_Math
---@field db WSA_DB
WSA_Math = {}

function WSA_Math:Initialize(db, globals)
    self.db = db
    self.globals = globals
end

-- Function to calculate a composite metric
function WSA_Math:CalculateMetric(stats, averageItemLevel)
    local ratingWeight = self.db:GetRatingWeight()
    local winLossWeight = self.db:GetWinLossWeight()
    local itemLevelWeight = self.db:GetItemLevelWeight()
    local maxRating = self.db:GetMaxRating()

    local highestRating = math.max(stats.twosRating or 0, stats.threesRating or 0, stats.soloRating or 0)
    local highestWinLossRatio = math.max(
        (stats.twosSeasonWon + 1) / (stats.twosSeasonPlayed + 1),
        (stats.threesSeasonWon + 1) / (stats.threesSeasonPlayed + 1),
        (stats.soloSeasonWon + 1) / (stats.soloSeasonPlayed + 1)
    )

    local compositeMetric = self.db:GetMinMetric()

    if highestRating >= maxRating then
        compositeMetric = self.db:GetMaxMetric()
    else
        -- Calculate item level score
        local maxMetric = self.db:GetMaxMetric()
        local minMetric = self.db:GetMinMetric()
        local maxItemLevel = self.db:GetMaxItemLevel()

        local ratingScore = (highestRating / maxRating) * maxMetric
        local itemLevelScore = (averageItemLevel / maxItemLevel) * maxMetric  -- Scale to max metric value
        local winLossScore = highestWinLossRatio * maxMetric

        -- Calculate the composite metric
        compositeMetric = (ratingWeight * ratingScore) +
                                (itemLevelWeight * itemLevelScore) +
                                (winLossWeight * winLossScore)

        -- Ensure the metric is within the desired range
        local numDelta = 0.5

        compositeMetric = math.max(minMetric, math.min(maxMetric, compositeMetric))
        compositeMetric = math.floor(compositeMetric + numDelta)
    end

    -- Determine color based on the metric value
    local color
    if compositeMetric <= 1000 then
        color = Colors.GREEN
    elseif compositeMetric <= 3000 then
        color = Colors.DARKGREEN
    else
        color = Colors.LIGHTPURPLE
    end

    return compositeMetric, color
end
