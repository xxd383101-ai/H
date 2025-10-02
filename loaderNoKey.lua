-- Plants vs Brainrots Ultimate Script - Full Fix
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌿 PLANTS vs BRAINROTS | ULTIMATE",
   LoadingTitle = "Plants vs Brainrots Hub",
   LoadingSubtitle = "Loading...",
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

-- Табы
local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local FarmSection = MainTab:CreateSection("Auto Farm")
local CombatSection = MainTab:CreateSection("Combat")

local PlayerTab = Window:CreateTab("🎮 Player", 4483362458)
local MovementSection = PlayerTab:CreateSection("Movement")
local CharacterSection = PlayerTab:CreateSection("Character")

local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)
local SettingsSection = MiscTab:CreateSection("Settings")

-- Переменные
local AutoBuy = false
local AutoPlant = false
local AutoCollect = false
local GodMode = false
local SpeedEnabled = false
local JumpEnabled = false
local DamageMultiplier = false
local AntiAFK = true
local NoClip = false

local MultiplierValue = 10
local WalkSpeed = 50
local JumpPower = 50

-- Основные функции
function BuyAllPlants()
    spawn(function()
        while AutoBuy do
            -- Поиск магазинов
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (string.find(obj.Name:lower(), "shop") or string.find(obj.Name:lower(), "vendor") or string.find(obj.Name:lower(), "store")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                        wait(0.2)
                    end
                end
            end
            
            -- Поиск кнопок в GUI
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
            wait(2)
        end
    end)
end

function PlantAllSeeds()
    spawn(function()
        while AutoPlant do
            -- Поиск мест для посадки
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and (string.find(obj.Name:lower(), "plot") or string.find(obj.Name:lower(), "soil") or string.find(obj.Name:lower(), "garden") or string.find(obj.Name:lower(), "plant")) then
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
            -- Сбор ресурсов
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and (string.find(obj.Name:lower(), "coin") or string.find(obj.Name:lower(), "money") or string.find(obj.Name:lower(), "reward") or string.find(obj.Name:lower(), "collect")) then
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
            -- Умножение урона через инструменты
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
            
            -- Перехват RemoteEvents для урона
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
    end)
end

function ApplyGodMode()
    spawn(function()
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
    end)
end

function ApplySpeed()
    spawn(function()
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
    end)
end

function ApplyJump()
    spawn(function()
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
    end)
end

function EnableNoClip()
    spawn(function()
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
    end)
end

-- Элементы управления Auto Farm
FarmSection:CreateToggle({
   Name = "🛒 Auto Buy Plants",
   CurrentValue = false,
   Flag = "AutoBuyToggle",
   Callback = function(Value)
      AutoBuy = Value
      if Value then
         Rayfield:Notify({
            Title = "Auto Buy Started",
            Content = "Automatically buying plants...",
            Duration = 3,
            Image = 4483362458,
         })
         BuyAllPlants()
      else
         Rayfield:Notify({
            Title = "Auto Buy Stopped",
            Content = "Stopped buying plants",
            Duration = 3,
            Image = 4483362458,
         })
      end
   end
})

FarmSection:CreateToggle({
   Name = "🌱 Auto Plant Seeds",
   CurrentValue = false,
   Flag = "AutoPlantToggle",
   Callback = function(Value)
      AutoPlant = Value
      if Value then
         PlantAllSeeds()
      end
   end
})

FarmSection:CreateToggle({
   Name = "💰 Auto Collect Coins",
   CurrentValue = false,
   Flag = "AutoCollectToggle",
   Callback = function(Value)
      AutoCollect = Value
      if Value then
         CollectAllCoins()
      end
   end
})

-- Элементы управления Combat
CombatSection:CreateToggle({
   Name = "💥 Damage Multiplier",
   CurrentValue = false,
   Flag = "DamageMultiplierToggle",
   Callback = function(Value)
      DamageMultiplier = Value
      if Value then
         ApplyDamageMultiplier()
      end
   end
})

CombatSection:CreateSlider({
   Name = "Multiplier Value",
   Range = {1, 100},
   Increment = 1,
   Suffix = "x",
   CurrentValue = 10,
   Flag = "MultiplierSlider",
   Callback = function(Value)
      MultiplierValue = Value
   end
})

CombatSection:CreateToggle({
   Name = "🛡️ God Mode",
   CurrentValue = false,
   Flag = "GodModeToggle",
   Callback = function(Value)
      GodMode = Value
      if Value then
         ApplyGodMode()
      end
   end
})

-- Элементы управления Movement
MovementSection:CreateToggle({
   Name = "🚀 Speed Hack",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      SpeedEnabled = Value
      if Value then
         ApplySpeed()
      end
   end
})

MovementSection:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "studs",
   CurrentValue = 50,
   Flag = "SpeedSlider",
   Callback = function(Value)
      WalkSpeed = Value
      if SpeedEnabled then
          ApplySpeed()
      end
   end
})

MovementSection:CreateToggle({
   Name = "🦘 Super Jump",
   CurrentValue = false,
   Flag = "JumpToggle",
   Callback = function(Value)
      JumpEnabled = Value
      if Value then
         ApplyJump()
      end
   end
})

MovementSection:CreateSlider({
   Name = "Jump Power",
   Range = {50, 200},
   Increment = 1,
   Suffix = "power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      JumpPower = Value
      if JumpEnabled then
          ApplyJump()
      end
   end
})

-- Элементы управления Character
CharacterSection:CreateToggle({
   Name = "👻 NoClip",
   CurrentValue = false,
   Flag = "NoClipToggle",
   Callback = function(Value)
      NoClip = Value
      if Value then
         EnableNoClip()
      end
   end
})

CharacterSection:CreateButton({
   Name = "🧹 Reset Character",
   Callback = function()
      game.Players.LocalPlayer.Character:BreakJoints()
   end
})

-- Настройки
SettingsSection:CreateToggle({
   Name = "🔄 Anti-AFK",
   CurrentValue = true,
   Flag = "AntiAFKToggle",
   Callback = function(Value)
      AntiAFK = Value
   end
})

SettingsSection:CreateKeybind({
   Name = "UI Toggle",
   CurrentKeybind = Enum.KeyCode.RightShift,
   HoldToInteract = false,
   Flag = "UIToggle",
   Callback = function(Keybind)
      Rayfield:Toggle()
   end
})

SettingsSection:CreateButton({
   Name = "💾 Save Configuration",
   Callback = function()
      Rayfield:Notify({
         Title = "Configuration Saved",
         Content = "Your settings have been saved!",
         Duration = 3,
         Image = 4483362458,
      })
   end
})

SettingsSection:CreateButton({
   Name = "🗑️ Destroy UI",
   Callback = function()
      Rayfield:Destroy()
   end
})

-- Анти-АФК система
spawn(function()
    while true do
        if AntiAFK then
            pcall(function()
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
                wait(0.1)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", false, game)
                wait(0.1)
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "S", false, game)
                wait(0.1)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "S", false, game)
            end)
        end
        wait(25)
    end
end)

-- Уведомление о загрузке
Rayfield:Notify({
   Title = "🌿 Script Loaded",
   Content = "Plants vs Brainrots Ultimate has been loaded!",
   Duration = 5,
   Image = 4483362458,
})

-- Загрузка конфигурации
Rayfield:LoadConfiguration()