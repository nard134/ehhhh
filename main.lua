-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

-- Player and constants
local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId
local webhookURL = "https://discord.com/api/webhooks/1395443029351075922/0K8QJ03Fwr509Az7UAB0rJ8IBB5zr2OcwCdMuNSZz6rcpuSTC08POMvJo2L6SOPsNrrj" -- Replace this

-- Remote
local PetEggService = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetEggService")

-- Webhook sender
local function sendWebhook(message)
	local payload = HttpService:JSONEncode({
		username = "Zen Egg Farmer",
		content = message
	})
	pcall(function()
		HttpService:PostAsync(webhookURL, payload)
	end)
end

-- Find Zen Egg model in workspace
local function getZenEgg()
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name:lower():find("zen") then
			return obj
		end
	end
	return nil
end

-- Hatch Zen Egg
local function hatchZenEgg()
	local egg = getZenEgg()
	if egg then
		sendWebhook("🥚 Attempting to hatch **Zen Egg**: " .. egg.Name)
		pcall(function()
			PetEggService:FireServer("HatchPet", egg)
		end)
	else
		sendWebhook("❌ No Zen Egg found.")
	end
end

-- Auto farming loop
while true do
	hatchZenEgg()
	wait(5) -- Wait before rejoining (adjust as needed)
	sendWebhook("🔁 Rejoining to refresh egg timer...")
	TeleportService:TeleportToPlaceInstance(placeId, game.JobId, LocalPlayer)
	wait(10) -- Wait after rejoining before loop continues
end

