local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelo-Gitland/Lua-Land-Ui-Library/refs/heads/main/Lua%20Land%20Ui"))()

local Window = lib:CreateWindow({
	Title     = "[FPS] Flick | Lua Land Hub",
	Subtitle  = "Developed By LLH Lua Land",
	TitleIcon = "house",
	Theme     = "Default",

Intro = {
		Title    = "[FPS] Flick Lua Land Hub",
		Subtitle = "Developed By LLH Lua Land",
		Icon     = "home",
	},
})

local HomeTab = Window:CreateTab({
	Name      = "Home",
	Icon      = "house",
	SearchBar = false,
})

local LP = game.Players.LocalPlayer

HomeTab:CreateSection("ABOUT ME")
HomeTab:CreateLabel("UserName: " .. LP.Name)
HomeTab:CreateLabel("UserId: " .. LP.UserId)
HomeTab:CreateLabel("Account Age: " .. LP.AccountAge)
HomeTab:CreateLabel("Executor: " .. identifyexecutor())
HomeTab:CreateLabel("Current Key: lowfps")

local ChangelogTab = Window:CreateTab({
	Name      = "Changelog",
	Icon      = "circle-question-mark",
	SearchBar = false, 
})

ChangelogTab:CreateSection("What's New?")
ChangelogTab:CreateLabel("No changelogs yet! Since the script is new.")

local MainTab = Window:CreateTab({
	Name      = "Main",
	Icon      = "house",
	SearchBar = true,
})

MainTab:CreateSection("Main Scripts")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Aimbot (Aimbot)
local AutoShootEnabled = false
local TargetBone = "Head"
local MaxDistance = 500
local WallCheck = true
local aimbotConnection

local function isVisible(targetPart)
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    raycastParams.IgnoreWater = true
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = MaxDistance
    local mousePosition = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local targetPart = player.Character:FindFirstChild(TargetBone)
            if targetPart then
                local screenPosition, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    if not WallCheck or isVisible(targetPart) then
                        local distanceToMouse = (Vector2.new(screenPosition.X, screenPosition.Y) - mousePosition).Magnitude
                        if distanceToMouse < shortestDistance then
                            shortestDistance = distanceToMouse
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function handleAutoShoot()
    if not AutoShootEnabled then return end
    local targetPlayer = getClosestPlayer()
    if targetPlayer and targetPlayer.Character then
        local targetPart = targetPlayer.Character:FindFirstChild(TargetBone)
        if targetPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end
end

MainTab:CreateToggle("Aimbot", function(Value)
    AutoShootEnabled = Value
    if Value then
        if not aimbotConnection then
            aimbotConnection = RunService.RenderStepped:Connect(handleAutoShoot)
        end
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end)

-- Fov Circle (Aimbot)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local fovRadius = 0
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1.5
fovCircle.Filled = false
fovCircle.NumSides = 64

local function updateFOVCircle()
	local center = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
	fovCircle.Position = center
	fovCircle.Radius = fovRadius
end

RunService.RenderStepped:Connect(function()
	if fovCircle.Visible then
		updateFOVCircle()
	end
end)

AimbotTab:CreateSlider("FOV Size", 0, 500, function(Value)
	fovRadius = Value
	if Value > 0 then
		fovCircle.Visible = true
	else
		fovCircle.Visible = false
	end
end)

-- Auto-Fire (Aimbot)
MainTab:CreateToggle("Auto-Fire", function(Value)
    if Value then
        autoFireConnection = RunService.RenderStepped:Connect(function()
            if not DEBUG 
                and getfenv().mouse1click 
                and IsComputer 
                and Triggering 
                and (Configuration.SmartTriggerBot and Aiming or not Configuration.SmartTriggerBot) 
                and Mouse.Target 
                and IsReady(Mouse.Target:FindFirstAncestorWhichIsA("Model")) 
                and MathHandler:CalculateChance(Configuration.TriggerBotChance) then
                    getfenv().mouse1click()
            end
        end)
    else
        if autoFireConnection then
            autoFireConnection:Disconnect()
            autoFireConnection = nil
        end
    end
end)

local VisualsTab = Window:CreateTab({
	Name      = "Visuals",
	Icon      = "house",
	SearchBar = true,
})

-- Health Bar (Visuals)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local hpConnections = {}
local hpEnabled = false

local function addHPBar(player)
	if player == LP then return end
	local char = player.Character or player.CharacterAdded:Wait()
	if not char then return end
	if char:FindFirstChild("LuaLandHPBar") then return end

	local head = char:WaitForChild("Head", 5)
	if not head then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "LuaLandHPBar"
	billboard.Size = UDim2.new(0, 60, 0, 8)
	billboard.StudsOffset = Vector3.new(0, 3.2, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local border = Instance.new("Frame")
	border.Size = UDim2.new(1, 0, 1, 0)
	border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	border.BorderSizePixel = 0
	border.Parent = billboard

	local borderCorner = Instance.new("UICorner")
	borderCorner.CornerRadius = UDim.new(0, 12)
	borderCorner.Parent = border

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, -2, 1, -2)
	bg.Position = UDim2.new(0, 1, 0, 1)
	bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	bg.BorderSizePixel = 0
	bg.Parent = border

	local bgCorner = Instance.new("UICorner")
	bgCorner.CornerRadius = UDim.new(0, 12)
	bgCorner.Parent = bg

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, 0, 1, 0)
	bar.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
	bar.BorderSizePixel = 0
	bar.Parent = bg

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 12)
	barCorner.Parent = bar

	hpConnections[player] = RunService.RenderStepped:Connect(function()
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local hpPercent = humanoid.Health / humanoid.MaxHealth
			bar.Size = UDim2.new(hpPercent, 0, 1, 0)
			if hpPercent > 0.5 then
				bar.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
			else
				bar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
			end
		end
	end)
end

local function removeHPBar(player)
	local char = player.Character
	if char then
		local gui = char:FindFirstChild("LuaLandHPBar")
		if gui then gui:Destroy() end
	end
	if hpConnections[player] then
		hpConnections[player]:Disconnect()
		hpConnections[player] = nil
	end
end

local function enableHPBars()
	if hpEnabled then return end
	hpEnabled = true
	for _, player in ipairs(Players:GetPlayers()) do
		addHPBar(player)
		player.CharacterAdded:Connect(function()
			task.wait(0.1)
			addHPBar(player)
		end)
	end
	Players.PlayerAdded:Connect(function(player)
		addHPBar(player)
		player.CharacterAdded:Connect(function()
			task.wait(0.1)
			addHPBar(player)
		end)
	end)
end

local function disableHPBars()
	if not hpEnabled then return end
	hpEnabled = false
	for _, player in ipairs(Players:GetPlayers()) do
		removeHPBar(player)
	end
end

VisualsTab:CreateToggle("Health Bar", function(Value)
	if Value then
		enableHPBars()
	else
		disableHPBars()
	end
end)

-- Esp (Visuals)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local espConnections = {}
local espEnabled = false

local function addESP(player)
    if player == LP then return end
    local char = player.Character or player.CharacterAdded:Wait()
    if not char then return end
    if char:FindFirstChild("LuaLandESP") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "LuaLandESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "LuaLandESPText"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextScaled = true
    textLabel.Parent = billboard

    local function updateText()
        if char and char:FindFirstChild("HumanoidRootPart") then
            local distance = (LP.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            textLabel.Text = player.Name .. " [" .. math.floor(distance) .. "m]"
        end
    end

    espConnections[player] = RunService.RenderStepped:Connect(updateText)
end

local function removeESP(player)
    local char = player.Character
    if char then
        local h = char:FindFirstChild("LuaLandESP")
        if h then h:Destroy() end
        local gui = char:FindFirstChild("LuaLandESPText")
        if gui then gui:Destroy() end
    end
    if espConnections[player] then
        espConnections[player]:Disconnect()
        espConnections[player] = nil
    end
end

local function enableESP()
    if espEnabled then return end
    espEnabled = true
    for _, player in ipairs(Players:GetPlayers()) do
        addESP(player)
        player.CharacterAdded:Connect(function()
            task.wait(0.1)
            addESP(player)
        end)
    end
    Players.PlayerAdded:Connect(function(player)
        addESP(player)
        player.CharacterAdded:Connect(function()
            task.wait(0.1)
            addESP(player)
        end)
    end)
end

local function disableESP()
    if not espEnabled then return end
    espEnabled = false
    for _, player in ipairs(Players:GetPlayers()) do
        removeESP(player)
    end
end

VisualsTab:CreateToggle("Team Check", function(Value)
    if Value then
        enableESP()
    else
        disableESP()
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Teams = game:GetService("Teams")

local TARGET_TEAM_NAME = "Play"
local Thickness = 2
local Transparency = 1

local ALLY_COLOR = Color3.fromRGB(255, 255, 255)
local ENEMY_COLOR = Color3.fromRGB(255, 0, 0)

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local skeletons = {}

local function isOnTargetTeam(plr)
    return plr.Team and plr.Team.Name == TARGET_TEAM_NAME
end

local function getColor(plr)
    return isOnTargetTeam(plr) and ALLY_COLOR or ENEMY_COLOR
end

local function createLine()
    return Drawing.new("Line")
end

local function removeSkeleton(skeleton)
    for _, line in pairs(skeleton) do
        line:Remove()
    end
end

local function trackPlayer(plr)
    local skeleton = {}

    local function updateSkeleton()
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            for _, line in pairs(skeleton) do
                line.Visible = false
            end
            return
        end

        local character = plr.Character
        local humanoid = character:FindFirstChild("Humanoid")
        local joints, connections = {}, {}

        if humanoid and humanoid.RigType == Enum.HumanoidRigType.R15 then
            joints = {
                Head = character:FindFirstChild("Head"),
                UpperTorso = character:FindFirstChild("UpperTorso"),
                LowerTorso = character:FindFirstChild("LowerTorso"),
                LeftUpperArm = character:FindFirstChild("LeftUpperArm"),
                LeftLowerArm = character:FindFirstChild("LeftLowerArm"),
                LeftHand = character:FindFirstChild("LeftHand"),
                RightUpperArm = character:FindFirstChild("RightUpperArm"),
                RightLowerArm = character:FindFirstChild("RightLowerArm"),
                RightHand = character:FindFirstChild("RightHand"),
                LeftUpperLeg = character:FindFirstChild("LeftUpperLeg"),
                LeftLowerLeg = character:FindFirstChild("LeftLowerLeg"),
                RightUpperLeg = character:FindFirstChild("RightUpperLeg"),
                RightLowerLeg = character:FindFirstChild("RightLowerLeg"),
            }
            connections = {
                { "Head", "UpperTorso" },
                { "UpperTorso", "LowerTorso" },
                { "LowerTorso", "LeftUpperLeg" },
                { "LeftUpperLeg", "LeftLowerLeg" },
                { "LowerTorso", "RightUpperLeg" },
                { "RightUpperLeg", "RightLowerLeg" },
                { "UpperTorso", "LeftUpperArm" },
                { "LeftUpperArm", "LeftLowerArm" },
                { "LeftLowerArm", "LeftHand" },
                { "UpperTorso", "RightUpperArm" },
                { "RightUpperArm", "RightLowerArm" },
                { "RightLowerArm", "RightHand" },
            }
        elseif humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
            joints = {
                Head = character:FindFirstChild("Head"),
                Torso = character:FindFirstChild("Torso"),
                LeftLeg = character:FindFirstChild("Left Leg"),
                RightLeg = character:FindFirstChild("Right Leg"),
                LeftArm = character:FindFirstChild("Left Arm"),
                RightArm = character:FindFirstChild("Right Arm"),
            }
            connections = {
                { "Head", "Torso" },
                { "Torso", "LeftArm" },
                { "Torso", "RightArm" },
                { "Torso", "LeftLeg" },
                { "Torso", "RightLeg" },
            }
        end

        local color = getColor(plr)

        for index, connection in ipairs(connections) do
            local jointA = joints[connection[1]]
            local jointB = joints[connection[2]]

            if jointA and jointB then
                local posA, onScreenA = camera:WorldToViewportPoint(jointA.Position)
                local posB, onScreenB = camera:WorldToViewportPoint(jointB.Position)

                local line = skeleton[index] or createLine()
                skeleton[index] = line

                line.Color = color
                line.Thickness = Thickness
                line.Transparency = Transparency

                if onScreenA and onScreenB then
                    line.From = Vector2.new(posA.X, posA.Y)
                    line.To = Vector2.new(posB.X, posB.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            elseif skeleton[index] then
                skeleton[index].Visible = false
            end
        end
    end

    skeletons[plr] = skeleton

    RunService.RenderStepped:Connect(function()
        if plr and plr.Parent then
            updateSkeleton()
        else
            removeSkeleton(skeleton)
        end
    end)
end

local function untrackPlayer(plr)
    if skeletons[plr] then
        removeSkeleton(skeletons[plr])
        skeletons[plr] = nil
    end
end

VisualsTab:CreateToggle("Skeleton ESP", function(Value)
    if Value then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                trackPlayer(plr)
            end
        end
        Players.PlayerAdded:Connect(function(plr)
            if plr ~= player then
                trackPlayer(plr)
            end
        end)
        Players.PlayerRemoving:Connect(untrackPlayer)
    else
        for _, plr in pairs(skeletons) do
            removeSkeleton(skeletons[plr])
        end
        skeletons = {}
    end
end)
