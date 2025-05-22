-- @ScriptType: Script
Flash = game.Lighting

while true do
	wait(math.random(0.5,20))
	for i = 1,math.random(1,5) do
		Flash.Brightness = 100
		wait(.2)
		Flash.Brightness = 1
		wait()
	end
	local time = math.random(1,5)
	wait(time)
	script.LightningSound.Volume = (1/time)
	script.ThunderSound.Volume = (1/time)
	if time < 5 then
		script.LightningSound:play()
		script.ThunderSound:play()
	else
		script.LightningSoundDeepThunder:play()
	end
end
