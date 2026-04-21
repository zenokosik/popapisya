local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local flySpeed = 60
local minSpeed = 20
local maxSpeed = 200

local bodyVelocity
local bodyGyro

local moveKeys = {
	W = false,
	A = false,
	S = false,
	D = false,
	Up = false,
	Down = false
}

local function setupCharacter(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")

	if flying then
		task.wait(0.2)

		if bodyVelocity then
			bodyVelocity:Destroy()
			bodyVelocity = nil
		end

		if bodyGyro then
			bodyGyro:Destroy()
			bodyGyro = nil
		end

		if rootPart then
			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
			bodyVelocity.Velocity = Vector3.zero
			bodyVelocity.Parent = rootPart

			bodyGyro = Instance.new("BodyGyro")
			bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000
			bodyGyro.P = 10000
			bodyGyro.CFrame = camera.CFrame
			bodyGyro.Parent = rootPart
		end
	end
end

player.CharacterAdded:Connect(setupCharacter)

local gui = Instance.new("ScreenGui")
gui.Name = "FlyControlGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 180)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(90, 90, 110)
mainStroke.Transparency = 0.15
mainStroke.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.45
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = 0
shadow.Parent = mainFrame

mainFrame.ZIndex = 2

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 42)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 18)
topBarCorner.Parent = topBar

local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 18)
topFix.Position = UDim2.new(0, 0, 1, -18)
topFix.BackgroundColor3 = topBar.BackgroundColor3
topFix.BorderSizePixel = 0
topFix.Parent = topBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.Font = Enum.Font.GothamBold
title.Text = "Fly Controller"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local statusDot = Instance.new("Frame")
statusDot.Name = "StatusDot"
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(1, -24, 0.5, -5)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
statusDot.BorderSizePixel = 0
statusDot.Parent = topBar

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

local content = Instance.new("Frame")
content.Name = "Content"
content.BackgroundTransparency = 1
content.Size = UDim2.new(1, -24, 1, -58)
content.Position = UDim2.new(0, 12, 0, 50)
content.Parent = mainFrame

local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(1, 0, 0, 44)
flyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
flyButton.BorderSizePixel = 0
flyButton.Font = Enum.Font.GothamBold
flyButton.Text = "ENABLE FLY"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 16
flyButton.AutoButtonColor = false
flyButton.Parent = content

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 14)
flyCorner.Parent = flyButton

local flyStroke = Instance.new("UIStroke")
flyStroke.Thickness = 1.5
flyStroke.Color = Color3.fromRGB(255, 255, 255)
flyStroke.Transparency = 0.8
flyStroke.Parent = flyButton

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.BackgroundTransparency = 1
speedLabel.Size = UDim2.new(1, 0, 0, 24)
speedLabel.Position = UDim2.new(0, 0, 0, 58)
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.Text = "Speed: 60"
speedLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
speedLabel.TextSize = 15
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = content

local sliderBack = Instance.new("Frame")
sliderBack.Name = "SliderBack"
sliderBack.Size = UDim2.new(1, 0, 0, 18)
sliderBack.Position = UDim2.new(0, 0, 0, 92)
sliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
sliderBack.BorderSizePixel = 0
sliderBack.Parent = content

local sliderBackCorner = Instance.new("UICorner")
sliderBackCorner.CornerRadius = UDim.new(1, 0)
sliderBackCorner.Parent = sliderBack

local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.new((flySpeed - minSpeed) / (maxSpeed - minSpeed), 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBack

local sliderFillCorner = Instance.new("UICorner")
sliderFillCorner.CornerRadius = UDim.new(1, 0)
sliderFillCorner.Parent = sliderFill

local sliderKnob = Instance.new("TextButton")
sliderKnob.Name = "SliderKnob"
sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
sliderKnob.Size = UDim2.new(0, 24, 0, 24)
sliderKnob.Position = UDim2.new((flySpeed - minSpeed) / (maxSpeed - minSpeed), 0, 0.5, 0)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.Text = ""
sliderKnob.BorderSizePixel = 0
sliderKnob.AutoButtonColor = false
sliderKnob.Parent = sliderBack

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = sliderKnob

local knobStroke = Instance.new("UIStroke")
knobStroke.Thickness = 1
knobStroke.Color = Color3.fromRGB(210, 210, 210)
knobStroke.Parent = sliderKnob

local speedMarks = Instance.new("TextLabel")
speedMarks.BackgroundTransparency = 1
speedMarks.Size = UDim2.new(1, 0, 0, 20)
speedMarks.Position = UDim2.new(0, 0, 0, 118)
speedMarks.Font = Enum.Font.Gotham
speedMarks.Text = tostring(minSpeed) .. "                         " .. tostring(maxSpeed)
speedMarks.TextColor3 = Color3.fromRGB(130, 130, 145)
speedMarks.TextSize = 12
speedMarks.Parent = content

local hintLabel = Instance.new("TextLabel")
hintLabel.BackgroundTransparency = 1
hintLabel.Size = UDim2.new(1, 0, 0, 28)
hintLabel.Position = UDim2.new(0, 0, 1, -8)
hintLabel.AnchorPoint = Vector2.new(0, 1)
hintLabel.Font = Enum.Font.Gotham
hintLabel.Text = "ПК: WASD / Space / Ctrl"
hintLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
hintLabel.TextSize = 13
hintLabel.TextXAlignment = Enum.TextXAlignment.Left
hintLabel.Parent = content

local draggingGui = false
local dragStart
local startPos

local sliderDragging = false

local function updateFlyButton()
	if flying then
		flyButton.Text = "DISABLE FLY"
		statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
		TweenService:Create(
			flyButton,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = Color3.fromRGB(0, 170, 110)}
		):Play()
	else
		flyButton.Text = "ENABLE FLY"
		statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
		TweenService:Create(
			flyButton,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = Color3.fromRGB(45, 45, 58)}
		):Play()
	end
end

local function updateSpeedVisual()
	local percent = math.clamp((flySpeed - minSpeed) / (maxSpeed - minSpeed), 0, 1)
	speedLabel.Text = "Speed: " .. tostring(math.floor(flySpeed))
	sliderFill.Size = UDim2.new(percent, 0, 1, 0)
	sliderKnob.Position = UDim2.new(percent, 0, 0.5, 0)
end

local function setSpeedFromInput(input)
	local absPos = sliderBack.AbsolutePosition.X
	local absSize = sliderBack.AbsoluteSize.X
	local percent = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
	flySpeed = math.floor(minSpeed + (maxSpeed - minSpeed) * percent)
	updateSpeedVisual()
end

local function startFlying()
	if flying or not rootPart or not humanoid then return end
	flying = true

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = rootPart

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000
	bodyGyro.P = 10000
	bodyGyro.CFrame = camera.CFrame
	bodyGyro.Parent = rootPart

	humanoid.PlatformStand = true
	updateFlyButton()
end

local function stopFlying()
	if not flying then return end
	flying = false

	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end

	if bodyGyro then
		bodyGyro:Destroy()
		bodyGyro = nil
	end

	if humanoid then
		humanoid.PlatformStand = false
	end

	updateFlyButton()
end

flyButton.MouseEnter:Connect(function()
	TweenService:Create(
		flyButton,
		TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = UDim2.new(1, 0, 0, 46)}
	):Play()
end)

flyButton.MouseLeave:Connect(function()
	TweenService:Create(
		flyButton,
		TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = UDim2.new(1, 0, 0, 44)}
	):Play()
end)

flyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFlying()
	else
		startFlying()
	end
end)

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingGui = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

topBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingGui = false
	end
end)

sliderBack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sliderDragging = true
		setSpeedFromInput(input)
	end
end)

sliderKnob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sliderDragging = true
		setSpeedFromInput(input)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingGui and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		setSpeedFromInput(input)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sliderDragging = false
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.W then moveKeys.W = true end
	if input.KeyCode == Enum.KeyCode.A then moveKeys.A = true end
	if input.KeyCode == Enum.KeyCode.S then moveKeys.S = true end
	if input.KeyCode == Enum.KeyCode.D then moveKeys.D = true end
	if input.KeyCode == Enum.KeyCode.Space then moveKeys.Up = true end
	if input.KeyCode == Enum.KeyCode.LeftControl then moveKeys.Down = true end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then moveKeys.W = false end
	if input.KeyCode == Enum.KeyCode.A then moveKeys.A = false end
	if input.KeyCode == Enum.KeyCode.S then moveKeys.S = false end
	if input.KeyCode == Enum.KeyCode.D then moveKeys.D = false end
	if input.KeyCode == Enum.KeyCode.Space then moveKeys.Up = false end
	if input.KeyCode == Enum.KeyCode.LeftControl then moveKeys.Down = false end
end)

RunService.RenderStepped:Connect(function()
	if not flying or not bodyVelocity or not bodyGyro or not humanoid or not rootPart then
		return
	end

	local moveVec = Vector3.zero
	local camCF = camera.CFrame

	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		moveVec = humanoid.MoveDirection * flySpeed
	else
		if moveKeys.W then moveVec += camCF.LookVector end
		if moveKeys.S then moveVec -= camCF.LookVector end
		if moveKeys.A then moveVec -= camCF.RightVector end
		if moveKeys.D then moveVec += camCF.RightVector end
		if moveKeys.Up then moveVec += Vector3.new(0, 1, 0) end
		if moveKeys.Down then moveVec -= Vector3.new(0, 1, 0) end

		if moveVec.Magnitude > 0 then
			moveVec = moveVec.Unit * flySpeed
		end
	end

	bodyVelocity.Velocity = moveVec
	bodyGyro.CFrame = camCF
end)

updateSpeedVisual()
updateFlyButton()
