-- LocalScript (z. B. in StarterPlayerScripts oder StarterGui)
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local remote = replicatedStorage:WaitForChild("WeaponFramework"):WaitForChild("Remotes"):WaitForChild("Network")

local FIRING_RATE = 0.1  -- Sekunden zwischen den Schüssen (0.1 = 10 Schuss pro Sekunde)
local isFiring = false
local fireLoop = nil

-- Funktion, die das eigentliche Schießen ausführt
local function shoot()
	local targetPosition = mouse.Hit.Position
	local args = {
		"M72",
		targetPosition,
		targetPosition + Vector3.new(0, 5, 0)
	}
	remote:FireServer(unpack(args))
end

-- Die Dauerschleife (läuft, solange isFiring == true)
local function startFiring()
	while isFiring do
		shoot()
		task.wait(FIRING_RATE)
	end
end

-- Maustaste gedrückt
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not isFiring then
		isFiring = true
		-- Starte die Fire-Schleife in einem neuen Thread (damit der Event-Handler nicht blockiert)
		task.spawn(startFiring)
	end
end)

-- Maustaste losgelassen
UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isFiring = false
	end
end)
