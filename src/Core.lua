-- Core.lua
--- @class WSA_Core
--- @field db WSA_DB
WSA_Core = {
    db = nil
}

GLOBAL_CONTEXT = {
    pendingInspectUnit = nil
}

--- Required to be called in order to initialize global context and dependencies
--- @return nil
function WSA_Core:InitializeDependencies()
    self.db = WSA_DB:New()

    WSA_PVPStats:Initialize(self.db, GLOBAL_CONTEXT)
    WSA_Tooltip:Initialize(self.db, GLOBAL_CONTEXT)
    WSA_Math:Initialize(self.db, GLOBAL_CONTEXT)
end

--- Checks if there is already fired inspect request for any unit that hasn't completed yet
--- @return boolean
function WSA_Core:IsInspectRequestPending()
    return not(GLOBAL_CONTEXT.pendingInspectUnit == nil);
end

--- Checks if there is already a fired inspect request for a particular unit that hasn't completed yet
--- @param guid string GUID of the particular unit
--- @return boolean
function WSA_Core:IsUnitInspectRequestPending(guid)
    return GLOBAL_CONTEXT.pendingInspectUnit ~= nil and guid == UnitGUID(GLOBAL_CONTEXT.pendingInspectUnit) ;
end

--- Resets global context field setting it to default value (nil) by provided field name
--- @param name string Name of the field in GLOBAL_CONTEXT object
--- @return nil
function WSA_Core:ResetGlobalContextField(name)
    if GLOBAL_CONTEXT[name] ~= nil then
        GLOBAL_CONTEXT[name] = nil
    end
end