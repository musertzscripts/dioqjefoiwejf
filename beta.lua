local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local clicking = false -- Controls the clicking loop

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

-- Function to check if the target is another player
local function isHoveringOverPlayer(target)
    if target and target.Parent then
        local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
        return targetPlayer and targetPlayer ~= player
    end
    return false
end

-- PC: Detects if the mouse is over another player
RunService.RenderStepped:Connect(function()
    if isHoveringOverPlayer(mouse.Target) then
        if not clicking then
            startClicking()
        end
    else
        stopClicking()
    end
end)

-- Mobile: Detects if the player taps on another player
UserInputService.TouchTapInWorld:Connect(function(position, processed)
    if processed then return end -- Ignore UI touches

    local ray = workspace:Raycast(position, Vector3.new(0, -1, 0))
    if ray and isHoveringOverPlayer(ray.Instance) then
        startClicking()
    else
        stopClicking()
    end
end)
