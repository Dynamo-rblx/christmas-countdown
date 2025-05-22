-- @ScriptType: Script
script.Parent.Touched:Connect(function(bp)
	if bp:FindFirstAncestorOfClass("Model") then
		if game.Players:FindFirstChild(bp:FindFirstAncestorOfClass("Model").Name) then
			bp:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid").Health -= 5
		end
	end
end)