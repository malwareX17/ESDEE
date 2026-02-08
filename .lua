local v1 = game
local v2 = v1:GetService("Players")
local v3 = v1:GetService("ReplicatedStorage")
local v4 = v2.LocalPlayer
local v5 = v4:WaitForChild("PlayerGui")
local v6 = Instance.new("ScreenGui")
local v7 = Instance.new("Frame")
local v8 = Instance.new("TextButton")
local v9 = Instance.new("UICorner")

v6.Parent = v5
v6.ResetOnSpawn = false

v7.Name = "v7"
v7.Parent = v6
v7.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
v7.BorderSizePixel = 0
v7.Position = UDim2.new(0.5, -100, 0.5, -30)
v7.Size = UDim2.new(0, 200, 0, 60)
v7.Active = true
v7.Draggable = true

v9.CornerRadius = UDim.new(0, 8)
v9.Parent = v7

v8.Name = "v8"
v8.Parent = v7
v8.BackgroundTransparency = 1
v8.Size = UDim2.new(1, 0, 1, 0)
v8.Font = Enum.Font.GothamBold
v8.RichText = true
v8.Text = 'Fake Macro <font color="rgb(255, 95, 42)">[OFF]</font>'
v8.TextColor3 = Color3.fromRGB(255, 255, 255)
v8.TextSize = 18

local v10 = false
local v11 = {"Stomp"}

local v12
v12 = hookmetamethod(v1, "__namecall", newcclosure(function(self, ...)
    local v13 = getnamecallmethod()
    local v14 = {...}
    if not checkcaller() and v13 == "FireServer" and self.Name == "MainEvent" then
        return v12(self, unpack(v14))
    end
    return v12(self, ...)
end))

local function v15()
    while v10 do
        local v16 = v3:FindFirstChild("MainEvent") or v3:FindFirstChild("CombatEvent")
        if v16 then
            v16:FireServer(unpack(v11))
        end
        task.wait()
    end
end

v8.MouseButton1Click:Connect(function()
    v10 = not v10
    if v10 then
        v8.Text = 'Auto Stomp <font color="rgb(102, 255, 102)">[ON]</font>'
        task.spawn(v15)
    else
        v8.Text = 'Fake Macro <font color="rgb(255, 95, 42)">[OFF]</font>'
    end
end)
