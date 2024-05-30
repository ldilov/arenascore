-- Utilities.lua

--- @class WSA_Utilities
WSA_Utilities = {}

-- Function to extract the number that pvp items scale to in terms of item level
--- @param text string Particular line of the effect
--- @param effectStringPattern string Pattern to match in order to capture the required item level number
--- @return number
function WSA_Utilities:GetPVPItemLevelFromEffect(text, effectStringPattern)
    local pvpItemLevel = string.match(text, effectStringPattern)
    local result = nil

    if pvpItemLevel then
        result = tonumber(pvpItemLevel)
    end

    return result
end

-- Function to convert hex color to RGB
--- @param hex string Color as hex string
--- @return number, number, number
function WSA_Utilities.HexToRGB(hex)
    if not hex then return 1, 1, 1 end
    hex = hex:gsub("#", "")
    return tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255
end

-- Function to add a double line to the tooltip with colored text
--- @param tooltip Tooltip
--- @param leftText string
--- @param rightText string
--- @param leftColor string
--- @param rightColor string
function WSA_Utilities.AddColoredDoubleLine(tooltip, leftText, rightText, leftColor, rightColor)
    local lr, lg, lb = WSA_Utilities.HexToRGB(leftColor)
    local rr, rg, rb = WSA_Utilities.HexToRGB(rightColor)
    tooltip:AddDoubleLine(leftText, rightText, lr, lg, lb, rr, rg, rb)
end

-- Function to add a single line to the tooltip with colored text
--- @param tooltip Tooltip
--- @param text string
--- @param color string
function WSA_Utilities.AddColoredLine(tooltip, text, color)
    local r, g, b = WSA_Utilities.HexToRGB(color)
    tooltip:AddLine(text, r, g, b)
end