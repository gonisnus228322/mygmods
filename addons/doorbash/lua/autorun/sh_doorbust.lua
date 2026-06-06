AddCSLuaFile()

CreateConVar("bust_enabled", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or disable sprinting busting behavior", 0, 1)
CreateConVar("bust_doors", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or disable busting doors", 0, 1)
CreateConVar("bust_windows", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or disable busting windows", 0, 1)
CreateClientConVar("bust_viewpunch", 1, true, true, "Enable or disable bust viewpunch", 0, 1)

if SERVER then
    util.AddNetworkString("BustEffect")
    local isNoclipping

    hook.Add("PlayerNoClip", "NoClipCheck", function(ply, noclip)
        isNoclipping = noclip
    end)

    local et1, et2

    local function BustDoorTest(ply, tbl, fx)
        local ent, surf = tbl[1], tbl[2]
        if !IsValid(ent) then print("if you see this something went wrong with doorbusting") return end
        if GetConVar("bust_doors"):GetBool() then
            if ent:GetClass() == "prop_door_rotating" then
                BustRotatingDoor(ply, ent, fx)
            elseif ent:GetClass() == "func_door_rotating" then
                BustFuncDoor(ply, ent, fx)
            end
        end
        if GetConVar("bust_windows"):GetBool() and (string.find(surf, "glass") or string.find(surf, "default")) then
            if ent:GetClass() == "func_breakable_surf" then
                ent:Fire("Shatter", "0.5 0.5 " .. ent:BoundingRadius())
                BustEffects(ply, ent, false)
            elseif ent:Health() > 0 and ent:Health() <= ent:GetMaxHealth() then
                ent:TakeDamage(10, ply, ent)
                ent:EmitSound("Glass.Strain")
                BustEffects(ply, ent, false)
            end
        end
    end

    hook.Add("SetupMove", "DoorBustSetup", function(ply, mv, cmd)
        if !IsFirstTimePredicted() or !GetConVar("bust_enabled"):GetBool() or !ply:Alive() then return end
        local vel = mv:GetVelocity()
        if vel:Length() < ply:GetRunSpeed() * .8 or !cmd:KeyDown(IN_SPEED) then return end
        local dir, pos, pos2 = vel:GetNormalized(), ply:GetPos() + Vector(0,0,ply:GetStepSize() + 1), ply:GetPos() + (ply:OBBMins() + ply:OBBMaxs()) -- so we're not breaking waist-high windows and doors we can't walk into
        local fwd, rt = dir, Vector(dir.y, -dir.x, dir.z)
        et1 = util.QuickTrace(pos2, fwd * 30, ply)
        local ent, ent2 = {et1.Entity, util.GetSurfacePropName(et1.SurfaceProps)}
        et1 = util.QuickTrace(pos, fwd * 30, ply)
        if et1.HitNonWorld and !isNoclipping then
            if et1.Entity == ent[1] then
                BustDoorTest(ply, ent, true)
            end
            if !IsValid(et1.Entity) or (string.find(ent[2], "glass") or string.find(ent[2], "default")) then return end
            et2 = util.QuickTrace(pos - (rt * 16), fwd * 45, ply)
            if !IsValid(et2.Entity) or et2.Entity == ent[1] then
                et2 = util.QuickTrace(pos + (rt * 16), fwd * 45, ply)
            end
            if !IsValid(et2.Entity) or et2.Entity == ent[1] then return end
            ent2 = {et2.Entity, util.GetSurfacePropName(et2.SurfaceProps)}
            if ent2 and ent2 != ent then
                BustDoorTest(ply, ent2, false)
            end
        end
    end)

    function BustRotatingDoor(ply, door, fx)
        local state = door:GetInternalVariable("m_eDoorState")
        if state > 0 then return end

        local isLocked = door:GetInternalVariable("m_bLocked")
        local oldDir = door:GetInternalVariable("opendir")
        local oldSpeed = door:GetInternalVariable("speed")
        local oldFlags = door:GetSpawnFlags()

        if bit.band(oldFlags, 32768) != 0 then return end
        if !isLocked then
            door:SetKeyValue("opendir", 0)
            door:Fire("SetSpeed", 500, 0)
            door:Fire("OpenAwayFrom", "Buster" .. ply:EntIndex(), 0)

            timer.Simple(0.5, function()
                door:Fire("SetSpeed", oldSpeed, 0)
                door:SetKeyValue("opendir", oldDir)
            end)
        end
        if !fx then return end
        BustEffects(ply, door, true)
    end

    local function BustFuncRotating(ply, door)
        door:SetSaveValue("m_hactivator", ply)
        door:Fire("SetSpeed", 500, 0)
        door:Fire("Open", "", 0)
    end

    function BustFuncDoor(ply, door, fx)
        local state = door:GetInternalVariable("m_toggle_state")
        if state != 1 then return end

        local isLocked = door:GetInternalVariable("m_bLocked")
        local oldSpeed = door:GetInternalVariable("speed")
        local oldFlags = door:GetSpawnFlags()
        local newFlags = oldFlags

        if bit.band(oldFlags, 192) != 0 or bit.band(oldFlags, 1280) == 0 then return end

        if !isLocked then
            local localRight = door:GetRight()
            local openDir = door:HasSpawnFlags(2) and (localRight * -1) or localRight

            if door:HasSpawnFlags(2) then
                if ply:GetVelocity():Dot(openDir) > 0 then BustFuncRotating(ply, door) end
            else
                if door:HasSpawnFlags(16) then newFlags = bit.bxor(newFlags, 16) end
                door:SetKeyValue("spawnflags", newFlags)

                BustFuncRotating(ply, door)
            end

            timer.Simple(0.5, function()
                door:Fire("SetSpeed", oldSpeed, 0)
                door:SetKeyValue("spawnflags", oldFlags)
            end)
        end

        if !fx then return end
        BustEffects(ply, door, true)
    end

    function BustEffects(ply, ent, fx)
        ply:SetName("Buster" .. ply:EntIndex())
        ply:AnimRestartGesture(4, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)

        if fx then
            util.ScreenShake(et1.HitPos, 10, 10, 1, 100)
            sound.Play("Wood_Furniture.Break", et1.HitPos, 100, math.random(95,105), 1)
            sound.Play("Plastic_Box.Break", et1.HitPos, 100, math.random(95,105), 1)
        end

        net.Start("BustEffect")
        net.WriteVector(et1.HitPos)
        net.WriteNormal(et1.HitNormal)
        net.WriteFloat(ent:GetInternalVariable("speed"))
        net.Broadcast()

        if !tobool(ply:GetInfoNum("bust_viewpunch", 0)) then return end
        local isLeftBust = tobool(math.random(0, 1))
        local bustYaw, bustRoll = isLeftBust and 10 or -10, isLeftBust and -10 or 10
        ply:ViewPunch(Angle(10, bustYaw, bustRoll))
    end
end



if CLIENT then
    net.Receive("BustEffect", function()
        LocalPlayer():AnimRestartGesture(4, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
        local hitPos = net.ReadVector()
        local normal = net.ReadNormal()
        local magnit = net.ReadFloat()

        local ef = EffectData()
        ef:SetStart(hitPos)
        ef:SetOrigin(hitPos)
        ef:SetNormal(normal)
        ef:SetMagnitude(magnit)
        util.Effect("busteffect", ef)
    end)

    hook.Add("PopulateToolMenu", "DoorBust_AddOptions", function()
        spawnmenu.AddToolMenuOption("Options", "Door Bust!", "doorbust_server", "Settings", "", "", function(pnl)
            pnl:Help("Server")
            pnl:CheckBox("Sprint busting enabled", "bust_enabled")
            pnl:CheckBox("Door busting enabled", "bust_doors")
            pnl:CheckBox("Window busting enabled", "bust_windows")
            pnl:Help("Client")
            pnl:CheckBox("Viewpunch on bust", "bust_viewpunch")
        end)
    end)
end