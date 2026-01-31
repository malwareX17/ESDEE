getgenv().Prediction = 0.109 
getgenv().AutoPrediction = true 
getgenv().SilentAimEnabled = true
getgenv().TracerThickness = 1.5
getgenv().VisualColor = Color3.fromRGB(255, 0, 0)
getgenv().TargetPart = "HumanoidRootPart"

local Colors = {
    Red = Color3.fromRGB(255, 0, 0),
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 0, 255),
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(0, 0, 0),
    Yellow = Color3.fromRGB(255, 255, 0),
    Cyan = Color3.fromRGB(0, 255, 255),
    Magenta = Color3.fromRGB(255, 0, 255),
    Orange = Color3.fromRGB(255, 165, 0),
    Purple = Color3.fromRGB(128, 0, 128),
    Pink = Color3.fromRGB(255, 192, 203),
    Lime = Color3.fromRGB(191, 255, 0),
    Teal = Color3.fromRGB(0, 128, 128),
    DeepPink = Color3.fromRGB(255, 20, 147),
    Aquamarine = Color3.fromRGB(127, 255, 212),
    SkyBlue = Color3.fromRGB(135, 206, 235),
    Gold = Color3.fromRGB(255, 215, 0),
    Silver = Color3.fromRGB(192, 192, 192),
    DarkRed = Color3.fromRGB(139, 0, 0),
    Violet = Color3.fromRGB(238, 130, 238),
    Rainbow = Color3.new(1, 1, 1)
}

local client = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local Tracer = Drawing.new("Line")
Tracer.Visible = false
Tracer.Color = getgenv().VisualColor
Tracer.Thickness = getgenv().TracerThickness
Tracer.Transparency = 1

local function getPingPrediction()
    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    if not getgenv().AutoPrediction then return getgenv().Prediction end
    if ping < 30 then return 0.12
    elseif ping < 40 then return 0.125
    elseif ping < 60 then return 0.135
    elseif ping < 80 then return 0.142
    elseif ping < 100 then return 0.151
    elseif ping < 150 then return 0.165
    else return 0.188 end
end

local function isAlive(player)
    return player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

local function isVisible(targetPart)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {client.Character, targetPart.Parent}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(camera.CFrame.Position, (targetPart.Position - camera.CFrame.Position), params)
    return result == nil
end

local function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= client and isAlive(v) then
            local root = v.Character:FindFirstChild(getgenv().TargetPart)
            if root then
                local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local magnitude = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if magnitude < shortestDistance then
                        if isVisible(root) then
                            closest = v
                            shortestDistance = magnitude
                        end
                    end
                end
            end
        end
    end
    return closest
end

local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldNamecall = gmt.__namecall

gmt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if getgenv().SilentAimEnabled and method == "FireServer" and self.Name == "MAINEVENT" and args[1] == "MOUSE" then
        local target = getClosestPlayer()
        if target then
            local predValue = getPingPrediction()
            local root = target.Character[getgenv().TargetPart]
            args[2] = root.Position + (root.Velocity * predValue)
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(gmt, true)

RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    local target = getClosestPlayer()
    
    if getgenv().VisualColor == Colors.Rainbow then
        local rainbowColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        Tracer.Color = rainbowColor
    else
        Tracer.Color = getgenv().VisualColor
    end

    if target and target.Character:FindFirstChild(getgenv().TargetPart) then
        local root = target.Character[getgenv().TargetPart]
        local targetPos, onScreen = camera:WorldToViewportPoint(root.Position)
        if onScreen then
            Tracer.Visible = true
            Tracer.From = mousePos
            Tracer.To = Vector2.new(targetPos.X, targetPos.Y)
        else
            Tracer.Visible = false
        end
    else
        Tracer.Visible = false
    end
end)
