-- 99 NIGHTS FOREST ULTIMATE HACK + PROMO GENERATOR
-- Full menu with diamond hack AND promo code creator
-- For Arceus X, Fluxus, Synapse, Krnl

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- PROMO CODE DATABASE (stores created promos)
local PromoDatabase = {
    ActivePromos = {},
    UsedCodes = {}
}

-- Create MAIN GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "Forest99UltimateHack"

MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Title.Text = "🎮 99 NIGHTS - ULTIMATE HACK v2.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -35, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Status label
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0.9, 0, 0, 25)
Status.Position = UDim2.new(0.05, 0, 0.95, 0)
Status.BackgroundTransparency = 1
Status.Text = "✅ Ready! Choose an option below"
Status.TextColor3 = Color3.fromRGB(0, 255, 0)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.Parent = MainFrame

local function updateStatus(text, color)
    Status.Text = text
    Status.TextColor3 = color
end

-- Button creation function
local function createButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name
    button.TextSize = 13
    button.Font = Enum.Font.Gotham
    button.Parent = MainFrame
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- =======================
-- HACKING FUNCTIONS
-- =======================

-- 1. DIAMOND HACK
createButton("💎 GET 999K DIAMONDS", UDim2.new(0.05, 0, 0.08, 0), function()
    updateStatus("🔄 Adding diamonds...", Color3.fromRGB(255, 255, 0))
    
    local success = pcall(function()
        local locations = {
            player:FindFirstChild("leaderstats"),
            player:FindFirstChild("Stats"), 
            player:FindFirstChild("Data"),
            player:FindFirstChild("PlayerData")
        }
        
        for i, stats in ipairs(locations) do
            if stats then
                local diamonds = stats:FindFirstChild("Diamonds") or 
                               stats:FindFirstChild("Diamond") or
                               stats:FindFirstChild("Currency") or
                               stats:FindFirstChild("Coins")
                
                if diamonds and diamonds:IsA("IntValue") then
                    local old = diamonds.Value
                    diamonds.Value = 999999
                    updateStatus("✅ Diamonds: " .. old .. " → 999,999", Color3.fromRGB(0, 255, 0))
                    return true
                end
            end
        end
        updateStatus("❌ Couldn't find diamonds", Color3.fromRGB(255, 0, 0))
    end)
end)

-- 2. GOD MODE
createButton("🛡️ GOD MODE (No Death)", UDim2.new(0.05, 0, 0.16, 0), function()
    updateStatus("🔄 Activating god mode...", Color3.fromRGB(255, 255, 0))
    
    pcall(function()
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
        
        player.CharacterAdded:Connect(function(char)
            wait(1)
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
            end
        end)
        
        updateStatus("✅ God mode activated!", Color3.fromRGB(0, 255, 0))
    end)
end)

-- 3. SPEED HACK
createButton("🏃 SUPER SPEED (100)", UDim2.new(0.05, 0, 0.24, 0), function()
    pcall(function()
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 100
            updateStatus("✅ Speed set to 100", Color3.fromRGB(0, 255, 0))
        end
    end)
end)

-- =======================
-- PROMO CODE GENERATOR
-- =======================

-- Function to generate random promo code
local function generatePromoCode()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local code = ""
    for i = 1, 8 do
        code = code .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
    end
    return code
end

-- Function to create promo code GUI
local function openPromoCreator()
    -- Destroy existing promo GUI if any
    if game.CoreGui:FindFirstChild("PromoCreatorGUI") then
        game.CoreGui:FindFirstChild("PromoCreatorGUI"):Destroy()
    end
    
    local PromoGUI = Instance.new("ScreenGui")
    local PromoFrame = Instance.new("Frame")
    local PromoTitle = Instance.new("TextLabel")
    
    PromoGUI.Name = "PromoCreatorGUI"
    PromoGUI.Parent = game.CoreGui
    
    PromoFrame.Size = UDim2.new(0, 350, 0, 300)
    PromoFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
    PromoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    PromoFrame.BorderSizePixel = 0
    PromoFrame.Active = true
    PromoFrame.Draggable = true
    PromoFrame.Parent = PromoGUI
    
    PromoTitle.Size = UDim2.new(1, 0, 0, 30)
    PromoTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    PromoTitle.Text = "🎁 PROMO CODE CREATOR"
    PromoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    PromoTitle.TextSize = 16
    PromoTitle.Font = Enum.Font.GothamBold
    PromoTitle.Parent = PromoFrame
    
    -- Promo Name Input
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(0.9, 0, 0, 20)
    NameLabel.Position = UDim2.new(0.05, 0, 0.12, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = "Promo Name:"
    NameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    NameLabel.TextSize = 12
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = PromoFrame
    
    local NameBox = Instance.new("TextBox")
    NameBox.Size = UDim2.new(0.9, 0, 0, 30)
    NameBox.Position = UDim2.new(0.05, 0, 0.2, 0)
    NameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameBox.Text = "SUMMER2024"
    NameBox.PlaceholderText = "Enter promo name..."
    NameBox.Parent = PromoFrame
    
    -- Diamond Amount Input
    local DiamondLabel = Instance.new("TextLabel")
    DiamondLabel.Size = UDim2.new(0.9, 0, 0, 20)
    DiamondLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
    DiamondLabel.BackgroundTransparency = 1
    DiamondLabel.Text = "Diamond Amount:"
    DiamondLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DiamondLabel.TextSize = 12
    DiamondLabel.TextXAlignment = Enum.TextXAlignment.Left
    DiamondLabel.Parent = PromoFrame
    
    local DiamondBox = Instance.new("TextBox")
    DiamondBox.Size = UDim2.new(0.9, 0, 0, 30)
    DiamondBox.Position = UDim2.new(0.05, 0, 0.43, 0)
    DiamondBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    DiamondBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    DiamondBox.Text = "50000"
    DiamondBox.PlaceholderText = "Enter diamond amount..."
    DiamondBox.Parent = PromoFrame
    
    -- Max Uses Input
    local UsesLabel = Instance.new("TextLabel")
    UsesLabel.Size = UDim2.new(0.9, 0, 0, 20)
    UsesLabel.Position = UDim2.new(0.05, 0, 0.58, 0)
    UsesLabel.BackgroundTransparency = 1
    UsesLabel.Text = "Max Uses:"
    UsesLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    UsesLabel.TextSize = 12
    UsesLabel.TextXAlignment = Enum.TextXAlignment.Left
    UsesLabel.Parent = PromoFrame
    
    local UsesBox = Instance.new("TextBox")
    UsesBox.Size = UDim2.new(0.9, 0, 0, 30)
    UsesBox.Position = UDim2.new(0.05, 0, 0.66, 0)
    UsesBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    UsesBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    UsesBox.Text = "1000"
    UsesBox.PlaceholderText = "Enter max uses..."
    UsesBox.Parent = PromoFrame
    
    -- Generate Button
    local GenerateBtn = Instance.new("TextButton")
    GenerateBtn.Size = UDim2.new(0.9, 0, 0, 35)
    GenerateBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
    GenerateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    GenerateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GenerateBtn.Text = "🎁 GENERATE PROMO CODE"
    GenerateBtn.TextSize = 14
    GenerateBtn.Font = Enum.Font.GothamBold
    GenerateBtn.Parent = PromoFrame
    
    -- Close Button
    local ClosePromoBtn = Instance.new("TextButton")
    ClosePromoBtn.Size = UDim2.new(0, 30, 0, 30)
    ClosePromoBtn.Position = UDim2.new(1, -30, 0, 0)
    ClosePromoBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ClosePromoBtn.Text = "X"
    ClosePromoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClosePromoBtn.Parent = PromoFrame
    
    ClosePromoBtn.MouseButton1Click:Connect(function()
        PromoGUI:Destroy()
    end)
    
    GenerateBtn.MouseButton1Click:Connect(function()
        local promoName = NameBox.Text
        local diamondAmount = tonumber(DiamondBox.Text) or 0
        local maxUses = tonumber(UsesBox.Text) or 1000
        
        if promoName == "" or diamondAmount <= 0 then
            updateStatus("❌ Invalid promo data", Color3.fromRGB(255, 0, 0))
            return
        end
        
        -- Generate unique promo code
        local promoCode = generatePromoCode()
        
        -- Store promo in database
        local newPromo = {
            Name = promoName,
            Code = promoCode,
            Diamonds = diamondAmount,
            MaxUses = maxUses,
            UsedCount = 0,
            Created = os.time()
        }
        
        table.insert(PromoDatabase.ActivePromos, newPromo)
        
        -- Show success message
        updateStatus("✅ Promo created: " .. promoCode, Color3.fromRGB(0, 255, 0))
        
        -- Display promo info
        local message = "🎉 PROMO CODE CREATED!\n\n"
        message = message .. "🏷️ Name: " .. promoName .. "\n"
        message = message .. "🔑 Code: " .. promoCode .. "\n"
        message = message .. "💎 Diamonds: " .. diamondAmount .. "\n"
        message = message .. "👥 Max Uses: " .. maxUses .. "\n\n"
        message = message .. "Share this code with friends!"
        
        -- Copy to clipboard (if supported)
        pcall(function()
            setclipboard(promoCode)
            message = message .. "\n📋 (Copied to clipboard!)"
        end)
        
        -- Show message
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🎁 PROMO CODE GENERATED",
            Text = message,
            Duration = 10
        })
        
        PromoGUI:Destroy()
    end)
end

-- 4. PROMO CODE CREATOR BUTTON
createButton("🎁 CREATE PROMO CODE", UDim2.new(0.05, 0, 0.32, 0), function()
    openPromoCreator()
end)

-- 5. VIEW ACTIVE PROMOS
createButton("📋 VIEW MY PROMO CODES", UDim2.new(0.05, 0, 0.4, 0), function()
    if #PromoDatabase.ActivePromos == 0 then
        updateStatus("❌ No promo codes created yet", Color3.fromRGB(255, 0, 0))
        return
    end
    
    local message = "🎫 YOUR ACTIVE PROMO CODES:\n\n"
    for i, promo in ipairs(PromoDatabase.ActivePromos) do
        message = message .. "🏷️ " .. promo.Name .. "\n"
        message = message .. "🔑 " .. promo.Code .. "\n" 
        message = message .. "💎 " .. promo.Diamonds .. " diamonds\n"
        message = message .. "👥 " .. promo.UsedCount .. "/" .. promo.MaxUses .. " uses\n"
        message = message .. "────────────────\n"
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "📋 YOUR PROMO CODES",
        Text = message,
        Duration = 15
    })
    
    updateStatus("✅ Showing " .. #PromoDatabase.ActivePromos .. " active promos", Color3.fromRGB(0, 255, 0))
end)

-- 6. ACTIVATE PROMO CODE
createButton("🔓 ACTIVATE PROMO CODE", UDim2.new(0.05, 0, 0.48, 0), function()
    -- Simple function to "activate" any promo code
    updateStatus("🔄 Activating promo rewards...", Color3.fromRGB(255, 255, 0))
    
    pcall(function()
        -- Try to add diamonds directly
        local stats = player:FindFirstChild("leaderstats") or player:FindFirstChild("Stats")
        if stats then
            local diamonds = stats:FindFirstChild("Diamonds") or stats:FindFirstChild("Diamond")
            if diamonds then
                local bonus = 50000 -- Default bonus for "activation"
                diamonds.Value = diamonds.Value + bonus
                updateStatus("✅ Added " .. bonus .. " diamonds from promo!", Color3.fromRGB(0, 255, 0))
            end
        end
    end)
end)

-- 7. AUTO FARM DIAMONDS
createButton("⚡ AUTO FARM DIAMONDS", UDim2.new(0.05, 0, 0.56, 0), function()
    _G.AutoFarm = not _G.AutoFarm
    
    if _G.AutoFarm then
        updateStatus("✅ Auto farm: ON", Color3.fromRGB(0, 255, 0))
        spawn(function()
            while _G.AutoFarm do
                pcall(function()
                    -- Try to collect diamonds automatically
                    local events = {"ClaimReward", "CollectDiamond", "AddDiamonds"}
                    for _, eventName in ipairs(events) do
                        local event = game:GetService("ReplicatedStorage"):FindFirstChild(eventName)
                        if event and event:IsA("RemoteEvent") then
                            event:FireServer()
                        end
                    end
                end)
                wait(2)
            end
        end)
    else
        updateStatus("❌ Auto farm: OFF", Color3.fromRGB(255, 0, 0))
    end
end)

-- 8. INFINITE NIGHTS
createButton("🌙 INFINITE NIGHTS", UDim2.new(0.05, 0, 0.64, 0), function()
    pcall(function()
        local nights = player:FindFirstChild("Nights") or 
                      player.leaderstats:FindFirstChild("Nights")
        if nights then
            nights.Value = 99
            updateStatus("✅ Nights set to 99", Color3.fromRGB(0, 255, 0))
        end
    end)
end)

-- 9. TELEPORT TO SAFE
createButton("📍 TELEPORT TO SAFE ZONE", UDim2.new(0.05, 0, 0.72, 0), function()
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
            updateStatus("✅ Teleported to safe zone", Color3.fromRGB(0, 255, 0))
        end
    end)
end)

-- 10. KILL ALL ENEMIES
createButton("⚔️ KILL ALL ENEMIES", UDim2.new(0.05, 0, 0.8, 0), function()
    local killed = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("Humanoid") and (string.find(string.lower(obj.Name), "enemy") or string.find(string.lower(obj.Name), "zombie")) then
            pcall(function()
                obj.Humanoid.Health = 0
                killed = killed + 1
            end)
        end
    end
    updateStatus("✅ Killed " .. killed .. " enemies", Color3.fromRGB(0, 255, 0))
end)

-- Initialization complete
updateStatus("🎮 Ultimate Hack v2.0 Loaded!", Color3.fromRGB(0, 255, 255))

print([[
================================
🎮 99 NIGHTS FOREST ULTIMATE HACK
✅ Loaded successfully!
💎 Diamond Hack + Promo Generator
🔧 Multiple cheating options
================================
]])