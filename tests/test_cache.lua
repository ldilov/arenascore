-- test_cache.lua
local busted = require('busted')
local WSA_Cache = require('src.Cache')
local PatchVariables = { cacheTimeOut = 10 }
_G.PatchVariables = PatchVariables

describe("WSA_Cache", function()

    before_each(function()
        WSA_Cache:ClearCache()
    end)

    it("should store and retrieve cached data", function()
        local unit = "testunit"
        local stats = { rating = 2000, winLossRatio = 1.5, itemLevel = 500 }

        WSA_Cache:UpdateCache(unit, stats)
        local cachedStats = WSA_Cache:GetCachedData(unit)

        assert.is_not_nil(cachedStats)
        assert.are.same(stats, cachedStats)
    end)

    it("should clear cache after timeout", function()
        local unit = "testunit"
        local stats = { rating = 2000, winLossRatio = 1.5, itemLevel = 500 }

        WSA_Cache:UpdateCache(unit, stats)
        busted.async.it("should wait for cache timeout", function(done)
            busted.setTimeout(function()
                local cachedStats = WSA_Cache:GetCachedData(unit)
                assert.is_nil(cachedStats)
                done()
            end, PatchVariables.cacheTimeOut * 1000 + 1000) -- Waiting for cache timeout plus an extra second
        end)
    end)

    it("should not retrieve expired cached data", function()
        local unit = "testunit"
        local stats = { rating = 2000, winLossRatio = 1.5, itemLevel = 500 }

        WSA_Cache:UpdateCache(unit, stats)
        busted.async.it("should wait for cache to expire", function(done)
            busted.setTimeout(function()
                local cachedStats = WSA_Cache:GetCachedData(unit)
                assert.is_nil(cachedStats)
                done()
            end, PatchVariables.cacheTimeOut * 1000 + 1000)
        end)
    end)
end)