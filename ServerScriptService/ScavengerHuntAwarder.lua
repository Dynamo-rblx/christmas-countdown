-- @ScriptType: Script
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ScavengerHunt = require(ReplicatedStorage:WaitForChild("ScavengerHunt"))

ScavengerHunt.collected:Connect(function(player, itemName)
	print(player.DisplayName, itemName)
end)

ScavengerHunt.allCollected:Connect(function(player)
	print(player.DisplayName .. " completed the hunt!")
	game:GetService("BadgeService"):AwardBadge(player.UserId, 271094868173319)
end)