-- Plants vs Brainrots Ultimate AFK Farm Script
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

-- Загрузка супер крутых GUI библиотек
local success, Library = pcall(function()
    -- Попробовать Venus UI (очень стильная)
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/sky-hub/main/venus.lua"))()
end)

if not success then
    success, Library = pcall(function()
        -- Попробовать Orion UI (современная)
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
    end)
end

if not success then
    success, Library = pcall(function()
        -- Попробовать Flux UI (анимированная)
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/roblox_4life/FluxLib/main/Lib.lua"))()
    end)
end

if not success then
    success, Library = pcall(function()
        -- Попробовать Astral Library (космическая тема)
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/ImRayyGG/AstralLib/main/AstralLib.lua"))()
    end)
end

if not success then
    -- Fallback на обычный Kavo
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end

-- Создание ультра крутого меню
local Window = Library.CreateLib("🌿 PLANTS vs BRAINROTS 🧠", "DarkTheme")

-- Переменные
local AutoBuyEnabled = false
local AntiAFKEnabled = true
local ClubMultiplierEnabled = false
local AutoPlantEnabled = false
local AutoCollectEnabled = false
local AutoUpgradeEnabled = false
local GodModeEnabled = false
local InfiniteMoneyEnabled = false
local SpeedHackEnabled = false
local JumpPowerEnabled = false

local CurrentMultiplier = 10
local SpeedValue = 50
local JumpValue = 50

-- Анимации
function CreateParticleEffect(frame)
    local particles = Instance.new("Frame")
    particles.Size = UDim2.new(1, 0, 1, 0)
    particles.BackgroundTransparency = 1
    particles.Parent = frame
    
    for i = 1, 5 do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, 2, 0, 2)
        particle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        particle.BorderSizePixel = 0
        particle.Parent = particles
        
        local tween = TweenService:Create(
            particle,
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(math.random(), 0, math.random(), 0), BackgroundTransparency = 1}
        )
        tween:Play()
    end
end

-- Главная вкладка
local MainTab = Window:NewTab("🏠 Главная")
local AutoFarmSection = MainTab:NewSection("🤖 Авто Фарм")
local CombatSection = MainTab:NewSection("⚔️ Боевые функции")

-- Вкладка улучшений
local UpgradeTab = Window:NewTab("📈 Улучшения")
local MultiplierSection = UpgradeTab:NewSection("🎯 Множители")
local StatsSection = UpgradeTab:NewSection("📊 Статистика")

-- Вкладка визуала
local VisualTab = Window:NewTab("🎨 Визуал")
local EffectsSection = VisualTab:NewSection("✨ Эффекты")
local ThemeSection = VisualTab:NewSection("🎭 Темы")

-- Вкладка настроек
local SettingsTab = Window:NewTab("⚙️ Настройки")
local ConfigSection = SettingsTab:NewSection("🔧 Конфигурация")
local KeybindSection = SettingsTab:NewSection("⌨️ Горячие клавиши")

-- Функции
function AutoBuyPlants()
    spawn(function()
        while AutoBuyEnabled do
            -- Поиск магазинов растений
            local shops = workspace:FindFirstChild("Shops") 
            if not shops then
                shops = workspace:FindFirstChild("VendingMachines")
            end
            if not shops then
                -- Поиск по всем объектам
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and (string.find(string.lower(obj.Name), "shop") or string.find(string.lower(obj.Name), "vendor") or string.find(string.lower(obj.Name), "store")) then
                        if obj:FindFirstChild("ClickDetector") then
                            fireclickdetector(obj.ClickDetector)
                            wait(0.3)
                        end
                    end
                end
            else
                for _, shop in pairs(shops:GetChildren()) do
                    if shop:FindFirstChild("ClickDetector") then
                        fireclickdetector(shop.ClickDetector)
                        wait(0.3)
                    end
                end
            end
            
            -- Поиск кнопок покупки в GUI
            local playerGui = Player:FindFirstChild("PlayerGui")
            if playerGui then
                for _, gui in pairs(playerGui:GetDescendants()) do
                    if gui:IsA("TextButton") and (string.find(string.lower(gui.Text), "buy") or string.find(string.lower(gui.Text), "purchase") or string.find(string.lower(gui.Text), "купить")) then
                        pcall(function()
                            gui:FireServer("Activated")
                        end)
                        wait(0.2)
                    end
                end
            end
            wait(2)
        end
    end)
end

function ApplyClubMultiplier()
    spawn(function()
        while ClubMultiplierEnabled do
            -- Умножение урона дубинки
            local character = Player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Метод 1: Изменение инструментов
                    for _, tool in pairs(character:GetChildren()) do
                        if tool:IsA("Tool") then
                            local damage = tool:FindFirstChild("Damage")
                            if damage and damage:IsA("NumberValue") then
                                damage.Value = damage.Value * CurrentMultiplier
                            end
                        end
                    end
                    
                    -- Метод 2: Глобальный множитель
                    humanoid:SetAttribute("DamageMultiplier", CurrentMultiplier)
                end
            end
            
            -- Метод 3: Перехват ударов
            local replicatedStorage = game:GetService("ReplicatedStorage")
            if replicatedStorage then
                for _, remote in pairs(replicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") and (string.find(string.lower(remote.Name), "damage") or string.find(string.lower(remote.Name), "hit") or string.find(string.lower(remote.Name), "attack")) then
                        pcall(function()
                            local oldFire = remote.FireServer
                            remote.FireServer = function(self, ...)
                                local args = {...}
                                for i, arg in pairs(args) do
                                    if type(arg) == "number" then
                                        args[i] = arg * CurrentMultiplier
                                    end
                                end
                                return oldFire(self, unpack(args))
                            end
                        end)
                    end
                end
            end
            wait(0.5)
        end
    end)
end

function AutoPlant()
    spawn(function()
        while AutoPlantEnabled do
            -- Автоматическая посадка растений
            local garden = workspace:FindFirstChild("Garden")
            if not garden then
                garden = workspace:FindFirstChild("PlantingSpots")
            end
            if not garden then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") and (string.find(string.lower(obj.Name), "plot") or string.find(string.lower(obj.Name), "soil") or string.find(string.lower(obj.Name), "garden")) then
                        if obj:FindFirstChild("ClickDetector") then
                            fireclickdetector(obj.ClickDetector)
                            wait(0.2)
                        end
                    end
                end
            else
                for _, plot in pairs(garden:GetChildren()) do
                    if plot:FindFirstChild("ClickDetector") then
                        fireclickdetector(plot.ClickDetector)
                        wait(0.2)
                    end
                end
            end
            wait(1)
        end
    end)
end

function AutoCollect()
    spawn(function()
        while AutoCollectEnabled do
            -- Сбор монет и ресурсов
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and (string.find(string.lower(obj.Name), "coin") or string.find(string.lower(obj.Name), "money") or string.find(string.lower(obj.Name), "reward")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                    end
                end
            end
            wait(0.5)
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
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                end
            end
            wait(1)
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

-- Элементы интерфейса

-- Авто Фарм секция
AutoFarmSection:NewToggle("🛒 Авто Покупка Растений", "Автоматически покупает все растения", function(state)
    AutoBuyEnabled = state
    if state then
        AutoBuyPlants()
        CreateParticleEffect(AutoFarmSection)
    end
end)

AutoFarmSection:NewToggle("🌱 Авто Посадка", "Автоматически сажает растения", function(state)
    AutoPlantEnabled = state
    if state then
        AutoPlant()
    end
end)

AutoFarmSection:NewToggle("💰 Авто Сбор Монет", "Автоматически собирает монеты", function(state)
    AutoCollectEnabled = state
    if state then
        AutoCollect()
    end
end)

AutoFarmSection:NewToggle("🆙 Авто Улучшение", "Автоматически улучшает растения", function(state)
    AutoUpgradeEnabled = state
end)

-- Боевые функции
CombatSection:NewToggle("🛡️ Режим Бога", "Неуязвимость к урону", function(state)
    GodModeEnabled = state
    if state then
        ApplyGodMode()
    end
end)

CombatSection:NewToggle("💥 Множитель Дубинки", "Увеличивает урон оружия", function(state)
    ClubMultiplierEnabled = state
    if state then
        ApplyClubMultiplier()
    end
end)

-- Множители
MultiplierSection:NewSlider("Множитель Урона", "Настройка силы множителя", 100, 1, function(value)
    CurrentMultiplier = value
end)

MultiplierSection:NewSlider("Скорость Персонажа", "Настройка скорости передвижения", 100, 16, function(value)
    SpeedValue = value
    if SpeedHackEnabled then
        ApplySpeedHack()
    end
end)

MultiplierSection:NewSlider("Сила Прыжка", "Настройка высоты прыжка", 100, 50, function(value)
    JumpValue = value
    if JumpPowerEnabled then
        ApplyJumpPower()
    end
end)

MultiplierSection:NewToggle("Включить Супер Скорость", "Активировать увеличение скорости", function(state)
    SpeedHackEnabled = state
    if state then
        ApplySpeedHack()
    end
end)

MultiplierSection:NewToggle("Включить Супер Прыжок", "Активировать увеличение прыжка", function(state)
    JumpPowerEnabled = state
    if state then
        ApplyJumpPower()
    end
end)

-- Эффекты
EffectsSection:NewButton("✨ Запустить Эффекты", "Активировать визуальные эффекты", function()
    CreateParticleEffect(EffectsSection)
end)

EffectsSection:NewToggle("🌈 Радужный Режим", "Цветные эффекты", function(state)
    -- Реализация радужного режима
end)

-- Горячие клавиши
KeybindSection:NewKeybind("Открыть/Закрыть Меню", "Основная клавиша меню", Enum.KeyCode.RightShift, function()
	Library:ToggleUI()
end)

KeybindSection:NewKeybind("Быстрая Покупка", "Быстро купить растения", Enum.KeyCode.P, function()
    AutoBuyPlants()
end)

KeybindSection:NewKeybind("Собрать Монеты", "Быстрый сбор монет", Enum.KeyCode.C, function()
    AutoCollect()
end)

-- Анти-АФК система
spawn(function()
    while true do
        if AntiAFKEnabled then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
        end
        wait(25)
    end
end)

-- Уведомление о загрузке
spawn(function()
    wait(1)
    if Library then
        print("🎮 Супер меню загружено!")
        print("🌿 Plants vs Brainrots Ultimate AFK Farm")
        print("⚡ Версия: 2.0 | Стиль: ULTRA PRO MAX")
    end
end)

-- Авто-реконнект
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == Player then
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end
end)































