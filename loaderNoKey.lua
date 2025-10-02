-- Plants vs Brainrots - Venus UI Full Script
local Venus = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stefanuk12/Venus/main/Loader.lua'))()

local Window = Venus:Create({
    Name = "🌿 PLANTS vs BRAINROTS 🧠", 
    LoadingTitle = "Plants vs Brainrots Ultimate",
    LoadingSubtitle = "by Venus UI",
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
    KeySystem = false,
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {"Hello"}
    }
})

-- Табы
local MainTab = Window:CreateTab("🏠 Main")
local AutoFarmSection = MainTab:CreateSection("🤖 Auto Farm")
local CombatSection = MainTab:CreateSection("⚔️ Combat")

local PlayerTab = Window:CreateTab("🎮 Player")
local MovementSection = PlayerTab:CreateSection("🚀 Movement")
local CharacterSection = PlayerTab:CreateSection("👤 Character")

local VisualTab = Window:CreateTab("✨ Visual")
local EffectsSection = VisualTab:CreateSection("🎭 Effects")

local MiscTab = Window:CreateTab("⚙️ Misc")
local SettingsSection = MiscTab:CreateSection("🔧 Settings")

-- Переменные
local AutoBuy = false
local AutoPlant = false
local AutoCollect = false
local AutoUpgrade = false
local ClubMultiplier = false
local GodMode = false
local SpeedEnabled = false
local JumpEnabled = false
local NoClip = false
local AntiAFK = true

local MultiplierValue = 10
local WalkSpeed = 16
local JumpPower = 50

-- Функции
function BuyAllPlants()
    while AutoBuy do
        -- Поиск магазинов в workspace
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (string.find(obj.Name:lower(), "shop") or string.find(obj.Name:lower(), "vendor") or string.find(obj.Name:lower(), "store")) then
                if obj:FindFirstChild("ClickDetector") then
                    fireclickdetector(obj.ClickDetector)
                    wait(0.2)
                end
            end
        end
        
        -- Поиск кнопок покупки в GUI
        local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            for _, gui in pairs(playerGui:GetDescendants()) do
                if gui:IsA("TextButton") and (string.find(gui.Text:lower(), "buy") or string.find(gui.Text:lower(), "purchase") or string.find(gui.Text:lower(), "купить")) then
                    pcall(function()
                        gui:FireServer("Activated")
                    end)
                    wait(0.1)
                end
            end
        end
        wait(1)
    end
end

function PlantAllSeeds()
    while AutoPlant do
        -- Поиск мест для посадки
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (string.find(obj.Name:lower(), "plot") or string.find(obj.Name:lower(), "soil") or string.find(obj.Name:lower(), "garden")) then
                if obj:FindFirstChild("ClickDetector") then
                    fireclickdetector(obj.ClickDetector)
                    wait(0.1)
                end
            end
        end
        wait(2)
    end
end

function CollectAllCoins()
    while AutoCollect do
        -- Сбор монет и ресурсов
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (string.find(obj.Name:lower(), "coin") or string.find(obj.Name:lower(), "money") or string.find(obj.Name:lower(), "reward")) then
                if obj:FindFirstChild("ClickDetector") then
                    fireclickdetector(obj.ClickDetector)
                end
            end
        end
        wait(0.5)
    end
end

function ApplyClubMultiplier()
    while ClubMultiplier do
        -- Умножение урона дубинки
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
        
        -- Перехват remote events для урона
        pcall(function()
            for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if remote:IsA("RemoteEvent") and (string.find(remote.Name:lower(), "damage") or string.find(remote.Name:lower(), "hit")) then
                    local oldFire = remote.FireServer
                    remote.FireServer = function(self, ...)
                        local args = {...}
                        for i, arg in pairs(args) do
                            if type(arg) == "number" then
                                args[i] = arg * MultiplierValue
                            end
                        end
                        return oldFire(self, unpack(args))
                    end
                end
            end
        end)
        wait(0.3)
    end
end

function EnableGodMode()
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

function ApplySpeed()
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
end

function ApplyJump()
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
end

function EnableNoClip()
    while NoClip do
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
        wait(0.1)
    end
end

-- Авто Фарм секция
AutoFarmSection:CreateToggle({
    Name = "🛒 Auto Buy Plants",
    Default = false,
    Callback = function(Value)
        AutoBuy = Value
        if Value then
            Venus:Notify({
                Title = "Auto Buy Started",
                Description = "Automatically buying all plants in stock",
                Duration = 3
            })
            spawn(BuyAllPlants)
        end
    end
})

AutoFarmSection:CreateToggle({
    Name = "🌱 Auto Plant Seeds",
    Default = false,
    Callback = function(Value)
        AutoPlant = Value
        if Value then
            spawn(PlantAllSeeds)
        end
    end
})

AutoFarmSection:CreateToggle({
    Name = "💰 Auto Collect Coins",
    Default = false,
    Callback = function(Value)
        AutoCollect = Value
        if Value then
            spawn(CollectAllCoins)
        end
    end
})

AutoFarmSection:CreateToggle({
    Name = "🆙 Auto Upgrade Plants",
    Default = false,
    Callback = function(Value)
        AutoUpgrade = Value
    end
})

-- Комбат секция
CombatSection:CreateToggle({
    Name = "💥 Club Damage Multiplier",
    Default = false,
    Callback = function(Value)
        ClubMultiplier = Value
        if Value then
            spawn(ApplyClubMultiplier)
        end
    end
})

CombatSection:CreateSlider({
    Name = "Multiplier Value",
    Min = 1,
    Max = 100,
    Default = 10,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "x",
    Callback = function(Value)
        MultiplierValue = Value
    end
})

CombatSection:CreateToggle({
    Name = "🛡️ God Mode",
    Default = false,
    Callback = function(Value)
        GodMode = Value
        if Value then
            spawn(EnableGodMode)
        end
    end
})

-- Движение секция
MovementSection:CreateToggle({
    Name = "🚀 Speed Hack",
    Default = false,
    Callback = function(Value)
        SpeedEnabled = Value
        if Value then
            spawn(ApplySpeed)
        end
    end
})

MovementSection:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "studs",
    Callback = function(Value)
        WalkSpeed = Value
        if SpeedEnabled then
            ApplySpeed()
        end
    end
})

MovementSection:CreateToggle({
    Name = "🦘 Super Jump",
    Default = false,
    Callback = function(Value)
        JumpEnabled = Value
        if Value then
            spawn(ApplyJump)
        end
    end
})

MovementSection:CreateSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "power",
    Callback = function(Value)
        JumpPower = Value
        if JumpEnabled then
            ApplyJump()
        end
    end
})

-- Персонаж секция
CharacterSection:CreateToggle({
    Name = "👻 NoClip",
    Default = false,
    Callback = function(Value)
        NoClip = Value
        if Value then
            spawn(EnableNoClip)
        end
    end
})

CharacterSection:CreateButton({
    Name = "🧹 Reset Character",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

-- Эффекты секция
EffectsSection:CreateColorpicker({
    Name = "UI Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        Window:ChangeColor(Value)
    end
})

EffectsSection:CreateButton({
    Name = "✨ Rainbow UI",
    Callback = function()
        spawn(function()
            while true do
                for i = 0, 1, 0.01 do
                    Window:ChangeColor(Color3.fromHSV(i, 1, 1))
                    wait(0.1)
                end
            end
        end)
    end
})

-- Настройки секция
SettingsSection:CreateToggle({
    Name = "🔄 Anti-AFK",
    Default = true,
    Callback = function(Value)
        AntiAFK = Value
    end
})

SettingsSection:CreateKeybind({
    Name = "UI Toggle Keybind",
    Default = Enum.KeyCode.RightShift,
    Hold = false,
    Callback = function()
        Venus:Toggle()
    end
})

SettingsSection:CreateButton({
    Name = "💾 Save Configuration",
    Callback = function()
        Venus:Notify({
            Title = "Configuration Saved",
            Description = "Your settings have been saved!",
            Duration = 3
        })
    end
})

SettingsSection:CreateButton({
    Name = "🗑️ Destroy UI",
    Callback = function()
        Venus:Destroy()
    end
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
        wait(25)
    end
end)

-- Уведомление о загрузке
Venus:Notify({
    Title = "Plants vs Brainrots Loaded!",
    Description = "Venus UI successfully injected!",
    Duration = 5
})

-- Инициализация
Window:SelectTab(MainTab)