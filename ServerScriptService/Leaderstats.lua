-- @ScriptType: Script
local stat = "Presents"
local startamount = 0


local DataStore = game:GetService("DataStoreService")
local ds = DataStore:GetDataStore("LeaderStatSave")

--Don't worry about the rest of the code, except for line 25.
game.Players.PlayerAdded:connect(function(player)
	local leader = Instance.new("Folder",player)
	leader.Name = "leaderstats"
	local Cash = Instance.new("IntValue",leader)
	Cash.Name = stat
	Cash.Value = ds:GetAsync(player.UserId) or startamount
	ds:SetAsync(player.UserId, Cash.Value)
	
	
	Cash.Changed:connect(function()
		ds:SetAsync(player.UserId, Cash.Value)
	end)
end)

game.Players.PlayerRemoving:connect(function(player)
	ds:SetAsync(player.UserId, player.leaderstats.Presents.Value)
end)
