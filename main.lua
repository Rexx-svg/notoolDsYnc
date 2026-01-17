-- YOU VS HOMER HUB
-- Hub completo para tu juego

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(c)
	char = c
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
end)

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "YOUVSHOMERHUB"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.fromScale(0.35,0.2)
frame.Size = UDim2.fromScale(0.3,0)
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
title.Text = "YOU VS HOMER HUB"
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
container.Position = UDim2.new(0,8,0,42)
container.Size = UDim2.new(1,-16,0,0)
container.AutomaticSize = Enum.AutomaticSize.Y
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,8)

-- BOTONES
local function createButton(text)
	local b = Instance.new("TextButton", container)
	b.Size = UDim2.new(1,0,0,48)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 20
	b.TextColor3 = Color3.new(1,1,1)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	return b
end

-- ORDEN:
-- TP LOBBY
-- SPEED
-- INF JUMP
-- ESP
-- FIX LAG
local tpBtn    = createButton("TP LOBBY")
local speedBtn = createButton("SPEED")
local infBtn   = createButton("INF JUMP")
local espBtn   = createButton("ESP")
local lagBtn   = createButton("FIX LAG")

------------------------------------------------
-- ABRIR / CERRAR MENU (+ y -)
------------------------------------------------
local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	
	if minimized then
		container.Visible = false
		toggleBtn.Text = "+"
	else
		container.Visible = true
		toggleBtn.Text = "-"
	end
end)

------------------------------------------------
-- TP LOBBY
------------------------------------------------
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

------------------------------------------------
-- SPEED (+35%)
------------------------------------------------
local speedEnabled = false
local baseSpeed = humanoid.WalkSpeed

speedBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	
	if speedEnabled then
		humanoid.WalkSpeed = baseSpeed * 1.35
		speedBtn.Text = "SPEED (ON)"
	else
		humanoid.WalkSpeed = baseSpeed
		speedBtn.Text = "SPEED"
	end
end)

------------------------------------------------
-- INF JUMP (rznnq toggle)
------------------------------------------------
local infinityJumpEnabled = false
local jumpForce = 50
local clampFallSpeed = 80

infBtn.MouseButton1Click:Connect(function()
	infinityJumpEnabled = not infinityJumpEnabled
	infBtn.Text = infinityJumpEnabled and "INF JUMP (ON)" or "INF JUMP"
end)

RunService.Heartbeat:Connect(function()
	if not infinityJumpEnabled then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp and hrp.Velocity.Y < -clampFallSpeed then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, -clampFallSpeed, hrp.Velocity.Z)
	end
end)

UIS.JumpRequest:Connect(function()
	if not infinityJumpEnabled then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpForce, hrp.Velocity.Z)
	end
end)

------------------------------------------------
-- ESP (Highlight rojo)
------------------------------------------------
local espEnabled = false
local espFolder = Instance.new("Folder", gui)
espFolder.Name = "ESPFolder"

local function addESP(plr)
	if plr == player then return end
	if plr.Character then
		local h = Instance.new("Highlight", espFolder)
		h.Adornee = plr.Character
		h.FillColor = Color3.fromRGB(255,0,0)
		h.OutlineColor = Color3.fromRGB(255,0,0)
	end
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = espEnabled and "ESP (ON)" or "ESP"
	
	if espEnabled then
		for _,plr in pairs(Players:GetPlayers()) do
			addESP(plr)
		end
	else
		espFolder:ClearAllChildren()
	end
end)

Players.PlayerAdded:Connect(function(plr)
	if espEnabled then
		plr.CharacterAdded:Connect(function()
			wait(1)
			addESP(plr)
		end)
	end
end)

------------------------------------------------
-- FIX LAG (modo cartón / fluido)
------------------------------------------------
local lagFixEnabled = false

lagBtn.MouseButton1Click:Connect(function()
	lagFixEnabled = not lagFixEnabled
	lagBtn.Text = lagFixEnabled and "FIX LAG (ON)" or "FIX LAG"
	
	if lagFixEnabled then
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.Plastic
				v.Reflectance = 0
			end
		end
	else
		Lighting.GlobalShadows = true
	end
end)

print("🔥 YOU VS HOMER HUB cargado completo y funcionando")
