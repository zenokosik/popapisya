local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local flySpeed = 60

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
end

player.CharacterAdded:Connect(setupCharacter)

local gui = Instance.new("ScreenGui")
gui.Name = "FlyGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(0, 140, 0, 50)
flyButton.Position = UDim2.new(1, -160, 1, -90)
flyButton.AnchorPoint = Vector2.new(0, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextScaled = true
flyButton.Font = Enum.Font.GothamBold
flyButton.Text = "FLY: OFF"
flyButton.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = flyButton

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Parent = flyButton

local function updateButton()
	if flying then
		flyButton.Text = "FLY: ON"
		flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
	else
		flyButton.Text = "FLY: OFF"
		flyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	end
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
	updateButton()
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

	updateButton()
end

flyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFlying()
	else
		startFlying()
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
	if not flying or not bodyVelocity or not bodyGyro or not humanoid then return end

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
	bodyGyro.CFrame = camera.CFrame
end)
