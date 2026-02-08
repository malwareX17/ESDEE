local v1 = game
local v2 = v1:GetService("Players")
local v3 = v1:GetService("ReplicatedFirst")
local v4 = v2.LocalPlayer
local v5 = v4:WaitForChild("PlayerGui")
local v6 = v1:GetService("ReplicatedStorage")

local v7 = Instance.new("ScreenGui")
v7.Name = "v7"
v7.Parent = v5
v7.ResetOnSpawn = false

local v8 = Instance.new("Frame")
v8.Name = "v8"
v8.Parent = v7
v8.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
v8.Position = UDim2.new(0.5, -100, 0.5, -30)
v8.Size = UDim2.new(0, 200, 0, 60)
v8.Active = true
v8.Draggable = true

local v9 = Instance.new("UICorner", v8)
v9.CornerRadius = UDim.new(0, 6)

local v10 = Instance.new("UIStroke", v8)
v10.Color = Color3.fromRGB(80, 80, 80)
v10.Thickness = 2
v10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local v11 = Instance.new("TextButton")
v11.Name = "v11"
v11.Parent = v8
v11.BackgroundTransparency = 1
v11.Size = UDim2.new(1, 0, 1, 0)
v11.Font = Enum.Font.GothamBold
v11.RichText = true
v11.Text = 'AUTO STOMP <font color="rgb(255, 95, 42)">[OFF]</font>'
v11.TextColor3 = Color3.fromRGB(255, 255, 255)
v11.TextSize = 16

local v12 = false
local v13 = v3:WaitForChild("STOMP")

local v14
v14 = hookmetamethod(v1, "__namecall", newcclosure(function(self, ...)
    local v15 = getnamecallmethod()
    local v16 = {...}
    if not checkcaller() and v15 == "FireServer" and self.Name == "MAINEVENT" then
        return v14(self, unpack(v16))
    end
    return v14(self, ...)
end))

local function v17()
    while v12 do
        local v18 = v6:FindFirstChild("MAINEVENT")
        if v18 then
            v18:FireServer("Stomp")
        end
        
        if v13 and v13:IsA("LocalScript") then
            local v19 = getsenv(v13)
            if v19 and v19.Stomp then
                v19.Stomp()
            end
        end
        task.wait()
    end
end

v11.MouseButton1Click:Connect(function()
    v12 = not v12
    if v12 then
        v11.Text = 'AUTO STOMP <font color="rgb(102, 255, 102)">[ON]</font>'
        task.spawn(v17)
    else
        v11.Text = 'AUTO STOMP <font color="rgb(255, 95, 42)">[OFF]</font>'
    end
end)
