local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local clicking = false -- Controls the click loop

-- Function to start clicking rapidly
local function startClicking()
    clicking = true
    while clicking do
        UserInputService:InputBegan:Fire(Enum.UserInputType.MouseButton1, false)
        task.wait(0.01) -- Adjust for faster/slower clicking
    end
end

-- Function to stop clicking
local function stopClicking()
    clicking = false
end

-- Constantly check if the mouse is over another player
RunService.RenderStepped:Connect(function()
    local target = mouse.Target
    if target and target.Parent then
        local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
        if targetPlayer and targetPlayer ~= player then
            if not clicking then
                startClicking()
            end
        else
            stopClicking()
        end
    else
        stopClicking()
    end
end)
