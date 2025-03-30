game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge -- Set max health to an extremely high number
            humanoid.Health = math.huge -- Set current health to an extremely high number
            
            humanoid.HealthChanged:Connect(function()
                humanoid.Health = math.huge -- Reset health if it changes
            end)
        end
    end)
end)
