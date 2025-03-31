local player = game.Players.LocalPlayer
local aimRadius = 150 -- FOV radius
local target = nil
local isCamLocked = true -- Camlock enabled by default

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.new(1, 0, 0) -- Red
fovCircle.Thickness = 2
fovCircle.Radius = aimRadius
fovCircle.Filled = false
fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)

-- Line of Sight Check
local function hasLineOfSight(model)
    local character = player.Character
    if character and character:FindFirstChild("Head") and model:FindFirstChild("Head") then
        local origin = character.Head.Position
        local target = model.Head.Position
        local ray = Ray.new(origin, (target - origin).Unit * (target - origin).Magnitude)
        local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {character, model})
        return hit == nil
    end
    return false
end

-- Find the Closest Target with Line of Sight
local function getClosestTarget()
    local closestDistance = aimRadius
    local closestTarget = nil

    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") and v ~= player.Character then
            local targetPosition = v.Head.Position
            local screenPosition, onScreen = workspace.CurrentCamera:WorldToScreenPoint(targetPosition)

            if onScreen and hasLineOfSight(v) then
                local screenCenter = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - screenCenter).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestTarget = v
                end
            end
        end
    end

    return closestTarget
end

-- Lock Camera to Target's Head
local function lockCameraToTarget()
    if target and target:FindFirstChild("Head") then
        workspace.CurrentCamera.CFrame = CFrame.new(
            workspace.CurrentCamera.CFrame.Position,
            target.Head.Position
        )
    end
end

-- Main Loop
game:GetService("RunService").RenderStepped:Connect(function()
    target = getClosestTarget()
    if isCamLocked and target then
        lockCameraToTarget()
    end
end)

-- Run Notification
local function showNotification(text)
    local notification = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    local frame = Instance.new("Frame", notification)
    frame.AnchorPoint = Vector2.new(0, 1)
    frame.Position = UDim2.new(0, 10, 1, -10)
    frame.Size = UDim2.new(0, 200, 0, 40)
    frame.BackgroundTransparency = 1
    frame.BackgroundColor3 = Color3.new(0, 0, 0)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextScaled = true

    task.wait(3)
    notification:Destroy()
end

showNotification("Loaded! (swag hub)")
