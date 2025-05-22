-- @ScriptType: Script
game.Players.PlayerAdded:Connect(function(plr)
	local c = plr.Character or plr.CharacterAdded:Wait()
	c:WaitForChild("Humanoid").WalkSpeed = 0
end)
script:WaitForChild("Creepy"):Play()
local function playAnim(animator, anim)
	local track = Instance.new("Animation")
	track.AnimationId = anim
	local track = animator:LoadAnimation(track)
	track:Play()
	return track
end

status = script.Status

for i = 10, 0, -1 do
	status.Value = "("..i..")"
	task.wait(1)
end
task.wait(1)
game:GetService("ReplicatedStorage"):WaitForChild("BeginIntro"):FireAllClients()
task.wait(1)
game.Chat:Chat(workspace:WaitForChild("Santa")["That Whole Santa Look"].Handle, "Ho Ho Ho!", Enum.ChatColor.White)
task.wait(3)
game.Chat:Chat(workspace:WaitForChild("Santa")["That Whole Santa Look"].Handle, "I was beginning to think you wouldn't show!", Enum.ChatColor.White)
task.wait(3)
game.Chat:Chat(workspace:WaitForChild("Santa")["That Whole Santa Look"].Handle, "I don't want to fight you...", Enum.ChatColor.White)
task.wait(4)


game.Lighting.Brightness = 50
script.lightning_strike:Play()
game.Chat:Chat(workspace:WaitForChild("Santa")["That Whole Santa Look"].Handle, "But I guess I will if I have to...", Enum.ChatColor.Red)
game.ServerStorage:WaitForChild("bolt").Parent = workspace
local electro = playAnim(workspace.Santa:WaitForChild("Humanoid"):WaitForChild("Animator"), 'rbxassetid://117489360319869')
electro.Looped = true
task.wait(0.5)
game.Workspace:WaitForChild("bolt").Parent = game.ServerStorage
task.wait(2.5)
electro:Stop()
game.Lighting.Brightness = -50
game.Chat:Chat(workspace:WaitForChild("Santa")["That Whole Santa Look"].Handle, "urggh", Enum.ChatColor.White)
local die = playAnim(workspace.Santa:WaitForChild("Humanoid"):WaitForChild("Animator"), 'rbxassetid://140704291100551')
die.Ended:Wait()
script.Creepy:Stop()
script:WaitForChild("Ignition"):Play()
game.Lighting.ColorCorrection.TintColor = Color3.fromRGB(223, 167, 255)

workspace.Santa.Parent = game.ServerStorage
game.ServerStorage["Thundersoul Santa"].Parent = workspace
task.wait(1)
game.Lighting.Brightness = 0
game.Chat:Chat(workspace:WaitForChild("Thundersoul Santa").Head, "...", Enum.ChatColor.Blue)
workspace:WaitForChild("Boss").Value = workspace["Thundersoul Santa"]
task.wait(1)
game.ReplicatedStorage:WaitForChild("toggleHealthBar"):FireAllClients(true)
game.ReplicatedStorage:WaitForChild("toggleHealthBar"):FireAllClients(true)
game.ReplicatedStorage:WaitForChild("toggleHealthBar"):FireAllClients(true)
for i, v in pairs(game.Players:GetChildren()) do
	v.PlayerGui.healthBar.Frame.Visible = true
end
task.wait(2)
game.ReplicatedStorage:WaitForChild("EndIntro"):FireAllClients()
for i, v in pairs(game.Players:GetChildren()) do
	v.Character.Humanoid.WalkSpeed = 16
	
	while workspace:WaitForChild("Thundersoul Santa"):WaitForChild("Humanoid").Health > 0 do
		task.wait()
		v.PlayerGui.healthBar.Frame.Visible = true
	end
end

