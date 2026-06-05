/*hook.Add( "StartCommand", "VManip_PreventReload", function(ply,ucmd) --prevent reload hook
	if VManip:IsActive() then 
        local curWep = ply:GetActiveWeapon()
        if (!IsValid(curWep) || curWep:GetClass() != "ca_tablet") && !ply:ShouldDrawLocalPlayer() then
            ucmd:RemoveKey(8192) 
        end 
    end
end)*/