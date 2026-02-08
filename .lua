local v1 = game:GetService("Players")
local v2 = game:GetService("ReplicatedStorage")
local v3 = v1.LocalPlayer

-- Reconstructing the "v_stack" (the arguments passed to unpack)
-- Based on typical Roblox combat scripts:
local v_args = {
    [1] = "Stomp", -- Or a similar action string found in your constants
    [2] = v3.Character -- Often scripts send the character as an argument
}

local v4 = Instance.new("ScreenGui", v3:WaitForChild("PlayerGui"))
local v5 = Instance.new("TextButton", v4)
v5.Size = UDim2.new(0, 200, 0, 50)
v5.Text = "Auto Stomp [OFF]"

local v6 = false

-- This is the part you caught: FireServer + unpack
local function v7()
    while v6 do
        local v8 = v2:FindFirstChild("MainEvent") or v2:FindFirstChild("StompEvent")
        if v8 then
            -- This is the 'unpack' logic you saw in the constants:
            v8:FireServer(unpack(v_args)) 
        end
        task.wait()
    end
end

v5.MouseButton1Click:Connect(function()
    v6 = not v6
    v5.Text = v6 and "Auto Stomp [ON]" or "Auto Stomp [OFF]"
    if v6 then task.spawn(v7) end
end)
