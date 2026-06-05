
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

local HOMELANDER_SHARED = HomelanderSWEPShared
local getHomelanderSettingFloat = HOMELANDER_SHARED.getHomelanderSettingFloat
local debugHomelanderDismember = HOMELANDER_SHARED.debugHomelanderDismember or function() end
local isHomelanderCharacter = HOMELANDER_SHARED.isHomelanderCharacter
local VOICE_LINE_MIN_COOLDOWN = HOMELANDER_SHARED.VOICE_LINE_MIN_COOLDOWN
local VOICE_LINE_SOUND_LEVEL = HOMELANDER_SHARED.VOICE_LINE_SOUND_LEVEL
local VOICE_LINE_SOUNDS = HOMELANDER_SHARED.VOICE_LINE_SOUNDS
local WEAPON_CLASS = HOMELANDER_SHARED.WEAPON_CLASS

if SERVER then
    local pendingLaserRagdollDismembers = {}

    local function broadcastLaserDismemberReset(ent)
        if not IsValid(ent) then return end

        net.Start("HomelanderDismember")
            net.WriteEntity(ent)
            net.WriteString("")
            net.WriteString("")
            net.WriteFloat(0)
        net.Broadcast()
    end

    local function queueLaserRagdollDismember(weapon, pos, modelName, mode, dir, boneName)
        if not IsValid(weapon) or not pos or not mode or mode == "" then return end

        debugHomelanderDismember("QueueRagdollDismember", {
            weapon = weapon,
            pos = pos,
            model = modelName or "",
            mode = mode,
            boneName = boneName or ""
        })

        pendingLaserRagdollDismembers[#pendingLaserRagdollDismembers + 1] = {
            weapon = weapon,
            pos = pos,
            modelName = modelName,
            mode = mode,
            dir = dir or Vector(0, 0, 1),
            boneName = boneName,
            expire = CurTime() + 3
        }
    end

    local function applyPendingLaserDismemberToRagdoll(ragdoll)
        if not IsValid(ragdoll) or ragdoll:GetClass() ~= "prop_ragdoll" then return false end

        local now = CurTime()
        for i = #pendingLaserRagdollDismembers, 1, -1 do
            local pending = pendingLaserRagdollDismembers[i]
            if not pending or pending.expire <= now or not IsValid(pending.weapon) then
                debugHomelanderDismember("PendingRagdoll dropped", {
                    ragdoll = ragdoll,
                    expired = pending and pending.expire and pending.expire <= now or false,
                    weaponValid = pending and IsValid(pending.weapon) or false
                })
                table.remove(pendingLaserRagdollDismembers, i)
                continue
            end

            local distanceSqr = pending.pos and ragdoll:WorldSpaceCenter():DistToSqr(pending.pos) or math.huge
            local modelMatches = pending.modelName and pending.modelName ~= "" and ragdoll:GetModel() == pending.modelName
            debugHomelanderDismember("PendingRagdoll check", {
                ragdoll = ragdoll,
                pendingModel = pending.modelName or "",
                ragdollModel = ragdoll:GetModel() or "",
                distance = distanceSqr < math.huge and math.sqrt(distanceSqr) or -1,
                modelMatches = modelMatches
            })
            if distanceSqr <= 360 * 360 or modelMatches then
                local laserDamage = getHomelanderSettingFloat("homelander_sv_laser_damage", pending.weapon.Secondary.Damage, 1, 100000)
                debugHomelanderDismember("PendingRagdoll applying", {
                    ragdoll = ragdoll,
                    mode = pending.mode,
                    boneName = pending.boneName or ""
                })
                pending.weapon:ApplyLaserDismemberToRagdoll(ragdoll, pending.mode, pending.dir, laserDamage * 6, pending.boneName)
                table.remove(pendingLaserRagdollDismembers, i)
                return true
            end
        end

        return false
    end

    hook.Add("OnEntityCreated", "Homelander.LaserDismemberPendingRagdoll", function(ent)
        if not IsValid(ent) or ent:GetClass() ~= "prop_ragdoll" then return end

        debugHomelanderDismember("OnEntityCreated prop_ragdoll", { ragdoll = ent })

        timer.Simple(0.1, function()
            if IsValid(ent) then
                applyPendingLaserDismemberToRagdoll(ent)
            end
        end)
    end)

    local function getHomelanderGrabberWeapon(ply)
        if not IsValid(ply) or not ply:IsPlayer() then return nil end

        local weapon = ply.HomelanderGrabbedBy
        if IsValid(weapon) and weapon:GetClass() == WEAPON_CLASS and weapon.HomelanderGrabbedTarget == ply then
            return weapon
        end

        ply.HomelanderGrabbedBy = nil
        return nil
    end

    local function isHomelanderGrabbedVictim(ply)
        return IsValid(getHomelanderGrabberWeapon(ply))
    end

    local blockedGrabbedVictimSpawnHooks = {
        "PlayerSpawnObject",
        "PlayerSpawnProp",
        "PlayerSpawnEffect",
        "PlayerSpawnNPC",
        "PlayerSpawnVehicle",
        "PlayerSpawnRagdoll",
        "PlayerSpawnSENT",
        "PlayerSpawnSWEP",
        "PlayerGiveSWEP",
        "CanTool",
        "CanProperty",
        "CanPlayerEnterVehicle",
        "PlayerNoClip",
        "PhysgunPickup",
        "GravGunPickupAllowed"
    }

    for _, hookName in ipairs(blockedGrabbedVictimSpawnHooks) do
        hook.Add(hookName, "Homelander.BlockGrabbedVictimActions", function(ply)
            if isHomelanderGrabbedVictim(ply) then
                return false
            end
        end)
    end

    hook.Add("PlayerSwitchWeapon", "Homelander.BlockGrabbedVictimWeaponSwitch", function(ply)
        if isHomelanderGrabbedVictim(ply) then
            return true
        end
    end)

    hook.Add("StartCommand", "Homelander.BlockGrabbedVictimCombatInput", function(ply, cmd)
        if not isHomelanderGrabbedVictim(ply) then return end

        cmd:RemoveKey(bit.bor(
            IN_ATTACK or 0,
            IN_ATTACK2 or 0,
            IN_RELOAD or 0,
            IN_USE or 0,
            IN_ZOOM or 0,
            IN_GRENADE1 or 0,
            IN_GRENADE2 or 0
        ))
        cmd:ClearMovement()
    end)

    local function pickHomelanderVoiceLine(ply)
        if #VOICE_LINE_SOUNDS <= 1 then return VOICE_LINE_SOUNDS[1] end

        local soundPath = VOICE_LINE_SOUNDS[math.random(#VOICE_LINE_SOUNDS)]
        if soundPath == ply.HomelanderLastVoiceLine then
            for _ = 1, 6 do
                soundPath = VOICE_LINE_SOUNDS[math.random(#VOICE_LINE_SOUNDS)]
                if soundPath ~= ply.HomelanderLastVoiceLine then break end
            end
        end

        if soundPath == ply.HomelanderLastVoiceLine then
            local index = table.KeyFromValue(VOICE_LINE_SOUNDS, soundPath) or 1
            soundPath = VOICE_LINE_SOUNDS[(index % #VOICE_LINE_SOUNDS) + 1]
        end

        ply.HomelanderLastVoiceLine = soundPath
        return soundPath
    end

    local function getHomelanderVoiceLineCooldown(soundPath)
        local duration = 0
        if SoundDuration then
            duration = SoundDuration(soundPath) or 0
        end

        if duration <= 0 then
            return VOICE_LINE_MIN_COOLDOWN
        end

        return VOICE_LINE_MIN_COOLDOWN
    end

    hook.Add("PlayerButtonDown", "Homelander.VoiceLineKey", function(ply, button)
        if button ~= KEY_G then return end

        local weapon = ply:GetActiveWeapon()
        if not IsValid(weapon) or weapon:GetClass() ~= WEAPON_CLASS then return end

        if ply.HomelanderNextVoiceLine and ply.HomelanderNextVoiceLine > CurTime() then return end

        local soundPath = pickHomelanderVoiceLine(ply)
        if not soundPath then return end

        ply.HomelanderNextVoiceLine = CurTime() + getHomelanderVoiceLineCooldown(soundPath)
        ply:EmitSound(soundPath, VOICE_LINE_SOUND_LEVEL, 100, 1)
    end)

    hook.Add("EntityTakeDamage", "Homelander.PreventOwnerSelfDamage", function(target, damage)
        if not IsValid(target) or not target:IsPlayer() or not damage then return end

        local inflictor = damage:GetInflictor()
        if IsValid(inflictor) and inflictor:GetClass() == WEAPON_CLASS and inflictor:GetOwner() == target then
            return true
        end
    end)

    local function getLaserDeathDismemberInfo(victim, attacker, inflictor)
        if not IsValid(victim) then return nil end

        local info = victim.HomelanderLaserDeathDismember
            or victim.HomelanderPendingLaserDismember
            or victim.HomelanderLaserDismember
        if not info or not info.mode or (info.expire or 0) < CurTime() then return nil end

        local weapon = info.weapon
        if not IsValid(weapon) or weapon:GetClass() ~= WEAPON_CLASS then return nil end

        if victim:IsNPC() then
            return info, weapon
        end

        if IsValid(inflictor) then
            if inflictor == weapon then return info, weapon end
            if inflictor:GetClass() == WEAPON_CLASS and inflictor == weapon then return info, weapon end
        end

        if IsValid(attacker) and attacker == weapon then
            return info, weapon
        end

        if IsValid(attacker) and attacker == weapon:GetOwner() then
            return info, weapon
        end

        return nil
    end

    local function applyLaserDeathDismember(victim, attacker, inflictor)
        local info, weapon = getLaserDeathDismemberInfo(victim, attacker, inflictor)
        if not info or not IsValid(weapon) then
            debugHomelanderDismember("DeathDismember no info", {
                victim = victim or NULL,
                attacker = attacker or NULL,
                inflictor = inflictor or NULL
            })
            return
        end

        local pos = info.pos or (IsValid(victim) and victim:WorldSpaceCenter()) or Vector(0, 0, 0)
        local dir = info.dir or Vector(0, 0, 1)
        local modelName = info.model or (IsValid(victim) and victim:GetModel()) or nil

        debugHomelanderDismember("DeathDismember info", {
            victim = victim,
            attacker = attacker or NULL,
            inflictor = inflictor or NULL,
            weapon = weapon,
            mode = info.mode or "",
            boneName = info.boneName or "",
            model = modelName or "",
            pos = pos
        })

        if IsValid(victim) then
            weapon:ApplyLaserDismemberInfo(victim, info)
        end

        weapon:TriggerLaserDismemberKillFX(victim, pos, dir, info.mode)
        if not weapon:ScheduleLaserDismemberRagdollSearch(pos, modelName, info.mode, dir, victim, info.boneName) then
            queueLaserRagdollDismember(weapon, pos, modelName, info.mode, dir, info.boneName)
        end
    end

    hook.Add("PlayerSpawn", "Homelander.ResetGrabExecutionVisibility", function(ply)
        if not IsValid(ply) then return end

        ply:SetNoDraw(false)
        ply:DrawShadow(true)
        ply:SetNotSolid(false)
        ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
        ply.HomelanderLaserDismember = nil
        ply.HomelanderPendingLaserDismember = nil
        ply.HomelanderLaserDeathDismember = nil
        ply.HomelanderLaserDismemberFxTime = nil
        ply.HomelanderSWEPHealthGranted = nil
        ply.HomelanderGrabbedBy = nil
        ply.HomelanderGrabExecutionPending = nil
        ply.HomelanderNextGrabWeaponStrip = nil
        ply:SetNW2String("HomelanderDismemberMode", "")
        ply:SetNW2String("HomelanderDismemberBone", "")
        ply:SetNW2Float("HomelanderDismemberExpire", 0)
        broadcastLaserDismemberReset(ply)
        if ply.RemoveAllDecals then
            ply:RemoveAllDecals()
        end
    end)

    hook.Add("CreateEntityRagdoll", "Homelander.LaserDismemberRagdoll", function(owner, ragdoll)
        debugHomelanderDismember("CreateEntityRagdoll hook", {
            owner = owner or NULL,
            ragdoll = ragdoll or NULL,
            ownerIsCharacter = isHomelanderCharacter(owner)
        })
        if not IsValid(owner) or not IsValid(ragdoll) or not isHomelanderCharacter(owner) then return end

        local info = owner.HomelanderLaserDismember or owner.HomelanderPendingLaserDismember or owner.HomelanderLaserDeathDismember
        if not info or not info.mode or (info.expire or 0) < CurTime() then
            debugHomelanderDismember("CreateEntityRagdoll no info", {
                owner = owner,
                ragdoll = ragdoll,
                hasInfo = info ~= nil,
                infoMode = info and info.mode or "",
                infoExpire = info and info.expire or 0,
                now = CurTime()
            })
            return
        end

        debugHomelanderDismember("CreateEntityRagdoll info", {
            owner = owner,
            ragdoll = ragdoll,
            mode = info.mode or "",
            boneName = info.boneName or "",
            expire = info.expire or 0
        })

        timer.Simple(0, function()
            if not IsValid(ragdoll) then return end

            local weapon = info.weapon
            if IsValid(weapon) and weapon.ApplyLaserDismemberToRagdoll then
                local laserDamage = getHomelanderSettingFloat("homelander_sv_laser_damage", weapon.Secondary.Damage, 1, 100000)
                debugHomelanderDismember("CreateEntityRagdoll timer apply", {
                    ragdoll = ragdoll,
                    weapon = weapon,
                    mode = info.mode or "",
                    boneName = info.boneName or ""
                })
                weapon:ApplyLaserDismemberToRagdoll(ragdoll, info.mode, info.dir, laserDamage * 6, info.boneName)
            elseif theboysbase.IsDismemberEnabled and theboysbase.IsDismemberEnabled() then
                debugHomelanderDismember("CreateEntityRagdoll timer fallback NW2", {
                    ragdoll = ragdoll,
                    mode = info.mode or "",
                    boneName = info.boneName or ""
                })
                ragdoll:SetNW2String("HomelanderDismemberMode", info.mode)
                ragdoll:SetNW2String("HomelanderDismemberBone", info.boneName or "")
                ragdoll:SetNW2Float("HomelanderDismemberExpire", CurTime() + 8)
                if theboysbase and theboysbase.ApplyRagdollPhysBoneDismember then
                    theboysbase.ApplyRagdollPhysBoneDismember(ragdoll, info.mode, info.boneName, {
                        dismemberBones = theboysbase.DismemberBones,
                        debugLog = debugHomelanderDismember
                    })
                end
            end

            if IsValid(owner) then
                owner.HomelanderLaserDismember = nil
                owner.HomelanderPendingLaserDismember = nil
                owner.HomelanderLaserDeathDismember = nil
                if owner:IsPlayer() then
                    timer.Simple(4, function()
                        if IsValid(owner) then
                            owner:SetNW2String("HomelanderDismemberMode", "")
                            owner:SetNW2String("HomelanderDismemberBone", "")
                            owner:SetNW2Float("HomelanderDismemberExpire", 0)
                            broadcastLaserDismemberReset(owner)
                        end
                    end)
                end
            end
        end)
    end)

    hook.Add("PlayerDeath", "Homelander.LaserDismemberPlayerDeath", function(victim, inflictor, attacker)
        debugHomelanderDismember("PlayerDeath hook", {
            victim = victim or NULL,
            attacker = attacker or NULL,
            inflictor = inflictor or NULL
        })
        applyLaserDeathDismember(victim, attacker, inflictor)
    end)

    hook.Add("OnNPCKilled", "Homelander.LaserDismemberNPCDeath", function(npc, attacker, inflictor)
        if not IsValid(npc) then return end

        debugHomelanderDismember("OnNPCKilled hook", {
            npc = npc,
            attacker = attacker or NULL,
            inflictor = inflictor or NULL,
            health = npc.Health and npc:Health() or ""
        })

        applyLaserDeathDismember(npc, attacker, inflictor)
    end)
end
