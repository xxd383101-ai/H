-- Plants vs Brainrots - Horizon UI
local Horizon = loadstring(game:HttpGet("https://raw.githubusercontent.com/ionlyusegithubformcmods/1-LinoriaLib/main/LinoriaLib%20V3.lua"))()

local Window = Horizon:CreateWindow({
    Title = "🌿 PLANTS vs BRAINROTS | HORIZON",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- Создаем вкладки
local MainTab = Window:AddTab("Главная")
local PlayerTab = Window:AddTab("Игрок")
local SettingsTab = Window:AddTab("Настройки")

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

-- Секция авто-фарма
local FarmSection = MainTab:AddLeftGroupbox("Авто Фарм")

FarmSection:AddToggle("AutoBuyToggle", {
    Text = "🛒 Авто покупка растений",
    Default = false,
    Tooltip = "Автоматически покупает растения",
    Callback = function(Value)
        AutoBuy = Value
        if Value then
            BuyAllPlants()
        end
    end
})

FarmSection:AddToggle("AutoPlantToggle", {
    Text = "🌱 Авто посадка",
    Default = false,
    Tooltip = "Автоматически сажает семена",
    Callback = function(Value)
        AutoPlant = Value
        if Value then
            PlantAllSeeds()
        end
    end
})

FarmSection:AddToggle("AutoCollectToggle", {
    Text = "💰 Авто сбор монет",
    Default = false,
    Tooltip = "Автоматически собирает монеты",
    Callback = function(Value)
        AutoCollect = Value
        if Value then
            CollectAllCoins()
        end
    end
})

-- Секция боевых функций
local CombatSection = MainTab:AddRightGroupbox("Боевые функции")

CombatSection:AddToggle("DamageMultiplierToggle", {
    Text = "💥 Множитель урона",
    Default = false,
    Tooltip = "Увеличивает урон оружия",
    Callback = function(Value)
        DamageMultiplier = Value
        if Value then
            ApplyDamageMultiplier()
        end
    end
})

CombatSection:AddSlider("MultiplierSlider", {
    Text = "Значение множителя",
    Default = 10,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        MultiplierValue = Value
    end
})

CombatSection:AddToggle("GodModeToggle", {
    Text = "🛡️ Режим бога",
    Default = false,
    Tooltip = "Делает вас неуязвимым",
    Callback = function(Value)
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
    end
})

-- Секция передвижения
local MovementSection = PlayerTab:AddLeftGroupbox("Передвижение")

MovementSection:AddToggle("SpeedToggle", {
    Text = "🚀 Изменение скорости",
    Default = false,
    Tooltip = "Изменяет скорость передвижения",
    Callback = function(Value)
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
    end
})

MovementSection:AddSlider("SpeedSlider", {
    Text = "Скорость передвижения",
    Default = 50,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        WalkSpeed = Value
    end
})

MovementSection:AddToggle("JumpToggle", {
    Text = "🦘 Супер прыжок",
    Default = false,
    Tooltip = "Увеличивает силу прыжка",
    Callback = function(Value)
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
    end
})

MovementSection:AddSlider("JumpSlider", {
    Text = "Сила прыжка",
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        JumpPower = Value
    end
})

-- Настройки
local UISettings = SettingsTab:AddLeftGroupbox("Настройки UI")

UISettings:AddToggle("AntiAFKToggle", {
    Text = "🔄 Anti-AFK",
    Default = true,
    Tooltip = "Предотвращает кик за бездействие",
    Callback = function(Value)
        AntiAFK = Value
    end
})

UISettings:AddButton({
    Text = "💾 Сохранить настройки",
    Func = function()
        Horizon:Notify("Настройки сохранены!", 3)
    end,
    DoubleClick = false
})

UISettings:AddButton({
    Text = "🗑️ Удалить UI",
    Func = function()
        Horizon:Unload()
    end,
    DoubleClick = true
})

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

-- Уведомление о загрузке
Horizon:Notify("Plants vs Brainrots загружен!", 5)

-- Инициализация
Horizon:ApplyConfig(Horizon.Config)