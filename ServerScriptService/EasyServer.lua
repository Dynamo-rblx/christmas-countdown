-- @ScriptType: Script
----------------------------------------------------------CONFIGURATION---------------------------------------------------------
local placeId = 132016272627199 --The ID of the place to teleport to

local minQueue = 1 --Minimum amount of players needed to be teleported to the place
local maxQueue = 6 --Maximum amount of players that can be queued in the same lobby
local timeAfterMin = 15 --Time allowed for more players to enter the queue once the minimum amount of queued players is reached

local minMembers = 1 --Minimum players needed to queue
local maxMembers = 3 --Maximum players allowed in one party
--------------------------------------------------------------------------------------------------------------------------------

local rs = game.ReplicatedStorage:WaitForChild("EasyPartyRS")
local re = rs:WaitForChild("RE")
local parties = rs:WaitForChild("EasyParties")

local tps = game:GetService("TeleportService")

local ms = game:GetService("MemoryStoreService")
local queue = ms:GetSortedMap("EQueueStore")


function findParty(plr)

	for i, party in pairs(parties:GetChildren()) do
		for x, member in pairs(party.Members:GetChildren()) do

			if member.Name == plr.Name then
				return party
			end
		end
	end
end

function joinParty(plr, party)
	leaveParty(plr)

	if party and #party.Members:GetChildren() < party.MaximumMembers.Value then
		local membersFolder = party.Members

		local memberValue = Instance.new("StringValue")
		memberValue.Name = plr.Name
		memberValue.Parent = membersFolder

		re:FireClient(plr, "JOIN", party)
	end
end

function leaveParty(plr)

	local currentParty = findParty(plr)

	if currentParty then
		local members = currentParty.Members:GetChildren()

		local memberValue = currentParty.Members[plr.Name]
		table.remove(members, table.find(members, memberValue))

		if #members > 0 then
			if memberValue:FindFirstChild("Leader") then
				local newLeader = members[Random.new():NextInteger(1, #members)]
				memberValue.Leader.Parent = newLeader

				currentParty.Name = newLeader.Name .. "'s party"
			end

			memberValue:Destroy()
		else
			currentParty:Destroy()
		end

		re:FireClient(plr, "LEAVE")
	end
end

game.Players.PlayerRemoving:Connect(leaveParty)


re.OnServerEvent:Connect(function(plr, instruction, data, diff)

	if instruction == "CREATE" then
		if data and tonumber(data) and tonumber(data) >= minMembers and tonumber(data) <= maxMembers then

			leaveParty(plr)

			local newParty = Instance.new("Folder")
			local partyName = plr.Name .. "'s party"
			newParty.Name = partyName

			local maxValue = Instance.new("IntValue")
			maxValue.Name = "MaximumMembers"
			maxValue.Value = data
			maxValue.Parent = newParty
			

			local membersFolder = Instance.new("Folder")
			membersFolder.Name = "Members"
			membersFolder.Parent = newParty

			local partyActive = true
			local function updateQueue()
				queue:RemoveAsync(partyName)

				if newParty:FindFirstChild("IN QUEUE") and partyActive then
					local members = {}
					for i, member in pairs(membersFolder:GetChildren()) do
						if game.Players:FindFirstChild(member.Name) then
							table.insert(members, game.Players[member.Name].UserId)
						end
					end

					queue:SetAsync(partyName, members, 2592000)
				end
			end

			membersFolder.ChildAdded:Connect(updateQueue)
			membersFolder.ChildRemoved:Connect(updateQueue)

			newParty.Destroying:Connect(function()
				partyActive = false
				queue:RemoveAsync(partyName)
			end)

			local memberValue = Instance.new("StringValue")
			memberValue.Name = plr.Name
			local leaderValue = Instance.new("StringValue")
			leaderValue.Name = "Leader"
			leaderValue.Parent = memberValue
			memberValue.Parent = membersFolder

			newParty.Parent = parties

			re:FireClient(plr, "JOIN", newParty)
		end

	elseif instruction == "JOIN" then
		if data and parties:FindFirstChild(data) then
			joinParty(plr, parties[data])
		end

	elseif instruction == "LEAVE" then
		leaveParty(plr)

	elseif instruction == "KICK" then
		local plrToKick = data and game.Players:FindFirstChild(data)
		if plrToKick then

			local currentParty = findParty(plr)
			if currentParty and currentParty.Members[plr.Name]:FindFirstChild("Leader") then

				local currentPartyOfPlrToKick = findParty(plrToKick)
				if currentPartyOfPlrToKick and currentParty == currentPartyOfPlrToKick then
					leaveParty(plrToKick)
				end
			end
		end

	elseif instruction == "QUEUE" then
		local currentParty = findParty(plr)

		local currentLeader = nil
		for i, member in pairs(currentParty.Members:GetChildren()) do
			if member:FindFirstChild("Leader") then
				currentLeader = member.Name
			end
		end

		if currentLeader == plr.Name and #currentParty.Members:GetChildren() >= minMembers then

			local inQueue = currentParty:FindFirstChild("IN QUEUE")

			if inQueue then
				queue:RemoveAsync(currentParty.Name)
				inQueue:Destroy()

			else
				local queueValue = Instance.new("IntValue")
				queueValue.Name = "IN QUEUE"
				queueValue.Parent = currentParty

				local members = {}
				for i, member in pairs(currentParty.Members:GetChildren()) do
					if game.Players:FindFirstChild(member.Name) then
						table.insert(members, game.Players[member.Name].UserId)
					end
				end
				queue:SetAsync(currentParty.Name, members, 2592000)

				local queueStart = os.time()
				while task.wait(1) do
					if queueValue then
						queueValue.Value = os.time() - queueStart
					else
						break
					end
				end
			end
		end
	end
end)


local lastOverMin = tick()

while task.wait(1) do
	local success, queuedData = pcall(function()
		return queue:GetRangeAsync(Enum.SortDirection.Descending, maxQueue)
	end)

	if success then
		local queuedPlayers = 0
		local queuedParties = {}

		for i, data in pairs(queuedData) do
			local partyName = data.key
			local partyMembers = data.value
			local amountInParty = #partyMembers

			if queuedPlayers < maxQueue and queuedPlayers + amountInParty < maxQueue then

				queuedPlayers += amountInParty
				table.insert(queuedParties, partyName)
			end
		end

		if queuedPlayers < minQueue then
			lastOverMin = tick()
		end

		if tick() - lastOverMin >= timeAfterMin or queuedPlayers == maxQueue then

			for i, party in pairs(queuedParties) do  

				if parties:FindFirstChild(party) then
					local playersToTeleport = {}

					for x, member in pairs(parties[party].Members:GetChildren()) do
						table.insert(playersToTeleport, game.Players[member.Name])
					end
					
					local data = {
						["difficulty"] = party
					}

					tps:TeleportPartyAsync(placeId, playersToTeleport, data, script.LoadingScreen)
				end	
			end
		end
	end
end

-- NOTES:
-- MAKE 2 SEPERATE PARTY SYSTEMS FOR THE DIFFERENT MODES
 -- FIX PARTY SYSTEM