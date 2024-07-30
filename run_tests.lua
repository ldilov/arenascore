-- test_cache.lua
local luaunit = require('luaunit')
package.path = package.path .. ";./src/?.lua;./tests/?.lua;C:/Users/lazar/Lua/lua/?.lua"

dofile('lib/LibStub/LibStub.lua')
dofile('lib/AceDB-3.0/AceDB-3.0.lua')
dofile('lib/AceDBOptions-3.0/AceDBOptions-3.0.lua')
dofile('lib/AceTimer-3.0/AceTimer-3.0.lua')
dofile('lib/AceEvent-3.0/AceEvent-3.0.lua')
dofile('lib/AceEvent-3.0/AceEvent-3.0.lua')


print(_G.LibStub )
_G.PatchVariables = { cacheTimeOut = 10 }

local WSA_Cache = require('src.Cache')

TestWSA_Cache = {}

function TestWSA_Cache:setUp()
    WSA_Cache:ClearCache()
end

function TestWSA_Cache:testStoreAndRetrieveCachedData()
    local unit = "testunit"
    local stats = { rating = 2000, winLossRatio = 1.5, itemLevel = 500 }

    WSA_C_cache:UpdateCache(unit, stats)
    local cachedStats = WSA_C_cache:GetCachedData(unit)

    luaunit.assertNotNil(cachedStats)
    luaunit.assertEquals(cachedStats, stats)
end

function TestWSA_Cache:testClearCacheAfterTimeout()
    local unit = "testunit"
    local stats = { rating = 2000, winLossRatio = 1.5, itemLevel = 500 }

    WSA_Cache:UpdateCache(unit, stats)
    os.execute("sleep " .. tonumber(_G.PatchVariables.cacheTimeOut + 1))
    local cachedStats = WSA_Cache:GetCachedData(unit)
    luaunit.assertNil(cachedStats)
end

function TestWSA_Cache:testNotRetrieveExpiredCachedData()
    local unit = "testunit"
    local stats = { rating = 2000, winLossRatio = 1.5, itemLevel = 500 }

    WSA_Cache:UpdateCache(unit, stats)
    os.execute("sleep " .. tonumber(_G.PatchVariables.cacheTimeOut + 1))
    local cachedStats = WSA_Cache:GetCachedData(unit)
    luaunit.assertNil(cachedStats)
end

os.exit(luaunit.LuaUnit.run())
