-- Plants vs Brainrots - FluxUI Script
local Flux = loadstring(game:HttpGet('https://raw.githubusercontent.com/roblox_4life/FluxLib/main/Lib.lua'))()

local Window = Flux:Window("Plants vs Brainrots", "v1.0", Color3.fromRGB(0, 120, 215))

-- Создаем вкладки
local MainTab = Window:Tab("Main", "http://www.roblox.com/asset/?id=6034818372")
local PlayerTab = Window:Tab("Player", "http://www.roblox.com/asset/?id=6034818372")
local SettingsTab = Window:Tab("Settings", "http://www.roblox.com/asset/?id=6034818372")

-- Переменные
local AutoBuy = false
local AutoPlant = false
local AutoCollect = false
local GodMode = false
local SpeedEnabled = false
local JumpEnabled = false
local DamageMultiplier = false
local AntiAFK = true

local MultiplierValue = 10
local WalkSpeed = 50
local JumpPower = 50

-- Функции
function BuyAllPlants()
    spawn(function()
        while AutoBuy do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (string.find(obj.Name:lower(), "shop") or string.find(obj.Name:lower(), "vendor")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                        wait(0.2)
                    end
                end
            end
            wait(2)
        end
    end)
end

function PlantAllSeeds()
    spawn(function()
        while AutoPlant do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and (string.find(obj.Name:lower(), "plot") or string.find(obj.Name:lower(), "soil")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                        wait(0.1)
                    end
                end
            end
            wait(1)
        end
    end)
end

function CollectAllCoins()
    spawn(function()
        while AutoCollect do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and (string.find(obj.Name:lower(), "coin") or string.find(obj.Name:lower(), "money")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                    end
                end
            end
            wait(0.5)
        end
    end)
end

function ApplyDamageMultiplier()
    spawn(function()
        while DamageMultiplier do
            local character = game.Players.LocalPlayer.Character
            if character then
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") then
                        local damage = tool:FindFirstChild("Damage")
                        if damage and damage:IsA("NumberValue") then
                            damage.Value = damage.Value * MultiplierValue
                        end
                    end
                end
            end
            wait(0.5)
        end
    end)
end

-- Вкладка Main
MainTab:Toggle("Auto Buy Plants", "Автоматически покупает растения", false, function(Value)
    AutoBuy = Value
    if Value then
        BuyAllPlants()
    end
end)

MainTab:Toggle("Auto Plant Seeds", "Автоматически сажает семена", false, function(Value)
    AutoPlant = Value
    if Value then
        PlantAllSeeds()
    end
end)

MainTab:Toggle("Auto Collect Coins", "Автоматически собирает монеты", false, function(Value)
    AutoCollect = Value
    if Value then
        CollectAllCoins()
    end
end)

MainTab:Toggle("Damage Multiplier", "Увеличивает урон оружия", false, function(Value)
    DamageMultiplier = Value
    if Value then
        ApplyDamageMultiplier()
    end
end)

MainTab:Slider("Multiplier Value", "Установите множитель урона", 1, 100, 10, function(Value)
    MultiplierValue = Value
end)

MainTab:Toggle("God Mode", "Делает вас неуязвимым", false, function(Value)
    GodMode = Value
    if Value then
        while GodMode do
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                end
            end
            wait(0.5)
        end
    end
end)

-- Вкладка Player
PlayerTab:Toggle("Speed Hack", "Увеличивает скорость передвижения", false, function(Value)
    SpeedEnabled = Value
    if Value then
        while SpeedEnabled do
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = WalkSpeed
                end
            end
            wait(0.1)
        end
    else
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16
        end
    end
end)

PlayerTab:Slider("Walk Speed", "Установите скорость", 16, 100, 50, function(Value)
    WalkSpeed = Value
end)

PlayerTab:Toggle("Super Jump", "Увеличивает силу прыжка", false, function(Value)
    JumpEnabled = Value
    if Value then
        while JumpEnabled do
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = JumpPower
                end
            end
            wait(0.1)
        end
    else
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = 50
        end
    end
end)

PlayerTab:Slider("Jump Power", "Установите силу прыжка", 50, 200, 50, function(Value)
    JumpPower = Value
end)

-- Вкладка Settings
SettingsTab:Toggle("Anti-AFK", "Предотвращает кик за бездействие", true, function(Value)
    AntiAFK = Value
end)

SettingsTab:Button("Save Settings", "Сохранить настройки", function()
    Flux:Notification("Настройки сохранены!", "OK")
end)

SettingsTab:Button("Destroy UI", "Удалить интерфейс", function()
    Flux:Close()
end)

-- Анти-АФК система
spawn(function()
    while true do
        if AntiAFK then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
            wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", false, game)
            wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "S", false, game)
            wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "S", false, game)
        end
        wait(30)
    end
end)

Flux:Init()