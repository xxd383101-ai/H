-- BRAINROT ULTIMATE TROLL MENU v5.0
-- Secret Menu + Player Control + Special Effects
-- For Arceus X, Fluxus, Synapse, Krnl

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- Wait for game to load
if not player or not player.Character then
    player.CharacterAdded:Wait()
end
wait(2)

-- =======================
-- SECRET VARIABLES
-- =======================
local SecretMenuEnabled = false
local SelectedPlayer = nil
local BlackScreenEnabled = false
local OriginalLighting = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd
}

-- =======================
-- SECRET OPEN FUNCTION
-- =======================
local function createSecretOpenButton()
    local SecretButton = Instance.new("TextButton")
    SecretButton.Size = UDim2.new(0, 50, 0, 50)
    SecretButton.Position = UDim2.new(0, 10, 0, 10)
    SecretButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    SecretButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SecretButton.Text = "🎮"
    SecretButton.TextSize = 20
    SecretButton.ZIndex = 100
    SecretButton.Parent = game.CoreGui
    
    SecretButton.MouseButton1Click:Connect(function()
        if not SecretMenuEnabled then
            createMainMenu()
            SecretMenuEnabled = true
        else
            -- Destroy existing menu
            if game.CoreGui:FindFirstChild("BrainrotMenu") then
                game.CoreGui:FindFirstChild("BrainrotMenu"):Destroy()
            end
            SecretMenuEnabled = false
        end
    end)
    
    -- Make it draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    SecretButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = SecretButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    SecretButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            SecretButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- =======================
-- TROLL FUNCTIONS
-- =======================
local function freezePlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end
    end
end

local function unfreezePlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
end

local function kickPlayer(targetPlayer)
    pcall(function()
        game:GetService("ReplicatedStorage"):FindFirstChild("Admin"):FireServer("kick", targetPlayer.Name)
    end)
end

local function blackScreenForOthers()
    BlackScreenEnabled = not BlackScreenEnabled
    
    if BlackScreenEnabled then
        -- Black screen for others
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.Brightness = 0
        Lighting.FogEnd = 0
        Lighting.ClockTime = 0
        
        -- Create black screen for all players except me
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                pcall(function()
                    local blackGui = Instance.new("ScreenGui")
                    blackGui.Name = "BlackScreen"
                    local blackFrame = Instance.new("Frame")
                    blackFrame.Size = UDim2.new(1, 0, 1, 0)
                    blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
                    blackFrame.BorderSizePixel = 0
                    blackFrame.Parent = blackGui
                    blackGui.Parent = otherPlayer.PlayerGui
                end)
            end
        end
    else
        -- Restore lighting
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.ClockTime = 12
        
        -- Remove black screens
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                pcall(function()
                    if otherPlayer.PlayerGui:FindFirstChild("BlackScreen") then
                        otherPlayer.PlayerGui:FindFirstChild("BlackScreen"):Destroy()
                    end
                end)
            end
        end
    end
end

local function spinPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            spawn(function()
                for i = 1, 100 do
                    pcall(function()
                        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(45), 0)
                    end)
                    wait(0.05)
                end
            end)
        end
    end
end

local function teleportPlayerToSky(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame + Vector3.new(0, 500, 0)
        end
    end
end

local function createUFO(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local ufo = Instance.new("Part")
            ufo.Name = "UFO"
            ufo.Size = Vector3.new(10, 2, 10)
            ufo.Shape = Enum.PartType.Cylinder
            ufo.Material = Enum.Material.Neon
            ufo.BrickColor = BrickColor.new("Bright blue")
            ufo.CFrame = root.CFrame + Vector3.new(0, 20, 0)
            ufo.Anchored = true
            ufo.CanCollide = false
            ufo.Parent = workspace
            
            local weld = Instance.new("Weld")
            weld.Part0 = ufo
            weld.Part1 = root
            weld.C0 = CFrame.new(0, 20, 0)
            weld.Parent = ufo
            
            -- Lights
            local light = Instance.new("PointLight")
            light.Brightness = 10
            light.Range = 20
            light.Color = Color3.new(0, 1, 1)
            light.Parent = ufo
        end
    end
end

local function earthquakeEffect()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local root = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                spawn(function()
                    for i = 1, 50 do
                        pcall(function()
                            root.CFrame = root.CFrame + Vector3.new(
                                math.random(-5, 5),
                                0,
                                math.random(-5, 5)
                            )
                        end)
                        wait(0.1)
                    end
                end)
            end
        end
    end
end

local function invisibleMode()
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    end
end

local function visibleMode()
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
end

-- =======================
-- MAIN MENU CREATION
-- =======================
local function createMainMenu()
    if game.CoreGui:FindFirstChild("BrainrotMenu") then
        game.CoreGui:FindFirstChild("BrainrotMenu"):Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")

    ScreenGui.Name = "BrainrotMenu"
    ScreenGui.Parent = game.CoreGui

    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    Title.Text = "🧠 BRAINROT TROLL MENU v5.0"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0.9, 0, 0, 25)
    Status.Position = UDim2.new(0.05, 0, 0.92, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "✅ Ready! Selected: None"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    Status.TextSize = 12
    Status.Font = Enum.Font.Gotham
    Status.Parent = MainFrame

    local function updateStatus(text, color)
        Status.Text = text
        Status.TextColor3 = color
    end

    local function createButton(name, position, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.9, 0, 0, 35)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Text = name
        button.TextSize = 13
        button.Font = Enum.Font.Gotham
        button.Parent = MainFrame
        
        button.MouseButton1Click:Connect(callback)
        return button
    end

    -- Player Selection Dropdown
    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Size = UDim2.new(0.9, 0, 0, 20)
    PlayerLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Text = "Select Player:"
    PlayerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerLabel.TextSize = 12
    PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerLabel.Parent = MainFrame

    local PlayerDropdown = Instance.new("TextButton")
    PlayerDropdown.Size = UDim2.new(0.9, 0, 0, 30)
    PlayerDropdown.Position = UDim2.new(0.05, 0, 0.15, 0)
    PlayerDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    PlayerDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerDropdown.Text = "Click to select player"
    PlayerDropdown.TextSize = 12
    PlayerDropdown.Parent = MainFrame

    PlayerDropdown.MouseButton1Click:Connect(function()
        local playersList = ""
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                playersList = playersList .. plr.Name .. "\n"
            end
        end
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "👥 PLAYERS LIST",
            Text = playersList,
            Duration = 10
        })
        
        -- Simple selection
        local input = game:GetService("VirtualInputManager")
        -- This would normally open a proper dropdown, but we'll use notifications
    end)

    -- Function to set selected player
    local function setSelectedPlayer(plrName)
        SelectedPlayer = Players:FindFirstChild(plrName)
        if SelectedPlayer then
            PlayerDropdown.Text = "Selected: " .. plrName
            updateStatus("✅ Selected: " .. plrName, Color3.fromRGB(0, 255, 0))
        end
    end

    -- Quick select buttons for random players
    createButton("🎯 SELECT RANDOM PLAYER", UDim2.new(0.05, 0, 0.22, 0), function()
        local otherPlayers = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                table.insert(otherPlayers, plr)
            end
        end
        
        if #otherPlayers > 0 then
            local randomPlayer = otherPlayers[math.random(1, #otherPlayers)]
            setSelectedPlayer(randomPlayer.Name)
        else
            updateStatus("❌ No other players found", Color3.fromRGB(255, 0, 0))
        end
    end)

    -- =======================
    -- TROLL BUTTONS
    -- =======================

    -- 1. FREEZE PLAYER
    createButton("❄️ FREEZE PLAYER", UDim2.new(0.05, 0, 0.3, 0), function()
        if SelectedPlayer then
            freezePlayer(SelectedPlayer)
            updateStatus("❄️ Frozen: " .. SelectedPlayer.Name, Color3.fromRGB(0, 255, 255))
        else
            updateStatus("❌ Select a player first!", Color3.fromRGB(255, 0, 0))
        end
    end)

    -- 2. UNFREEZE PLAYER
    createButton("🔥 UNFREEZE PLAYER", UDim2.new(0.05, 0, 0.38, 0), function()
        if SelectedPlayer then
            unfreezePlayer(SelectedPlayer)
            updateStatus("🔥 Unfrozen: " .. SelectedPlayer.Name, Color3.fromRGB(0, 255, 255))
        else
            updateStatus("❌ Select a player first!", Color3.fromRGB(255, 0, 0))
        end
    end)

    -- 3. SPIN PLAYER
    createButton("🌀 SPIN PLAYER", UDim2.new(0.05, 0, 0.46, 0), function()
        if SelectedPlayer then
            spinPlayer(SelectedPlayer)
            updateStatus("🌀 Spinning: " .. SelectedPlayer.Name, Color3.fromRGB(255, 165, 0))
        else
            updateStatus("❌ Select a player first!", Color3.fromRGB(255, 0, 0))
        end
    end)

    -- 4. UFO ABDUCTION
    createButton("👽 UFO ABDUCTION", UDim2.new(0.05, 0, 0.54, 0), function()
        if SelectedPlayer then
            createUFO(SelectedPlayer)
            updateStatus("👽 UFO on: " .. SelectedPlayer.Name, Color3.fromRGB(0, 255, 0))
        else
            updateStatus("❌ Select a player first!", Color3.fromRGB(255, 0, 0))
        end
    end)

    -- 5. TELEPORT TO SKY
    createButton("☁️ TELEPORT TO SKY", UDim2.new(0.05, 0, 0.62, 0), function()
        if SelectedPlayer then
            teleportPlayerToSky(SelectedPlayer)
            updateStatus("☁️ Teleported to sky: " .. SelectedPlayer.Name, Color3.fromRGB(0, 255, 255))
        else
            updateStatus("❌ Select a player first!", Color3.fromRGB(255, 0, 0))
        end
    end)

    -- 6. BLACK SCREEN FOR OTHERS
    createButton("🌑 BLACK SCREEN (OTHERS)", UDim2.new(0.05, 0, 0.7, 0), function()
        blackScreenForOthers()
        if BlackScreenEnabled then
            updateStatus("🌑 BLACK SCREEN: ON for others", Color3.fromRGB(255, 0, 0))
        else
            updateStatus("✅ BLACK SCREEN: OFF", Color3.fromRGB(0, 255, 0))
        end
    end)

    -- 7. EARTHQUAKE EFFECT
    createButton("🌋 EARTHQUAKE (ALL)", UDim2.new(0.05, 0, 0.78, 0), function()
        earthquakeEffect()
        updateStatus("🌋 EARTHQUAKE ACTIVATED!", Color3.fromRGB(255, 165, 0))
    end)

    -- 8. INVISIBLE MODE
    createButton("👻 INVISIBLE MODE", UDim2.new(0.05, 0, 0.86, 0), function()
        invisibleMode()
        updateStatus("👻 INVISIBLE: ON", Color3.fromRGB(0, 255, 255))
    end)

    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Parent = MainFrame

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        SecretMenuEnabled = false
    end)

    updateStatus("🧠 BRAINROT MENU LOADED!", Color3.fromRGB(0, 255, 255))
end

-- =======================
-- INITIALIZATION
-- =======================
createSecretOpenButton()

print([[
==========================================
🧠 BRAINROT TROLL MENU v5.0
✅ SUCCESSFULLY INJECTED!
🎮 Secret open button created (top-left)
👥 Player control functions
🌑 Black screen for others
🌀 Troll effects and more!
==========================================
]])

-- Auto-select first other player
spawn(function()
    wait(3)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            SelectedPlayer = plr
            break
        end
    end
end)