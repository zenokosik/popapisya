local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local flying = false
local flySpeed = 60

local bodyVelocity
local bodyGyro

local moveDirection = {
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

local function startFlying()
	if flying then return end
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

	humanoid.PlatformStand = false
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.F then
		if flying then
			stopFlying()
		else
			startFlying()
		end
	end

	if input.KeyCode == Enum.KeyCode.W then moveDirection.W = true end
	if input.KeyCode == Enum.KeyCode.A then moveDirection.A = true end
	if input.KeyCode == Enum.KeyCode.S then moveDirection.S = true end
	if input.KeyCode == Enum.KeyCode.D then moveDirection.D = true end
	if input.KeyCode == Enum.KeyCode.Space then moveDirection.Up = true end
	if input.KeyCode == Enum.KeyCode.LeftControl then moveDirection.Down = true end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then moveDirection.W = false end
	if input.KeyCode == Enum.KeyCode.A then moveDirection.A = false end
	if input.KeyCode == Enum.KeyCode.S then moveDirection.S = false end
	if input.KeyCode == Enum.KeyCode.D then moveDirection.D = false end
	if input.KeyCode == Enum.KeyCode.Space then moveDirection.Up = false end
	if input.KeyCode == Enum.KeyCode.LeftControl then moveDirection.Down = false end
end)

RunService.RenderStepped:Connect(function()
	if not flying or not bodyVelocity or not bodyGyro then return end

	local moveVec = Vector3.zero
	local camCF = camera.CFrame

	if moveDirection.W then moveVec += camCF.LookVector end
	if moveDirection.S then moveVec -= camCF.LookVector end
	if moveDirection.A then moveVec -= camCF.RightVector end
	if moveDirection.D then moveVec += camCF.RightVector end
	if moveDirection.Up then moveVec += Vector3.new(0, 1, 0) end
	if moveDirection.Down then moveVec -= Vector3.new(0, 1, 0) end

	if moveVec.Magnitude > 0 then
		moveVec = moveVec.Unit * flySpeed
	end

	bodyVelocity.Velocity = moveVec
	bodyGyro.CFrame = camera.CFrame
end)
