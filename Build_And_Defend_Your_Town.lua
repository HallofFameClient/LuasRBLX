local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Event = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("EventManagerClient"):WaitForChild("ServerEvent")
local chestFolder = workspace:WaitForChild("Gameplay"):WaitForChild("Bin")

local VirtualUser = game:GetService("VirtualUser")

player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.zero, camera.CFrame)
    task.delay(1)
    VirtualUser:Button2Up(Vector2.zero, camera.CFrame)
end)

player.Idled:Connect(function()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            humanoid:Jump = true
            task.wait(0.1)
            humanoid:Jump = false
        end
    end
end)

local function openChest(chest)
    if string.sub(chest.Name, 1, 6) == "Chest_" then
        Event:FireServer("ChestOpened", chest.Name)
        task.wait(0.1)
    end
end

local existingChests = chestFolder:GetChildren()
if #existingChests == 0 then
else
    for _, chest in ipairs(existingChests) do
        openChest(chest)
    end
end

chestFolder.ChildAdded:Connect(function(newChest)
    openChest(newChest)
end)
