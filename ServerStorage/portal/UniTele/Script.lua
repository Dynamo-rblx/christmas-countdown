-- @ScriptType: Script
-- © T
function onTouched(hit)
    local player = game.Players:GetPlayerFromCharacter(hit.Parent)
    if player then
		game:GetService("TeleportService"):Teleport(132232648008801, player,{},script.LoadingScreen)
    end
end
 
script.Parent.Touched:connect(onTouched) 
-- © Firetim Productions - Team Spyral, All Rights Reserved. ©