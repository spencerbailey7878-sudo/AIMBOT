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

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "HeadAimAssist"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Smaller main menu
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(235, 280)
Main.Position = UDim2.new(0.5, -117, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(18, 20, 25)
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(55, 60, 70)
MainStroke.Thickness = 1
MainStroke.Parent = Main

-- Header / drag area
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(13, 6)
Title.Size = UDim2.new(1, -60, 0, 20)
Title.Font = Enum.Font.GothamBold
Title.Text = "AIM CONTROL"
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(245, 247, 250)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Status = Instance.new("TextLabel")
Status.BackgroundTransparency = 1
Status.Position = UDim2.fromOffset(13, 27)
Status.Size = UDim2.new(1, -60, 0, 14)
Status.Font = Enum.Font.GothamMedium
Status.Text = "●  DISABLED"
Status.TextSize = 8
Status.TextColor3 = Color3.fromRGB(145, 150, 160)
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Header

-- Minimize button
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(28, 28)
Minimize.Position = UDim2.new(1, -36, 0, 10)
Minimize.BackgroundColor3 = Color3.fromRGB(40, 44, 52)
Minimize.Text = "—"
Minimize.TextColor3 = Color3.fromRGB(230, 233, 238)
Minimize.TextSize = 15
Minimize.Font = Enum.Font.GothamBold
Minimize.AutoButtonColor = false
Minimize.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = Minimize

-- Content
local Content = Instance.new("Frame")
Content.BackgroundTransparency = 1
Content.Position = UDim2.fromOffset(10, 56)
Content.Size = UDim2.new(1, -20, 1, -65)
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

--==================================================
-- TOGGLES
--==================================================

local function CreateToggle(text, enabled, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 34)
    Row.BackgroundColor3 = Color3.fromRGB(27, 30, 37)
    Row.BorderSizePixel = 0
    Row.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.fromOffset(10, 0)
    Label.Size = UDim2.new(1, -58, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextSize = 10
    Label.TextColor3 = Color3.fromRGB(225, 228, 233)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.fromOffset(36, 19)
    Toggle.Position = UDim2.new(1, -46, 0.5, -9)
    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Row

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = Toggle

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.fromOffset(15, 15)
    Knob.BackgroundColor3 = Color3.fromRGB(245, 246, 248)
    Knob.BorderSizePixel = 0
    Knob.Parent = Toggle

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local State = enabled

    local function Update()
        if State then
            Toggle.BackgroundColor3 = Color3.fromRGB(70, 145, 255)
            Knob.Position = UDim2.new(1, -17, 0.5, -7)
        else
            Toggle.BackgroundColor3 = Color3.fromRGB(58, 62, 70)
            Knob.Position = UDim2.fromOffset(2, 2)
        end

        callback(State)
    end

    Toggle.Activated:Connect(function()
        State = not State
        Update()
    end)

    Update()
end

CreateToggle("🎯  Aim Assist", Settings.Enabled, function(value)
    Settings.Enabled = value

    if value then
        Status.Text = "●  ENABLED"
        Status.TextColor3 = Color3.fromRGB(85, 175, 255)
    else
        Status.Text = "●  DISABLED"
        Status.TextColor3 = Color3.fromRGB(145, 150, 160)
    end
end)

CreateToggle("👁  Wall Check", Settings.WallCheck, function(value)
    Settings.WallCheck = value
end)

CreateToggle("⭕  FOV Circle", Settings.FOVEnabled, function(value)
    Settings.FOVEnabled = value
end)

--==================================================
-- SLIDERS
--==================================================

local function CreateSlider(title, minimum, maximum, current, suffix, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 43)
    Row.BackgroundColor3 = Color3.fromRGB(27, 30, 37)
    Row.BorderSizePixel = 0
    Row.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.fromOffset(10, 4)
    Label.Size = UDim2.new(0.65, 0, 0, 15)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = title
    Label.TextSize = 9
    Label.TextColor3 = Color3.fromRGB(220, 223, 229)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Value = Instance.new("TextLabel")
    Value.BackgroundTransparency = 1
    Value.Position = UDim2.new(0.65, 0, 0, 4)
    Value.Size = UDim2.new(0.3, -4, 0, 15)
    Value.Font = Enum.Font.GothamBold
    Value.TextSize = 9
    Value.TextColor3 = Color3.fromRGB(100, 175, 255)
    Value.TextXAlignment = Enum.TextXAlignment.Right
    Value.Parent = Row

    local Bar = Instance.new("TextButton")
    Bar.Size = UDim2.new(1, -20, 0, 6)
    Bar.Position = UDim2.fromOffset(10, 29)
    Bar.BackgroundColor3 = Color3.fromRGB(55, 59, 68)
    Bar.BorderSizePixel = 0
    Bar.Text = ""
    Bar.AutoButtonColor = false
    Bar.Parent = Row

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.BackgroundColor3 = Color3.fromRGB(70, 145, 255)
    Fill.BorderSizePixel = 0
    Fill.Size = UDim2.fromScale(0, 1)
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Size = UDim2.fromOffset(12, 12)
    Knob.BackgroundColor3 = Color3.fromRGB(245, 247, 250)
    Knob.BorderSizePixel = 0
    Knob.Parent = Bar

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local dragging = false

    local function SetValue(x)
        local percent = math.clamp(
            (x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
            0,
            1
        )

        local number = minimum + (maximum - minimum) * percent
        number = math.floor(number + 0.5)

        Fill.Size = UDim2.fromScale(percent, 1)
        Knob.Position = UDim2.new(percent, 0, 0.5, 0)
        Value.Text = tostring(number) .. suffix

        callback(number)
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then

            dragging = true
            SetValue(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.Touch
                or input.UserInputType == Enum.UserInputType.MouseMovement then

                SetValue(input.Position.X)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then

            dragging = false
        end
    end)

    local initialPercent =
        (current - minimum) / (maximum - minimum)

    Fill.Size = UDim2.fromScale(initialPercent, 1)
    Knob.Position = UDim2.new(initialPercent, 0, 0.5, 0)
    Value.Text = tostring(current) .. suffix
end

CreateSlider(
    "📏  FOV Size",
    50,
    500,
    Settings.FOVRadius,
    "",
    function(value)
        Settings.FOVRadius = value
    end
)

CreateSlider(
    "🎚  Aim Strength",
    0,
    100,
    Settings.AimStrength * 100,
    "%",
    function(value)
        Settings.AimStrength = value / 100
    end
)

--==================================================
-- DRAGGING
--==================================================

local function MakeDraggable(object, handle)
    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then

            dragging = true
            dragStart = input.Position
            startPosition = object.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement then

            local delta = input.Position - dragStart

            object.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then

            dragging = false
        end
    end)
end

-- Drag the menu using the header
MakeDraggable(Main, Header)

--==================================================
-- MINIMIZED BUTTON
--==================================================

local Restore = Instance.new("TextButton")
Restore.Name = "Restore"
Restore.Size = UDim2.fromOffset(46, 46)
Restore.Position = UDim2.new(0, 18, 0.5, -23)
Restore.BackgroundColor3 = Color3.fromRGB(20, 23, 29)
Restore.Text = "A"
Restore.TextColor3 = Color3.fromRGB(95, 175, 255)
Restore.TextSize = 18
Restore.Font = Enum.Font.GothamBold
Restore.AutoButtonColor = false
Restore.Visible = false
Restore.Parent = Gui

local RestoreCorner = Instance.new("UICorner")
RestoreCorner.CornerRadius = UDim.new(0, 13)
RestoreCorner.Parent = Restore

local RestoreStroke = Instance.new("UIStroke")
RestoreStroke.Color = Color3.fromRGB(60, 65, 75)
RestoreStroke.Parent = Restore

-- Minimized button can also be moved
MakeDraggable(Restore, Restore)

Minimize.Activated:Connect(function()
    Main.Visible = false
    Restore.Visible = true
end)

Restore.Activated:Connect(function()
    Main.Visible = true
    Restore.Visible = false
end)

--==================================================
-- FOV CIRCLE
--==================================================

local FOVCircle

pcall(function()
    if Drawing then
        FOVCircle = Drawing.new("Circle")
    end
end)

if FOVCircle then
    FOVCircle.Visible = false
    FOVCircle.Thickness = 2
    FOVCircle.NumSides = 64
    FOVCircle.Radius = Settings.FOVRadius
end

--==================================================
-- VISIBILITY CHECK
--==================================================

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

    return Result
        and Result.Instance
        and Result.Instance:IsDescendantOf(Character)
end

--==================================================
-- FIND CLOSEST HEAD
--==================================================

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
                        Camera:WorldToViewportPoint(
                            Head.Position
                        )

                    if OnScreen then

                        local Distance =
                            (
                                Vector2.new(
                                    ScreenPosition.X,
                                    ScreenPosition.Y
                                ) - ScreenCenter
                            ).Magnitude

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

--==================================================
-- AIM AT HEAD
--==================================================

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

--==================================================
-- MAIN LOOP
--==================================================

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