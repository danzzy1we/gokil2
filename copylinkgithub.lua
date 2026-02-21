-- ======================================================
-- AXEL FLUENT TELEGRAM POPUP (ADVANCED)
-- ======================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

-- Bersihkan jika ada UI lama
if CoreGui:FindFirstChild("AxelTelegramPopup") then CoreGui.AxelTelegramPopup:Destroy() end

-- --- CONFIGURATION ---
local TelegramLink = "https://t.me/axelhubscriptinfo" -- Ganti dengan link kamu
local AccentColor = Color3.fromRGB(255, 255, 255)
local BgColor = Color3.fromRGB(15, 15, 15)

-- 1. Root UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxelTelegramPopup"
ScreenGui.Parent = CoreGui

-- 2. Main Frame (Fluent UI)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0.5, -150, 1, 50) -- Start dari bawah layar
MainFrame.BackgroundColor3 = BgColor
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1
UIStroke.Color = AccentColor
UIStroke.Transparency = 0.8
UIStroke.Parent = MainFrame

-- 3. Title (Branding AXEL)
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "AXEL COMMUNITY"
Title.TextColor3 = AccentColor
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

-- 4. Description
local Desc = Instance.new("TextLabel")
Desc.Parent = MainFrame
Desc.Size = UDim2.new(0.8, 0, 0, 40)
Desc.Position = UDim2.new(0.1, 0, 0, 45)
Desc.BackgroundTransparency = 1
Desc.Text = "Join our Telegram to get latest updates and support."
Desc.TextColor3 = AccentColor
Desc.TextTransparency = 0.4
Desc.TextSize = 12
Desc.Font = Enum.Font.Gotham
Desc.TextWrapped = true

-- 5. Tombol Copy (Fluent Style)
local CopyBtn = Instance.new("TextButton")
CopyBtn.Name = "CopyBtn"
CopyBtn.Parent = MainFrame
CopyBtn.Size = UDim2.new(0.4, 0, 0, 35)
CopyBtn.Position = UDim2.new(0.08, 0, 0, 95)
CopyBtn.BackgroundColor3 = AccentColor
CopyBtn.Text = "Copy Link"
CopyBtn.TextColor3 = BgColor
CopyBtn.TextSize = 12
CopyBtn.Font = Enum.Font.GothamMedium
CopyBtn.AutoButtonColor = false

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 8)
UICornerBtn.Parent = CopyBtn

-- 6. Tombol Close (Elegant Style)
local CloseBtn = CopyBtn:Clone()
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.Position = UDim2.new(0.52, 0, 0, 95)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseBtn.Text = "Later"
CloseBtn.TextColor3 = AccentColor

-- --- LOGIC & ANIMATIONS ---

-- Munculkan (Animate In)
MainFrame:TweenPosition(UDim2.new(0.5, -150, 0.5, -75), "Out", "Quart", 1, true)

-- Fungsi Copy Link
CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(TelegramLink)
        CopyBtn.Text = "Copied!"
        task.wait(2)
        CopyBtn.Text = "Copy Link"
    else
        CopyBtn.Text = "Not Supported"
    end
end)

-- Fungsi Close (Animate Out)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame:TweenPosition(UDim2.new(0.5, -150, 1, 50), "In", "Quart", 0.8, true)
    task.wait(0.8)
    ScreenGui:Destroy()
end)

-- Hover Effects
local function addHover(btn, colorOn, colorOff)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = colorOn}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = colorOff}):Play()
    end)
end

addHover(CopyBtn, Color3.fromRGB(200, 200, 200), AccentColor)
addHover(CloseBtn, Color3.fromRGB(60, 60, 60), Color3.fromRGB(40, 40, 40))