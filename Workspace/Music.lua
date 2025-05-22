-- @ScriptType: Script
function PickRandomSong()
	local RandomSong
	repeat
		local Songs = script.Parent.Songs:GetChildren()
		RandomSong = Songs[math.random(1,#Songs)]
	until RandomSong.ClassName == "Sound"
	return RandomSong
end

local RandomSong = PickRandomSong()
RandomSong:Play()

for i,v in pairs(script.Parent.Songs:GetChildren()) do
	if v:IsA("Sound") then
		v.Ended:Connect(function()
			local RandomSong = PickRandomSong()
			RandomSong:Play()
		end)
	end
end