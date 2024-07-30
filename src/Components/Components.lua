-- Components.lua
WSA_Components = {}

function WSA_Components:Initialize(globals)
    self.globals = globals
    self.components = {
        AnimatedDots = WSA_AnimatedDots:Initialize(globals)
    }
end