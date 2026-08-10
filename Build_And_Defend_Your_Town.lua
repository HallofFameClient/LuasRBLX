local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Sicherheitshalber die Ordner abfragen (falls sie fehlen, bricht es nicht ab)
local Event = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("EventManagerClient"):WaitForChild("ServerEvent")
local chestFolder = workspace:WaitForChild("Gameplay"):WaitForChild("Bin")

-- ==============================================
-- 1. ANTI-IDLE (100% MOBILE KOMPATIBEL)
-- ==============================================
player.Idled:Connect(function()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            humanoid:Jump = true
            task.wait(0.1)
            humanoid:Jump = false
            -- print("Anti-Idle via Sprung") -- Kannst du auskommentieren
        end
    end
end)

-- ==============================================
-- 2. TRUHE-AUTOMATIK
-- ==============================================
local function openChest(chest)
    if string.sub(chest.Name, 1, 6) == "Chest_" then
        Event:FireServer("ChestOpened", chest.Name)
        task.wait(0.1) -- Kurze Pause, um Remote-Event-Spam zu vermeiden
    end
end

-- Bestehende Truhen öffnen (das leere "if" ist überflüssig – bei 0 Truhen passiert einfach nichts)
for _, chest in ipairs(chestFolder:GetChildren()) do
    openChest(chest)
end

-- Neue Truhen sofort öffnen
chestFolder.ChildAdded:Connect(function(newChest)
    openChest(newChest)
end)
