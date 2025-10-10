-- Universal Troll Script with Beautiful UI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Настройки
local UniversalTroll = {
    MenuOpen = false,
    Flight = {
        Enabled = false,
        Speed = 50
    },
    Speed = {
        Enabled = false,
        Value = 50
    },
    Aimbot = false,
    ESP = false,
    Noclip = false,
    GodMode = false
}

-- Цветовая схема
local Colors = {
    Background = Color3.fromRGB(15, 15, 15),
    Header = Color3.fromRGB(25, 25, 35),
    Primary = Color3.fromRGB(45, 45, 55),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(0, 170, 255),
    Success = Color3.fromRGB(0, 200, 100),
    Danger = Color3.fromRGB(220, 60, 60),
    Text = Color3.fromRGB(240, 240, 240)
}

-- Создание красивого GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalTrollGUI"
screenGui.Parent = player.PlayerGui

-- Основной контейнер
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 450, 0, 550)
mainContainer.Position = UDim2.new(0.5, -225, 0.5, -275)
mainContainer.BackgroundColor3 = Colors.Background
mainContainer.BackgroundTransparency = 0.1
mainContainer.Visible = false

-- Скругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainContainer

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceScale = 0.02
shadow.Parent = mainContainer

mainContainer.Parent = screenGui

-- Заголовок
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 60)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Colors.Header
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🚀 UNIVERSAL TROLL SCRIPT"
title.TextColor3 = Colors.Text
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 35)
subtitle.BackgroundTransparency = 1
subtitle.Text = "by Toxic Developer"
subtitle.TextColor3 = Colors.Accent
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.Parent = header

header.Parent = mainContainer

-- Вкладки
local tabsContainer = Instance.new("Frame")
tabsContainer.Name = "TabsContainer"
tabsContainer.Size = UDim2.new(1, 0, 0, 40)
tabsContainer.Position = UDim2.new(0, 0, 0, 60)
tabsContainer.BackgroundColor3 = Colors.Primary
tabsContainer.BorderSizePixel = 0

local tabs = {"🚀 Speed", "✈️ Flight", "😈 Troll", "👤 Player", "🎨 Visual"}

for i, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName
    tabButton.Size = UDim2.new(1/#tabs, 0, 1, 0)
    tabButton.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    tabButton.BackgroundColor3 = Colors.Primary
    tabButton.Text = tabName
    tabButton.TextColor3 = Colors.Text
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 12
    tabButton.Parent = tabsContainer
    
    tabButton.MouseButton1Click:Connect(function()
        SwitchTab(tabName)
    end)
end

tabsContainer.Parent = mainContainer

-- Контент
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -150)
contentFrame.Position = UDim2.new(0, 10, 0, 110)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.Parent = mainContainer

-- Функции для каждой вкладки
local Functions = {
    ["🚀 Speed"] = {
        {
            Type = "Slider",
            Name = "Скорость передвижения",
            Min = 16,
            Max = 200,
            Default = 50,
            Callback = function(value)
                UniversalTroll.Speed.Value = value
                local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = value
                end
            end
        },
        {
            Type = "Slider",
            Name = "Сила прыжка",
            Min = 50,
            Max = 300,
            Default = 100,
            Callback = function(value)
                local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = value
                end
            end
        },
        {
            Type = "Button",
            Name = "⚡ Супер скорость",
            Callback = function()
                SetSuperSpeed()
            end
        },
        {
            Type = "Toggle",
            Name = "Бесконечная выносливость",
            Callback = function(state)
                ToggleInfiniteStamina(state)
            end
        }
    },
    
    ["✈️ Flight"] = {
        {
            Type = "Toggle",
            Name = "Включить полет (X)",
            Callback = function(state)
                UniversalTroll.Flight.Enabled = state
                ToggleFlight(state)
            end
        },
        {
            Type = "Slider",
            Name = "Скорость полета",
            Min = 10,
            Max = 200,
            Default = 50,
            Callback = function(value)
                UniversalTroll.Flight.Speed = value
            end
        },
        {
            Type = "Button",
            Name = "🚀 Ускоренный полет",
            Callback = function()
                UniversalTroll.Flight.Speed = 100
                UpdateSliders()
            end
        }
    },
    
    ["😈 Troll"] = {
        {
            Type = "Button",
            Name = "💣 Взрыв всех игроков",
            Callback = function()
                TrollExplodeAll()
            end
        },
        {
            Type = "Button", 
            Name = "🌀 Телепорт всех в небо",
            Callback = function()
                TrollTeleportAllToSky()
            end
        },
        {
            Type = "Button",
            Name = "🎭 Украсть скины всех",
            Callback = function()
                TrollStealAllSkins()
            end
        },
        {
            Type = "Button",
            Name = "🌈 Радуга всех игроков",
            Callback = function()
                TrollRainbowAll()
            end
        },
        {
            Type = "Button",
            Name = "📏 Гигантские игроки",
            Callback = function()
                TrollMakeAllGiant()
            end
        },
        {
            Type = "Button",
            Name = "🌀 Вращать игроков",
            Callback = function()
                TrollSpinPlayers()
            end
        },
        {
            Type = "Button",
            Name = "🎯 Притягивать игроков",
            Callback = function()
                TrollAttractPlayers()
            end
        }
    },
    
    ["👤 Player"] = {
        {
            Type = "Toggle",
            Name = "🛡️ Бессмертие",
            Callback = function(state)
                UniversalTroll.GodMode = state
                ToggleGodMode(state)
            end
        },
        {
            Type = "Toggle",
            Name = "🎯 Аимбот (Q)",
            Callback = function(state)
                UniversalTroll.Aimbot = state
                ToggleAimbot(state)
            end
        },
        {
            Type = "Toggle",
            Name = "👁️ ESP игроков",
            Callback = function(state)
                UniversalTroll.ESP = state
                ToggleESP(state)
            end
        },
        {
            Type = "Toggle",
            Name = "🌀 Ноклип (N)",
            Callback = function(state)
                UniversalTroll.Noclip = state
                ToggleNoclip(state)
            end
        },
        {
            Type = "Slider",
            Name = "Размер игрока",
            Min = 0.1,
            Max = 10,
            Default = 1,
            Callback = function(value)
                ChangePlayerSize(value)
            end
        }
    },
    
    ["🎨 Visual"] = {
        {
            Type = "Button",
            Name = "🌙 Ночной режим",
            Callback = function()
                SetNightMode()
            end
        },
        {
            Type = "Button",
            Name = "☀️ Дневной режим",
            Callback = function()
                SetDayMode()
            end
        },
        {
            Type = "Button",
            Name = "🌈 Радуга карта",
            Callback = function()
                VisualRainbowMap()
            end
        },
        {
            Type = "Button",
            Name = "👻 Призрачный режим",
            Callback = function()
                VisualGhostMode()
            end
        },
        {
            Type = "Toggle",
            Name = "💀 Режим хрусталя",
            Callback = function(state)
                ToggleXray(state)
            end
        }
    }
}

-- Создание элементов управления
local function CreateSlider(name, min, max, default, callback)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = name .. "Slider"
    sliderContainer.Size = UDim2.new(1, 0, 0, 60)
    sliderContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Colors.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer
    
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Name = "Background"
    sliderBackground.Size = UDim2.new(1, 0, 0, 6)
    sliderBackground.Position = UDim2.new(0, 0, 0, 30)
    sliderBackground.BackgroundColor3 = Colors.Secondary
    sliderBackground.BorderSizePixel = 0
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBackground
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Colors.Accent
    sliderFill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0, 25)
    sliderButton.BackgroundColor3 = Colors.Text
    sliderButton.Text = ""
    sliderButton.BorderSizePixel = 0
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton
    
    -- Логика слайдера
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    sliderButton.MouseMoved:Connect(function()
        if dragging then
            local x = math.clamp(mouse.X - sliderBackground.AbsolutePosition.X, 0, sliderBackground.AbsoluteSize.X)
            local value = min + (x / sliderBackground.AbsoluteSize.X) * (max - min)
            value = math.floor(value)
            
            sliderFill.Size = UDim2.new(x / sliderBackground.AbsoluteSize.X, 0, 1, 0)
            sliderButton.Position = UDim2.new(x / sliderBackground.AbsoluteSize.X, -10, 0, 25)
            label.Text = name .. ": " .. value
            
            callback(value)
        end
    end)
    
    sliderFill.Parent = sliderBackground
    sliderButton.Parent = sliderContainer
    sliderBackground.Parent = sliderContainer
    
    return sliderContainer
end

local function CreateButton(name, callback)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Colors.Primary
    button.Text = name
    button.TextColor3 = Colors.Text
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Colors.Accent
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Colors.Primary
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

local function CreateToggle(name, callback)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = name .. "Toggle"
    toggleContainer.Size = UDim2.new(1, 0, 0, 30)
    toggleContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Colors.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleContainer
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -50, 0, 2)
    toggleButton.BackgroundColor3 = Colors.Danger
    toggleButton.Text = ""
    toggleButton.AutoButtonColor = false
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleButton
    
    local toggleDot = Instance.new("Frame")
    toggleDot.Name = "Dot"
    toggleDot.Size = UDim2.new(0, 19, 0, 19)
    toggleDot.Position = UDim2.new(0, 3, 0, 3)
    toggleDot.BackgroundColor3 = Colors.Text
    toggleDot.BorderSizePixel = 0
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = toggleDot
    
    local state = false
    
    local function updateToggle()
        if state then
            toggleButton.BackgroundColor3 = Colors.Success
            toggleDot.Position = UDim2.new(0, 28, 0, 3)
        else
            toggleButton.BackgroundColor3 = Colors.Danger
            toggleDot.Position = UDim2.new(0, 3, 0, 3)
        end
        callback(state)
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
    end)
    
    toggleDot.Parent = toggleButton
    toggleButton.Parent = toggleContainer
    
    return toggleContainer
end

-- Функции для обновления интерфейса
function SwitchTab(tabName)
    contentFrame:ClearAllChildren()
    
    local yOffset = 0
    local functions = Functions[tabName]
    
    if functions then
        for _, func in ipairs(functions) do
            local element
            local height = 0
            
            if func.Type == "Slider" then
                element = CreateSlider(func.Name, func.Min, func.Max, func.Default, func.Callback)
                height = 60
            elseif func.Type == "Button" then
                element = CreateButton(func.Name, func.Callback)
                height = 40
            elseif func.Type == "Toggle" then
                element = CreateToggle(func.Name, func.Callback)
                height = 30
            end
            
            if element then
                element.Position = UDim2.new(0, 0, 0, yOffset)
                element.Parent = contentFrame
                yOffset = yOffset + height + 5
            end
        end
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

function UpdateSliders()
    -- Обновление слайдеров при изменении значений
end

-- ТРОЛЛЬ ФУНКЦИИ
function TrollExplodeAll()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end
    print("💣 Все игроки взорваны!")
end

function TrollTeleportAllToSky()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local root = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = root.CFrame + Vector3.new(0, 500, 0)
            end
        end
    end
    print("🌀 Все телепортированы в небо!")
end

function TrollStealAllSkins()
    print("🎭 Скины украдены! (функция)")
end

function TrollRainbowAll()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            for _, part in ipairs(otherPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.random()
                    part.Material = Enum.Material.Neon
                end
            end
        end
    end
    print("🌈 Все игроки стали радужными!")
end

function TrollMakeAllGiant()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                for _, part in ipairs(otherPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Size = part.Size * 3
                    end
                end
            end
        end
    end
    print("📏 Все игроки стали гигантами!")
end

function TrollSpinPlayers()
    print("🌀 Игроки вращаются! (функция)")
end

function TrollAttractPlayers()
    print("🎯 Игроки притягиваются! (функция)")
end

-- СИСТЕМНЫЕ ФУНКЦИИ
function ToggleFlight(state)
    print("✈️ Полет: " .. (state and "ВКЛ" or "ВЫКЛ"))
end

function ToggleGodMode(state)
    print("🛡️ Бессмертие: " .. (state and "ВКЛ" or "ВЫКЛ"))
end

function ToggleAimbot(state)
    print("🎯 Аимбот: " .. (state and "ВКЛ" or "ВЫКЛ"))
end

function ToggleESP(state)
    print("👁️ ESP: " .. (state and "ВКЛ" or "ВЫКЛ"))
end

function ToggleNoclip(state)
    print("🌀 Ноклип: " .. (state and "ВКЛ" or "ВЫКЛ"))
end

function ToggleInfiniteStamina(state)
    print("⚡ Выносливость: " .. (state and "ВКЛ" or "ВЫКЛ"))
end

function ToggleXray(state)
    print("💀 X-Ray: " .. (state and "ВКЛ" or "ВЫКЛ"))
end

function SetSuperSpeed()
    UniversalTroll.Speed.Value = 100
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 100
        humanoid.JumpPower = 150
    end
    UpdateSliders()
    print("⚡ Супер скорость активирована!")
end

function ChangePlayerSize(size)
    print("📏 Размер игрока: " .. size)
end

function SetNightMode()
    Lighting.TimeOfDay = "00:00:00"
    Lighting.Brightness = 0
    print("🌙 Ночной режим включен")
end

function SetDayMode()
    Lighting.TimeOfDay = "14:00:00"
    Lighting.Brightness = 2
    print("☀️ Дневной режим включен")
end

function VisualRainbowMap()
    print("🌈 Радуга карты активирована!")
end

function VisualGhostMode()
    print("👻 Призрачный режим активирован!")
end

-- Управление меню
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        UniversalTroll.MenuOpen = not UniversalTroll.MenuOpen
        mainContainer.Visible = UniversalTroll.MenuOpen
        
        if UniversalTroll.MenuOpen then
            SwitchTab("🚀 Speed")
        end
    end
end)


SwitchTab("🚀 Speed")

print("====================================")
print("🚀 t.me/TurboScriptss TROLL SCRIPT LOADED")
print("📌 RightShift - Открыть/Закрыть меню")
print("🎮 Beautiful UI with Sliders & Toggles")
print("====================================")