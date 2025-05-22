-- @ScriptType: LocalScript
-- made by 4836s (wynn), Put me in StarterPlayer>StarterCharacterScripts
-- preload
local runningAnimation = Instance.new('Animation')
local jumpingAnimation = Instance.new('Animation')
local pressed = false

-- settings
local defaultSpeed = 16 -- Your default walking speed
local sprintSpeed = 32 -- Your custom running speed
local FOV = 80 -- Change to your default FOV
local walkingFOV = {FieldOfView = FOV} -- The FOV variable (line above) will be the walkingFOV. (default FOV)
local sprintFOV = {FieldOfView = FOV + 20} -- Increase the FOV by how much (Default is 50 (Which will be 120 FOV))
local tweenTime = 0.7 -- Change this to the time that you want the tween to take to finish
local keyboardButton = Enum.KeyCode.LeftShift -- To customize, go to create.roblox.com/docs/reference/engine/enums/KeyCode and find the key you want.
local controllerButton = Enum.KeyCode.ButtonR1 -- To customize, go to create.roblox.com/docs/reference/engine/enums/KeyCode and find the key you want.
local tweenEasingStyle = Enum.EasingStyle.Exponential -- To customize, go to create.roblox.com/docs/reference/engine/enums/EasingStyle and find the easing style you want.
local tweenEasingDirection = Enum.EasingDirection.Out -- Easing Directions: In, Out, InOut
runningAnimation.AnimationId = 'rbxassetid://113606999711905' -- Set your running Animation ID
jumpingAnimation.AnimationId = 'rbxassetid://507765000' -- Set your running Animation ID
local keepJumpingAnimation = true -- (false by default) Turn this off if you dont want a jumping animation.

-- load Services & more
local player = script.Parent
local player2 = game:GetService("Players").LocalPlayer
local humanoid = player:WaitForChild("Humanoid",5)
local camera = game.workspace.CurrentCamera
local animator = humanoid:WaitForChild("Animator") -- Don't want animations? Delete line 6, 29 to 33, and line 58 and 61.
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local playRunning = humanoid:LoadAnimation(runningAnimation)
local playJumping = humanoid:LoadAnimation(jumpingAnimation)
local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait() -- A players Character
local Humanoid2 = character.Humanoid

-- Create FOV tweens
local Info = TweenInfo.new(tweenTime, tweenEasingStyle, tweenEasingDirection)
local runningT = TweenService:Create(camera, Info, sprintFOV)
local walkingT = TweenService:Create(camera, Info, walkingFOV)

-- Check for a key being held, Change FOV and Speed
UserInputService.InputBegan:Connect(function(input,gameProcessedEvent)
	if input.KeyCode == keyboardButton or input.KeyCode == controllerButton and gameProcessedEvent == false then
		pressed = true
		humanoid.WalkSpeed = sprintSpeed
	end
end)

UserInputService.InputEnded:Connect(function(input,gameProcessedEvent)
	if input.KeyCode == keyboardButton or input.KeyCode == controllerButton and gameProcessedEvent == false then
		pressed = false
		humanoid.WalkSpeed = defaultSpeed
		walkingT:Play()
	end
end)

-- Checks if your speed is over than the defaultSpeed by 1, Which it assumes that you're running, and plays the animation.
humanoid.Running:Connect(function(Speed)
	if Speed > 21 then
		if not playRunning.IsPlaying then
			runningT:Play()
			playRunning:Play()
		end
	else
		playRunning:Stop()
	end
end)

-- Checks if you jumped, and then stops the running animation and plays the jumping animation (If its turned on).
humanoid.Jumping:Connect(function()
	if playRunning.IsPlaying then
		playRunning:Stop()
		if keepJumpingAnimation == true then
			playJumping:Play()
		end
	end
end)