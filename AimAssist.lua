--// AIM ASSIST - YOUR OWN ROBLOX EXPERIENCE
--// LocalScript
--// StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local Settings = {
	Enabled = false,
	WallCheck = true,

	FOVEnabled = true,
	FOVRadius = 150,
	MinFOV = 50,
	MaxFOV = 500,

	-- 0.05 = weaker/slower
	-- 0.50 = stronger/faster
	AimStrength = 0.15,
	MinStrength = 0.05,
	MaxStrength = 0.50,
}

--// R6 + R15
local TargetParts = {
	"Head",
	"UpperTorso",
	"LowerTorso",
	"HumanoidRootPart",

	"LeftUpperArm",
	"LeftLowerArm",
	"LeftHand",
	"RightUpperArm",
	"RightLowerArm",
	"RightHand",

	"LeftUpperLeg",
	"LeftLowerLeg",
	"LeftFoot",
	"RightUpperLeg",
	"RightLowerLeg",
	"RightFoot",

	-- R6
	"Torso",
	"Left Arm",
	"Right Arm",
	"Left Leg",
	"Right Leg",
}

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "AimAssistUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Menu = Instance.new("Frame")
Menu.Size = UDim2.fromOffset(270, 390)
Menu.Position = UDim2.new(0, 20, 0.5, -195)
Menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Menu.BorderSizePixel = 0
Menu.Parent = Gui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = Menu

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 40)
Title.Position = UDim2.fromOffset(12, 2)
Title.BackgroundTransparency = 1
Title.Text = "🎯 Aim Assist"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Menu

-- Minimize
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(35, 35)
Minimize.Position = UDim2.new(1, -40, 0, 3)
Minimize.BackgroundTransparency = 1
Minimize.Text = "—"
Minimize.TextColor3 = Color3.new(1, 1, 1)
Minimize.TextSize = 24
Minimize.Parent = Menu

-- Restore
local Restore = Instance.new("TextButton")
Restore.Size = UDim2.fromOffset(50, 50)
Restore.Position = UDim2.fromOffset(20, 100)
Restore.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Restore.Text = "☰"
Restore.TextColor3 = Color3.new(1, 1, 1)
Restore.TextSize = 23
Restore.Visible = false
Restore.Parent = Gui

local RestoreCorner = Instance.new("UICorner")
RestoreCorner.CornerRadius = UDim.new(1, 0)
RestoreCorner.Parent = Restore

Minimize.Activated:Connect(function()
	Menu.Visible = false
	Restore.Visible = true
end)

Restore.Activated:Connect(function()
	Menu.Visible = true
	Restore.Visible = false
end)

-- Button helper
local function MakeButton(text, y)
	local button = Instance.new("TextButton")

	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.fromOffset(10, y)

	button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	button.TextColor3 = Color3.new(1, 1, 1)

	button.TextSize = 15
	button.Font = Enum.Font.Gotham
	button.Text = text

	button.Parent = Menu

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button

	return button
end

--==================================================
-- AIM TOGGLE
--==================================================

local AimButton = MakeButton("Aim Assist: OFF", 48)

local function UpdateAimButton()
	if Settings.Enabled then
		AimButton.Text = "Aim Assist: ON"
		AimButton.BackgroundColor3 = Color3.fromRGB(45, 130, 65)
	else
		AimButton.Text = "Aim Assist: OFF"
		AimButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	end
end

AimButton.Activated:Connect(function()
	Settings.Enabled = not Settings.Enabled
	UpdateAimButton()
end)

--==================================================
-- WALL CHECK
--==================================================

local WallButton = MakeButton("👁 Wall Check: ON", 93)

WallButton.Activated:Connect(function()
	Settings.WallCheck = not Settings.WallCheck

	if Settings.WallCheck then
		WallButton.Text = "👁 Wall Check: ON"
	else
		WallButton.Text = "👁 Wall Check: OFF"
	end
end)

--==================================================
-- FOV TOGGLE
--==================================================

local FOVButton = MakeButton("⭕ FOV Circle: ON", 138)

FOVButton.Activated:Connect(function()
	Settings.FOVEnabled = not Settings.FOVEnabled

	if Settings.FOVEnabled then
		FOVButton.Text = "⭕ FOV Circle: ON"
	else
		FOVButton.Text = "⭕ FOV Circle: OFF"
	end
end)

--==================================================
-- FOV SLIDER
--==================================================

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(1, -20, 0, 25)
FOVLabel.Position = UDim2.fromOffset(10, 183)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV: 150"
FOVLabel.TextColor3 = Color3.new(1, 1, 1)
FOVLabel.TextSize = 14
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.Parent = Menu

local FOVSlider = Instance.new("Frame")
FOVSlider.Size = UDim2.new(1, -20, 0, 12)
FOVSlider.Position = UDim2.fromOffset(10, 215)
FOVSlider.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
FOVSlider.BorderSizePixel = 0
FOVSlider.Parent = Menu

local FOVSliderCorner = Instance.new("UICorner")
FOVSliderCorner.CornerRadius = UDim.new(1, 0)
FOVSliderCorner.Parent = FOVSlider

local FOVFill = Instance.new("Frame")
FOVFill.Size = UDim2.fromScale(0.22, 1)
FOVFill.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
FOVFill.BorderSizePixel = 0
FOVFill.Parent = FOVSlider

local FOVFillCorner = Instance.new("UICorner")
FOVFillCorner.CornerRadius = UDim.new(1, 0)
FOVFillCorner.Parent = FOVFill

local draggingFOV = false

local function UpdateFOV(input)
	local percent = math.clamp(
		(input.Position.X - FOVSlider.AbsolutePosition.X)
		/ FOVSlider.AbsoluteSize.X,
		0,
		1
	)

	Settings.FOVRadius = math.floor(
		Settings.MinFOV +
		(Settings.MaxFOV - Settings.MinFOV) * percent
	)

	FOVLabel.Text = "FOV: " .. Settings.FOVRadius
	FOVFill.Size = UDim2.fromScale(percent, 1)
end

FOVSlider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		draggingFOV = true
		UpdateFOV(input)
	end
end)

--==================================================
-- AIM STRENGTH SLIDER
--==================================================

local StrengthLabel = Instance.new("TextLabel")
StrengthLabel.Size = UDim2.new(1, -20, 0, 25)
StrengthLabel.Position = UDim2.fromOffset(10, 245)
StrengthLabel.BackgroundTransparency = 1
StrengthLabel.Text = "Aim Strength: 15%"
StrengthLabel.TextColor3 = Color3.new(1, 1, 1)
StrengthLabel.TextSize = 14
StrengthLabel.Font = Enum.Font.Gotham
StrengthLabel.Parent = Menu

local StrengthSlider = Instance.new("Frame")
StrengthSlider.Size = UDim2.new(1, -20, 0, 12)
StrengthSlider.Position = UDim2.fromOffset(10, 277)
StrengthSlider.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
StrengthSlider.BorderSizePixel = 0
StrengthSlider.Parent = Menu

local StrengthCorner = Instance.new("UICorner")
StrengthCorner.CornerRadius = UDim.new(1, 0)
StrengthCorner.Parent = StrengthSlider

local StrengthFill = Instance.new("Frame")
StrengthFill.Size = UDim2.fromScale(
	(Settings.AimStrength - Settings.MinStrength)
	/ (Settings.MaxStrength - Settings.MinStrength),
	1
)

StrengthFill.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
StrengthFill.BorderSizePixel = 0
StrengthFill.Parent = StrengthSlider

local StrengthFillCorner = Instance.new("UICorner")
StrengthFillCorner.CornerRadius = UDim.new(1, 0)
StrengthFillCorner.Parent = StrengthFill

local draggingStrength = false

local function UpdateStrength(input)
	local percent = math.clamp(
		(input.Position.X - StrengthSlider.AbsolutePosition.X)
		/ StrengthSlider.AbsoluteSize.X,
		0,
		1
	)

	Settings.AimStrength =
		Settings.MinStrength +
		(Settings.MaxStrength - Settings.MinStrength) * percent

	StrengthLabel.Text =
		"Aim Strength: "
		.. math.floor(Settings.AimStrength * 100)
		.. "%"

	StrengthFill.Size = UDim2.fromScale(percent, 1)
end

StrengthSlider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		draggingStrength = true
		UpdateStrength(input)
	end
end)

--==================================================
-- TOGGLE KEY
--==================================================

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.KeyCode == Enum.KeyCode.Q then
		Settings.Enabled = not Settings.Enabled
		UpdateAimButton()
	end
end)

--==================================================
-- FOV CIRCLE
--==================================================

local FOVCircle = Instance.new("Frame")
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 2
FOVCircle.BorderColor3 = Color3.new(1, 1, 1)
FOVCircle.Parent = Gui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = FOVCircle

--==================================================
-- VISIBILITY CHECK
--==================================================

local function IsVisible(character, targetPart)
	local camera = workspace.CurrentCamera

	if not camera or not targetPart then
		return false
	end

	local origin = camera.CFrame.Position
	local direction = targetPart.Position - origin

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {
		LocalPlayer.Character
	}

	local result = workspace:Raycast(
		origin,
		direction,
		params
	)

	if result == nil then
		return true
	end

	return result.Instance:IsDescendantOf(character)
end

--==================================================
-- FIND CLOSEST BODY PART
--==================================================

local function GetClosestBodyPart(character)
	local camera = workspace.CurrentCamera

	if not camera then
		return nil, math.huge
	end

	local center = Vector2.new(
		camera.ViewportSize.X / 2,
		camera.ViewportSize.Y / 2
	)

	local closestPart = nil
	local closestDistance = math.huge

	for _, partName in ipairs(TargetParts) do
		local part = character:FindFirstChild(partName)

		if part and part:IsA("BasePart") then
			local screenPosition, onScreen =
				camera:WorldToViewportPoint(part.Position)

			if onScreen and screenPosition.Z > 0 then

				local screenPoint = Vector2.new(
					screenPosition.X,
					screenPosition.Y
				)

				local distance =
					(screenPoint - center).Magnitude

				if distance <= Settings.FOVRadius
					and distance < closestDistance then

					if not Settings.WallCheck
						or IsVisible(character, part) then

						closestPart = part
						closestDistance = distance
					end
				end
			end
		end
	end

	return closestPart, closestDistance
end

--==================================================
-- FIND NEAREST TARGET
--==================================================

local function GetClosestTarget()
	local closestPart = nil
	local closestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then

			local character = player.Character

			if character then

				local humanoid =
					character:FindFirstChildOfClass("Humanoid")

				if humanoid and humanoid.Health > 0 then

					local part, distance =
						GetClosestBodyPart(character)

					if part and distance < closestDistance then
						closestPart = part
						closestDistance = distance
					end
				end
			end
		end
	end

	return closestPart
end

--==================================================
-- SMOOTH AIM
--==================================================

local function AimAt(targetPart)
	local camera = workspace.CurrentCamera

	if not camera or not targetPart then
		return
	end

	local targetCFrame = CFrame.lookAt(
		camera.CFrame.Position,
		targetPart.Position
	)

	camera.CFrame = camera.CFrame:Lerp(
		targetCFrame,
		Settings.AimStrength
	)
end

--==================================================
-- INPUT DRAGGING
--==================================================

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseMovement then

		if draggingFOV then
			UpdateFOV(input)
		end

		if draggingStrength then
			UpdateStrength(input)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		draggingFOV = false
		draggingStrength = false
	end
end)

--==================================================
-- DRAG MENU
--==================================================

local draggingMenu = false
local dragStart
local menuStart

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		draggingMenu = true
		dragStart = input.Position
		menuStart = Menu.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingMenu then
		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseMovement then

			local delta = input.Position - dragStart

			Menu.Position = UDim2.new(
				menuStart.X.Scale,
				menuStart.X.Offset + delta.X,
				menuStart.Y.Scale,
				menuStart.Y.Offset + delta.Y
			)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		draggingMenu = false
	end
end)

--==================================================
-- MAIN LOOP
--==================================================

RunService.RenderStepped:Connect(function()

	local camera = workspace.CurrentCamera

	if not camera then
		return
	end

	-- FOV
	FOVCircle.Visible = Settings.FOVEnabled

	if Settings.FOVEnabled then
		FOVCircle.Size = UDim2.fromOffset(
			Settings.FOVRadius * 2,
			Settings.FOVRadius * 2
		)

		FOVCircle.Position =
			UDim2.fromScale(0.5, 0.5)
	end

	-- Aim
	if Settings.Enabled then
		local target = GetClosestTarget()

		if target then
			AimAt(target)
		end
	end
end)