-- @ScriptType: LocalScript
-----------{}
repeat
	task.wait(.5)
until game:IsLoaded()

game:GetService("StarterGui"):SetCore("ResetButtonCallback", false)
local CameraPart = workspace:WaitForChild("menuCam")
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local mouse = LocalPlayer:GetMouse()
local viewing = "easy"
local btn = script.Parent:WaitForChild("Switch"):WaitForChild("Frame"):WaitForChild("TextButton")
local stopper = false
local db = false

--local rig = workspace:WaitForChild("rig")
--local Humanoid = rig:FindFirstChildOfClass("Humanoid") or rig:WaitForChild("Humanoid")
--local Joint =	rig:WaitForChild("Head"):WaitForChild("Neck")
-----------{}

repeat task.wait()
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
until CurrentCamera.CameraType == Enum.CameraType.Scriptable

repeat task.wait()
	CurrentCamera.CFrame = CameraPart.CFrame
until CurrentCamera.CFrame == CameraPart.CFrame

local hd = game.Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
hd.Parent = workspace.rig

for i, v in pairs(PlayerCharacter:GetChildren()) do
	if v:IsA("Accessory") or v:IsA("Hat") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") or v:IsA("Clothing") then
		v.Parent = workspace
		v.Parent = workspace.rig
		v:Clone().Parent = workspace.Hard.rig
	end
end

workspace.rig["Elf Ears"].Handle.Color = workspace.rig.Head.Color
workspace.Hard.rig["Elf Ears"].Handle.Color = workspace.rig.Head.Color

btn.MouseButton1Click:Connect(function()
	if db == false then
		db = true
		stopper = true
		if viewing == "easy" then
			local e = game:GetService("TweenService"):Create(CurrentCamera, TweenInfo.new(1.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {["CFrame"]=workspace:WaitForChild("Hard"):WaitForChild("menuCam").CFrame})
			e:Play()
			e.Completed:Wait()
			CameraPart = workspace:WaitForChild("Hard"):WaitForChild("menuCam")
			viewing = "hard"
			
		elseif viewing == "hard" then
			local e = game:GetService("TweenService"):Create(CurrentCamera, TweenInfo.new(1.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {["CFrame"]=workspace:WaitForChild("menuCam").CFrame})
			e:Play()
			e.Completed:Wait()
			CameraPart = workspace:WaitForChild("menuCam")
			viewing = "easy"
			
		end
		stopper = false
		db = false
	end
end)

script.Parent:WaitForChild("inParty").Changed:Connect(function()
	if script.Parent.inParty.Value == true then
		script.Parent:WaitForChild("Switch").Enabled = false
	else
		script.Parent:WaitForChild("Switch").Enabled = true
	end
end)

--// Move cam
local maxTilt = 10
game:GetService("RunService").RenderStepped:Connect(function()
	if not(stopper) then
		CurrentCamera.CFrame = CameraPart.CFrame * CFrame.Angles(
			math.rad((((mouse.Y - mouse.ViewSizeY / 2) / mouse.ViewSizeY)) * -maxTilt),
			math.rad((((mouse.X - mouse.ViewSizeX / 2) / mouse.ViewSizeX)) * -maxTilt),
			0
		)
	end
	--Joint.C0 = CFrame.lookAt(Joint.C0.Position, Vector3.new(mouse.Hit.Position.X, Joint.C0.Position.Y, math.min(-Joint.C0.LookVector.Z, mouse.Hit.Position.Z))) * CFrame.Angles(0, 0, 0)
end)


