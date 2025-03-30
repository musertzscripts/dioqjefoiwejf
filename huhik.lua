-- Create highlights and UI for all players
local function createESP(player)
    if player == game.Players.LocalPlayer then return end -- Don't highlight yourself
    
    local character = player.Character
    if not character then return end
    
    -- Check if highlight already exists
    if character:FindFirstChild("ESPHighlight") then return end
    
    -- Create highlight
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red highlight
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Name = "ESPHighlight"
    
    -- Create BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(4, 0, 1, 0)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = character:FindFirstChild("HumanoidRootPart")
    billboard.AlwaysOnTop = true
    billboard.Parent = character
    
    -- Create TextLabel
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextScaled = true
    textLabel.Parent = billboard
    
    -- Update health and name
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        textLabel.Text = player.Name .. " | Health: " .. math.floor(humanoid.Health)
        humanoid.HealthChanged:Connect(function(newHealth)
            textLabel.Text = player.Name .. " | Health: " .. math.floor(newHealth)
        end)
    end
end

-- Apply ESP to all players
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- Allow character to load
        createESP(player)
    end)
end

-- Connect to existing players
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        onPlayerAdded(player)
    end
end

-- Connect to new players
game.Players.PlayerAdded:Connect(onPlayerAdded)
