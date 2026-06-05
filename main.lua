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
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local fovCircle
local fovConnection
local fovEnabled = false
local fovRadius = 150

local function enableFOV()
    if fovEnabled then return end
    fovEnabled = true
    fovCircle = Drawing.new("Circle")
    fovCircle.Color = Color3.fromRGB(255, 0, 0)
    fovCircle.Thickness = 2
    fovCircle.NumSides = 64
    fovCircle.Radius = fovRadius
    fovCircle.Filled = false
    fovCircle.Visible = true

    fovConnection = RunService.RenderStepped:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        fovCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
    end)
end

local function disableFOV()
    if not fovEnabled then return end
    fovEnabled = false
    if fovConnection then
        fovConnection:Disconnect()
        fovConnection = nil
    end
    if fovCircle then
        fovCircle:Remove()
        fovCircle = nil
    end
end

MainTab:CreateToggle("Fov Circle", function(Value)
    if Value then
        enableFOV()
    else
        disableFOV()
    end
end)
local RunService = game:GetService("RunService")
local Mouse = game.Players.LocalPlayer:GetMouse()
local autoFireConnection

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
local Camera = workspace.CurrentCamera
local hpConnections = {}
local hpEnabled = false

local function addHPBar(player)
    if player == LP then return end
    local char = player.Character or player.CharacterAdded:Wait()
    if not char then return end
    if char:FindFirstChild("LuaLandHPBar") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "LuaLandHPBar"
    billboard.Size = UDim2.new(0, 50, 0, 5)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    frame.Parent = billboard

    hpConnections[player] = RunService.RenderStepped:Connect(function()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local hpPercent = humanoid.Health / humanoid.MaxHealth
            frame.Size = UDim2.new(hpPercent, 0, 1, 0)
            if hpPercent > 0.5 then
                frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif hpPercent > 0.25 then
                frame.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
            else
                frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
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

VisualsTab:CreateToggle("ESP", function(Value)
    if Value then
        enableESP()
    else
        disableESP()
    end
end)
