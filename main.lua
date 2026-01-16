--// RexHub Insta Stealer estilo You vs Homer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "RexHubGUI"
gui.ResetOnSpawn = false

-- PANEL
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Position = UDim2.fromScale(0.35,0.2)
frame.Size = UDim2.fromScale(0.3,0) -- ancho medio
frame.AutomaticSize = Enum.AutomaticSize.Y
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

-- HEADER
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,36)
header.BackgroundColor3 = Color3.fromRGB(240,240,240)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "RexHub Insta Stealer 1.0"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0,0,0)
title.TextXAlignment = Enum.TextXAlignment.Left

local toggleBtn = Instance.new("TextButton", header)
toggleBtn.Size = UDim2.new(0,26,0,26)
toggleBtn.Position = UDim2.new(1,-30,0.5,-13)
toggleBtn.Text = "-"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 22
toggleBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
toggleBtn.TextColor3 = Color3.fromRGB(0,0,0)
toggleBtn.BorderSizePixel = 0
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

-- CONTENEDOR
local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1,-16,0,0)
container.Position = UDim2.new(0,8,0,42)
container.AutomaticSize = Enum.AutomaticSize.Y
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,8)

-- BOTONES
local function createButton(text)
	local btn = Instance.new("TextButton", container)
	btn.Size = UDim2.new(1,0,0,48)
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 20
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
	return btn
end

local tpBtn = createButton("TP Lobby")
local infBtn = createButton("INF JUMP")
local speedBtn = createButton("SPEED")

-- MINIMIZAR / RESTAURAR
local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	container.Visible = not minimized
	toggleBtn.Text = minimized and "+" or "-"
end)

-- TP LOBBY
local lobbyCFrame
local firstSpawn = true
player.CharacterAdded:Connect(function(c)
	char = c
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
	if firstSpawn then
		lobbyCFrame = hrp.CFrame
		firstSpawn = false
	end
end)

tpBtn.MouseButton1Click:Connect(function()
	if hrp and lobbyCFrame then
		hrp.CFrame = lobbyCFrame
	end
end)

-- INF JUMP (rznnq source)
local infinityJumpEnabled = false
local jumpForce = 50
local clampFallSpeed = 80

infBtn.MouseButton1Click:Connect(function()
	infinityJumpEnabled = not infinityJumpEnabled
	infBtn.Text = infinityJumpEnabled and "INF JUMP (ON)" or "INF JUMP"
end)

RunService.Heartbeat:Connect(function()
	if not infinityJumpEnabled then return end
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp and hrp.Velocity.Y < -clampFallSpeed then
		hrp.Velocity = Vector3.new(hrp.Velocity.X,-clampFallSpeed,hrp.Velocity.Z)
	end
end)

UIS.JumpRequest:Connect(function()
	if not infinityJumpEnabled then return end
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Velocity = Vector3.new(hrp.Velocity.X,jumpForce,hrp.Velocity.Z)
	end
end)

print("✅ Menú RexHub mediano listo con TP Lobby, INF JUMP y SPEED")
