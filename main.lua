-- YOU VS HOMER HUB
-- Coloca este LocalScript en:
-- StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(c)
	char = c
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
end)

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "YOUVSHOMER_HUB"
gui.ResetOnSpawn = false

-- FRAME PRINCIPAL
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,330)
frame.Position = UDim2.new(0.5,-130,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

-- HEADER
local header = Instance.new("Frame",frame)
header.Size = UDim2.new(1,0,0,35)
header.BackgroundColor3 = Color3.fromRGB(255,255,255)
header.BorderSizePixel = 0
Instance.new("UICorner",header).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel",header)
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "YOU VS HOMER HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(0,0,0)
title.BackgroundTransparency = 1
title.TextXAlignment = Left

local toggleBtn = Instance.new("TextButton",header)
toggleBtn.Size = UDim2.new(0,25,0,25)
toggleBtn.Position = UDim2.new(1,-30,0.5,-12)
toggleBtn.Text = "-"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 22
toggleBtn.BackgroundColor3 = Color3.fromRGB(200,200,200)
toggleBtn.BorderSizePixel = 0
Instance.new("UICorner",toggleBtn).CornerRadius = UDim.new(1,0)

-- CONTENEDOR
local container = Instance.new("Frame",frame)
container.Position = UDim2.new(0,10,0,45)
container.Size = UDim2.new(1,-20,1,-55)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout",container)
layout.Padding = UDim.new(0,6)

-- BOTONES
local function createButton(text)
	local b = Instance.new("TextButton",container)
	b.Size = UDim2.new(1,0,0,45)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 18
	b.TextColor3 = Color3.new(1,1,1)
	b.BorderSizePixel = 0
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)
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

----------------------------------------------------------------
-- MINIMIZAR / ABRIR (+ y -)
----------------------------------------------------------------
local opened = true

toggleBtn.MouseButton1Click:Connect(function()
	opened = not opened
	
	if opened then
		container.Visible = true
		toggleBtn.Text = "-"
		frame:TweenSize(UDim2.new(0,260,0,330),"Out","Quad",0.2,true)
	else
		toggleBtn.Text = "+"
		frame:TweenSize(UDim2.new(0,260,0,40),"Out","Quad",0.2,true)
		task.delay(0.2,function()
			container.Visible = false
		end)
	end
end)

----------------------------------------------------------------
-- TP LOBBY (primer spawn)
----------------------------------------------------------------
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

----------------------------------------------------------------
-- SPEED (+35%)
----------------------------------------------------------------
local speedOn = false
local baseSpeed = humanoid.WalkSpeed

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	if speedOn then
		humanoid.WalkSpeed = baseSpeed * 1.35
		speedBtn.Text = "SPEED (ON)"
	else
		humanoid.WalkSpeed = baseSpeed
		speedBtn.Text = "SPEED"
	end
end)

----------------------------------------------------------------
-- INF JUMP (rznnq, ON/OFF)
----------------------------------------------------------------
local infinityJumpEnabled = false
local jumpForce = 50
local clampFallSpeed = 80

infBtn.MouseButton1Click:Connect(function()
	infinityJumpEnabled = not infinityJumpEnabled
	infBtn.Text = infinityJumpEnabled and "INF JUMP (ON)" or "INF JUMP"
end)

RunService.Heartbeat:Connect(function()
	if not infinityJumpEnabled then return end
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp and hrp.Velocity.Y < -clampFallSpeed then
		hrp.Velocity = Vector3.new(hrp.Velocity.X,-clampFallSpeed,hrp.Velocity.Z)
	end
end)

UIS.JumpRequest:Connect(function()
	if not infinityJumpEnabled then return end
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Velocity = Vector3.new(hrp.Velocity.X,jumpForce,hrp.Velocity.Z)
	end
end)

----------------------------------------------------------------
-- ESP PLAYERS (rojo + hitbox)
----------------------------------------------------------------
local espOn = false
local espBoxes = {}

local function createESP(plr)
	if plr == player then return end
	local box = Instance.new("BoxHandleAdornment")
	box.Size = Vector3.new(4,6,2)
	box.Color3 = Color3.fromRGB(255,0,0)
	box.Transparency = 0.5
	box.AlwaysOnTop = true
	box.ZIndex = 10
	box.Adornee = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	box.Parent = gui
	espBoxes[plr] = box
end

espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = espOn and "ESP (ON)" or "ESP"
	
	if espOn then
		for _,plr in pairs(Players:GetPlayers()) do
			createESP(plr)
		end
	else
		for _,box in pairs(espBoxes) do
			box:Destroy()
		end
		espBoxes = {}
	end
end)

----------------------------------------------------------------
-- FIX LAG (texturas cartón / revertible)
----------------------------------------------------------------
local lagFixOn = false
local oldMaterials = {}

lagBtn.MouseButton1Click:Connect(function()
	lagFixOn = not lagFixOn
	lagBtn.Text = lagFixOn and "FIX LAG (ON)" or "FIX LAG"

	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			if lagFixOn then
				oldMaterials[v] = v.Material
				v.Material = Enum.Material.SmoothPlastic
			else
				if oldMaterials[v] then
					v.Material = oldMaterials[v]
				end
			end
		end
	end
end)

print("🔥 YOU VS HOMER HUB cargado correctamente")
