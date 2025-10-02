-- Plants vs Brainrots AFK Farm Script
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Загрузка библиотеки Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Создание окна
local Window = Rayfield:CreateWindow({
   Name = "🌿 PLANTS vs BRAINROTS | ULTIMATE HUB",
   LoadingTitle = "Plants vs Brainrots Hub",
   LoadingSubtitle = "Загрузка...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PlantsVsBrainrots",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

-- Переменные
local AutoBuyEnabled = false
local AntiAFKEnabled = true
local ClubMultiplierEnabled = false
local AutoPlantEnabled = false
local AutoCollectEnabled = false
local GodModeEnabled = false
local SpeedHackEnabled = false
local JumpPowerEnabled = false

local CurrentMultiplier = 10
local SpeedValue = 50
local JumpValue = 50

-- Создание вкладок
local MainTab = Window:CreateTab("Главная", nil)
local FarmSection = MainTab:CreateSection("Авто Фарм")
local CombatSection = MainTab:CreateSection("Боевые функции")

local PlayerTab = Window:CreateTab("Игрок", nil)
local MovementSection = PlayerTab:CreateSection("Передвижение")
local CharacterSection = PlayerTab:CreateSection("Персонаж")

local MiscTab = Window:CreateTab("Настройки", nil)
local SettingsSection = MiscTab:CreateSection("Конфигурация")

-- Функции
function AutoBuyPlants()
    spawn(function()
        while AutoBuyEnabled do
            -- Поиск магазинов
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (string.find(string.lower(obj.Name), "shop") or 
                   string.find(string.lower(obj.Name), "vendor") or 
                   string.find(string.lower(obj.Name), "store")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                        wait(0.2)
                    end
                end
            end
            
            -- Поиск кнопок в GUI
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
            -- Умножение урона
            local character = Player.Character
            if character then
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") then
                        local damage = tool:FindFirstChild("Damage")
                        if damage and damage:IsA("NumberValue") then
                            damage.Value = damage.Value * CurrentMultiplier
                        end
                    end
                end
            end
            
            -- Перехват ударов
            pcall(function()
                for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                    if remote:IsA("RemoteEvent") and (string.find(string.lower(remote.Name), "damage") or 
                       string.find(string.lower(remote.Name), "hit") or 
                       string.find(string.lower(remote.Name), "attack")) then
                       
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
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and (string.find(string.lower(obj.Name), "plot") or 
                   string.find(string.lower(obj.Name), "soil") or 
                   string.find(string.lower(obj.Name), "garden")) then
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
                if obj:IsA("Part") and (string.find(string.lower(obj.Name), "coin") or 
                   string.find(string.lower(obj.Name), "money") or 
                   string.find(string.lower(obj.Name), "reward")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
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

-- Элементы интерфейса
FarmSection:CreateToggle({
    Name = "🛒 Авто покупка растений",
    CurrentValue = false,
    Callback = function(Value)
        AutoBuyEnabled = Value
        if Value then
            AutoBuyPlants()
            Rayfield:Notify({
                Title = "Авто покупка запущена",
                Content = "Автоматически покупаем растения...",
                Duration = 5,
                Image = 4483362458
            })
        end
    end
})

FarmSection:CreateToggle({
    Name = "🌱 Авто посадка",
    CurrentValue = false,
    Callback = function(Value)
        AutoPlantEnabled = Value
        if Value then
            AutoPlant()
        end
    end
})

FarmSection:CreateToggle({
    Name = "💰 Авто сбор монет",
    CurrentValue = false,
    Callback = function(Value)
        AutoCollectEnabled = Value
        if Value then
            AutoCollect()
        end
    end
})

CombatSection:CreateToggle({
    Name = "💥 Множитель дубинки",
    CurrentValue = false,
    Callback = function(Value)
        ClubMultiplierEnabled = Value
        if Value then
            ApplyClubMultiplier()
        end
    end
})

CombatSection:CreateSlider({
    Name = "Значение множителя",
    Range = {1, 100},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 10,
    Callback = function(Value)
        CurrentMultiplier = Value
    end
})

CombatSection:CreateToggle({
    Name = "🛡️ Режим бога",
    CurrentValue = false,
    Callback = function(Value)
        GodModeEnabled = Value
        if Value then
            ApplyGodMode()
        end
    end
})

MovementSection:CreateToggle({
    Name = "🚀 Изменение скорости",
    CurrentValue = false,
    Callback = function(Value)
        SpeedHackEnabled = Value
        if Value then
            ApplySpeedHack()
        end
    end
})

MovementSection:CreateSlider({
    Name = "Скорость передвижения",
    Range = {16, 100},
    Increment = 1,
    Suffix = "ед.",
    CurrentValue = 50,
    Callback = function(Value)
        SpeedValue = Value
        if SpeedHackEnabled then
            ApplySpeedHack()
        end
    end
})

MovementSection:CreateToggle({
    Name = "🦘 Супер прыжок",
    CurrentValue = false,
    Callback = function(Value)
        JumpPowerEnabled = Value
        if Value then
            ApplyJumpPower()
        end
    end
})

MovementSection:CreateSlider({
    Name = "Сила прыжка",
    Range = {50, 200},
    Increment = 1,
    Suffix = "ед.",
    CurrentValue = 50,
    Callback = function(Value)
        JumpValue = Value
        if JumpPowerEnabled then
            ApplyJumpPower()
        end
    end
})

SettingsSection:CreateToggle({
    Name = "🔄 Anti-AFK",
    CurrentValue = true,
    Callback = function(Value)
        AntiAFKEnabled = Value
    end
})

SettingsSection:CreateKeybind({
    Name = "Открыть/Закрыть меню",
    CurrentKeybind = "RightShift",
    HoldToInteract = false,
    Callback = function()
        Rayfield:Toggle()
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
        wait(25)
    end
end)

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "Скрипт загружен!",
    Content = "Plants vs Brainrots Ultimate Hub активирован!",
    Duration = 6.5,
    Image = 4483362458
})