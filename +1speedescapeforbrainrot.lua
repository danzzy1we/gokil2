--[[
    Script: AxelHub - FLUENT FINAL
    Author: Danz
    Desc: Auto steal + player boosts + teleport + info
--]]

-- ==================== INIT ====================
if math.random() < 1 then
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/danzzy1we/gokil2/refs/heads/main/copylinkgithub.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/1SpeedEscapeforBrainrots"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/danzzy1we/gokil2/refs/heads/main/pressbuttonforandro.lua"))()
    end)
end

task.wait(3)

-- Services
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local uis = game:GetService("UserInputService")
local pps = game:GetService("ProximityPromptService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local http = game:GetService("HttpService")

-- Core variables
local autosteal = false
local instanthold = false
local holdconn = nil
local speedenabled = false
local noclip = false
local infinjump = false
local noclipconn = nil
local defaultspeed = 16
local customspeed = 50
local teleportpos = Vector3.new(-966.808044, 61.964756, -1329.856934)

-- UI Toggle
local uiVisible = true
local toggleKey = Enum.KeyCode.F4

-- ==================== FLUENT LOAD ====================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Tunggu bentar biar Fluent siap
task.wait(1)

-- ==================== WINDOW ====================
local Window = Fluent:CreateWindow({
    Title = "🌊 AXEL HUB | " .. lp.Name,
    SubTitle = "By Axel • Final Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(530, 520),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = toggleKey
})

-- ==================== TABS ====================
local Tabs = {
    Main = Window:AddTab({ Title = "MAIN", Icon = "rbxassetid://4483345998" }),
    Player = Window:AddTab({ Title = "PLAYER", Icon = "rbxassetid://4483345998" }),
    Teleport = Window:AddTab({ Title = "TELEPORT", Icon = "rbxassetid://4483345998" }),
    Info = Window:AddTab({ Title = "INFO", Icon = "rbxassetid://4483345998" })
}

-- ==================== FUNCTIONS ====================

-- Auto steal
local function autoStealToggle(value)
    autosteal = value
    Fluent:Notify({
        Title = "Auto Steal",
        Content = value and "✅ Enabled" or "❌ Disabled",
        Duration = 2
    })
end

-- Instant hold
local function instantHoldToggle(value)
    instanthold = value
    if instanthold then
        if fireproximityprompt then
            if holdconn then holdconn:Disconnect() end
            holdconn = pps.PromptButtonHoldBegan:Connect(function(prompt)
                if prompt.HoldDuration > 0 then
                    prompt.HoldDuration = 0
                end
                fireproximityprompt(prompt)
            end)
            Fluent:Notify({ Title = "Instant Hold", Content = "✅ Enabled", Duration = 2 })
        else
            Fluent:Notify({ Title = "Instant Hold", Content = "❌ Executor not supported", Duration = 3 })
            instanthold = false
        end
    else
        if holdconn then 
            holdconn:Disconnect()
            holdconn = nil
        end
        Fluent:Notify({ Title = "Instant Hold", Content = "❌ Disabled", Duration = 2 })
    end
end

-- Manual steal
local function manualSteal()
    pcall(function()
        local char = lp.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(teleportpos)
            Fluent:Notify({ Title = "Teleport", Content = "📍 Steal point", Duration = 2 })
        end
    end)
end

-- Speed
local function speedToggle(value)
    speedenabled = value
    local char = lp.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = value and customspeed or defaultspeed
        end
    end
    Fluent:Notify({ 
        Title = "Speed", 
        Content = value and "✅ Enabled ("..customspeed..")" or "❌ Disabled", 
        Duration = 2 
    })
end

-- Noclip
local function noclipFunction()
    if noclip then
        if noclipconn then noclipconn:Disconnect() end
        noclipconn = rs.Stepped:Connect(function()
            local char = lp.Character
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipconn then 
            noclipconn:Disconnect()
            noclipconn = nil
        end
        local char = lp.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and not v.CanCollide then
                    v.CanCollide = true
                end
            end
        end
    end
end

local function noclipToggle(value)
    noclip = value
    noclipFunction()
    Fluent:Notify({ Title = "Noclip", Content = value and "✅ Enabled" or "❌ Disabled", Duration = 2 })
end

-- Infinite jump
local function infJumpToggle(value)
    infinjump = value
    Fluent:Notify({ Title = "Infinite Jump", Content = value and "✅ Enabled" or "❌ Disabled", Duration = 2 })
end

-- Auto steal handler
pps.PromptButtonHoldBegan:Connect(function(prompt)
    if not autosteal then return end
    task.spawn(function()
        task.wait(0.5)
        local char = lp.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local lastpos = root.Position
                root.CFrame = CFrame.new(teleportpos)
                task.wait(1)
                root.CFrame = CFrame.new(lastpos)
                task.wait(0.05)
                if fireproximityprompt then 
                    fireproximityprompt(prompt) 
                end
            end
        end
    end)
end)

-- Infinite jump handler
uis.JumpRequest:Connect(function()
    if infinjump then
        local char = lp.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then 
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- ==================== MAIN TAB ====================
local MainSection = Tabs.Main:AddSection("⚡ Auto Steal")

MainSection:AddToggle("AutoStealToggle", {
    Title = "Auto Steal",
    Description = "Auto teleport & steal when prompt appears",
    Default = false
}):OnChanged(autoStealToggle)

MainSection:AddToggle("InstantHoldToggle", {
    Title = "Instant Hold",
    Description = "Zero hold time for prompts (requires executor support)",
    Default = false
}):OnChanged(instantHoldToggle)

MainSection:AddButton({
    Title = "Manual Steal",
    Description = "📍 Teleport to steal location",
    Callback = manualSteal
})

-- ==================== PLAYER TAB ====================
local PlayerSection = Tabs.Player:AddSection("🏃 Player Boosts")

-- Speed toggle
local speedToggleObj = PlayerSection:AddToggle("SpeedToggle", {
    Title = "Speed Boost",
    Description = "Toggle speed boost on/off",
    Default = false
})
speedToggleObj:OnChanged(speedToggle)

-- Speed slider
PlayerSection:AddSlider("SpeedSlider", {
    Title = "Speed Value",
    Description = "Adjust walking speed (16-200)",
    Default = 50,
    Min = 16,
    Max = 200,
    Rounding = 1
}):OnChanged(function(value)
    customspeed = value
    if speedenabled then
        local char = lp.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then 
                hum.WalkSpeed = customspeed
            end
        end
    end
end)

-- Noclip toggle
PlayerSection:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Description = "Walk through walls",
    Default = false
}):OnChanged(noclipToggle)

-- Infinite jump toggle
PlayerSection:AddToggle("InfJumpToggle", {
    Title = "Infinite Jump",
    Description = "Jump infinitely",
    Default = false
}):OnChanged(infJumpToggle)

-- ==================== TELEPORT TAB ====================
local TeleportSection = Tabs.Teleport:AddSection("📍 Teleport Locations")

local zones = {
    {"END ZONE", Vector3.new(-1121.544434, 60.979870, 4258.432129)},
    {"END 2 ZONE", Vector3.new(-1109.029785, 61.735142, 3997.270752)},
    {"END 3 ZONE", Vector3.new(-1111.088379, 61.735142, 3783.730713)},
    {"END 4 ZONE", Vector3.new(-1090.498535, 61.735142, 3014.854980)},
    {"END 5 ZONE", Vector3.new(-1086.666748, 61.667107, 2797.735596)},
    {"END 6 ZONE", Vector3.new(-1103.466187, 61.735142, 2464.626465)}
}

for _, zone in ipairs(zones) do
    TeleportSection:AddButton({
        Title = zone[1],
        Description = "Click to teleport",
        Callback = function()
            pcall(function()
                local char = lp.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(zone[2])
                    Fluent:Notify({ Title = "Teleport", Content = "📍 " .. zone[1], Duration = 2 })
                end
            end)
        end
    })
end

-- ==================== INFO TAB ====================
local InfoSection = Tabs.Info:AddSection("ℹ️ Information")

-- Player info
InfoSection:AddParagraph({
    Title = "👤 Player Info",
    Content = string.format(
        "Username: %s\nDisplay: %s\nUser ID: %d\nAge: %d days",
        lp.Name,
        lp.DisplayName,
        lp.UserId,
        lp.AccountAge
    )
})

-- Game info
local placeId = game.PlaceId
local jobId = game.JobId
local success, productInfo = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(placeId)
end)
local gameName = success and productInfo.Name or "Unknown"

InfoSection:AddParagraph({
    Title = "🎮 Game Info",
    Content = string.format(
        "Game: %s\nPlace ID: %d\nJob ID: %s\nPlayers: %d/%d",
        gameName,
        placeId,
        jobId,
        #plrs:GetPlayers(),
        plrs.MaxPlayers
    )
})

-- Script info
InfoSection:AddParagraph({
    Title = "📦 Script Info",
    Content = [[
Name: Axel Hub
Version: 3.0 Final
Author: Danz
Features: Auto Steal, Instant Hold, Speed, Noclip, Inf Jump, 6 Teleports
Library: Fluent UI
    ]]
})

-- Live stats
local statsPara = InfoSection:AddParagraph({
    Title = "📊 Live Stats",
    Content = "Loading..."
})

-- Update stats
spawn(function()
    while true do
        task.wait(3)
        local char = lp.Character
        local pos = char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position or Vector3.new(0,0,0)
        
        statsPara:SetContent(string.format(
            "Auto Steal: %s\nSpeed: %d W/S\nNoclip: %s\nInf Jump: %s\nPosition: %.1f, %.1f, %.1f",
            autosteal and "ON" or "OFF",
            speedenabled and customspeed or defaultspeed,
            noclip and "ON" or "OFF",
            infinjump and "ON" or "OFF",
            pos.X, pos.Y, pos.Z
        ))
    end
end)

-- Utilities
local UtilSection = Tabs.Info:AddSection("🛠️ Utilities")

UtilSection:AddButton({
    Title = "Copy Job ID",
    Description = "Copy server ID to clipboard",
    Callback = function()
        if setclipboard then
            setclipboard(jobId)
            Fluent:Notify({ Title = "Info", Content = "✅ Job ID copied", Duration = 2 })
        else
            Fluent:Notify({ Title = "Info", Content = "❌ Clipboard not supported", Duration = 2 })
        end
    end
})

UtilSection:AddButton({
    Title = "Rejoin Server",
    Description = "Teleport back to same server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, jobId, lp)
    end
})

UtilSection:AddButton({
    Title = "Server Hop",
    Description = "Find new server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(placeId)
    end
})

-- ==================== SAVE MANAGER ====================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndex({ "AutoStealToggle", "InstantHoldToggle", "SpeedToggle", "NoclipToggle", "InfJumpToggle" })

InterfaceManager:SetIgnoreIndex({})

SaveManager:BuildConfigSection(Tabs.Info)

-- ==================== INIT ====================
Fluent:Notify({
    Title = "Axel Hub",
    Content = "🌊 Loaded successfully | Press F1 to toggle",
    Duration = 5
})

-- Pastuin character spawn
lp.CharacterAdded:Connect(function(char)
    task.wait(1)
    if speedenabled then
        local hum = char:WaitForChild("Humanoid")
        hum.WalkSpeed = customspeed
    end
end)

print("✅ Axel Hub Final loaded")