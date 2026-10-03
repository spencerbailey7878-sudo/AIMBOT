-- AIM CONTROL - Mobile UI
-- Intended for your own Roblox game

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// SETTINGS
local Enabled = false
local WallCheck = true
local FOVEnabled = true

local FOVRadius = 250
local AimStrength = 0.50

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimControl"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Smaller overall menu
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(270, 285)
Main.Position = UDim2.new(0.5, -135, 0.5, -142)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(55, 55, 65)
MainStroke.Thickness = 1
MainStroke.Parent = Main

--// HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(27, 27, 34)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.BackgroundTransparency = 1
Header.Position = UDim2.fromOffset(15, 5)
Header.Size = UDim2.new(1, -70, 0, 24)
Header.Font = Enum.Font.GothamBold
Header.Text = "AIM CONTROL"
Header.TextSize = 14
Header.TextColor3 = Color3.fromRGB(240, 240, 245)
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = Header

local Status = Instance.new("TextLabel")
Status.BackgroundTransparency = 1
Status.Position = UDim2.fromOffset(15, 26)
Status.Size = UDim2.new(1, -70, 0, 16)
Status.Font = Enum.Font.Gotham
Status.Text = "● DISABLED"
Status.TextSize = 9
Status.TextColor3 = Color3.fromRGB(150, 150, 160)
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Header

--// MINIMIZE
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(30, 30)
Minimize.Position = UDim2.new(1, -38, 0, 9)
Minimize.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
Minimize.Text = "—"
Minimize.TextColor3 = Color3.fromRGB(220, 220, 225)
Minimize.TextSize = 16
Minimize.Font = Enum.Font.GothamBold
Minimize.AutoButtonColor = false
Minimize.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 9)
MinCorner.Parent = Minimize

--// CONTENT
local Content = Instance.new("Frame")
Content.BackgroundTransparency = 1
Content.Position = UDim2.fromOffset(12, 56)
Content.Size = UDim2.new(1, -24, 1, -65)
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 7)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

--// TOGGLE CREATOR
local function createToggle(text, default, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 38)
    Row.BackgroundColor3 = Color3.fromRGB(27, 27, 34)
    Row.BorderSizePixel = 0
    Row.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.fromOffset(11, 0)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextSize = 11
    Label.TextColor3 = Color3.fromRGB(225, 225, 230)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.fromOffset(38, 20)
    Toggle.Position = UDim2.new(1, -48, 0.5, -10)
    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Row

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = Toggle

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.fromOffset(16, 16)
    Knob.BorderSizePixel = 0
    Knob.Parent = Toggle

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local State = default

    local function update()
        Toggle.BackgroundColor3 = State
            and Color3.fromRGB(70, 140, 255)
            or Color3.fromRGB(55, 55, 63)

        Knob.Position = State
            and UDim2.new(1, -18, 0.5, -8)
            or UDim2.fromOffset(2, 2)

        Knob.BackgroundColor3 = Color3.fromRGB(245, 245, 248)
        callback(State)
    end

    Toggle.MouseButton1Click:Connect(function()
        State = not State
        update()
    end)

    update()

    return Row
end

createToggle("Aim Assist", Enabled, function(value)
    Enabled = value

    if value then
        Status.Text = "● ENABLED"
        Status.TextColor3 = Color3.fromRGB(80, 180, 255)
    else
        Status.Text = "● DISABLED"
        Status.TextColor3 = Color3.fromRGB(150, 150, 160)
    end
end)

createToggle("Wall Check", WallCheck, function(value)
    WallCheck = value
end)

createToggle("FOV Circle", FOVEnabled, function(value)
    FOVEnabled = value
end)

--// SLIDER CREATOR
local function createSlider(text, minValue, maxValue, currentValue, callback, suffix)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 46)
    Row.BackgroundColor3 = Color3.fromRGB(27, 27, 34)
    Row.BorderSizePixel = 0
    Row.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.fromOffset(11, 5)
    Label.Size = UDim2.new(0.6, 0, 0, 16)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextSize = 10
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(0.6, 0, 0, 5)
    ValueLabel.Size = UDim2.new(0.35, 0, 0, 16)
    ValueLabel.Font = Enum.Font.GothamMedium
    ValueLabel.TextSize = 10
    ValueLabel.TextColor3 = Color3.fromRGB(130, 180, 255)
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Row

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -22, 0, 5)
    Bar.Position = UDim2.fromOffset(11, 31)
    Bar.BackgroundColor3 = Color3.fromRGB(55, 55, 63)
    Bar.BorderSizePixel = 0
    Bar.Parent = Row

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.fromScale(0, 1)
    Fill.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local dragging = false

    local function setValueFromX(x)
        local percent = math.clamp(
            (x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
            0,
            1
        )

        local value = minValue + (maxValue - minValue) * percent
        value = math.floor(value + 0.5)

        Fill.Size = UDim2.fromScale(percent, 1)
        ValueLabel.Text = tostring(value) .. suffix

        callback(value)
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            setValueFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            setValueFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local percent = (currentValue - minValue) / (maxValue - minValue)
    Fill.Size = UDim2.fromScale(percent, 1)
    ValueLabel.Text = tostring(currentValue) .. suffix

    return Row
end

createSlider(
    "FOV Radius",
    50,
    500,
    FOVRadius,
    function(value)
        FOVRadius = value
    end,
    ""
)

createSlider(
    "Aim Strength",
    0,
    100,
    AimStrength * 100,
    function(value)
        AimStrength = value / 100
    end,
    "%"
)

--// FOV CIRCLE
local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(FOVRadius * 2, FOVRadius * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Parent = ScreenGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = FOVCircle

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(70, 140, 255)
CircleStroke.Thickness = 1
CircleStroke.Transparency = 0.25
CircleStroke.Parent = FOVCircle

--// DRAG FUNCTION
local function makeDraggable(object, dragArea)
    local dragging = false
    local dragStart
    local startPosition

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = object.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

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
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)
end

-- Header is now the menu's drag area.
-- The minimize button still works independently.
makeDraggable(Main, Header)

--// MINIMIZED BUTTON
local Restore = Instance.new("TextButton")
Restore.Name = "Restore"
Restore.Size = UDim2.fromOffset(48, 48)
Restore.Position = UDim2.new(0, 25, 0.5, -24)
Restore.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
Restore.Text = "A"
Restore.TextColor3 = Color3.fromRGB(100, 170, 255)
Restore.TextSize = 20
Restore.Font = Enum.Font.GothamBold
Restore.Visible = false
Restore.AutoButtonColor = false
Restore.Parent = ScreenGui

local RestoreCorner = Instance.new("UICorner")
RestoreCorner.CornerRadius = UDim.new(0, 14)
RestoreCorner.Parent = Restore

local RestoreStroke = Instance.new("UIStroke")
RestoreStroke.Color = Color3.fromRGB(65, 65, 75)
RestoreStroke.Parent = Restore

-- Minimized button remains draggable
makeDraggable(Restore, Restore)

--// MINIMIZE / RESTORE
Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    FOVCircle.Visible = false
    Restore.Visible = true
end)

Restore.MouseButton1Click:Connect(function()
    Main.Visible = true
    FOVCircle.Visible = FOVEnabled
    Restore.Visible = false
end)

--// AIM TARGET
local function isVisible(character)
    if not WallCheck then
        return true
    end

    local head = character:FindFirstChild("Head")

    if not head then
        return false
    end

    local origin = Camera.CFrame.Position
    local direction = head.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character}

    local result = workspace:Raycast(origin, direction, params)

    return result and result.Instance
        and result.Instance:IsDescendantOf(character)
end

local function getClosestTarget()
    local closest
    local closestDistance = math.huge

    local center = Camera.ViewportSize / 2

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
            and player.Character
            and player.Character:FindFirstChild("Head") then

            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                local head = player.Character.Head

                local screenPosition, onScreen =
                    Camera:WorldToViewportPoint(head.Position)

                if onScreen then
                    local distance = (
                        Vector2.new(screenPosition.X, screenPosition.Y)
                        - Vector2.new(center.X, center.Y)
                    ).Magnitude

                    if distance <= FOVRadius
                        and distance < closestDistance
                        and isVisible(player.Character) then

                        closest = head
                        closestDistance = distance
                    end
                end
            end
        end
    end

    return closest
end

--// AIM LOOP
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = FOVEnabled and Main.Visible

    FOVCircle.Size = UDim2.fromOffset(
        FOVRadius * 2,
        FOVRadius * 2
    )

    if not Enabled then
        return
    end

    local target = getClosestTarget()

    if target then
        local cameraPosition = Camera.CFrame.Position
        local targetCFrame = CFrame.lookAt(
            cameraPosition,
            target.Position
        )

        Camera.CFrame = Camera.CFrame:Lerp(
            targetCFrame,
            AimStrength
        )
    end
end)