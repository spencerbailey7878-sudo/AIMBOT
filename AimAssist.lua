--[[
    MOBILE HEAD AIM ASSIST
    For your own Roblox game

    Includes:
    • Head-only targeting
    • Aim Assist ON/OFF
    • Wall Check ON/OFF
    • FOV Circle ON/OFF
    • FOV slider
    • Aim Strength 0–100%
    • Polished mobile UI
    • Minimize / restore
    • Draggable minimized button
    • Mobile touch controls
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--------------------------------------------------
-- SETTINGS
--------------------------------------------------

local Settings = {
    Enabled = false,
    WallCheck = true,
    FOVEnabled = true,

    FOVRadius = 250,
    AimStrength = 0.50
}

--------------------------------------------------
-- COLORS
--------------------------------------------------

local BG = Color3.fromRGB(12, 14, 19)
local PANEL = Color3.fromRGB(20, 23, 30)
local CARD = Color3.fromRGB(27, 30, 39)
local CARD_HOVER = Color3.fromRGB(34, 38, 49)

local TEXT = Color3.fromRGB(245, 247, 250)
local SUBTEXT = Color3.fromRGB(145, 151, 164)

local ACCENT = Color3.fromRGB(80, 170, 255)
local ACCENT_DARK = Color3.fromRGB(45, 115, 190)
local OFF = Color3.fromRGB(55, 59, 69)

--------------------------------------------------
-- HELPERS
--------------------------------------------------

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function Tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.15,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    ):Play()
end

--------------------------------------------------
-- GUI
--------------------------------------------------

local Gui = Instance.new("ScreenGui")
Gui.Name = "HeadAimAssist"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

--------------------------------------------------
-- MAIN PANEL
--------------------------------------------------

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 310, 0, 440)
Main.Position = UDim2.new(0.5, -155, 0.5, -220)
Main.BackgroundColor3 = BG
Main.BorderSizePixel = 0
Main.Parent = Gui

Corner(Main, 16)
Stroke(Main, Color3.fromRGB(65, 70, 82), 0.5, 1)

--------------------------------------------------
-- HEADER
--------------------------------------------------

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 72)
Header.BackgroundColor3 = PANEL
Header.BorderSizePixel = 0
Header.Parent = Main

Corner(Header, 16)

local HeaderBottom = Instance.new("Frame")
HeaderBottom.Size = UDim2.new(1, 0, 0, 18)
HeaderBottom.Position = UDim2.new(0, 0, 1, -18)
HeaderBottom.BackgroundColor3 = PANEL
HeaderBottom.BorderSizePixel = 0
HeaderBottom.Parent = Header

local Logo = Instance.new("Frame")
Logo.Size = UDim2.new(0, 42, 0, 42)
Logo.Position = UDim2.new(0, 15, 0, 15)
Logo.BackgroundColor3 = ACCENT_DARK
Logo.Parent = Header

Corner(Logo, 12)

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "A"
LogoText.TextColor3 = TEXT
LogoText.TextSize = 22
LogoText.Font = Enum.Font.GothamBold
LogoText.Parent = Logo

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 180, 0, 25)
Title.Position = UDim2.new(0, 67, 0, 14)
Title.BackgroundTransparency = 1
Title.Text = "AIM CONTROL"
Title.TextColor3 = TEXT
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0, 180, 0, 20)
Subtitle.Position = UDim2.new(0, 67, 0, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Mobile configuration"
Subtitle.TextColor3 = SUBTEXT
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 34, 0, 34)
Minimize.Position = UDim2.new(1, -48, 0, 19)
Minimize.BackgroundColor3 = CARD
Minimize.Text = "−"
Minimize.TextColor3 = TEXT
Minimize.TextSize = 22
Minimize.Font = Enum.Font.GothamBold
Minimize.AutoButtonColor = false
Minimize.Parent = Header

Corner(Minimize, 10)

--------------------------------------------------
-- STATUS
--------------------------------------------------

local StatusCard = Instance.new("Frame")
StatusCard.Size = UDim2.new(1, -30, 0, 55)
StatusCard.Position = UDim2.new(0, 15, 0, 87)
StatusCard.BackgroundColor3 = CARD
StatusCard.BorderSizePixel = 0
StatusCard.Parent = Main

Corner(StatusCard, 12)

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 9, 0, 9)
StatusDot.Position = UDim2.new(0, 15, 0.5, -4)
StatusDot.BackgroundColor3 = OFF
StatusDot.Parent = StatusCard

Corner(StatusDot, 9)

local StatusTitle = Instance.new("TextLabel")
StatusTitle.Size = UDim2.new(0, 150, 0, 20)
StatusTitle.Position = UDim2.new(0, 35, 0, 8)
StatusTitle.BackgroundTransparency = 1
StatusTitle.Text = "SYSTEM STATUS"
StatusTitle.TextColor3 = SUBTEXT
StatusTitle.TextSize = 10
StatusTitle.Font = Enum.Font.GothamBold
StatusTitle.TextXAlignment = Enum.TextXAlignment.Left
StatusTitle.Parent = StatusCard

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0, 150, 0, 20)
StatusText.Position = UDim2.new(0, 35, 0, 27)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Inactive"
StatusText.TextColor3 = TEXT
StatusText.TextSize = 13
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusCard

--------------------------------------------------
-- TOGGLE FUNCTION
--------------------------------------------------

local function CreateToggle(parent, y, title, subtitle, initialValue)

    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -30, 0, 58)
    Card.Position = UDim2.new(0, 15, 0, y)
    Card.BackgroundColor3 = CARD
    Card.BorderSizePixel = 0
    Card.Parent = parent

    Corner(Card, 12)

    local MainText = Instance.new("TextLabel")
    MainText.Size = UDim2.new(1, -90, 0, 21)
    MainText.Position = UDim2.new(0, 14, 0, 8)
    MainText.BackgroundTransparency = 1
    MainText.Text = title
    MainText.TextColor3 = TEXT
    MainText.TextSize = 13
    MainText.Font = Enum.Font.GothamMedium
    MainText.TextXAlignment = Enum.TextXAlignment.Left
    MainText.Parent = Card

    local SubText = Instance.new("TextLabel")
    SubText.Size = UDim2.new(1, -90, 0, 17)
    SubText.Position = UDim2.new(0, 14, 0, 30)
    SubText.BackgroundTransparency = 1
    SubText.Text = subtitle
    SubText.TextColor3 = SUBTEXT
    SubText.TextSize = 10
    SubText.Font = Enum.Font.Gotham
    SubText.TextXAlignment = Enum.TextXAlignment.Left
    SubText.Parent = Card

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 46, 0, 25)
    Switch.Position = UDim2.new(1, -60, 0.5, -12)
    Switch.BackgroundColor3 = initialValue and ACCENT_DARK or OFF
    Switch.Text = ""
    Switch.AutoButtonColor = false
    Switch.Parent = Card

    Corner(Switch, 15)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 19, 0, 19)
    Knob.Position = initialValue
        and UDim2.new(1, -22, 0.5, -9)
        or UDim2.new(0, 3, 0.5, -9)
    Knob.BackgroundColor3 = TEXT
    Knob.Parent = Switch

    Corner(Knob, 10)

    local Value = initialValue

    Switch.Activated:Connect(function()

        Value = not Value

        Tween(Switch, {
            BackgroundColor3 = Value and ACCENT_DARK or OFF
        })

        Tween(Knob, {
            Position = Value
                and UDim2.new(1, -22, 0.5, -9)
                or UDim2.new(0, 3, 0.5, -9)
        })

    end)

    return {
        Card = Card,
        Switch = Switch,

        Get = function()
            return Value
        end,

        Set = function(newValue)

            Value = newValue

            Switch.BackgroundColor3 =
                Value and ACCENT_DARK or OFF

            Knob.Position =
                Value
                and UDim2.new(1, -22, 0.5, -9)
                or UDim2.new(0, 3, 0.5, -9)
        end
    }
end

--------------------------------------------------
-- SETTINGS SECTION
--------------------------------------------------

local Section = Instance.new("TextLabel")
Section.Size = UDim2.new(1, -30, 0, 20)
Section.Position = UDim2.new(0, 15, 0, 153)
Section.BackgroundTransparency = 1
Section.Text = "AIM SETTINGS"
Section.TextColor3 = SUBTEXT
Section.TextSize = 10
Section.Font = Enum.Font.GothamBold
Section.TextXAlignment = Enum.TextXAlignment.Left
Section.Parent = Main

local AimToggle = CreateToggle(
    Main,
    177,
    "Aim Assist",
    "Enable camera assistance",
    Settings.Enabled
)

local WallToggle = CreateToggle(
    Main,
    242,
    "Wall Check",
    "Only use visible targets",
    Settings.WallCheck
)

local FOVToggle = CreateToggle(
    Main,
    307,
    "FOV Circle",
    "Show targeting radius",
    Settings.FOVEnabled
)

--------------------------------------------------
-- FOV / STRENGTH DISPLAY
--------------------------------------------------

local FOVInfo = Instance.new("TextLabel")
FOVInfo.Size = UDim2.new(0, 130, 0, 20)
FOVInfo.Position = UDim2.new(0, 15, 0, 374)
FOVInfo.BackgroundTransparency = 1
FOVInfo.Text = "FOV: 250"
FOVInfo.TextColor3 = TEXT
FOVInfo.TextSize = 11
FOVInfo.Font = Enum.Font.GothamMedium
FOVInfo.TextXAlignment = Enum.TextXAlignment.Left
FOVInfo.Parent = Main

local StrengthInfo = Instance.new("TextLabel")
StrengthInfo.Size = UDim2.new(0, 150, 0, 20)
StrengthInfo.Position = UDim2.new(1, -165, 0, 374)
StrengthInfo.BackgroundTransparency = 1
StrengthInfo.Text = "Strength: 50%"
StrengthInfo.TextColor3 = TEXT
StrengthInfo.TextSize = 11
StrengthInfo.Font = Enum.Font.GothamMedium
StrengthInfo.TextXAlignment = Enum.TextXAlignment.Right
StrengthInfo.Parent = Main

--------------------------------------------------
-- FOV SLIDER
--------------------------------------------------

local FOVSlider = Instance.new("TextButton")
FOVSlider.Size = UDim2.new(1, -30, 0, 8)
FOVSlider.Position = UDim2.new(0, 15, 0, 399)
FOVSlider.BackgroundColor3 = OFF
FOVSlider.Text = ""
FOVSlider.AutoButtonColor = false
FOVSlider.Parent = Main

Corner(FOVSlider, 8)

local FOVFill = Instance.new("Frame")
FOVFill.Size = UDim2.new(
    (Settings.FOVRadius - 50) / 450,
    0,
    1,
    0
)
FOVFill.BackgroundColor3 = ACCENT
FOVFill.BorderSizePixel = 0
FOVFill.Parent = FOVSlider

Corner(FOVFill, 8)

local FOVKnob = Instance.new("Frame")
FOVKnob.Size = UDim2.new(0, 16, 0, 16)
FOVKnob.AnchorPoint = Vector2.new(0.5, 0.5)
FOVKnob.Position = UDim2.new(
    (Settings.FOVRadius - 50) / 450,
    0,
    0.5,
    0
)
FOVKnob.BackgroundColor3 = TEXT
FOVKnob.Parent = FOVSlider

Corner(FOVKnob, 10)

--------------------------------------------------
-- STRENGTH SLIDER
--------------------------------------------------

local StrengthSlider = Instance.new("TextButton")
StrengthSlider.Size = UDim2.new(1, -30, 0, 8)
StrengthSlider.Position = UDim2.new(0, 15, 0, 424)
StrengthSlider.BackgroundColor3 = OFF
StrengthSlider.Text = ""
StrengthSlider.AutoButtonColor = false
StrengthSlider.Parent = Main

Corner(StrengthSlider, 8)

local StrengthFill = Instance.new("Frame")
StrengthFill.Size =
    UDim2.new(Settings.AimStrength, 0, 1, 0)

StrengthFill.BackgroundColor3 = ACCENT
StrengthFill.BorderSizePixel = 0
StrengthFill.Parent = StrengthSlider

Corner(StrengthFill, 8)

local StrengthKnob = Instance.new("Frame")
StrengthKnob.Size = UDim2.new(0, 16, 0, 16)
StrengthKnob.AnchorPoint = Vector2.new(0.5, 0.5)
StrengthKnob.Position = UDim2.new(
    Settings.AimStrength,
    0,
    0.5,
    0
)
StrengthKnob.BackgroundColor3 = TEXT
StrengthKnob.Parent = StrengthSlider

Corner(StrengthKnob, 10)

--------------------------------------------------
-- SLIDER LOGIC
--------------------------------------------------

local FOVDragging = false
local StrengthDragging = false

local function SetFOVFromInput(input)

    local x = math.clamp(
        (
            input.Position.X
            - FOVSlider.AbsolutePosition.X
        ) / FOVSlider.AbsoluteSize.X,
        0,
        1
    )

    Settings.FOVRadius =
        math.floor(50 + x * 450)

    FOVFill.Size =
        UDim2.new(x, 0, 1, 0)

    FOVKnob.Position =
        UDim2.new(x, 0, 0.5, 0)

    FOVInfo.Text =
        "FOV: " .. Settings.FOVRadius
end

local function SetStrengthFromInput(input)

    local x = math.clamp(
        (
            input.Position.X
            - StrengthSlider.AbsolutePosition.X
        ) / StrengthSlider.AbsoluteSize.X,
        0,
        1
    )

    Settings.AimStrength = x

    StrengthFill.Size =
        UDim2.new(x, 0, 1, 0)

    StrengthKnob.Position =
        UDim2.new(x, 0, 0.5, 0)

    StrengthInfo.Text =
        "Strength: " .. math.floor(x * 100) .. "%"
end

FOVSlider.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        FOVDragging = true
        SetFOVFromInput(input)
    end
end)

StrengthSlider.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        StrengthDragging = true
        SetStrengthFromInput(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        FOVDragging = false
        StrengthDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if FOVDragging then

        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement then

            SetFOVFromInput(input)
        end
    end

    if StrengthDragging then

        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement then

            SetStrengthFromInput(input)
        end
    end
end)

--------------------------------------------------
-- FOV CIRCLE
-- Uses a normal Roblox GUI circle.
--------------------------------------------------

local FOVCircle = Instance.new("Frame")
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Parent = Gui

Corner(FOVCircle, 999)

local FOVStroke =
    Instance.new("UIStroke")

FOVStroke.Color = ACCENT
FOVStroke.Thickness = 2
FOVStroke.Transparency = 0.15
FOVStroke.Parent = FOVCircle

--------------------------------------------------
-- TARGETING
--------------------------------------------------

local function GetCamera()
    return workspace.CurrentCamera
end

local function IsVisible(head)

    if not Settings.WallCheck then
        return true
    end

    local Camera = GetCamera()

    local Character = head.Parent

    if not Character then
        return false
    end

    local Origin = Camera.CFrame.Position
    local Direction = head.Position - Origin

    local Params = RaycastParams.new()

    Params.FilterType =
        Enum.RaycastFilterType.Exclude

    Params.FilterDescendantsInstances = {
        LocalPlayer.Character
    }

    local Result =
        workspace:Raycast(
            Origin,
            Direction,
            Params
        )

    return Result ~= nil
        and Result.Instance:IsDescendantOf(Character)
end

local function GetClosestTarget()

    local Camera = GetCamera()

    local Center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    local Closest = nil
    local ClosestDistance = Settings.FOVRadius

    for _, Player in ipairs(Players:GetPlayers()) do

        if Player ~= LocalPlayer then

            local Character = Player.Character

            if Character then

                local Head =
                    Character:FindFirstChild("Head")

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
                                ) - Center
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

--------------------------------------------------
-- AIM
--------------------------------------------------

local function AimAt(head)

    if not head then
        return
    end

    if Settings.AimStrength <= 0 then
        return
    end

    local Camera = GetCamera()

    local TargetCFrame =
        CFrame.lookAt(
            Camera.CFrame.Position,
            head.Position
        )

    Camera.CFrame =
        Camera.CFrame:Lerp(
            TargetCFrame,
            Settings.AimStrength
        )
end

--------------------------------------------------
-- STATUS
--------------------------------------------------

local function UpdateStatus()

    Settings.Enabled = AimToggle.Get()
    Settings.WallCheck = WallToggle.Get()
    Settings.FOVEnabled = FOVToggle.Get()

    if Settings.Enabled then

        StatusText.Text = "Active"
        StatusText.TextColor3 = ACCENT

        Tween(StatusDot, {
            BackgroundColor3 = ACCENT
        })

    else

        StatusText.Text = "Inactive"
        StatusText.TextColor3 = TEXT

        Tween(StatusDot, {
            BackgroundColor3 = OFF
        })
    end
end

AimToggle.Switch.Activated:Connect(UpdateStatus)
WallToggle.Switch.Activated:Connect(UpdateStatus)
FOVToggle.Switch.Activated:Connect(UpdateStatus)

--------------------------------------------------
-- MINIMIZED BUTTON
--------------------------------------------------

local Restore = Instance.new("TextButton")
Restore.Size = UDim2.new(0, 52, 0, 52)
Restore.Position = UDim2.new(0, 15, 0.5, -26)
Restore.BackgroundColor3 = PANEL
Restore.Text = "A"
Restore.TextColor3 = TEXT
Restore.TextSize = 21
Restore.Font = Enum.Font.GothamBold
Restore.AutoButtonColor = false
Restore.Visible = false
Restore.Parent = Gui

Corner(Restore, 15)
Stroke(Restore, ACCENT, 0.3, 1)

--------------------------------------------------
-- DRAG RESTORE BUTTON
--------------------------------------------------

local Dragging = false
local DragStart
local StartPosition
local Moved = false

Restore.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        Dragging = true
        Moved = false

        DragStart = input.Position
        StartPosition = Restore.Position

        input.Changed:Connect(function()

            if input.UserInputState ==
                Enum.UserInputState.End then

                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not Dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then

        local Delta =
            input.Position - DragStart

        if Delta.Magnitude > 5 then
            Moved = true
        end

        Restore.Position =
            UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,

                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
    end
end)

--------------------------------------------------
-- MINIMIZE / RESTORE
--------------------------------------------------

local Minimized = false

Minimize.Activated:Connect(function()

    Minimized = true

    Main.Visible = false
    Restore.Visible = true
end)

Restore.Activated:Connect(function()

    if Moved then
        return
    end

    Minimized = false

    Main.Visible = true
    Restore.Visible = false
end)

--------------------------------------------------
-- RENDER LOOP
--------------------------------------------------

RunService.RenderStepped:Connect(function()

    local Camera = GetCamera()

    ------------------------------------------------
    -- FOV CIRCLE
    ------------------------------------------------

    local Center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    FOVCircle.Position =
        UDim2.fromOffset(
            Center.X,
            Center.Y
        )

    FOVCircle.Size =
        UDim2.fromOffset(
            Settings.FOVRadius * 2,
            Settings.FOVRadius * 2
        )

    FOVCircle.Visible =
        Settings.FOVEnabled

    ------------------------------------------------
    -- AIM
    ------------------------------------------------

    if Settings.Enabled then

        local Target =
            GetClosestTarget()

        if Target then
            AimAt(Target)
        end
    end
end)

--------------------------------------------------
-- INITIAL UPDATE
--------------------------------------------------

UpdateStatus()