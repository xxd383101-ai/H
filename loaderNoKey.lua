-- Plants vs Brainrots Ultimate AFK Farm with Premium UI
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

-- Загрузка премиум UI библиотек
local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/shlexware/Orion/main/source")))()
local Venus = loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/sky-hub/main/venus.lua"))()
local Flux = loadstring(game:HttpGet('https://raw.githubusercontent.com/roblox_4life/FluxLib/main/Lib.lua'))()
local Celestial = loadstring(game:HttpGet("https://raw.githubusercontent.com/x4c0/Celestial/main/Library.lua"))()

-- Используем Orion UI (очень крутая и популярная)
local Window = OrionLib:MakeWindow({
    Name = "🌿 PLANTS vs BRAINROTS 🧠 | ULTIMATE HUB", 
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "PlantsVsBrainrotsConfig",
    IntroEnabled = true,
    IntroText = "ULTIMATE HUB"
})

-- Переменные
local AutoBuyEnabled = false
local AntiAFKEnabled = true
local ClubMultiplierEnabled = false
local AutoPlantEnabled = false
local AutoCollectEnabled = false
local AutoUpgradeEnabled = false
local GodModeEnabled = false
local SpeedHackEnabled = false
local JumpPowerEnabled = false
local NoClipEnabled = false

local CurrentMultiplier = 10
local SpeedValue = 50
local JumpValue = 50

-- Табы
local FarmTab = Window:MakeTab({
    Name = "🤖 Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local CombatTab = Window:MakeTab({
    Name = "⚔️ Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PlayerTab = Window:MakeTab({
    Name = "🎮 Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local VisualTab = Window:MakeTab({
    Name = "✨ Visual",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local SettingsTab = Window:MakeTab({
    Name = "⚙️ Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Функции
function AutoBuyPlants()
    spawn(function()
        while AutoBuyEnabled do
            -- Умный поиск магазинов
            local foundShop = false
            
            -- Поиск по известным местам
            local potentialShops = {
                "Shops", "VendingMachines", "Shop", "Store", "Market", "Vendor",
                "PlantShop", "SeedShop", "GardenShop"
            }
            
            for _, shopName in pairs(potentialShops) do
                local shop = workspace:FindFirstChild(shopName)
                if shop then
                    for _, item in pairs(shop:GetDescendants()) do
                        if item:IsA("ClickDetector") then
                            fireclickdetector(item)
                            foundShop = true
                            wait(0.2)
                        end
                    end
                end
            end
            
            -- Поиск по всем объектам
            if not foundShop then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and (string.find(string.lower(obj.Name), "shop") or 
                       string.find(string.lower(obj.Name), "vendor") or 
                       string.find(string.lower(obj.Name), "store") or
                       string.find(string.lower(obj.Name), "buy")) then
                        if obj:FindFirstChild("ClickDetector") then
                            fireclickdetector(obj.ClickDetector)
                            wait(0.2)
                        end
                    end
                end
            end
            
            -- GUI покупки
            local playerGui = Player:FindFirstChild("PlayerGui")
            if playerGui then
                for _, gui in pairs(playerGui:GetDescendants()) do
                    if gui:IsA("TextButton") and (string.find(string.lower(gui.Text), "buy") or 
                       string.find(string.lower(gui.Text), "purchase") or 
                       string.find(string.lower(gui.Text), "купить")) then
                        pcall(function()
                            gui:FireServer("Activated")
                        end)
                        wait(0.1)
                    end
                end
            end
            wait(1)
        end
    end)
end

function ApplyClubMultiplier()
    spawn(function()
        while ClubMultiplierEnabled do
            -- Умножение урона через инструменты
            local character = Player.Character
            if character then
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") then
                        -- Поиск значений урона
                        local damageValues = {
                            "Damage", "damage", "Attack", "attack", 
                            "Power", "power", "Strength", "strength"
                        }
                        
                        for _, damageName in pairs(damageValues) do
                            local damage = tool:FindFirstChild(damageName)
                            if damage and damage:IsA("NumberValue") then
                                damage.Value = damage.Value * CurrentMultiplier
                            end
                        end
                    end
                end
            end
            
            -- Перехват RemoteEvents
            pcall(function()
                local remotes = game:GetService("ReplicatedStorage"):GetDescendants()
                for _, remote in pairs(remotes) do
                    if remote:IsA("RemoteEvent") then
                        local remoteName = string.lower(remote.Name)
                        if string.find(remoteName, "damage") or 
                           string.find(remoteName, "hit") or 
                           string.find(remoteName, "attack") then
                           
                            local oldFire = remote.FireServer
                            remote.FireServer = function(self, ...)
                                local args = {...}
                                -- Умножаем числовые аргументы
                                for i, arg in pairs(args) do
                                    if type(arg) == "number" then
                                        args[i] = arg * CurrentMultiplier
                                    end
                                end
                                return oldFire(self, unpack(args))
                            end
                        end
                    end
                end
            end)
            wait(0.3)
        end
    end)
end

function AutoPlant()
    spawn(function()
        while AutoPlantEnabled do
            -- Поиск мест для посадки
            local plantingSpots = {
                "Garden", "PlantingSpots", "Plots", "Soil", "Farm",
                "GardenArea", "PlantArea", "FarmArea"
            }
            
            for _, spotName in pairs(plantingSpots) do
                local spot = workspace:FindFirstChild(spotName)
                if spot then
                    for _, plot in pairs(spot:GetDescendants()) do
                        if plot:IsA("Part") and plot:FindFirstChild("ClickDetector") then
                            fireclickdetector(plot.ClickDetector)
                            wait(0.1)
                        end
                    end
                end
            end
            
            -- Универсальный поиск
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and (string.find(string.lower(obj.Name), "plot") or 
                   string.find(string.lower(obj.Name), "soil") or 
                   string.find(string.lower(obj.Name), "garden") or
                   string.find(string.lower(obj.Name), "plant")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                        wait(0.1)
                    end
                end
            end
            wait(0.5)
        end
    end)
end

function AutoCollect()
    spawn(function()
        while AutoCollectEnabled do
            -- Сбор ресурсов
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") then
                    local objName = string.lower(obj.Name)
                    if string.find(objName, "coin") or 
                       string.find(objName, "money") or 
                       string.find(objName, "reward") or
                       string.find(objName, "collect") or
                       string.find(objName, "resource") then
                       
                        if obj:FindFirstChild("ClickDetector") then
                            fireclickdetector(obj.ClickDetector)
                        end
                    end
                end
            end
            wait(0.3)
        end
    end)
end

function ApplyGodMode()
    spawn(function()
        while GodModeEnabled do
            local character = Player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = 99999
                    humanoid.Health = 99999
                end
            end
            wait(0.5)
        end
    end)
end

function ApplySpeedHack()
    spawn(function()
        while SpeedHackEnabled do
            local character = Player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = SpeedValue
                end
            end
            wait(0.1)
        end
    end)
end

function ApplyJumpPower()
    spawn(function()
        while JumpPowerEnabled do
            local character = Player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = JumpValue
                end
            end
            wait(0.1)
        end
    end)
end

function EnableNoClip()
    spawn(function()
        while NoClipEnabled do
            local character = Player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
            wait(0.1)
        end
    end)
end

-- Farm Tab
FarmTab:AddToggle({
    Name = "🛒 Auto Buy Plants",
    Default = false,
    Callback = function(Value)
        AutoBuyEnabled = Value
        if Value then
            AutoBuyPlants()
            OrionLib:MakeNotification({
                Name = "Auto Buy Started!",
                Content = "Automatically buying plants...",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end    
})

FarmTab:AddToggle({
    Name = "🌱 Auto Plant",
    Default = false,
    Callback = function(Value)
        AutoPlantEnabled = Value
        if Value then
            AutoPlant()
        end
    end    
})

FarmTab:AddToggle({
    Name = "💰 Auto Collect Coins",
    Default = false,
    Callback = function(Value)
        AutoCollectEnabled = Value
        if Value then
            AutoCollect()
        end
    end    
})

FarmTab:AddToggle({
    Name = "🆙 Auto Upgrade Plants",
    Default = false,
    Callback = function(Value)
        AutoUpgradeEnabled = Value
    end    
})

-- Combat Tab
CombatTab:AddToggle({
    Name = "💥 Club Damage Multiplier",
    Default = false,
    Callback = function(Value)
        ClubMultiplierEnabled = Value
        if Value then
            ApplyClubMultiplier()
        end
    end    
})

CombatTab:AddSlider({
    Name = "Multiplier Value",
    Min = 1,
    Max = 100,
    Default = 10,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "x",
    Callback = function(Value)
        CurrentMultiplier = Value
    end    
})

CombatTab:AddToggle({
    Name = "🛡️ God Mode",
    Default = false,
    Callback = function(Value)
        GodModeEnabled = Value
        if Value then
            ApplyGodMode()
        end
    end    
})

-- Player Tab
PlayerTab:AddToggle({
    Name = "🚀 Speed Hack",
    Default = false,
    Callback = function(Value)
        SpeedHackEnabled = Value
        if Value then
            ApplySpeedHack()
        end
    end    
})

PlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "studs",
    Callback = function(Value)
        SpeedValue = Value
        if SpeedHackEnabled then
            ApplySpeedHack()
        end
    end    
})

PlayerTab:AddToggle({
    Name = "🦘 Super Jump",
    Default = false,
    Callback = function(Value)
        JumpPowerEnabled = Value
        if Value then
            ApplyJumpPower()
        end
    end    
})

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "power",
    Callback = function(Value)
        JumpValue = Value
        if JumpPowerEnabled then
            ApplyJumpPower()
        end
    end    
})

PlayerTab:AddToggle({
    Name = "👻 NoClip",
    Default = false,
    Callback = function(Value)
        NoClipEnabled = Value
        if Value then
            EnableNoClip()
        end
    end    
})

-- Visual Tab
VisualTab:AddButton({
    Name = "✨ Toggle UI",
    Callback = function()
        OrionLib:ToggleUI()
    end    
})

VisualTab:AddColorpicker({
    Name = "UI Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        Window:ChangeColor(Value)
    end    
})

-- Settings Tab
SettingsTab:AddToggle({
    Name = "🔄 Anti-AFK",
    Default = true,
    Callback = function(Value)
        AntiAFKEnabled = Value
    end    
})

SettingsTab:AddBind({
    Name = "Toggle Menu Keybind",
    Default = Enum.KeyCode.RightShift,
    Hold = false,
    Callback = function()
        OrionLib:ToggleUI()
    end    
})

SettingsTab:AddButton({
    Name = "💾 Save Configuration",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Configuration Saved!",
            Content = "Your settings have been saved.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end    
})

SettingsTab:AddButton({
    Name = "🔄 Refresh Game",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end    
})

-- Анти-АФК система
spawn(function()
    while true do
        if AntiAFKEnabled then
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                wait(0.1)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, game)
                wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
            end)
        end
        wait(20)
    end
end)

-- Инициализация
OrionLib:MakeNotification({
    Name = "🌿 Plants vs Brainrots Loaded!",
    Content = " modern TG ---> t.me/TurboModsHack ",
    Image = "rbxassetid://4483345998",
    Time = 5
})

OrionLib:Init()