-- @ScriptType: LocalScript
local speed = 1 -- Speed
local gradient = script.Parent
local rs = game:GetService("RunService")

rs.RenderStepped:Connect(function(dt)
	gradient.Offset = Vector2.new(gradient.Offset.X + (speed*dt), 0)
	if gradient.Offset.X >= 1 then
		local isRotated = (gradient.Rotation == 180)
		gradient.Rotation = isRotated and 0 or 180; gradient.Offset = Vector2.new(-1, 0) --isRotated and -0.5 or -1
	end
end)