--// MOBILE AIM ASSIST
--// R6 + R15 SUPPORT
--// For your own Roblox game
--// Place this LocalScript in:
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

	Smoothing = 0.15,
}

--// R15 + R6 BODY PARTS
local TargetParts = {
	-- R15
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

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileAimAssist"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Menu = Instance.new("Frame")
Menu.Size = UDim2.fromOffset(250, 300)
Menu.Position = UDim2.new(0, 20, 0.5, -150)
Menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Menu.BorderSizePixel = 0
Menu.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = Menu

--// TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -45, 0, 40)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = "Aim Assist"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Menu

--// MINIMIZE BUTTON
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(35, 35)
Minimize.Position = UDim2.new(1, -40, 0, 3)
Minimize.BackgroundTransparency = 1
Minimize.Text = "—"
Minimize.TextColor3 = Color3.new(1, 1, 1)
Minimize.TextSize = 24
Minimize.Parent = Menu

--// RESTORE BUTTON
local Restore = Instance.new("TextButton")
Restore.Size = UDim2.fromOffset(50, 50)
Restore.Position = UDim2.fromOffset(20, 100)
Restore.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Restore.Text = "☰"
Restore.TextColor3 = Color3.new(1, 1, 1)
Restore.TextSize = 24
Restore.Visible = false
Restore.Parent = ScreenGui

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

--// BUTTON CREATOR
local function CreateButton(text, y)
	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, -20, 0, 40)
	Button.Position = UDim2.fromOffset(10, y)

	Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Button.TextColor3 = Color3.new(1, 1, 1)

	Button.TextSize = 15
	Button.Font = Enum.Font.Gotham

	Button.Text = text
	Button.AutoButtonColor = true

	Button.Parent = Menu

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Button

	return Button
end

--// AIM TOGGLE
local AimButton = CreateButton("Aim Assist: OFF", 45)

AimButton.Activated:Connect(function()
	Settings.Enabled = not Settings.Enabled

	if Settings.Enabled then
		AimButton.Text = "Aim Assist: ON"
		AimButton.BackgroundColor3 = Color3.fromRGB(50, 130, 70)
	else
		AimButton.Text = "Aim Assist: OFF"
		AimButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	end
end)

--// WALL CHECK
local WallButton = CreateButton("Wall Check: ON", 90)

WallButton.Activated:Connect(function()
	Settings.WallCheck = not Settings.WallCheck

	if Settings.WallCheck then
		WallButton.Text = "Wall Check: ON"
	else
		WallButton.Text = "Wall Check: OFF"
	end
end)

--// FOV TOGGLE
local FOVButton = CreateButton("FOV Circle: ON", 135)

FOVButton.Activated:Connect(function()
	Settings.FOVEnabled = not Settings.FOVEnabled

	if Settings.FOVEnabled then
		FOVButton.Text = "FOV Circle: ON"
	else
		FOVButton.Text = "FOV Circle: OFF"
	end
end)

--// FOV LABEL
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(1, -20, 0, 25)
FOVLabel.Position = UDim2.fromOffset(10, 180)
FOVLabel.BackgroundTransparency = 1
FOVLabel.TextColor3 = Color3.new(1, 1, 1)
FOVLabel.TextSize = 14
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.Text = "FOV: 150"
FOVLabel.Parent = Menu

--// FOV SLIDER
local FOVSlider = Instance.new("Frame")
FOVSlider.Size = UDim2.new(1, -20, 0, 12)
FOVSlider.Position = UDim2.fromOffset(10, 215)
FOVSlider.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
FOVSlider.BorderSizePixel = 0
FOVSlider.Parent = Menu

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(1, 0)
SliderCorner.Parent = FOVSlider

local FOVFill = Instance.new("Frame")
FOVFill.Size = UDim2.fromScale(
	(Settings.FOVRadius - Settings.MinFOV) /
	(Settings.MaxFOV - Settings.MinFOV),
	1
)

FOVFill.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
FOVFill.BorderSizePixel = 0
FOVFill.Parent = FOVSlider

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = FOVFill

--// FOV SLIDER DRAGGING
local draggingFOV = false

local function UpdateFOV(input)
	local x = input.Position.X

	local startX = FOVSlider.AbsolutePosition.X
	local width = FOVSlider.AbsoluteSize.X

	local percent = math.clamp(
		(x - startX) / width,
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

UserInputService.InputChanged:Connect(function(input)
	if not draggingFOV then
		return
	end

	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseMovement then

		UpdateFOV(input)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		draggingFOV = false
	end
end)

--// FOV CIRCLE
local FOVCircle = Instance.new("Frame")
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 2
FOVCircle.BorderColor3 = Color3.fromRGB(255, 255, 255)
FOVCircle.Parent = ScreenGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = FOVCircle

--// VISIBILITY CHECK
local function IsVisible(character, targetPart)
	local Camera = workspace.CurrentCamera

	if not Camera or not targetPart then
		return false
	end

	local origin = Camera.CFrame.Position
	local direction = targetPart.Position - origin

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude

	-- Don't let your own character block the ray
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

	-- The first thing hit must belong to the target
	return result.Instance:IsDescendantOf(character)
end

--// FIND CLOSEST BODY PART
local function GetClosestBodyPart(character)
	local Camera = workspace.CurrentCamera

	if not Camera then
		return nil, math.huge
	end

	local closestPart = nil
	local closestDistance = math.huge

	local screenCenter = Vector2.new(
		Camera.ViewportSize.X / 2,
		Camera.ViewportSize.Y / 2
	)

	for _, partName in ipairs(TargetParts) do

		-- FindFirstChild automatically skips parts
		-- that don't exist on the current rig.
		local part = character:FindFirstChild(partName)

		if part and part:IsA("BasePart") then

			local screenPosition, onScreen =
				Camera:WorldToViewportPoint(part.Position)

			if onScreen and screenPosition.Z > 0 then

				local screenPoint = Vector2.new(
					screenPosition.X,
					screenPosition.Y
				)

				local distance =
					(screenPoint - screenCenter).Magnitude

				if distance <= Settings.FOVRadius
					and distance < closestDistance then

					if not Settings.WallCheck
						or IsVisible(character, part) then

						closestDistance = distance
						closestPart = part
					end
				end
			end
		end
	end

	return closestPart, closestDistance
end

--// FIND CLOSEST PLAYER
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
						closestDistance = distance
						closestPart = part
					end
				end
			end
		end
	end

	return closestPart
end

--// AIM AT TARGET
local function AimAt(targetPart)
	local Camera = workspace.CurrentCamera

	if not Camera or not targetPart then
		return
	end

	local targetCFrame =
		CFrame.lookAt(
			Camera.CFrame.Position,
			targetPart.Position
		)

	Camera.CFrame =
		Camera.CFrame:Lerp(
			targetCFrame,
			Settings.Smoothing
		)
end

--// MAIN LOOP
RunService.RenderStepped:Connect(function()

	local Camera = workspace.CurrentCamera

	if not Camera then
		return
	end

	-- FOV circle
	if Settings.FOVEnabled then

		FOVCircle.Visible = true

		FOVCircle.Size = UDim2.fromOffset(
			Settings.FOVRadius * 2,
			Settings.FOVRadius * 2
		)

		FOVCircle.Position = UDim2.fromScale(0.5, 0.5)

	else

		FOVCircle.Visible = false

	end

	-- Aim assist
	if Settings.Enabled then

		local targetPart = GetClosestTarget()

		if targetPart then
			AimAt(targetPart)
		end

	end
end)

--// DRAG MENU
local draggingMenu = false
local dragStart
local startPosition

Title.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		draggingMenu = true
		dragStart = input.Position
		startPosition = Menu.Position

	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not draggingMenu then
		return
	end

	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseMovement then

		local delta = input.Position - dragStart

		Menu.Position = UDim2.new(
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

		draggingMenu = false

	end
end)