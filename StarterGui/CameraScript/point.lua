-- @ScriptType: LocalScript
--- Services ---
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
task.wait();

--- Declarations ---
local Player = Players.LocalPlayer;
local Character = workspace:WaitForChild("rig");

local Mouse = Player:GetMouse();

--- Character ---
local RightUpperArm = Character:WaitForChild("RightUpperArm");
local RightShoulder = RightUpperArm:WaitForChild("RightShoulder");
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");

--- Execution ---
RunService.Stepped:Connect(function()
	local hit = Mouse.Hit;

	-- add the lookVector * 5000 to the hit.p to make the point more "dramatic" (remove it and you'll see why I did this)
	local direction = hit.p + (Vector3.new(hit.LookVector.X + 0.001, 0.0008, hit.LookVector.Z) * 5000);

	-- get the rotation offset (so the arm points correctly depending on your rotation)
	local rootCFrame = HumanoidRootPart.CFrame;
	local rotationOffset = (rootCFrame - rootCFrame.p):inverse();
	
	-- since CFrames are relative, put the rotationOffset first, and then multiple by the point CFrame, and then multiple by the CFrame.Angles so the arm points in the right direction
	RightShoulder.Transform = rotationOffset * CFrame.new(Vector3.new(0, 0, 0), direction) * CFrame.Angles(math.pi / 2, 0, 0);
end)