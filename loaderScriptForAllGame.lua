
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function createUI()
    local screenGui = Instance.new("ScreenGui")
    local textLabel = Instance.new("TextLabel")
    
    textLabel.Text = "Это пример легального UI"
    textLabel.Size = UDim2.new(0, 200, 0, 50)
    textLabel.Parent = screenGui
    screenGui.Parent = player.PlayerGui
end

createUI()