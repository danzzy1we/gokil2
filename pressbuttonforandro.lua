local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

if CoreGui:FindFirstChild("AxelMobileKey") then CoreGui.AxelMobileKey:Destroy() end

local ImageId = "rbxassetid://6031094678" -- Ganti ID ini untuk ganti gambar F4 kamu
local ButtonColor = Color3.fromRGB(30, 30, 30)
local AccentColor = Color3.fromRGB(255, 255, 255)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxelMobileKey"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainBtn = Instance.new("ImageButton")
MainBtn.Name = "F4Button"
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 55, 0, 55)
MainBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
MainBtn.BackgroundColor3 = ButtonColor
MainBtn.BackgroundTransparency = 0.2 -- Efek transparan Fluent
MainBtn.BorderSizePixel = 0
MainBtn.AutoButtonColor = false

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15) -- Sangat bulat
UICorner.Parent = MainBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = AccentColor
UIStroke.Transparency = 0.8
UIStroke.Thickness = 1.5
UIStroke.Parent = MainBtn

local Icon = Instance.new("ImageLabel")
Icon.Parent = MainBtn
Icon.Size = UDim2.new(0.6, 0, 0.6, 0)
Icon.Position = UDim2.new(0.2, 0, 0.2, 0)
Icon.BackgroundTransparency = 1
Icon.Image = ImageId
Icon.ImageColor3 = AccentColor
Icon.ScaleType = Enum.ScaleType.Fit

local dragging, dragInput, dragStart, startPos

MainBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

MainBtn.MouseButton1Click:Connect(function()
    local shrink = TweenService:Create(MainBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 50, 0, 50)})
    local expand = TweenService:Create(MainBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 55, 0, 55)})
    
    shrink:Play()
    shrink.Completed:Wait()
    expand:Play()

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F4, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F4, false, game)
end)