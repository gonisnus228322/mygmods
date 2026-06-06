hook.Add("PlayerDeath", "NoRagdollOnDeath_nosey", function(ply)
    timer.Simple(0, function()
        if IsValid(ply) and IsValid(ply:GetRagdollEntity()) then
            if not ply:GetNWBool("nosey_shouldnotragdol") then return end
            ply:SetNWBool("nosey_shouldnotragdol", false)
            ply:GetRagdollEntity():Remove()
        end
    end)
end)


hook.Add("PlayerButtonDown", "DetectUseKey_Nosey", function(ply, button)
    local pillentity = ply.pk_pill_ent
    if IsValid(pillentity) then
        if pillentity.formTable.NoseyKeybind then
            pillentity.formTable.NoseyKeybind(ply, pillentity, button)
        end
    end
end)

hook.Add("OnEntityCreated", "Nosey_gentoi_iniatlize", function(ent)
    timer.Simple(0.01, function()
        if !IsValid(ent) then return end
        if ent:GetClass() ~= "pill_ent_costume" then return end


        if ent.formTable then
            local PuppetEntity = ent:GetPuppet()
            local entityply = ent:GetPillUser()

            if ent.formTable.nosey_jentoi_pill_init then
                ent.formTable:nosey_jentoi_pill_init(entityply, ent, PuppetEntity)


                local self = ent
                ent.Think = function()
                    local ply = self:GetPillUser()
                    local puppet = self:GetPuppet()
                    if not IsValid(puppet) or not IsValid(ply) then return end
                    local vel = ply:GetVelocity():Length()

                    if SERVER then
                        --Anims
                        local anims = table.Copy(self.formTable.anims.default or {})
                        table.Merge(anims, (IsValid(ply:GetActiveWeapon()) and self.formTable.anims[ply:GetActiveWeapon():GetHoldType()]) or (self.forceAnimSet and self.formTable.anims[self.forceAnimSet]) or {})
                        local anim
                        --local useSeqVel=true
                        local overrideRate

                        if (not self.anim or not anims[self.anim]) then
                            self.animFreeze = nil
                            self.animStart = nil
                        end

                        if self.animFreeze and not self.plyFrozen then
                            ply:SetWalkSpeed(ply:GetWalkSpeed() / 2)
                            ply:SetRunSpeed(ply:GetWalkSpeed() / 2)
                            self.plyFrozen = true
                        elseif not self.animFreeze and self.plyFrozen then
                            local speed = self.formTable.moveSpeed or {}
                            ply:SetWalkSpeed(speed.walk or 200)
                            ply:SetRunSpeed(speed.run or speed.walk or 500)
                            self.plyFrozen = nil
                        end

                        if self.anim and anims[self.anim] then
                            anim = anims[self.anim]
                            overrideRate = anims[self.anim .. "_rate"] or 1
                            local cycle = puppet:GetCycle()

                            if not self.animStart then
                                if cycle == 1 or (self.animCycle and self.animCycle > cycle) or (string.lower(anim) ~= string.lower(puppet:GetSequenceName(puppet:GetSequence()))) then
                                    self.anim = nil
                                    self.animCycle = nil

                                    if self.animFreeze then
                                        self.animFreeze = nil
                                    end
                                elseif self.animCycle then
                                    self.animCycle = cycle
                                end
                            end
                        elseif self.tickAnim and anims[self.tickAnim] then
                            anim = anims[self.tickAnim]
                            overrideRate = anims[self.tickAnim .. "_rate"] or 1
                            self.tickAnim = nil
                        elseif self.burrowed then
                            anim = anims["burrow_loop"]
                        elseif ply:WaterLevel() > 2 then
                            anim = anims["swim"] or anims["glide"] or anims["idle"]
                        elseif ply:IsOnGround() then
                            if ply:Crouching() then
                                if vel > ply:GetCrouchedWalkSpeed() / 4 then
                                    anim = anims["crouch_walk"] or anims["crouch"] or anims["walk"] or anims["idle"]
                                else
                                    anim = anims["crouch"] or anims["idle"]
                                end
                            else
                                if vel > (ply:GetWalkSpeed() + ply:GetRunSpeed()) / 2 then
                                    anim = anims["run"] or anims["walk"] or anims["idle"]
                                elseif vel > ply:GetWalkSpeed() / 4 then
                                    anim = anims["walk"] or anims["idle"]
                                else
                                    anim = anims["idle"]
                                end
                            end
                        else
                            anim = anims["glide"] or anims["idle"]
                        end

                        if anim == anims["idle"] or anim == anims["crouch"] then
                            overrideRate = 1
                        end

                        if (anim and puppet:GetSequence() ~= puppet:LookupSequence(anim)) or self.animStart or (self.formTable.autoRestartAnims and puppet:GetCycle() == 1) then
                            puppet:ResetSequence(puppet:LookupSequence(anim))
                            puppet:SetCycle(0)
                            self.animCycle = 0
                        end

                        self.animStart = nil
                        local seq_vel = puppet:GetSequenceGroundSpeed(puppet:GetSequence())

                        --if true then
                        if self.formTable.movePoseMode ~= "xy" and self.formTable.movePoseMode ~= "xy-bot" and not overrideRate then
                            local rate = overrideRate or vel / seq_vel

                            --goofy limitation (floods console with errors if above 12!)
                            if rate > 12 then
                                rate = 12
                            end

                            puppet:SetPlaybackRate(rate)
                        else
                            --puppet:SetPlaybackRate(1)
                        end

                        --print(puppet:GetCycle())
                        if self.formTable.movePoseMode then
                            --
                            if self.formTable.movePoseMode == "yaw" then
                                local move_dir = puppet:WorldToLocalAngles(ply:GetVelocity():Angle())
                                puppet:SetPoseParameter("move_yaw", move_dir.y)
                            elseif self.formTable.movePoseMode == "xy" then
                                if not overrideRate then
                                    local localvel = ply:WorldToLocal(ply:GetPos() + ply:GetVelocity())
                                    local maxdim = math.Max(math.abs(localvel.x), math.abs(localvel.y))
                                    local clampedvel = maxdim == 0 and Vector(0, 0, 0) or localvel / maxdim
                                    puppet:SetPoseParameter("move_x", clampedvel.x)
                                    puppet:SetPoseParameter("move_y", -clampedvel.y)
                                    seq_vel = puppet:GetSequenceGroundSpeed(puppet:GetSequence())

                                    if seq_vel ~= 0 then
                                        puppet:SetPoseParameter("move_x", math.Clamp(localvel.x / seq_vel, -.99, .99))
                                        puppet:SetPoseParameter("move_y", math.Clamp(-localvel.y / seq_vel, -.99, .99))
                                    end
                                    --print(puppet:GetPlaybackRate())
                                else
                                    puppet:SetPoseParameter("move_x", 0)
                                    puppet:SetPoseParameter("move_y", 0)
                                end
                            elseif self.formTable.movePoseMode == "xy-bot" then
                                if not overrideRate then
                                    local localvel = ply:WorldToLocal(ply:GetPos() + ply:GetVelocity())
                                    local maxdim = math.Max(math.abs(localvel.x), math.abs(localvel.y))
                                    local clampedvel = maxdim == 0 and Vector(0, 0, 0) or localvel / maxdim
                                    local move_dir = puppet:WorldToLocalAngles(ply:GetVelocity():Angle())
                                    puppet:SetPoseParameter("move_x", clampedvel.x)
                                    puppet:SetPoseParameter("move_y", -clampedvel.y)
                                    puppet:SetPoseParameter("move_yaw", move_dir.y)
                                    puppet:SetPoseParameter("move_scale", 1)
                                    seq_vel = puppet:GetSequenceGroundSpeed(puppet:GetSequence())

                                    if seq_vel ~= 0 then
                                        puppet:SetPoseParameter("move_x", math.Clamp(localvel.x / seq_vel, -.99, .99))
                                        puppet:SetPoseParameter("move_y", math.Clamp(-localvel.y / seq_vel, -.99, .99))
                                        puppet:SetPoseParameter("move_scale", math.Clamp(localvel:Length() / seq_vel, -.99, .99))
                                    end
                                    --print(puppet:GetPlaybackRate())
                                else
                                    puppet:SetPoseParameter("move_x", 0)
                                    puppet:SetPoseParameter("move_y", 0)
                                    puppet:SetPoseParameter("move_yaw", 0)
                                    puppet:SetPoseParameter("move_scale", 0)
                                end
                            end
                        end

                        --Aimage
                        if self.formTable.aim then
                            if self.formTable.aim.xPose then
                                local yaw = math.AngleDifference(ply:EyeAngles().y, self:GetAngles().y)

                                if self.formTable.aim.xInvert then
                                    yaw = -yaw
                                end

                                puppet:SetPoseParameter(self.formTable.aim.xPose, yaw)
                            end

                            if self.formTable.aim.yPose then
                                local pitch = math.AngleDifference(ply:EyeAngles().p, self:GetAngles().p)

                                if self.formTable.aim.yInvert then
                                    pitch = -pitch
                                end

                                puppet:SetPoseParameter(self.formTable.aim.yPose, pitch)
                            end
                        end

                        --gliding and landing
                        if not ply:IsOnGround() and ply:WaterLevel() == 0 and self.formTable.glideThink then
                            self.formTable.glideThink(ply, self)
                        end

                        if not ply:IsOnGround() and not self.touchingWater and ply:WaterLevel() > 0 and self.formTable.land then
                            self.formTable.land(ply, self)
                        end

                        --water death
                        self.touchingWater = ply:WaterLevel() > 1

                        if (self.formTable.damageFromWater and self.touchingWater) then
                            if self.formTable.damageFromWater == -1 then
                                --self:PillDie()
                                ply:Kill()
                            else
                                ply:TakeDamage(self.formTable.damageFromWater)
                                --TODO APPLY DAMAGE
                            end
                        end

                        --tick attack
                        if ply:KeyDown(IN_ATTACK) and self.formTable.attack and self.formTable.attack.mode == "tick" then
                            self.formTable.attack.func(ply, self, self.formTable.attack)
                        end

                        if ply:KeyDown(IN_ATTACK2) and self.formTable.attack2 and self.formTable.attack2.mode == "tick" then
                            self.formTable.attack2.func(ply, self, self.formTable.attack2)
                        end

                        --auto attack
                        if ply:KeyDown(IN_ATTACK) and self.formTable.attack and self.formTable.attack.mode == "auto" then
                            if not self.formTable.aim then
                                self:PillLoopSound("attack")
                            else
                                self:PillLoopStop("attack")
                            end

                            if (not self.lastAttack or (self.formTable.attack.interval or self.formTable.attack.delay) < CurTime() - self.lastAttack) then
                                self.formTable.attack.func(ply, self, self.formTable.attack)
                                self.lastAttack = CurTime()
                            end
                        else
                            self:PillLoopStop("attack")
                        end

                        if ply:KeyDown(IN_ATTACK2) and self.formTable.attack2 and self.formTable.attack2.mode == "auto" then
                            if not self.formTable.aim then
                                self:PillLoopSound("attack2")
                            else
                                self:PillLoopStop("attack2")
                            end

                            if not self.lastAttack2 or (self.formTable.attack2.interval or self.formTable.attack2.delay) < CurTime() - self.lastAttack2 then
                                self.formTable.attack2.func(ply, self, self.formTable.attack2)
                                self.lastAttack2 = CurTime()
                            end
                        else
                            self:PillLoopStop("attack2")
                        end

                        --charge
                        if self:GetChargeTime() ~= 0 then
                            if ply:OnGround() then
                                local charge = self.formTable.charge
                                local angs = ply:EyeAngles()
                                self:PillAnimTick("charge_loop")
                                local hit_ent = ply:TraceHullAttack(ply:EyePos(), ply:EyePos() + angs:Forward() * 100, Vector(-20, -20, -20), Vector(20, 20, 20), charge.dmg, DMG_CRUSH, 1, true)

                                if IsValid(hit_ent) then
                                    self:PillAnim("charge_hit", true)
                                    --self:PillGesture("charge_hit")
                                    self:PillSound("charge_hit")
                                    self:SetChargeTime(0)
                                    self:PillLoopStop("charge")
                                end
                            else
                                self:SetChargeTime(0)
                                self:PillLoopStop("charge")
                            end
                        end

                        --Cloak
                        if self.formTable.cloak then
                            local cloak = self.formTable.cloak

                            if self.iscloaked then
                                local cloakamt = self:GetCloakLeft()

                                if cloakamt ~= -1 then
                                    cloakamt = cloakamt - FrameTime()

                                    if cloakamt < 0 then
                                        cloakamt = 0
                                        self:ToggleCloak()
                                    end

                                    self:SetCloakLeft(cloakamt)
                                end
                            else
                                local cloakamt = self:GetCloakLeft()

                                if cloakmt ~= -1 and cloakamt < cloak.max then
                                    cloakamt = cloakamt + FrameTime() * cloak.rechargeRate

                                    if cloakamt > cloak.max then
                                        cloakamt = cloak.max
                                    end

                                    self:SetCloakLeft(cloakamt)
                                end
                            end

                            local color = self:GetPuppet():GetColor()

                            if self.iscloaked then
                                if color.a > 0 then
                                    color.a = color.a - 5
                                    self:GetPuppet():SetColor(color)
                                end
                            else
                                if color.a < 255 then
                                    color.a = color.a + 5
                                    self:GetPuppet():SetColor(color)
                                end
                            end

                            --PrintTable(color)
                            if IsValid(self.wepmdl) and self.wepmdl:GetColor().a ~= color.a then
                                self.wepmdl:SetColor(color)
                            end
                        end

                        --if !IsValid(ply) then self:NextThink(CurTime()) return true end
                        --wepon-no longer SO hackey
                        if not self.formTable.hideWeapons then
                            local realWep = self:GetPillUser():GetActiveWeapon()

                            --&&self:GetPillUser()!=ply or pk_pills.var_thirdperson:GetBool()) then
                            if IsValid(realWep) and realWep:GetModel() ~= "" then
                                --hiding the real thing [BROKEN]
                                --[[if realWep:GetRenderMode()!=RENDERMODE_NONE then
                                    realWep:SetRenderMode(RENDERMODE_NONE)
                                end]]
                                if realWep.pill_attachment then
                                    if IsValid(self.wepmdl) then
                                        self.wepmdl:Remove()
                                    end

                                    self.wepmdl = ents.Create("pill_attachment_wep")
                                    self.wepmdl:SetParent(self:GetPuppet())
                                    self.wepmdl:SetModel(realWep:GetModel())
                                    self.wepmdl.attachment = realWep.pill_attachment
                                    self.wepmdl:Spawn()

                                    if realWep.pill_offset then
                                        self.wepmdl:SetWepOffset(realWep.pill_offset)
                                    end

                                    if realWep.pill_angle then
                                        self.wepmdl:SetWepAng(realWep.pill_angle)
                                    end

                                    realWep.pill_proxy = self.wepmdl
                                elseif not IsValid(self.wepmdl) then
                                    self.wepmdl = ents.Create("pill_attachment_wep")
                                    self.wepmdl:SetParent(self:GetPuppet())
                                    self.wepmdl:SetModel(realWep:GetModel())
                                    self.wepmdl:Spawn()
                                    realWep.pill_proxy = self.wepmdl
                                elseif self.wepmdl:GetModel() ~= realWep:GetModel() then
                                    self.wepmdl:SetModel(realWep:GetModel())
                                end
                            elseif IsValid(self.wepmdl) then
                                self.wepmdl:Remove()
                            end
                        end
                    else
                        self:SetNWBool('clientsideshould', not pk_pills.convars.cl_thirdperson:GetBool())

                        if self:GetPillUser() ~= LocalPlayer() or true then
                            puppet:SetNoDraw(false)
                        end

                        local realWep = self:GetPillUser():GetActiveWeapon()

                        if IsValid(realWep) and realWep:GetModel() ~= "" and not realWep:GetNoDraw() then
                            realWep:SetNoDraw(true)
                        end
                    end

                    if SERVER then
                        puppet:SetPos(ply:GetPos())
                    end
                    --Align pos and angles with player
                    if ply:GetNWInt("DisableMovement_jumpscare_pill_nosey") < CurTime() then
                        if SERVER then
                            self:SetAngles(ply:GetAngles())
                        else
                            puppet:SetRenderOrigin(ply:GetPos())
                        end
                    end

                    if vel > 0 or math.abs(math.AngleDifference(puppet:GetAngles().y, ply:EyeAngles().y)) > 350 or self:GetNWBool('clientsideshould') then
                        local angs = ply:EyeAngles()
                        angs.p = 0

                        if SERVER then
                            puppet:SetAngles(angs)
                        else
                            --puppet:SetAngles(angs)
                            puppet:SetRenderAngles(angs)
                        end
                    end

                    self:NextThink(CurTime())

                    return true
                end


            else
            end
        end

        if ent.formTable.HandleAnimEvent_g_nosey then
            local PuppetEntity = ent:GetPuppet()
            local entityply = ent:GetPillUser()

            if IsValid(PuppetEntity) then
                function PuppetEntity:AcceptInput(inputName, activator, caller, data)
                    ent.formTable.HandleAnimEvent_g_nosey(entityply, ent, inputName)
                    return true
                end
            end
        end
    end)
end)

hook.Add("Think", "nosey_gentoi_think", function()
    for _, ent in ipairs(ents.FindByClass("pill_ent_costume")) do
        if !IsValid(ent) then continue end
        local ply = ent:GetPillUser()
        local puppet = ent:GetPuppet()

        if not IsValid(puppet) or not IsValid(ply) then continue end

        if ent.formTable.nosey_gentoi_think then
            ent.formTable.nosey_gentoi_think(ply, ent)
        end
    end
end)



if SERVER then
    AddCSLuaFile()
    util.AddNetworkString('nosey_jumpscare_gen')
    util.AddNetworkString('nosey_scanmap')


else

    net.Receive('nosey_jumpscare_gen', function()
        local ent = net.ReadEntity()
        local state = net.ReadBool()
        local startTime = CurTime()

        local hookID = "nosey_jumpscare_" .. LocalPlayer():SteamID()

        --print(state)

        if not state then
            hook.Remove('CalcView', hookID)
        else
            hook.Add('CalcView', hookID, function(ply, pos, angles, fov)
                if not IsValid(ply) or not ply:Alive() or !IsValid(ent) then
                    hook.Remove('CalcView', hookID)
                    if IsValid(ply) then
                        ply:RemoveFlags(FL_NOTARGET)
                        ply:Freeze(false)
                        ply:DrawViewModel(true)
                    end
                    return
                end

                local cam = ent:GetAttachment(ent:LookupAttachment('camera'))

                ply:AddFlags(FL_NOTARGET)
                ply:Freeze(true)
                ply:DrawViewModel(false)

                local lerpFactor = math.Clamp((CurTime() - startTime) / (0.7), 0, 1)
                
                local targetFOV = 80 

                local orgiginlerpto = LerpVector(lerpFactor, pos, cam.Pos)
                local angleslerpto = LerpAngle(lerpFactor, angles, cam.Ang)
                local interpolatedFOV = Lerp(lerpFactor, fov, targetFOV)

                local view = {
                    origin = orgiginlerpto,
                    angles = angleslerpto,
                    fov = interpolatedFOV,
                    drawviewer = false
                }
                return view
            end)
        end
    end)
    
    net.Receive("nosey_scanmap", function()
        local ply = LocalPlayer()
        ply:SetNWVector("nosey_scanmap", ply:GetPos())
        local pos = ply:GetNWVector("nosey_scanmap")
        local enti = net.ReadEntity()
            
        local duration = 7
        local startTime = CurTime()
        local fadeduration = 1.4
        
        ply:EmitSound("nosey/Echolocation.wav", 75, 100, 1, CHAN_AUTO)



        hook.Add("PostDrawTranslucentRenderables", "NoseyScanRing".. ply:Nick(), function()
            local elapsed = CurTime() - startTime
            if elapsed > duration or !IsValid(ply) or !IsValid(enti) then
                hook.Remove("PostDrawTranslucentRenderables", "NoseyScanRing".. ply:Nick())
                return
            end

            local detail = math.min(math.floor(60), 100)
            local radiusno = Lerp(elapsed / duration, 0, 4000)
            local radius = math.floor(radiusno)

            render.SetStencilEnable(true)
            render.SetStencilReferenceValue(0x55)
            render.SetStencilTestMask(0x1C)
            render.SetStencilWriteMask(0x1C)
            render.ClearStencil()
            render.SetColorMaterial()

            local detailWithDs = detail + 1
            local radiusMinusThickness = radius - math.floor(28)

            render.SetStencilReferenceValue(1)
            render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
            render.SetStencilZFailOperation(STENCILOPERATION_INVERT)

            render.DrawSphere(pos, -radius, detail, detail, Color(0, 0, 0, 0))
            render.DrawSphere(pos, radius, detail, detail, Color(0, 0, 0, 0))
            render.DrawSphere(pos, -radiusMinusThickness, detailWithDs, detailWithDs, Color(0, 0, 0, 0))
            render.DrawSphere(pos, radiusMinusThickness, detailWithDs, detailWithDs, Color(0, 0, 0, 0))

            render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
            render.DrawSphere(pos, radius + 0.25, detailWithDs, detailWithDs, Color(0, 0, 0, 0))

            render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)
            cam.IgnoreZ(true)
            render.SetStencilReferenceValue(1)

            local alpha = 255
            local cur = CurTime()
            if cur < startTime + fadeduration then
                alpha = math.Clamp(Lerp((cur - startTime) / fadeduration, 0, 255), 0, 255)
            elseif cur > startTime + duration - fadeduration then
                alpha = math.Clamp(Lerp((cur - (startTime + duration - fadeduration)) / fadeduration, 255, 0), 0, 255)
            end

            render.DrawQuadEasy(
                ply:EyePos() + ply:GetAimVector():Angle():Forward() * 10,
                -ply:GetAimVector():Angle():Forward(),
                10000,
                10000,
                Color(255, 0, 0, alpha),
                ply:GetAimVector():Angle().roll
            )
            cam.IgnoreZ(false)
            render.SetStencilEnable(false)

            local function InRange(eb, pos, dis)
                if not IsValid(eb) then return false end
                return eb:GetPos():DistToSqr(pos) <= dis * dis
            end

            for i, v in ipairs(ents.GetAll()) do 
                if InRange(v,pos,radiusno) then
                    if (v:IsPlayer() or v:IsNextBot() or v:IsNPC()) then
                        if IsValid(v) and v ~= ply then
                            render.SetBlend(1)
                            render.SetColorModulation(1, 1, 1)
                            
                            render.SetStencilEnable(true)
                            render.SetStencilReferenceValue(0)
                            render.SetStencilPassOperation(STENCIL_KEEP)
                            render.SetStencilZFailOperation(STENCIL_KEEP)
                            render.ClearStencil()

                            render.SetStencilCompareFunction(STENCIL_NEVER)
                            render.SetStencilFailOperation(STENCIL_REPLACE)
                            render.SetStencilReferenceValue(0x1C)
                            render.SetStencilWriteMask(0x55)

                            v:DrawModel()

                            render.SetStencilTestMask(0xF3)
                            render.SetStencilReferenceValue(0x10)
                            render.SetStencilCompareFunction(STENCIL_EQUAL)

                            local markColor = Color(255, 0, 0, alpha)
                            render.ClearBuffersObeyStencil(255, 0, 0, alpha, false)

                            render.SetStencilEnable(false)
                        end
                    end
                end
            end
        end)
    end)

    local preservedmats = {
        [0] = Material("icons/NoseyScan.png")
    }

    hook.Add("HUDPaint", "Nosey_pill_painting", function()

        local ply = LocalPlayer()
        local pillentity = LocalPlayer().pk_pill_ent
        local screenW, screenH = ScrW(), ScrH()

        if IsValid(pillentity) then
            if pillentity:GetNWBool("Nosey_pill_scan") then
                local iconsize = screenW / 15
                local xaxis = iconsize / 3
                local yaxis = screenH - iconsize * 1.75
                local outlineThickness = 4

                local function DrawThickOutline(tables)
                    local x = tables.x
                    local y = tables.y
                    local w = tables.w
                    local h = tables.h
                    local thickness = tables.thickness
                    for i = 0, thickness - 1 do
                        surface.DrawOutlinedRect(x - i, y - i, w + i * 2, h + i * 2)
                    end
                end

                surface.SetDrawColor(0, 0, 0, 255)
                surface.DrawRect(xaxis + iconsize, yaxis + iconsize * 0.5, iconsize * 1.3, iconsize * 0.5)
                surface.SetDrawColor(255, 0, 0, 255)
                DrawThickOutline({
                    x = xaxis + iconsize,
                    y = yaxis + iconsize * 0.5,
                    w = iconsize * 1.3, 
                    h = iconsize * 0.5, 
                    thickness = outlineThickness
                })

                surface.SetDrawColor(0, 0, 0, 255)
                surface.DrawRect(xaxis, yaxis, iconsize, iconsize)
                surface.SetDrawColor(255, 0, 0, 255)
                DrawThickOutline({
                    x = xaxis,
                    y = yaxis,
                    w = iconsize, 
                    h = iconsize, 
                    thickness = outlineThickness
                })

                surface.SetDrawColor(0, 0, 0, 255)
                surface.DrawRect(xaxis + iconsize-1, yaxis + iconsize * 0.5 + 1, iconsize * 1.3 - 1, iconsize * 0.5 - 2)

                --cooldownbar
                local sizemax = iconsize * 1.3 - iconsize*0.05
                local lerp = sizemax
                if pillentity:GetNWInt("lasttimeusedNOSEYSCAN")> CurTime() then
                    lerp = Lerp( (pillentity:GetNWInt("lasttimeusedNOSEYSCAN")-CurTime())/ 7,0,sizemax)
                elseif pillentity:GetNWInt("lasttimeusedNOSEYSCANCooldown") > CurTime() then
                    lerp = Lerp( (pillentity:GetNWInt("lasttimeusedNOSEYSCANCooldown")-CurTime())/ 14,sizemax,0)
                end
                local sizeshouldbe = math.Clamp( lerp, 0, sizemax )

                surface.SetDrawColor(255, 0, 0, 255)
                surface.DrawRect(xaxis + iconsize, yaxis + iconsize * 0.5 + iconsize *0.05, sizeshouldbe, iconsize * 0.5*0.8*1.05)

                local yaxis_bar = yaxis + iconsize



                local lerp = 255
                if pillentity:GetNWInt("lasttimeusedNOSEYSCAN")> CurTime() then
                    lerp = Lerp( (pillentity:GetNWInt("lasttimeusedNOSEYSCAN")-CurTime())/ 2,0,255)
                elseif pillentity:GetNWInt("lasttimeusedNOSEYSCANCooldown") > CurTime() then
                    lerp = Lerp( (pillentity:GetNWInt("lasttimeusedNOSEYSCANCooldown")-CurTime())/ 1,255,0)
                end
                local color = math.Clamp( lerp, 0, 255 )

                draw.SimpleText("1", "CloseCaption_BoldItalic", xaxis+ScreenScale(1), yaxis+ScreenScale(1), Color(255, color, color), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                surface.SetDrawColor(color, color, color, 255)
                surface.SetMaterial(preservedmats[0])
                surface.DrawTexturedRect(xaxis, yaxis, iconsize, iconsize)

                --draw.SimpleText("Ghastly Ominance", "Trebuchet18", xaxis+iconsize/2, yaxis+iconsize*0.85, Color(165, 0, 165), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

        end
    end)
end

local function AdvancedPillSound(SoundData, ent)
    if IsValid(ent) then
        SoundData = SoundData or {}
        SoundData.stringe = SoundData.stringe or {}
        SoundData.soundLevel = SoundData.soundLevel or 75
        SoundData.pitchPercent = SoundData.pitchPercent or 100
        SoundData.volume = SoundData.volume or 1
        SoundData.channel = SoundData.channel or CHAN_AUTO
        SoundData.soundFlags = SoundData.soundFlags or 0
        SoundData.dsp = SoundData.dsp or 0
        SoundData.filter = SoundData.filter or nil

        local chosenSound = SoundData.stringe

        if istable(SoundData.stringe) then
            local index = math.random(1, #SoundData.stringe)
            chosenSound = SoundData.stringe[index]
        end

        ent:EmitSound(
            chosenSound,
            SoundData.soundLevel,
            SoundData.pitchPercent,
            SoundData.volume,
            SoundData.channel,
            SoundData.soundFlags,
            SoundData.dsp,
            SoundData.filter
        )
    end
    return true
end

local function racheljackietien_jumpscare(ply, ent, duration, customanimstuff)
    if not ent.IsInJumpscare then ent.IsInJumpscare = 0 end
    if ent.IsInJumpscare >= CurTime() then return end
    if not ent.IsInJumpscareCooldown then ent.IsInJumpscareCooldown = 0 end
    if ent.IsInJumpscareCooldown >= CurTime() then return end

    local jumpscare_entity = nil

    for _, ent2 in pairs(ents.FindInSphere(ent:LocalToWorld(Vector(0, 0, 50)), 90)) do
        if (ent2:IsPlayer() or ent2:IsNextBot() or ent2:IsNPC()) and ent2:Health() >= 0.1 then
            if ent2 == ply then continue end
            if ent2:IsPlayer() and ent2:Team() == TEAM_SPECTATOR then continue end

            if IsValid(ent2) then
                jumpscare_entity = ent2
                break
            end
        end
    end

    if jumpscare_entity ~= nil then
        timer.Simple(duration, function()
            if !IsValid(ent) then return end
            if !IsValid(jumpscare_entity) then return end
            jumpscare_entity:SetCollisionGroup(COLLISION_GROUP_NONE)
        end)
        jumpscare_entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
        ent.JuumpscareStart = CurTime()

        ent.jumpscare_entity = jumpscare_entity
        ent.entitylastpos = jumpscare_entity:GetPos()
        ent.entitylastang = jumpscare_entity:GetAngles()

        local targetAngle = (ply:GetPos() - jumpscare_entity:GetPos()):Angle()

        targetAngle.p = 0
        targetAngle.r = 0

        ply:SetNWInt("DisableMovement_jumpscare_pill_nosey", duration+CurTime())
        jumpscare_entity:SetNWInt("DisableMovement_jumpscare_pill_nosey", duration+CurTime())

        ent.IsInJumpscare = CurTime() + duration

        local puppet = ent:GetPuppet()

        if jumpscare_entity:IsPlayer() then
            net.Start('nosey_jumpscare_gen')
            net.WriteEntity(puppet)
            net.WriteBool(true)
            net.Send(jumpscare_entity)
        else
            jumpscare_entity:NextThink(duration+0.1+CurTime())
        end
        
        jumpscare_entity:AddFlags(FL_NOTARGET)

        ent:CallOnRemove("RachelJumpscare"..ent:EntIndex(), function()
            if !IsValid(jumpscare_entity) then return end
            jumpscare_entity:SetCollisionGroup(COLLISION_GROUP_NONE)

            jumpscare_entity:RemoveFlags(FL_NOTARGET)
            ent.jumpscare_entity = nil

            if jumpscare_entity:IsPlayer() then
                net.Start('nosey_jumpscare_gen')
                net.WriteEntity(puppet)
                net.WriteBool(false)
                net.Send(jumpscare_entity)
            else
                jumpscare_entity:NextThink(CurTime())
                if jumpscare_entity.OldWeapon then
                    jumpscare_entity.OldWeapon:SetNoDraw(false)
                end
            end
            jumpscare_entity:SetPos(ent.entitylastpos)
            jumpscare_entity:SetAngles(ent.entitylastang)
            jumpscare_entity:SetNWInt("DisableMovement_jumpscare_pill_nosey", CurTime())

            jumpscare_entity:SetNoDraw(false)
            jumpscare_entity:SetNotSolid(false)

        end)

        customanimstuff()
    end
end

hook.Add("SetupMove", "DisablePlayerMovement_nosey", function(ply, mv, cmd)
    if ply:GetNWInt("DisableMovement_jumpscare_pill_nosey") >= CurTime() then
        mv:SetForwardSpeed(0)
        mv:SetSideSpeed(0)
        mv:SetUpSpeed(0)
        mv:SetButtons(0)
    end
end)

hook.Add("PlayerFootstep", "Nosey_DisableStep", function(ply, pos, foot, sound, volume, rf)
    if ply.pk_pill_ent == nil then return end
    if !IsValid(ply.pk_pill_ent) then return end
    if ply.pk_pill_ent:GetNWBool("Nosey_pill_scan") then
        return true
    end
end)


pk_pills.packStart("WalterFiles_nosey", "AnalogHorrorPills_gentio_nosey", "pills/pill_gentoi_nosey.png")

pk_pills.register('pill_gentoi_nosey', {

    printName='Nosey',
        
    model="models/gentoi/walterfiles/nosey.mdl",
        
    modelScale='1.0',
        

    noragdoll = true,
    muteSteps = true,
        
    anims={
        default={
            idle="idle",
            run="run",
            walk="walk",
            kill="kill",
            crouch = "Crouch",
            crouch_walk = "CrawlMovement",
            echolocation = "echolocation"
        },
    },

    moveSpeed = {
        walk = 41,
        run = 420,
        ducked=20,
    },
        
    sounds={
        kill = "nosey/NoseyExecution.wav",
    },

    type='ply',


    FirstPersonBone = {
        'Head',
        7,
        0,
        7,
    },
    ThirdPersonBone = {
        'waist',
        0,
        28,
        8,
    },

    camera={
        offset = Vector(0, 0, 75),
        dist=144,
    },
        
    jumpPower=0,
        
    health=2000,
    
    movePoseMode="xy",
        aim={
        xPose="aim_yaw",
        yPose="aim_pitch",
        nocrosshair = true
    },
        
    canAim=function(ply,ent) return ent.active end,    

    HandleAnimEvent_g_nosey = function(ply, ent, event)
        if event == 'ragdoll' then

            if !IsValid(ent) then return end
            local jumpscare_entity = ent.jumpscare_entity
            if !(IsValid(jumpscare_entity)) then return end

            local ragdoll = ents.Create("prop_ragdoll")
            ragdoll:SetModel(jumpscare_entity:GetModel())
            ragdoll:SetPos(jumpscare_entity:GetPos())
            ragdoll:SetAngles(jumpscare_entity:GetAngles())
            ragdoll:SetSkin(jumpscare_entity:GetSkin() or 0)
            ragdoll:Spawn()


            local physCount = ragdoll:GetPhysicsObjectCount()
            if physCount <= 0 then
                ragdoll:Remove()
                return end

            if not jumpscare_entity:IsPlayer() then
                local wep = jumpscare_entity:GetActiveWeapon()
                if IsValid(wep) then
                    jumpscare_entity.OldWeapon = wep
                    wep:SetNoDraw(true)
                end
            end

            if jumpscare_entity.GetBodyGroups then
                for _, bg in ipairs(jumpscare_entity:GetBodyGroups()) do
                    ragdoll:SetBodygroup(bg.id, jumpscare_entity:GetBodygroup(bg.id))
                end
            end

            if jumpscare_entity.GetPlayerColor and ragdoll.SetPlayerColor then
                ragdoll:SetPlayerColor(jumpscare_entity:GetPlayerColor())
            end

            if jumpscare_entity.GetColor then
                ragdoll:SetColor(jumpscare_entity:GetColor())
            end

            if jumpscare_entity.GetMaterial then
                ragdoll:SetMaterial(jumpscare_entity:GetMaterial())
            end

            if ragdoll.GetNumSubMaterials and ragdoll.SetSubMaterial and jumpscare_entity.GetSubMaterial then
                for i = 0, ragdoll:GetNumSubMaterials() - 1 do
                    local sub = jumpscare_entity:GetSubMaterial(i)
                    if sub then
                        ragdoll:SetSubMaterial(i, sub)
                    end
                end
            end

            jumpscare_entity:SetNoDraw(true)
            jumpscare_entity:SetNotSolid(true)

            ent.CurrentJumpscareRagdoll = ragdoll
            ent:DeleteOnRemove(ragdoll)

--
            hook.Add("Think", "ragdoll_nosey".. ent:EntIndex(), function()
                if !IsValid(ragdoll) then return end
                if SERVER then
                    local headPhys = nil

                    for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
                        local phys = ragdoll:GetPhysicsObjectNum(i)
                        if IsValid(phys) then
                            local boneIndex = ragdoll:TranslatePhysBoneToBone(i)
                            local boneName = ragdoll:GetBoneName(boneIndex) or ""
                            if string.find(string.lower(boneName), "head") then
                                headPhys = phys
                                break
                            end
                        end
                    end

                    if !IsValid(headPhys) then
                        headPhys = ragdoll:GetPhysicsObject()
                    end

                    if IsValid(headPhys) then
                        local cam = ent:GetPuppet():GetAttachment(ent:GetPuppet():LookupAttachment('camera'))
                        local lerpFactor = math.Clamp((CurTime() - ent.JuumpscareStart) / 0.5, 0, 1)
                        local newAngle = LerpAngle(lerpFactor, ent.entitylastang, cam.Ang)
                        local NewVector = LerpVector(lerpFactor, ent.entitylastpos, cam.Pos)
                        headPhys:SetPos(NewVector)
                        headPhys:SetAngles(newAngle)

                        headPhys:Wake()
                    end
                end
            end)

        end
        if event == "throw" then
            if ent.CurrentJumpscareRagdoll then
                if IsValid(ent.CurrentJumpscareRagdoll) then
                    ent:DontDeleteOnRemove(ent.CurrentJumpscareRagdoll)

                    local ragdoll = ent.CurrentJumpscareRagdoll
                    local headPhys = nil

                    for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
                        local phys = ragdoll:GetPhysicsObjectNum(i)
                        if IsValid(phys) then
                            local boneIndex = ragdoll:TranslatePhysBoneToBone(i)
                            local boneName = ragdoll:GetBoneName(boneIndex) or ""
                            if string.find(string.lower(boneName), "head") then
                                headPhys = phys
                                break
                            end
                        end
                    end

                    if !IsValid(headPhys) then
                        headPhys = ragdoll:GetPhysicsObject()
                    end

                    if IsValid(headPhys) then
                        headPhys:SetVelocity(ent:GetPuppet():GetForward()*300000)


                        headPhys:Wake()

                    end


                end
            end
            hook.Remove('Think', "ragdoll_nosey".. ent:EntIndex())
        end
        if event == "playerded" then
            timer.Simple(0.4, function()
                if !IsValid(ent) then return end
                local jumpscare_entity = ent.jumpscare_entity
                if !(IsValid(jumpscare_entity)) then return end
                ent.jumpscare_entity = nil
                jumpscare_entity:SetCollisionGroup(COLLISION_GROUP_NONE)
                jumpscare_entity:SetPos(ent.entitylastpos)
                jumpscare_entity:SetAngles(ent.entitylastang)


                if jumpscare_entity:IsPlayer() then
                    ply:SetNWBool("nosey_shouldnotragdol", true)
                else hook.Run("OnNPCKilled", jumpscare_entity, ply, ply) end

                if jumpscare_entity:IsPlayer() then
                    net.Start('nosey_jumpscare_gen')
                    net.WriteEntity(puppet)
                    net.WriteBool(false)
                    net.Send(jumpscare_entity)

                    jumpscare_entity:Kill(ply)
                else
                    jumpscare_entity:NextThink(CurTime())
                    jumpscare_entity:AddFlags(FL_TRANSRAGDOLL)
                    jumpscare_entity:Remove()
                end
                ent:RemoveCallOnRemove("RachelJumpscare"..ent:EntIndex())
            end)
        end
        if event == "Step" then
            if IsValid(ent) then
                AdvancedPillSound({
                    stringe = "nosey/Nosey_footstep"..math.random(1,5)..".wav",
                    pitchPercent = 100,
                    soundLevel = 67
                }, ent)
            end
        end
        if event == "echolocation" then
            ent:SetNWInt('lasttimeusedNOSEYSCAN',CurTime()+7)
            ent:SetNWInt('lasttimeusedNOSEYSCANCooldown',CurTime()+21)
            net.Start("nosey_scanmap")
            net.WriteEntity(ent)
            net.Send(ply)
        end
    end,


    attack = {
        mode = 'trigger',
        func = function(ply, ent)

            local dur = ent:GetPuppet():SequenceDuration(ent:GetPuppet():LookupSequence("kill"))
            if ply:GetNWInt("DisableMovement_jumpscare_pill_nosey") < CurTime() then
                racheljackietien_jumpscare(
                    ply,
                    ent,
                    dur,
                    function()
                        ent:SetNWInt('lasttimeusedNOSEYSCANCooldown',ent:GetNWInt('lasttimeusedNOSEYSCANCooldown',0)-4)
                        ent:PillSound('kill')
                        ent:PillAnim('kill')
                    end
                )
            end
        end
    },


    NoseyKeybind = function(ply, ent, button)
        if button == KEY_1 then
            if ent:GetNWInt("lasttimeusedNOSEYSCANCooldown") > CurTime() then return end
            if ent:GetNWInt("lasttimeusedNOSEYSCAN") > CurTime() then return end
            if ply:GetNWInt("DisableMovement_jumpscare_pill_nosey") > CurTime() then return end
                
            local dur = ent:GetPuppet():SequenceDuration(ent:GetPuppet():LookupSequence("echolocation"))
            ply:SetNWInt("DisableMovement_jumpscare_pill_nosey", CurTime()+dur)
            if SERVER then
                ent:PillAnim('echolocation')
            end
            --ent:PillSound('Echolocation')
        end
    end,

    noragdoll=true,


    nosey_jentoi_pill_init=function(ply,ent, puppet)
        puppet.IsInJumpscare = 0
    end,

    reload=function(ply,ent)
    end,

    flashlight = function(ply, ent)
    end,
        
    jump = function(ply, ent) end,

    nosey_gentoi_think = function(ply, ent)
        ent:SetNWBool("Nosey_pill_scan", true)
        if ent.jumpscare_entity then
            local entity = ent.jumpscare_entity
            if IsValid(entity) then

                local lengthofentitybody = (entity:EyePos() - entity:GetPos()):Length() /2

                local cam = ent:GetPuppet():GetAttachment(ent:GetPuppet():LookupAttachment('camera'))

                if entity:Health() < 0.1 and entity:IsPlayer() then
                    ent.jumpscare_entity = nil
                else
                    local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
                    local lengthofentitybody = ((maxs.z - mins.z)/2) * 4

                    local lerpFactor = math.Clamp((CurTime() - ent.JuumpscareStart) / 0.5, 0, 1)
                    local newAngle = LerpAngle(lerpFactor, ent.entitylastang, cam.Ang)
                    local NewVector = LerpVector(lerpFactor, ent.entitylastpos, cam.Pos - entity:GetUp() * lengthofentitybody)
                    entity:SetPos(NewVector)
                    entity:SetAngles(newAngle)
                end
            end
        end
    end
})