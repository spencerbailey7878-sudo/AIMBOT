-- MOBILE HEAD-ONLY AIM ASSIST
-- For use in your own Roblox game

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    Enabled = false,
    WallCheck = true,
    FOVEnabled = true,

    FOVRadius = 250,

    -- 0% = no camera movement
    -- 100% = strongest/fastest camera movement
    AimStrength = 0.50
}

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "HeadAimAssist"
Gui.ResetOnSpawn = false
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 270, 0, 350)
Main.Position = UDim2.new(0.5, -135, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -45, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🎯 Head Aim Assist"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 35, 0, 30)
Minimize.Position = UDim2.new(1, -40, 0, 8)
Minimize.Text = "—"
Minimize.TextSize = 20
Minimize.TextColor3 = Color3.new(1, 1, 1)
Minimize.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Minimize.Parent = Main

local function CreateButton(text, y)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 38)
    Button.Position = UDim2.new(0, 10, 0, y)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.Parent = Main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = Button

    return Button
end

-- Aim Assist
local AimButton = CreateButton("🎯 Aim Assist: OFF", 48)

AimButton.Activated:Connect(function()
    Settings.Enabled = not Settings.Enabled
    AimButton.Text = "🎯 Aim Assist: " .. (Settings.Enabled and "ON" or "OFF")
end)

-- Wall Check
local WallButton = CreateButton("👁️ Wall Check: ON", 93)

WallButton.Activated:Connect(function()
    Settings.WallCheck = not Settings.WallCheck
    WallButton.Text = "👁️ Wall Check: " .. (Settings.WallCheck and "ON" or "OFF")
end)

-- FOV
local FOVButton = CreateButton("⭕ FOV Circle: ON", 138)

FOVButton.Activated:Connect(function()
    Settings.FOVEnabled = not Settings.FOVEnabled
    FOVButton.Text = "⭕ FOV Circle: " .. (Settings.FOVEnabled and "ON" or "OFF")
end)

-- FOV Label
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(1, -20, 0, 25)
FOVLabel.Position = UDim2.new(0, 10, 0, 183)
FOVLabel.BackgroundTransparency = 1
FOVLabel.TextColor3 = Color3.new(1, 1, 1)
FOVLabel.TextSize = 14
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.Text = "📏 FOV Size: 250"
FOVLabel.Parent = Main

-- FOV Slider
local FOVSlider = Instance.new("TextButton")
FOVSlider.Size = UDim2.new(1, -20, 0, 25)
FOVSlider.Position = UDim2.new(0, 10, 0, 215)
FOVSlider.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
FOVSlider.Text = ""
FOVSlider.AutoButtonColor = false
FOVSlider.Parent = Main

local FOVFill = Instance.new("Frame")
FOVFill.Size = UDim2.new(0.5, 0, 1, 0)
FOVFill.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
FOVFill.BorderSizePixel = 0
FOVFill.Parent = FOVSlider

local function UpdateFOV(input)
    local x = math.clamp(
        (input.Position.X - FOVSlider.AbsolutePosition.X)
        / FOVSlider.AbsoluteSize.X,
        0,
        1
    )

    Settings.FOVRadius = math.floor(50 + x * 450)
    FOVFill.Size = UDim2.new(x, 0, 1, 0)
    FOVLabel.Text = "📏 FOV Size: " .. Settings.FOVRadius
end

FOVSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        UpdateFOV(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then

        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
            or input.UserInputType == Enum.UserInputType.Touch then
            if FOVSlider:IsAncestorOf(input.Target) then
                UpdateFOV(input)
            end
        end
    end
end)

-- Aim Strength Label
local StrengthLabel = Instance.new("TextLabel")
StrengthLabel.Size = UDim2.new(1, -20, 0, 25)
StrengthLabel.Position = UDim2.new(0, 10, 0, 245)
StrengthLabel.BackgroundTransparency = 1
StrengthLabel.TextColor3 = Color3.new(1, 1, 1)
StrengthLabel.TextSize = 14
StrengthLabel.Font = Enum.Font.Gotham
StrengthLabel.Text = "🎚️ Aim Strength: 50%"
StrengthLabel.Parent = Main

-- Aim Strength Slider
local StrengthSlider = Instance.new("TextButton")
StrengthSlider.Size = UDim2.new(1, -20, 0, 25)
StrengthSlider.Position = UDim2.new(0, 10, 0, 277)
StrengthSlider.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
StrengthSlider.Text = ""
StrengthSlider.AutoButtonColor = false
StrengthSlider.Parent = Main

local StrengthFill = Instance.new("Frame")
StrengthFill.Size = UDim2.new(Settings.AimStrength, 0, 1, 0)
StrengthFill.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
StrengthFill.BorderSizePixel = 0
StrengthFill.Parent = StrengthSlider

local function UpdateStrength(input)
    local x = math.clamp(
        (input.Position.X - StrengthSlider.AbsolutePosition.X)
        / StrengthSlider.AbsoluteSize.X,
        0,
        1
    )

    -- 0.00 = 0%
    -- 1.00 = 100%
    Settings.AimStrength = x

    StrengthFill.Size = UDim2.new(x, 0, 1, 0)
    StrengthLabel.Text =
        "🎚️ Aim Strength: " .. math.floor(x * 100) .. "%"
end

StrengthSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        UpdateStrength(input)
    end
end)

-- FOV Circle
local FOVCircle = Drawing and Drawing.new("Circle")

if FOVCircle then
    FOVCircle.Visible = false
    FOVCircle.Thickness = 2
    FOVCircle.NumSides = 64
    FOVCircle.Radius = Settings.FOVRadius
end

-- Visibility check
local function IsVisible(part)
    if not Settings.WallCheck then
        return true
    end

    local Character = part.Parent
    if not Character then
        return false
    end

    local Origin = Camera.CFrame.Position
    local Direction = part.Position - Origin

    local Params = RaycastParams.new()
    Params.FilterType = Enum.RaycastFilterType.Exclude
    Params.FilterDescendantsInstances = {
        LocalPlayer.Character
    }

    local Result = workspace:Raycast(
        Origin,
        Direction,
        Params
    )

    return Result and Result.Instance:IsDescendantOf(Character)
end

-- Find closest HEAD only
local function GetClosestTarget()
    local Closest = nil
    local ClosestDistance = Settings.FOVRadius

    local ScreenCenter = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character

            if Character then
                -- HEAD ONLY
                local Head = Character:FindFirstChild("Head")

                if Head then
                    local ScreenPosition, OnScreen =
                        Camera:WorldToViewportPoint(Head.Position)

                    if OnScreen then
                        local Distance =
                            (Vector2.new(
                                ScreenPosition.X,
                                ScreenPosition.Y
                            ) - ScreenCenter).Magnitude

                        if Distance < ClosestDistance then
                            if IsVisible(Head) then
                                ClosestDistance = Distance
                                Closest = Head
                            end
                        end
                    end
                end
            end
        end
    end

    return Closest
end

-- Aim at HEAD
local function AimAt(Head)
    if not Head then
        return
    end

    if Settings.AimStrength <= 0 then
        return
    end

    local CameraPosition = Camera.CFrame.Position

    local TargetCFrame = CFrame.lookAt(
        CameraPosition,
        Head.Position
    )

    Camera.CFrame = Camera.CFrame:Lerp(
        TargetCFrame,
        Settings.AimStrength
    )
end

-- Minimize
local Minimized = false

Minimize.Activated:Connect(function()
    Minimized = not Minimized

    for _, Object in ipairs(Main:GetChildren()) do
        if Object ~= Title and Object ~= Minimize then
            Object.Visible = not Minimized
        end
    end

    Minimize.Text = Minimized and "+" or "—"
end)

-- Restore button
local Restore = Instance.new("TextButton")
Restore.Size = UDim2.new(0, 55, 0, 40)
Restore.Position = UDim2.new(0, 10, 0.5, -20)
Restore.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Restore.TextColor3 = Color3.new(1, 1, 1)
Restore.TextSize = 18
Restore.Text = "🎯"
Restore.Visible = false
Restore.Parent = Gui

local RestoreCorner = Instance.new("UICorner")
RestoreCorner.CornerRadius = UDim.new(0, 8)
RestoreCorner.Parent = Restore

Restore.Activated:Connect(function()
    Minimized = false
    Main.Visible = true
    Restore.Visible = false

    for _, Object in ipairs(Main:GetChildren()) do
        Object.Visible = true
    end
end)

-- Fix minimize/restore visibility
Minimize.Activated:Connect(function()
    Main.Visible = not Minimized
    Restore.Visible = Minimized
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    if FOVCircle then
        FOVCircle.Visible = Settings.FOVEnabled
        FOVCircle.Position = Vector2.new(
            Camera.ViewportSize.X / 2,
            Camera.ViewportSize.Y / 2
        )
        FOVCircle.Radius = Settings.FOVRadius
    end

    if Settings.Enabled then
        local Target = GetClosestTarget()

        if Target then
            AimAt(Target)
        end
    end
end)