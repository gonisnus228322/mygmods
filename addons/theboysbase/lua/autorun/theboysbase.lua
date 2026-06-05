-- Shared helper library for The Boys-style SWEP powers: combat, flight, lasers and impacts.

theboysbase = theboysbase or {}
local TBOYS = theboysbase

TBOYS.Version = "1.0.0"

local vector_origin = vector_origin or Vector(0, 0, 0)
local angle_zero = angle_zero or Angle(0, 0, 0)

if SERVER then
    util.AddNetworkString("theboysbase_request_sv_cvars")
    util.AddNetworkString("theboysbase_send_cvars_to_client")
    util.AddNetworkString("theboysbase_send_sv_cvar")

    if not ConVarExists("theboysbase_sv_dismember_enabled") then
        CreateConVar("theboysbase_sv_dismember_enabled", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY }, "Enable The Boys dismembering on the server and clients.", 0, 1)
    end

    local function updateDismemberEnabledGlobal()
        local cvar = GetConVar("theboysbase_sv_dismember_enabled")
        SetGlobalBool("theboysbase_sv_dismember_enabled", not cvar or cvar:GetBool())
    end

    updateDismemberEnabledGlobal()
    cvars.AddChangeCallback("theboysbase_sv_dismember_enabled", updateDismemberEnabledGlobal, "TheBoysBase_DismemberEnabledGlobal")

    net.Receive("theboysbase_request_sv_cvars", function(_, ply)
        if not IsValid(ply) then return end
        if not (game.SinglePlayer() or ply:IsAdmin()) then return end

        local cvar = GetConVar("theboysbase_sv_dismember_enabled")

        net.Start("theboysbase_send_cvars_to_client")
        net.WriteTable({
            theboysbase_sv_dismember_enabled = cvar and cvar:GetString() or "1"
        })
        net.Send(ply)
    end)

    net.Receive("theboysbase_send_sv_cvar", function(_, ply)
        if not (game.SinglePlayer() or ply:IsAdmin()) then return end

        local name = net.ReadString()
        local value = tonumber(net.ReadString())
        if name ~= "theboysbase_sv_dismember_enabled" or not value then return end

        RunConsoleCommand(name, tostring(math.Clamp(value, 0, 1)))
    end)
end

function TBOYS.IsDismemberEnabled()
    local cvar = GetConVar("theboysbase_sv_dismember_enabled")
    if not cvar and CLIENT then
        return GetGlobalBool("theboysbase_sv_dismember_enabled", true)
    end
    if not cvar then return true end
    return cvar:GetBool()
end

if CLIENT then
    local theBoysBaseServerCVarPanels = {}
    local theBoysBaseServerCVarLoading = false

    local function createClientConVar(name, default, help, minValue, maxValue)
        if ConVarExists(name) then return end
        CreateClientConVar(name, default, true, false, help, minValue, maxValue)
    end

    local function setTheBoysBaseServerCVar(cvarName, value)
        if theBoysBaseServerCVarLoading then return end

        net.Start("theboysbase_send_sv_cvar")
        net.WriteString(cvarName)
        net.WriteString(value and "1" or "0")
        net.SendToServer()
    end

    local function requestTheBoysBaseServerCVars()
        net.Start("theboysbase_request_sv_cvars")
        net.SendToServer()
    end

    local function addServerCheckBox(panel, label, cvarName, globalName, defaultValue)
        local checkbox = vgui.Create("DCheckBoxLabel", panel)
        checkbox:SetText(label)
        checkbox:SetDark(true)
        checkbox:SetValue(GetGlobalBool(globalName, defaultValue ~= false) and 1 or 0)
        checkbox.OnChange = function(_, value)
            if theBoysBaseServerCVarLoading then return end
            setTheBoysBaseServerCVar(cvarName, value)
        end
        panel:AddItem(checkbox)
        theBoysBaseServerCVarPanels[cvarName] = checkbox
        return checkbox
    end

    net.Receive("theboysbase_send_cvars_to_client", function()
        local cvarsTable = net.ReadTable()
        theBoysBaseServerCVarLoading = true

        for cvarName, value in pairs(cvarsTable) do
            local panel = theBoysBaseServerCVarPanels[cvarName]
            if IsValid(panel) then
                panel:SetValue(tonumber(value) and tonumber(value) >= 0.5 and 1 or 0)
            end
        end

        theBoysBaseServerCVarLoading = false
    end)

    createClientConVar("theboysbase_cl_blood_enabled", "1", "Enable local The Boys blood effects.", 0, 1)
    createClientConVar("theboysbase_cl_gore_enabled", "1", "Enable local The Boys gibs.", 0, 1)
    createClientConVar("theboysbase_cl_gore_amount", "1", "Legacy local The Boys gore amount.", 0, 2)
    createClientConVar("theboysbase_cl_gore_gib_amount", "1", "Local The Boys gib amount.", 0, 2)
    createClientConVar("theboysbase_cl_blood_amount", "1", "Local The Boys blood decal amount and scatter.", 0, 2)
    createClientConVar("theboysbase_cl_gore_gib_lifetime", "45", "How long client-side The Boys gibs stay alive. -1 means never auto-remove.", -1, 180)
    createClientConVar("theboysbase_cl_gore_gib_limit", "180", "Maximum active local The Boys gibs.", 0, 1000)
    createClientConVar("theboysbase_cl_destruction_effects", "1", "Enable local The Boys destruction smoke and debris.", 0, 1)
    createClientConVar("theboysbase_cl_destruction_debris_amount", "1", "Local The Boys destruction debris amount.", 0, 2)
    createClientConVar("theboysbase_cl_destruction_debris_scale", "1", "Local The Boys destruction debris scale.", 0.1, 3)

    hook.Add("PopulateToolMenu", "TheBoysBase_Options", function()
        if spawnmenu.AddToolCategory then
            spawnmenu.AddToolCategory("Options", "TheBoys", "The Boys")
        end

        spawnmenu.AddToolMenuOption("Options", "TheBoys", "TheBoysBase_Effects", "Effects", "", "", function(panel)
            panel:ClearControls()
            panel:Help("Client-side settings. They only affect local blood, gibs and destruction visuals.")

            panel:CheckBox("Enable blood", "theboysbase_cl_blood_enabled")
            panel:CheckBox("Enable gore", "theboysbase_cl_gore_enabled")
            panel:NumSlider("Gib amount", "theboysbase_cl_gore_gib_amount", 0, 2, 2)
            panel:NumSlider("Blood amount", "theboysbase_cl_blood_amount", 0, 2, 2)
            panel:NumSlider("Gib lifetime", "theboysbase_cl_gore_gib_lifetime", -1, 180, 0)
            panel:NumSlider("Max active gibs", "theboysbase_cl_gore_gib_limit", 0, 1000, 0)

            panel:Help("")
            panel:Help("Destruction effects")
            panel:CheckBox("Enable destruction effects", "theboysbase_cl_destruction_effects")
            panel:NumSlider("Debris amount", "theboysbase_cl_destruction_debris_amount", 0, 2, 2)
            panel:NumSlider("Debris scale", "theboysbase_cl_destruction_debris_scale", 0.1, 3, 2)

            panel:Help("")
            panel:Help("Server-side settings, admin only")

            local ply = LocalPlayer()
            if not IsValid(ply) or not ply:IsAdmin() then
                panel:ControlHelp("You must be a server admin to change these settings.")
                return
            end

            addServerCheckBox(panel, "Enable dismembering", "theboysbase_sv_dismember_enabled", "theboysbase_sv_dismember_enabled", true)
            panel:ControlHelp("When disabled, dismembering and bone hiding are disabled on the server and clients.")

            requestTheBoysBaseServerCVars()
        end)
    end)
end

TBOYS.Sounds = TBOYS.Sounds or {
    PunchNormal = "theboysbase/punch/punch_normal.ogg",
    PunchLightSwing = "theboysbase/punch/light_swing.ogg",
    PunchHeavyBass = "theboysbase/punch/heavyhit_bass.wav",
    PunchEarthquake = "theboysbase/punch/hit_earthquake.wav",
    FlightLoop = "theboysbase/flying/fling_whoosh.wav",
    FlightStart = "theboysbase/flying/start_01.mp3",
    FlightLunge = "theboysbase/flying/flight_lunge.ogg",
    SonicStop = "theboysbase/flying/sonic_stop.ogg",
    ConcreteBreak = "physics/concrete/concrete_break2.wav",
    PropBreak = {
        "physics/metal/metal_box_break1.wav",
        "physics/metal/metal_box_break2.wav"
    },
    PunchLightHit = {
        "theboysbase/punch/lighthit01.wav",
        "theboysbase/punch/lighthit02.wav",
        "theboysbase/punch/lighthit03.wav",
        "theboysbase/punch/lighthit04.wav"
    },
    PunchHeavyHit = {
        "theboysbase/punch/heavyhit01.wav",
        "theboysbase/punch/heavyhit02.wav",
        "theboysbase/punch/heavyhit03.wav",
        "theboysbase/punch/heavyhit04.wav"
    },
    PunchSwing = {
        "theboysbase/punch/swing_001.wav",
        "theboysbase/punch/swing_002.wav"
    },
    PunchHeavySwing = {
        "theboysbase/punch/heavyswing_01.wav",
        "theboysbase/punch/heavyswing_02.wav",
        "theboysbase/punch/heavyswing_03.wav"
    },
    PunchMiss = {
        "theboysbase/punch/miss_01.wav",
        "theboysbase/punch/miss_02.wav"
    },
    ShockwaveHeavy = {
        "theboysbase/shockwave/shockwave_heavy01.mp3",
        "theboysbase/shockwave/shockwave_heavy02.mp3"
    },
    ShockwaveLight = {
        "theboysbase/shockwave/shockwave_light01.mp3",
        "theboysbase/shockwave/shockwave_light02.mp3"
    },
    SonicBoom = {
        "theboysbase/flying/sonicboom_01.mp3",
        "theboysbase/flying/sonicboom_02.mp3"
    },
    SuperSpeedCrush = {
        "theboysbase/flying/superspeed_crush_01.mp3",
        "theboysbase/flying/superspeed_crush_02.mp3",
        "theboysbase/flying/superspeed_crush_03.mp3"
    }
}

TBOYS.Particles = TBOYS.Particles or {
    PunchHit = "homlndr_punch_hit",
    Shockwave = "homlndr_shockwave",
    SuperFlightTrail = "homlndr_superflight_trail",
    SuperFlightBoom = "homlndr_superflight_boom",
    SuperFlightHit = "homlndr_superflight_hit",
    BloodImpactRed = "blood_impact_red_01_goop",
    BloodImpactYellow = "blood_impact_yellow_01"
}

function TBOYS.RandomSound(soundEntry)
    if istable(soundEntry) then
        if #soundEntry <= 0 then return nil end
        return soundEntry[math.random(#soundEntry)]
    end
    return soundEntry
end

function TBOYS.EmitRandomSound(ent, soundEntry, level, pitch, volume, channel, flags, dsp)
    if not IsValid(ent) then return nil end
    local soundPath = TBOYS.RandomSound(soundEntry)
    if not soundPath then return nil end
    ent:EmitSound(soundPath, level, pitch, volume, channel, flags, dsp)
    return soundPath
end

function TBOYS.PlayRandomSound(soundEntry, pos, level, pitch, volume)
    local soundPath = TBOYS.RandomSound(soundEntry)
    if not soundPath or not pos then return nil end
    sound.Play(soundPath, pos, level, pitch, volume)
    return soundPath
end


function TBOYS.AddBaseResources()
    if not SERVER then return end

    for _, soundDir in ipairs({ "punch", "flying", "shockwave" }) do
        local soundFiles = file.Find("sound/theboysbase/" .. soundDir .. "/*", "GAME")
        for _, fileName in ipairs(soundFiles or {}) do
            resource.AddFile("sound/theboysbase/" .. soundDir .. "/" .. fileName)
        end
    end

    local goreAssetFiles = file.Find("models/gore/*", "GAME")
    for _, fileName in ipairs(goreAssetFiles or {}) do
        resource.AddFile("models/gore/" .. fileName)
    end

    local goreMaterialFiles = file.Find("materials/models/gore/*", "GAME")
    for _, fileName in ipairs(goreMaterialFiles or {}) do
        resource.AddFile("materials/models/gore/" .. fileName)
    end

    local particleMaterialFiles = file.Find("materials/homelanders/particles/*", "GAME")
    for _, fileName in ipairs(particleMaterialFiles or {}) do
        resource.AddFile("materials/homelanders/particles/" .. fileName)
    end

    resource.AddFile("particles/homelander_character_particles.pcf")
end

function TBOYS.PrecacheBaseAssets()
    if SERVER then
        for _, soundEntry in pairs(TBOYS.Sounds or {}) do
            if istable(soundEntry) then
                for _, soundPath in ipairs(soundEntry) do util.PrecacheSound(soundPath) end
            else
                util.PrecacheSound(soundEntry)
            end
        end
        TBOYS.PrecacheGoreAssets()
    end

    if game.AddParticles then
        game.AddParticles("particles/homelander_character_particles.pcf")
    end
    for _, particleName in pairs(TBOYS.Particles or {}) do
        PrecacheParticleSystem(particleName)
    end
end

local vector_up = vector_up or Vector(0, 0, 1)

TBOYS.DefaultVehicleClassHints = TBOYS.DefaultVehicleClassHints or {
    "simfphys", "gmod_sent_vehicle", "sent_sakarias", "lvs", "wac", "scar", "scars",
    "sw_", "swv", "tdm", "photon", "vcmod", "vehicle"
}

TBOYS.DefaultDamageParentMethods = TBOYS.DefaultDamageParentMethods or {
    "GetBaseEnt", "GetVehicle", "GetVehicleBase", "GetChassis", "GetBase"
}

TBOYS.DefaultFlyingDamageClasses = TBOYS.DefaultFlyingDamageClasses or {
    prop_physics = true,
    prop_physics_multiplayer = true,
    prop_dynamic = true,
    prop_ragdoll = false,
    prop_physics_clipped = true,
    prop_door_rotating = true,
    func_breakable_surf = true,
    func_physbox = true,
    func_breakable = true
}

local function copyTraceData(data)
    local copied = {}
    for k, v in pairs(data or {}) do
        copied[k] = v
    end
    return copied
end

local function callOption(options, name, ...)
    local callback = options and options[name]
    if isfunction(callback) then
        return callback(...)
    end
end

function TBOYS.GetSettingFloat(cvarName, fallback, minValue, maxValue)
    local cvar = cvarName and GetConVar(cvarName) or nil
    local value = cvar and cvar:GetFloat() or fallback

    if minValue ~= nil or maxValue ~= nil then
        value = math.Clamp(value, minValue or value, maxValue or value)
    end

    return value
end

function TBOYS.GetSettingBool(cvarName, fallback)
    local cvar = cvarName and GetConVar(cvarName) or nil
    if not cvar then return fallback == true end
    return cvar:GetBool()
end

function TBOYS.CombineDamageTypes(...)
    local result = 0

    for i = 1, select("#", ...) do
        local damageType = select(i, ...)
        if damageType and damageType ~= 0 then
            result = bit and bit.bor and bit.bor(result, damageType) or (result + damageType)
        end
    end

    return result
end

function TBOYS.IsCharacter(ent)
    return IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or (ent.IsNextBot and ent:IsNextBot()))
end

function TBOYS.FindAttachment(ent, names)
    if not IsValid(ent) then return nil end

    for _, name in ipairs(names or {}) do
        local id = ent:LookupAttachment(name)
        if id and id > 0 then
            local attachment = ent:GetAttachment(id)
            if attachment then return attachment end
        end
    end

    return nil
end

function TBOYS.ForEachChildBone(ent, bone, callback)
    if not IsValid(ent) or not bone or not isfunction(callback) then return end

    if ent.GetChildBones then
        for _, child in ipairs(ent:GetChildBones(bone)) do
            callback(child)
        end

        return
    end

    if not ent.GetBoneCount or not ent.GetBoneParent then return end
    for child = 0, ent:GetBoneCount() - 1 do
        if ent:GetBoneParent(child) == bone then
            callback(child)
        end
    end
end

function TBOYS.InvalidateBoneCache(ent)
    if not IsValid(ent) then return end
    if ent.InvalidateBoneCache then ent:InvalidateBoneCache() end
    if ent.SetupBones then ent:SetupBones() end
end

if CLIENT then
    local hiddenBoneScale = Vector(0, 0, 0)
    local visibleBoneScale = Vector(1, 1, 1)

    local function getDismemberField(options, name, fallback)
        return options and options[name] or fallback
    end

    local function debugClientDismember(options, context, fields)
        local debugLog = options and options.debugLog
        if isfunction(debugLog) then
            debugLog(context, fields)
        end
    end

    local function collectChildBones(ent, rootBone, out, seen)
        if ent.SetLOD then ent:SetLOD(0) end
        seen = seen or {}
        if seen[rootBone] then return end
        seen[rootBone] = true

        TBOYS.ForEachChildBone(ent, rootBone, function(child)
            if seen[child] then return end
            out[#out + 1] = child
            collectChildBones(ent, child, out, seen)
        end)
    end

    local function getCachedChildBones(ent, rootBone)
        ent.TheBoysBaseDismemberChildBoneCache = ent.TheBoysBaseDismemberChildBoneCache or {}

        if not ent.TheBoysBaseDismemberChildBoneCache[rootBone] then
            ent.TheBoysBaseDismemberChildBoneCache[rootBone] = {}
            collectChildBones(ent, rootBone, ent.TheBoysBaseDismemberChildBoneCache[rootBone])
        end

        return ent.TheBoysBaseDismemberChildBoneCache[rootBone]
    end

    local function getHiddenBoneOrigin(ent, rootBone, options)
        local origin = options and options.hiddenBoneOrigin
        if isfunction(origin) then
            local ok, value = pcall(origin, ent, rootBone)
            if ok and isvector(value) then return value end
        elseif isvector(origin) then
            return origin
        end

        if ent.GetBoneMatrix then
            local matrix = ent:GetBoneMatrix(rootBone)
            if matrix then return matrix:GetTranslation() end
        end

        if ent.GetBonePosition then
            local pos = ent:GetBonePosition(rootBone)
            if isvector(pos) then return pos end
        end

        return ent:GetPos()
    end

    local function moveChildBoneMatrixToOrigin(ent, bone, origin)
        if not IsValid(ent) or not bone or bone < 0 or not ent.GetBoneMatrix or not ent.SetBoneMatrix then return false end

        local matrix = ent:GetBoneMatrix(bone)
        if not matrix then return false end

        matrix:SetTranslation(origin)
        matrix:Scale(matrix:GetScale() * hiddenBoneScale)
        ent:SetBoneMatrix(bone, matrix)
        return true
    end

    function TBOYS.MoveHiddenBoneChainToOrigin(ent, rootBone, options)
        if not IsValid(ent) or not rootBone or rootBone < 0 then return false end

        local origin = getHiddenBoneOrigin(ent, rootBone, options)
        local moved = false

        for _, child in ipairs(getCachedChildBones(ent, rootBone)) do
            moved = moveChildBoneMatrixToOrigin(ent, child, origin) or moved
        end

        return moved
    end

    local function applyHiddenBoneMatrix(ent, rootBone, options)
        if not IsValid(ent) or not rootBone or rootBone < 0 then return false end
        if not ent.ManipulateBoneScale and not ent.SetBoneMatrix then return false end

        if ent.ManipulateBoneScale then
            ent:ManipulateBoneScale(rootBone, hiddenBoneScale)
            for _, child in ipairs(getCachedChildBones(ent, rootBone)) do
                ent:ManipulateBoneScale(child, hiddenBoneScale)
            end
        end

        local moved = false
        if not options or options.moveHiddenBonesToOrigin ~= false then
            moved = TBOYS.MoveHiddenBoneChainToOrigin(ent, rootBone, options)
        end

        return ent.ManipulateBoneScale ~= nil or moved
    end

    local function applyClientDismemberMatrices(ent, options)
        if not IsValid(ent) then return false end

        local rootsField = getDismemberField(options, "rootsField", "TheBoysBaseDismemberBoneRoots")
        local roots = ent[rootsField]
        if not roots then return false end

        local applied = false
        local boneCount = ent.GetBoneCount and ent:GetBoneCount() or 0
        for rootBone in pairs(roots) do
            if rootBone >= 0 and rootBone < boneCount then
                applied = applyHiddenBoneMatrix(ent, rootBone, options) or applied
            end
        end

        return applied
    end

    local function ensureClientDismemberCallback(ent, options)
        local callbackField = getDismemberField(options, "callbackField", "TheBoysBaseDismemberBuildBoneCallback")
        if not IsValid(ent) or ent[callbackField] or not ent.AddCallback then return end

        local inBuildField = getDismemberField(options, "inBuildField", "TheBoysBaseDismemberInBuildBones")

        ent[callbackField] = ent:AddCallback("BuildBonePositions", function(callbackEnt)
            if not IsValid(callbackEnt) or callbackEnt[inBuildField] then return end

            callbackEnt[inBuildField] = true
            applyClientDismemberMatrices(callbackEnt, options)
            callbackEnt[inBuildField] = nil
        end)
    end

    local function countBoneChain(ent, bone, counted)
        if not IsValid(ent) or not bone or bone < 0 then return 0 end

        counted = counted or {}
        if counted[bone] then return 0 end
        counted[bone] = true

        local count = 1
        TBOYS.ForEachChildBone(ent, bone, function(child)
            count = count + countBoneChain(ent, child, counted)
        end)

        return count
    end

    local fallbackBoneHints = {
        head = { "head", "neck", "skull", "jaw" },
        left_arm = { "l_upperarm", "leftupperarm", "l_forearm", "leftforearm", "l_hand", "lefthand", "left_arm" },
        right_arm = { "r_upperarm", "rightupperarm", "r_forearm", "rightforearm", "r_hand", "righthand", "right_arm" },
        left_leg = { "l_thigh", "leftthigh", "l_calf", "leftcalf", "l_foot", "leftfoot", "left_leg" },
        right_leg = { "r_thigh", "rightthigh", "r_calf", "rightcalf", "r_foot", "rightfoot", "right_leg" },
        upper = { "spine2", "spine4", "chest", "torso", "spine" },
        lower = { "pelvis", "hip", "spine" }
    }

    local function lookupBoneByNameHints(ent, hints)
        if not IsValid(ent) or not ent.GetBoneCount or not hints then return nil end

        for bone = 0, ent:GetBoneCount() - 1 do
            local boneName = ent:GetBoneName(bone)
            if isstring(boneName) then
                local lowerName = string.lower(boneName)
                for _, hint in ipairs(hints) do
                    if string.find(lowerName, hint, 1, true) then
                        return bone
                    end
                end
            end
        end
    end

    local function isPelvisBoneName(boneName)
        return isstring(boneName) and string.find(string.lower(boneName), "pelvis", 1, true) ~= nil
    end

    local function lookupClientFallbackBones(ent, mode, dismemberBones)
        if not IsValid(ent) or not ent.LookupBone then return nil end

        local roots = {}
        local seen = {}
        local fallbackBones = dismemberBones and dismemberBones[mode]
        if fallbackBones then
            for _, fallbackBoneName in ipairs(fallbackBones) do
                if not isPelvisBoneName(fallbackBoneName) then
                    local bone = ent:LookupBone(fallbackBoneName)
                    if bone and bone >= 0 and not seen[bone] then
                        roots[#roots + 1] = bone
                        seen[bone] = true
                    end
                end
            end
        end

        return #roots > 0 and roots or nil
    end

    local function lookupClientDismemberBone(ent, boneName, mode, dismemberBones)
        if not IsValid(ent) or not ent.LookupBone then return nil end

        if boneName and boneName ~= "" and not (mode == "lower" and isPelvisBoneName(boneName)) then
            local bone = ent:LookupBone(boneName)
            if bone and bone >= 0 then return bone end
        end

        local fallbackBones = dismemberBones and dismemberBones[mode]
        if fallbackBones then
            for _, fallbackBoneName in ipairs(fallbackBones) do
                local bone = ent:LookupBone(fallbackBoneName)
                if bone and bone >= 0 then return bone end
            end
        end

        return lookupBoneByNameHints(ent, fallbackBoneHints[mode])
    end

    local function registerClientDismemberRoot(ent, bone, options)
        if not IsValid(ent) or not bone or bone < 0 then return 0 end

        local rootsField = getDismemberField(options, "rootsField", "TheBoysBaseDismemberBoneRoots")
        ent[rootsField] = ent[rootsField] or {}
        ent[rootsField][bone] = true
        ent.TheBoysBaseDismemberChildBoneCache = nil
        ensureClientDismemberCallback(ent, options)
        applyClientDismemberMatrices(ent, options)

        return countBoneChain(ent, bone)
    end

    function TBOYS.ApplyClientBoneDismember(ent, mode, options)
        if not IsValid(ent) or not mode or mode == "" then return false end

        if ent.SetupBones then ent:SetupBones() end

        options = options or {}
        local dismemberBones = options.dismemberBones or TBOYS.DismemberBones
        local appliedField = getDismemberField(options, "appliedField", "TheBoysBaseClientDismemberApplied")
        local appliedKey = mode .. ":" .. tostring(options.boneName or "")

        debugClientDismember(options, "base ApplyClientBoneDismember start", {
            ent = ent,
            mode = mode,
            boneName = options.boneName or "",
            boneCount = ent.GetBoneCount and ent:GetBoneCount() or 0,
            currentApplied = ent[appliedField] or ""
        })

        if ent[appliedField] == appliedKey then
            debugClientDismember(options, "base ApplyClientBoneDismember cache hit", {
                ent = ent,
                appliedKey = appliedKey
            })
            return applyClientDismemberMatrices(ent, options) or true
        end
        if ent[appliedField] then
            debugClientDismember(options, "base ApplyClientBoneDismember reset previous", {
                ent = ent,
                previousApplied = ent[appliedField]
            })
            TBOYS.ResetClientBoneDismember(ent, options)
        end

        local exactBone = nil
        if options.boneName and options.boneName ~= "" and ent.LookupBone then
            exactBone = ent:LookupBone(options.boneName)
        end

        local rootBone = lookupClientDismemberBone(ent, options.boneName, mode, dismemberBones)
        local rootBones = nil
        if mode == "lower" and isPelvisBoneName(options.boneName) then
            rootBones = lookupClientFallbackBones(ent, mode, dismemberBones)
        end
        rootBones = rootBones or (rootBone and { rootBone } or nil)
        debugClientDismember(options, "base ApplyClientBoneDismember root lookup", {
            ent = ent,
            mode = mode,
            requestedBoneName = options.boneName or "",
            exactBone = exactBone or "nil",
            rootBone = rootBone or "nil",
            rootCount = rootBones and #rootBones or 0,
            rootBoneName = rootBone and ent.GetBoneName and ent:GetBoneName(rootBone) or ""
        })

        local hiddenCount = 0
        if rootBones then
            for _, bone in ipairs(rootBones) do
                hiddenCount = hiddenCount + registerClientDismemberRoot(ent, bone, options)
            end
        end
        if hiddenCount <= 0 then
            debugClientDismember(options, "base ApplyClientBoneDismember failed", {
                ent = ent,
                mode = mode,
                boneName = options.boneName or "",
                rootBone = rootBone or "nil",
                hiddenCount = hiddenCount
            })
            return false
        end

        ent[appliedField] = appliedKey
        TBOYS.InvalidateBoneCache(ent)
        debugClientDismember(options, "base ApplyClientBoneDismember success", {
            ent = ent,
            mode = mode,
            boneName = options.boneName or "",
            rootBone = rootBone,
            rootCount = rootBones and #rootBones or 0,
            rootBoneName = ent.GetBoneName and ent:GetBoneName(rootBone) or "",
            hiddenCount = hiddenCount
        })
        return true
    end

    function TBOYS.ResetClientBoneDismember(ent, options)
        if not IsValid(ent) then return end

        options = options or {}
        local callbackField = getDismemberField(options, "callbackField", "TheBoysBaseDismemberBuildBoneCallback")
        local rootsField = getDismemberField(options, "rootsField", "TheBoysBaseDismemberBoneRoots")
        local inBuildField = getDismemberField(options, "inBuildField", "TheBoysBaseDismemberInBuildBones")
        local appliedField = getDismemberField(options, "appliedField", "TheBoysBaseClientDismemberApplied")
        local checkedOwnerField = options.checkedOwnerField

        if ent[callbackField] then
            if ent.RemoveCallback then
                ent:RemoveCallback("BuildBonePositions", ent[callbackField])
            end
            ent[callbackField] = nil
        end

        if ent.GetBoneCount and ent.ManipulateBoneScale then
            for bone = 0, ent:GetBoneCount() - 1 do
                ent:ManipulateBoneScale(bone, visibleBoneScale)
            end
        end

        ent[rootsField] = nil
        ent[inBuildField] = nil
        ent[appliedField] = nil
        ent.TheBoysBaseDismemberChildBoneCache = nil
        if checkedOwnerField then ent[checkedOwnerField] = nil end

        TBOYS.InvalidateBoneCache(ent)
    end

end

if SERVER then
    local hiddenBoneScale = Vector(0, 0, 0)
    local forcedPhysBoneVelocity = Vector(0, 0, 0)

    local fallbackBoneHints = {
        head = { "head", "neck", "skull", "jaw" },
        left_arm = { "l_upperarm", "leftupperarm", "l_forearm", "leftforearm", "l_hand", "lefthand", "left_arm" },
        right_arm = { "r_upperarm", "rightupperarm", "r_forearm", "rightforearm", "r_hand", "righthand", "right_arm" },
        left_leg = { "l_thigh", "leftthigh", "l_calf", "leftcalf", "l_foot", "leftfoot", "left_leg" },
        right_leg = { "r_thigh", "rightthigh", "r_calf", "rightcalf", "r_foot", "rightfoot", "right_leg" },
        upper = { "spine2", "spine4", "chest", "torso", "spine" },
        lower = { "pelvis", "hip", "spine" }
    }

    local function debugRagdollPhysDismember(options, context, fields)
        local debugLog = options and options.debugLog
        if isfunction(debugLog) then
            debugLog(context, fields)
        end
    end

    local function lookupBoneByNameHints(ent, hints)
        if not IsValid(ent) or not ent.GetBoneCount or not hints then return nil end

        for bone = 0, ent:GetBoneCount() - 1 do
            local boneName = ent:GetBoneName(bone)
            if isstring(boneName) then
                local lowerName = string.lower(boneName)
                for _, hint in ipairs(hints) do
                    if string.find(lowerName, hint, 1, true) then
                        return bone
                    end
                end
            end
        end
    end

    local function isPelvisBoneName(boneName)
        return isstring(boneName) and string.find(string.lower(boneName), "pelvis", 1, true) ~= nil
    end

    local function lookupRagdollFallbackBones(ent, mode, dismemberBones)
        if not IsValid(ent) or not ent.LookupBone then return nil end

        local roots = {}
        local seen = {}
        local fallbackBones = dismemberBones and dismemberBones[mode or ""]
        if fallbackBones then
            for _, fallbackBoneName in ipairs(fallbackBones) do
                if not isPelvisBoneName(fallbackBoneName) then
                    local bone = ent:LookupBone(fallbackBoneName)
                    if bone and bone >= 0 and not seen[bone] then
                        roots[#roots + 1] = bone
                        seen[bone] = true
                    end
                end
            end
        end

        return #roots > 0 and roots or nil
    end

    local function lookupRagdollDismemberBone(ent, mode, boneName, dismemberBones)
        if not IsValid(ent) or not ent.LookupBone then return nil end

        if boneName and boneName ~= "" and not (mode == "lower" and isPelvisBoneName(boneName)) then
            local bone = ent:LookupBone(boneName)
            if bone and bone >= 0 then return bone end
        end

        local fallbackBones = dismemberBones and dismemberBones[mode or ""]
        if fallbackBones then
            for _, fallbackBoneName in ipairs(fallbackBones) do
                local bone = ent:LookupBone(fallbackBoneName)
                if bone and bone >= 0 then return bone end
            end
        end

        return lookupBoneByNameHints(ent, fallbackBoneHints[mode])
    end

    local function collectBoneBranch(ent, bone, out, seen)
        if not IsValid(ent) or not bone or bone < 0 then return end

        seen = seen or {}
        if seen[bone] then return end
        seen[bone] = true
        out[#out + 1] = bone

        TBOYS.ForEachChildBone(ent, bone, function(child)
            collectBoneBranch(ent, child, out, seen)
        end)
    end

    local function getBonePhysBone(ent, bone)
        if not IsValid(ent) or not ent.TranslateBoneToPhysBone or not bone or bone < 0 then return -1 end

        local physBone = ent:TranslateBoneToPhysBone(bone)
        if not physBone or physBone < 0 then return -1 end

        return physBone
    end

    local function findParentPhysBone(ent, bone, physBone)
        if not IsValid(ent) or not ent.GetBoneParent then return nil end

        local parentBone = ent:GetBoneParent(bone)
        local guard = 0

        while parentBone and parentBone >= 0 and guard < 128 do
            local parentPhysBone = getBonePhysBone(ent, parentBone)
            if parentPhysBone >= 0 and parentPhysBone ~= physBone then
                return parentPhysBone
            end

            parentBone = ent:GetBoneParent(parentBone)
            guard = guard + 1
        end

        return 0
    end

    local function forceHiddenPhysBones(ragdoll)
        local parents = IsValid(ragdoll) and ragdoll.TheBoysBaseGibbedPhysBoneParents or nil
        if not parents then return false end

        local forced = false
        for physBone, parentPhysBone in pairs(parents) do
            if physBone and parentPhysBone and physBone >= 0 and parentPhysBone >= 0 and physBone ~= parentPhysBone then
                local physObj = ragdoll:GetPhysicsObjectNum(physBone)
                local parentPhysObj = ragdoll:GetPhysicsObjectNum(parentPhysBone)

                if IsValid(physObj) and IsValid(parentPhysObj) then
                    physObj:SetPos(parentPhysObj:GetPos())
                    physObj:SetAngles(parentPhysObj:GetAngles())
                    physObj:SetVelocity(forcedPhysBoneVelocity)
                    forced = true
                end
            end
        end

        return forced
    end

    local function registerForcedPhysBoneRagdoll(ragdoll)
        if not IsValid(ragdoll) or ragdoll.TheBoysBasePhysDismemberRegistered then return end

        TBOYS.PhysDismemberRagdolls = TBOYS.PhysDismemberRagdolls or {}
        TBOYS.PhysDismemberRagdolls[#TBOYS.PhysDismemberRagdolls + 1] = ragdoll
        ragdoll.TheBoysBasePhysDismemberRegistered = true

        if ragdoll.CallOnRemove then
            ragdoll:CallOnRemove("TheBoysBasePhysDismember", function(ent)
                ent.TheBoysBasePhysDismemberRegistered = nil
            end)
        end
    end

    hook.Add("Think", "TheBoysBase.ForceHiddenPhysBones", function()
        local ragdolls = TBOYS.PhysDismemberRagdolls
        if not ragdolls then return end

        for i = #ragdolls, 1, -1 do
            local ragdoll = ragdolls[i]
            if not IsValid(ragdoll) or not ragdoll.TheBoysBaseGibbedPhysBoneParents then
                table.remove(ragdolls, i)
            else
                forceHiddenPhysBones(ragdoll)
            end
        end
    end)

    function TBOYS.ApplyRagdollPhysBoneDismember(ragdoll, mode, boneName, options)
        if not TBOYS.IsDismemberEnabled() then return false end
        if not IsValid(ragdoll) or ragdoll:GetClass() ~= "prop_ragdoll" or not mode or mode == "" then return false end
        if not ragdoll.GetBoneCount or not ragdoll.TranslateBoneToPhysBone then return false end

        options = options or {}
        if ragdoll.SetupBones then ragdoll:SetupBones() end

        local dismemberBones = options.dismemberBones or TBOYS.DismemberBones
        local rootBone = lookupRagdollDismemberBone(ragdoll, mode, boneName, dismemberBones)
        local rootBones = nil
        if mode == "lower" and isPelvisBoneName(boneName) then
            rootBones = lookupRagdollFallbackBones(ragdoll, mode, dismemberBones)
        end
        rootBones = rootBones or (rootBone and { rootBone } or nil)
        if not rootBone or rootBone < 0 then
            debugRagdollPhysDismember(options, "base ragdoll phys dismember failed", {
                ragdoll = ragdoll,
                mode = mode,
                boneName = boneName or ""
            })
            return false
        end

        local bones = {}
        for _, bone in ipairs(rootBones) do
            collectBoneBranch(ragdoll, bone, bones)
        end

        ragdoll.TheBoysBaseGibbedPhysBones = ragdoll.TheBoysBaseGibbedPhysBones or {}
        ragdoll.TheBoysBaseGibbedPhysBoneParents = ragdoll.TheBoysBaseGibbedPhysBoneParents or {}

        local hiddenCount = 0
        local physCount = 0

        for _, bone in ipairs(bones) do
            if ragdoll.ManipulateBoneScale then
                ragdoll:ManipulateBoneScale(bone, hiddenBoneScale)
                hiddenCount = hiddenCount + 1
            end

            local physBone = getBonePhysBone(ragdoll, bone)
            if physBone >= 0 and not ragdoll.TheBoysBaseGibbedPhysBones[physBone] then
                local physObj = ragdoll:GetPhysicsObjectNum(physBone)
                if IsValid(physObj) then
                    physObj:EnableCollisions(false)
                    physObj:SetMass(0.1)
                end

                if physBone ~= 0 then
                    local parentPhysBone = findParentPhysBone(ragdoll, bone, physBone)
                    if parentPhysBone and parentPhysBone >= 0 and parentPhysBone ~= physBone then
                        ragdoll.TheBoysBaseGibbedPhysBoneParents[physBone] = parentPhysBone

                        if ragdoll.RemoveInternalConstraint then
                            pcall(ragdoll.RemoveInternalConstraint, ragdoll, physBone)
                        end
                    end
                end

                ragdoll.TheBoysBaseGibbedPhysBones[physBone] = true
                physCount = physCount + 1
            end
        end

        if next(ragdoll.TheBoysBaseGibbedPhysBoneParents) then
            registerForcedPhysBoneRagdoll(ragdoll)
            forceHiddenPhysBones(ragdoll)
        end

        TBOYS.InvalidateBoneCache(ragdoll)
        debugRagdollPhysDismember(options, "base ragdoll phys dismember applied", {
            ragdoll = ragdoll,
            mode = mode,
            boneName = boneName or "",
            rootBone = rootBone,
            rootCount = rootBones and #rootBones or 0,
            rootBoneName = ragdoll.GetBoneName and ragdoll:GetBoneName(rootBone) or "",
            hiddenCount = hiddenCount,
            physCount = physCount
        })

        return hiddenCount > 0
    end
end
function TBOYS.GetEyePositions(ply, config)
    if not IsValid(ply) then return nil, nil end

    config = config or {}
    local left = TBOYS.FindAttachment(ply, config.leftAttachments)
    local right = TBOYS.FindAttachment(ply, config.rightAttachments)

    if left and right then
        return left.Pos, right.Pos, left.Ang or ply:EyeAngles()
    end

    local eyes = TBOYS.FindAttachment(ply, config.centerAttachments)
    local ang = (eyes and eyes.Ang) or ply:EyeAngles()
    local base = (eyes and eyes.Pos) or ply:EyePos()
    local sideOffset = tonumber(callOption(config, "getSideOffset", ply)) or config.sideOffset or 1.3
    local forwardOffset = tonumber(callOption(config, "getForwardOffset", ply)) or config.forwardOffset or 0
    local heightOffset = tonumber(callOption(config, "getHeightOffset", ply)) or config.heightOffset or 0

    return base - ang:Right() * sideOffset + ang:Forward() * forwardOffset + ang:Up() * heightOffset,
        base + ang:Right() * sideOffset + ang:Forward() * forwardOffset + ang:Up() * heightOffset,
        ang
end

function TBOYS.IsIgnoredImpactEntity(ent, options)
    if not IsValid(ent) or ent:IsWorld() then return true end

    local custom = callOption(options, "isIgnoredImpactEntity", ent)
    if custom ~= nil then return custom == true end

    return ent:GetClass() == "prop_ragdoll"
end

function TBOYS.IsVehicleBaseEntity(ent, options)
    if not IsValid(ent) then return false end
    if ent:IsVehicle() then return true end

    local className = string.lower(ent:GetClass() or "")
    for _, hint in ipairs((options and options.vehicleClassHints) or TBOYS.DefaultVehicleClassHints) do
        if string.find(className, hint, 1, true) then
            return true
        end
    end

    return false
end

function TBOYS.IsBreakableProp(ent, options)
    if not IsValid(ent) or TBOYS.IsIgnoredImpactEntity(ent, options) then return false end

    local custom = callOption(options, "isBreakableProp", ent)
    if custom ~= nil then return custom == true end

    local className = ent:GetClass()
    return className == "prop_physics"
        or className == "prop_physics_multiplayer"
        or className == "prop_physics_clipped"
        or className == "func_physbox"
        or className == "func_breakable"
        or className == "func_breakable_surf"
end

function TBOYS.ShouldUseFallbackDamage(ent, options)
    if not IsValid(ent) or TBOYS.IsCharacter(ent) then return false end

    local custom = callOption(options, "shouldUseFallbackDamage", ent)
    if custom ~= nil then return custom == true end
    if TBOYS.IsVehicleBaseEntity(ent, options) then return true end

    local className = ent:GetClass()
    local classes = (options and options.flyingDamageClasses) or TBOYS.DefaultFlyingDamageClasses
    if classes[className] == true or string.StartWith(className, "prop_physics") then return false end

    local phys = ent:GetPhysicsObject()
    return IsValid(phys) and ent:GetMoveType() == MOVETYPE_VPHYSICS
end

function TBOYS.IsFlyingDamageTarget(ent, owner, options)
    if not IsValid(ent) or ent == owner or TBOYS.IsIgnoredImpactEntity(ent, options) then return false end

    local custom = callOption(options, "isFlyingDamageTarget", ent, owner)
    if custom ~= nil then return custom == true end
    if TBOYS.IsCharacter(ent) or TBOYS.IsVehicleBaseEntity(ent, options) then return true end

    local classes = (options and options.flyingDamageClasses) or TBOYS.DefaultFlyingDamageClasses
    if classes[ent:GetClass()] == true then return true end

    local phys = ent:GetPhysicsObject()
    if IsValid(phys) and ent:GetMoveType() == MOVETYPE_VPHYSICS then return true end
    if ent.Health and ent:Health() > 0 then return true end

    return false
end

function TBOYS.PushPhysicsObject(ent, direction, force)
    if not IsValid(ent) then return end

    local phys = ent:GetPhysicsObject()
    if not IsValid(phys) then return end

    direction = direction or vector_up
    if direction:LengthSqr() <= 0.001 then direction = vector_up end
    direction = direction:GetNormalized()

    phys:EnableMotion(true)
    phys:Wake()
    phys:ApplyForceCenter(direction * (tonumber(force) or 0) * math.max(phys:GetMass(), 20))
end

function TBOYS.ResolveCharacterTarget(ent, options)
    if not IsValid(ent) then return nil end
    if TBOYS.IsCharacter(ent) then return ent end

    local parent = ent:GetParent()
    local depth = 0
    while IsValid(parent) and parent ~= ent and depth < ((options and options.parentDepth) or 6) do
        if TBOYS.IsCharacter(parent) then return parent end

        parent = parent:GetParent()
        depth = depth + 1
    end

    local owner = ent:GetOwner()
    if IsValid(owner) and owner ~= ent and TBOYS.IsCharacter(owner) then
        local ownerParent = ent:GetParent()
        if IsValid(ownerParent) and ownerParent == owner then return owner end
        if owner:IsNPC() or (owner.IsNextBot and owner:IsNextBot()) then return owner end
    end

    for _, methodName in ipairs((options and options.damageParentMethods) or TBOYS.DefaultDamageParentMethods) do
        local method = ent[methodName]
        if isfunction(method) then
            local ok, related = pcall(method, ent)
            if ok and IsValid(related) and related ~= ent and TBOYS.IsCharacter(related) then
                return related
            end
        end
    end

    return nil
end

function TBOYS.TraceCharacterHull(data, options)
    local trace = util.TraceHull(data)
    if IsValid(TBOYS.ResolveCharacterTarget(trace.Entity, options)) then return trace end

    for _, mask in ipairs((options and options.fallbackMasks) or { MASK_SOLID, MASK_NPCSOLID or MASK_SOLID }) do
        if mask and mask ~= data.mask then
            local fallbackData = copyTraceData(data)
            fallbackData.mask = mask

            local fallbackTrace = util.TraceHull(fallbackData)
            if IsValid(TBOYS.ResolveCharacterTarget(fallbackTrace.Entity, options)) then
                return fallbackTrace
            end
        end
    end

    return trace
end

function TBOYS.TraceCharacterLine(data, options)
    local trace = util.TraceLine(data)
    if IsValid(TBOYS.ResolveCharacterTarget(trace.Entity, options)) then return trace end

    for _, mask in ipairs((options and options.fallbackMasks) or { MASK_NPCSOLID or MASK_SOLID, MASK_SOLID }) do
        if mask and mask ~= data.mask then
            local fallbackData = copyTraceData(data)
            fallbackData.mask = mask

            local fallbackTrace = util.TraceLine(fallbackData)
            if IsValid(TBOYS.ResolveCharacterTarget(fallbackTrace.Entity, options)) then
                return fallbackTrace
            end
        end
    end

    return trace
end

function TBOYS.AddDamageTarget(targets, seen, ent, options)
    if not IsValid(ent) or ent:IsWorld() or seen[ent] or TBOYS.IsIgnoredImpactEntity(ent, options) then return end

    seen[ent] = true
    targets[#targets + 1] = ent
end

function TBOYS.CollectDamageTargets(ent, options)
    local targets = {}
    local seen = {}

    TBOYS.AddDamageTarget(targets, seen, ent, options)
    if not IsValid(ent) then return targets end

    local characterTarget = TBOYS.ResolveCharacterTarget(ent, options)
    if IsValid(characterTarget) then TBOYS.AddDamageTarget(targets, seen, characterTarget, options) end

    local parent = ent:GetParent()
    if IsValid(parent) and parent ~= ent then TBOYS.AddDamageTarget(targets, seen, parent, options) end

    local owner = ent:GetOwner()
    if IsValid(owner) and owner ~= ent and not TBOYS.IsCharacter(owner) then TBOYS.AddDamageTarget(targets, seen, owner, options) end

    for _, methodName in ipairs((options and options.damageParentMethods) or TBOYS.DefaultDamageParentMethods) do
        local method = ent[methodName]
        if isfunction(method) then
            local ok, related = pcall(method, ent)
            if ok and IsValid(related) and related ~= ent and not TBOYS.IsCharacter(related) then
                TBOYS.AddDamageTarget(targets, seen, related, options)
            end
        end
    end

    return targets
end

function TBOYS.ApplyCompatDamage(weapon, ent, damage, options)
    if not SERVER or not IsValid(ent) or not damage then return end

    options = options or {}
    local targets = TBOYS.CollectDamageTargets(ent, options)
    local attacker = damage:GetAttacker()
    local inflictor = damage:GetInflictor()
    local damageAmount = damage:GetDamage()
    local damageType = TBOYS.CombineDamageTypes(damage:GetDamageType(), options.extraDamageType or 0)

    for _, target in ipairs(targets) do
        if not IsValid(target) then continue end
        if IsValid(attacker) and target == attacker and IsValid(inflictor) and inflictor == weapon then continue end

        local compatDamage = DamageInfo()
        compatDamage:SetAttacker(IsValid(attacker) and attacker or target)
        compatDamage:SetInflictor(IsValid(inflictor) and inflictor or weapon)
        compatDamage:SetDamage(damageAmount)
        compatDamage:SetDamageType(damageType)
        compatDamage:SetDamagePosition(damage:GetDamagePosition())
        compatDamage:SetDamageForce(damage:GetDamageForce())

        local beforeHealth = (not target:IsPlayer() and target.Health) and target:Health() or nil
        target:TakeDamageInfo(compatDamage)

        if options.fallbackTakeDamage and IsValid(target) and TBOYS.ShouldUseFallbackDamage(target, options) and target.TakeDamage then
            target:TakeDamage(math.max(damageAmount * (options.fallbackScale or 0.35), 1), IsValid(attacker) and attacker or target, IsValid(inflictor) and inflictor or weapon)
        elseif options.fallbackTakeDamage
            and IsValid(target)
            and beforeHealth
            and TBOYS.IsCharacter(target)
            and not target:IsPlayer()
            and target.TakeDamage
            and target:Health() >= beforeHealth then
            target:TakeDamage(math.max(damageAmount * (options.characterFallbackScale or 1), 1), IsValid(attacker) and attacker or target, IsValid(inflictor) and inflictor or weapon)
        end
    end
end

function TBOYS.BreakAndScatterImpactProps(weapon, data)
    if not SERVER then return end

    data = data or {}
    local pos = data.pos
    if not pos then return end

    local aimDir = data.dir or vector_up
    if aimDir:LengthSqr() <= 0.001 then aimDir = vector_up end
    aimDir = aimDir:GetNormalized()

    local destroyRadius = tonumber(data.destroyRadius) or 0
    local scatterRadius = tonumber(data.scatterRadius) or destroyRadius
    local scatterForce = tonumber(data.scatterForce) or 0
    local damageAmount = tonumber(data.damage) or 1000
    local attacker = data.attacker

    for _, ent in ipairs(ents.FindInSphere(pos, scatterRadius)) do
        if not TBOYS.IsBreakableProp(ent, data) then continue end
        if isfunction(data.isBlockedEntity) and data.isBlockedEntity(ent) then continue end

        local entPos = ent:WorldSpaceCenter()
        local distance = entPos:Distance(pos)
        local pushDir = entPos - pos
        if pushDir:LengthSqr() <= 0.001 then pushDir = aimDir else pushDir:Normalize() end

        local finalDir = (pushDir + aimDir * (data.forwardBias or 0.25) + vector_up * (data.upBias or 0.12)):GetNormalized()
        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(true)
            phys:Wake()
        end

        if distance <= destroyRadius then
            if isfunction(data.onBreakProp) then data.onBreakProp(ent, entPos) end

            local damage = DamageInfo()
            damage:SetAttacker(IsValid(attacker) and attacker or ent)
            damage:SetInflictor(IsValid(weapon) and weapon or ent)
            damage:SetDamage(damageAmount)
            damage:SetDamageType(TBOYS.CombineDamageTypes(DMG_BLAST, DMG_CRUSH, DMG_CLUB, DMG_VEHICLE or 0))
            damage:SetDamagePosition(entPos)
            damage:SetDamageForce(finalDir * scatterForce)
            TBOYS.ApplyCompatDamage(weapon, ent, damage, data.damageOptions or { fallbackTakeDamage = true, fallbackScale = 0.3 })

            if IsValid(ent) and ent.Fire then ent:Fire("Break", "", 0) end
            if IsValid(ent) and string.StartWith(ent:GetClass(), "prop_physics") then
                timer.Simple(0, function()
                    if IsValid(ent) then ent:Remove() end
                end)
            end
        elseif IsValid(phys) then
            local falloff = 1 - math.Clamp((distance - destroyRadius) / math.max(scatterRadius - destroyRadius, 1), 0, 1)
            phys:ApplyForceCenter(finalDir * scatterForce * math.max(phys:GetMass(), 20) * math.max(falloff, 0.25))
        end
    end
end

function TBOYS.DoShockwave(weapon, data)
    if not SERVER or not IsValid(weapon) then return end

    data = data or {}
    local pos = data.pos
    local owner = data.owner or weapon:GetOwner()
    if not pos or not IsValid(owner) then return end

    local aimDir = data.dir or owner:EyeAngles():Forward()
    if aimDir:LengthSqr() <= 0.001 then aimDir = vector_up end
    aimDir = aimDir:GetNormalized()

    if isfunction(data.sendImpactFX) then data.sendImpactFX("shockwave", pos, vector_up, false, false) end
    if data.screenShake ~= false then
        util.ScreenShake(pos, data.shakeAmplitude or 28, data.shakeFrequency or 220, data.shakeDuration or 0.65, (data.radius or 0) * (data.shakeRadiusScale or 4), true)
    end
    if isfunction(data.playSounds) then data.playSounds(owner, pos, data.soundVolumeScale or 1) end

    TBOYS.BreakAndScatterImpactProps(weapon, {
        pos = pos,
        dir = aimDir,
        attacker = owner,
        destroyRadius = data.propDestroyRadius,
        scatterRadius = data.propScatterRadius,
        scatterForce = data.propScatterForce,
        damage = data.propDamage,
        onBreakProp = data.onBreakProp,
        isBlockedEntity = data.isBlockedEntity,
        vehicleClassHints = data.vehicleClassHints,
        flyingDamageClasses = data.flyingDamageClasses
    })

    for _, ent in ipairs(ents.FindInSphere(pos, data.radius or 0)) do
        if ent == owner or ent == data.directHit then continue end
        if TBOYS.IsBreakableProp(ent, data) then continue end
        if isfunction(data.isBlockedEntity) and data.isBlockedEntity(ent) then continue end

        local pushDir = ent:WorldSpaceCenter() - pos
        if pushDir:LengthSqr() <= 0.001 then pushDir = aimDir else pushDir:Normalize() end

        local finalDir = (pushDir + aimDir * (data.damageForwardBias or 0.65)):GetNormalized()
        local wasCharacter = TBOYS.IsCharacter(ent)
        local damageAmount = tonumber(data.damage) or 0
        if isfunction(data.scaleDamage) then damageAmount = data.scaleDamage(ent, damageAmount) end

        local damage = DamageInfo()
        damage:SetAttacker(owner)
        damage:SetInflictor(weapon)
        damage:SetDamage(damageAmount)
        damage:SetDamageType(TBOYS.CombineDamageTypes(DMG_CLUB, DMG_CRUSH, DMG_BLAST, DMG_VEHICLE or 0, wasCharacter and (DMG_ALWAYSGIB or 0) or 0))
        damage:SetDamagePosition(ent:WorldSpaceCenter())
        damage:SetDamageForce(finalDir * (data.force or 0))

        local killPos = ent:WorldSpaceCenter()
        local victimModel = ent:GetModel()
        TBOYS.ApplyCompatDamage(weapon, ent, damage, data.damageOptions or { fallbackTakeDamage = true, fallbackScale = 0.3 })

        if wasCharacter and isfunction(data.onCharacterDamaged) then
            timer.Simple(0, function()
                if IsValid(weapon) then data.onCharacterDamaged(ent, finalDir, killPos, wasCharacter, victimModel) end
            end)
        end

        TBOYS.PushPhysicsObject(ent, finalDir, data.force or 0)
    end
end

function TBOYS.DoMeleePunch(weapon, data)
    if not SERVER or not IsValid(weapon) then return nil end

    data = data or {}
    local owner = data.owner or weapon:GetOwner()
    if not IsValid(owner) then return nil end

    if data.animateOwner ~= false then
        owner:SetAnimation(data.ownerAnimation or PLAYER_ATTACK1)
    end

    owner:LagCompensation(true)

    local startPos = data.startPos or owner:EyePos()
    local aimDir = data.dir or owner:EyeAngles():Forward()
    local range = data.range or 95
    local trace = TBOYS.TraceCharacterHull({
        start = startPos,
        endpos = startPos + aimDir * range,
        filter = data.filter or owner,
        mins = data.mins or Vector(-12, -12, -12),
        maxs = data.maxs or Vector(12, 12, 12),
        mask = data.mask or MASK_SHOT
    }, data.traceOptions)

    if not trace.Hit or not IsValid(trace.Entity) then
        local solidTrace = TBOYS.TraceCharacterHull({
            start = startPos,
            endpos = startPos + aimDir * range,
            filter = data.filter or owner,
            mins = data.mins or Vector(-12, -12, -12),
            maxs = data.maxs or Vector(12, 12, 12),
            mask = data.solidMask or MASK_SOLID
        }, data.traceOptions)

        if solidTrace.Hit and IsValid(solidTrace.Entity) then
            trace = solidTrace
        end
    end

    owner:LagCompensation(false)

    if not trace.Hit or not IsValid(trace.Entity) then
        if isfunction(data.onMiss) then data.onMiss(trace, aimDir) end
        return trace
    end

    local ent = TBOYS.ResolveCharacterTarget(trace.Entity, data.traceOptions) or trace.Entity
    local hitCharacter = TBOYS.IsCharacter(ent)
    local damageAmount = tonumber(data.damage) or 0
    if isfunction(data.scaleDamage) then damageAmount = data.scaleDamage(ent, damageAmount, hitCharacter) end

    if isfunction(data.onPreDamageHit) then data.onPreDamageHit(ent, trace, aimDir, hitCharacter) end

    local damage = DamageInfo()
    damage:SetAttacker(owner)
    damage:SetInflictor(weapon)
    damage:SetDamage(damageAmount)
    damage:SetDamageType(data.damageType or TBOYS.CombineDamageTypes(DMG_CLUB, DMG_CRUSH, DMG_VEHICLE or 0))
    damage:SetDamagePosition(trace.HitPos)
    damage:SetDamageForce(aimDir * (data.force or 0))

    local killPos = ent:WorldSpaceCenter()
    local victimModel = ent:GetModel()
    TBOYS.ApplyCompatDamage(weapon, ent, damage, data.damageOptions or { fallbackTakeDamage = true, fallbackScale = 0.25 })
    TBOYS.PushPhysicsObject(ent, aimDir, data.force or 0)

    if isfunction(data.onHit) then
        data.onHit(ent, trace, aimDir, hitCharacter, killPos, victimModel)
    end

    return trace, ent, hitCharacter
end

function TBOYS.SlideVelocity(vel, normal)
    local intoWall = normal * -1
    return vel - intoWall * vel:Dot(intoWall)
end

function TBOYS.GetFlyingVelocity(ply, weapon, config)
    if not IsValid(ply) or not IsValid(weapon) then return vector_origin end

    config = config or {}
    local forward = (ply:KeyDown(IN_FORWARD) and 1 or 0) - (ply:KeyDown(IN_BACK) and 1 or 0)
    local side = (ply:KeyDown(IN_MOVERIGHT) and 1 or 0) - (ply:KeyDown(IN_MOVELEFT) and 1 or 0)
    local vertical = (ply:KeyDown(IN_JUMP) and 1 or 0) - (ply:KeyDown(IN_DUCK) and 1 or 0)
    local ang = ply:EyeAngles()

    if weapon:GetNW2Bool(config.superNW or "SuperFlying", false) then
        return ang:Forward() * (config.superSpeed or 3500) * (config.speedScale or 0.9)
    end

    local vel = ang:Forward() * forward + ang:Right() * side + vector_up * vertical
    if vel:LengthSqr() <= 0.001 then return vector_origin end

    vel:Normalize()
    vel = vel * (config.flySpeed or 450) * (config.speedScale or 0.9)
    if ply:KeyDown(IN_SPEED) then vel = vel * (config.sprintMultiplier or 1.8) end

    return vel
end

function TBOYS.ResolveFlyingVelocity(ply, vel, collideWithEntities, options)
    if vel:LengthSqr() <= 0.001 then return vel end

    options = options or {}
    local filtered = { ply }
    local current = vel

    for _ = 1, options.iterations or 4 do
        local normal = current:GetNormalized()
        local trace = util.TraceEntity({
            start = ply:GetPos(),
            endpos = ply:GetPos() + current * FrameTime() + normal,
            filter = filtered
        }, ply)

        if not trace.Hit then return current end

        if trace.HitWorld
            or (collideWithEntities and IsValid(trace.Entity) and trace.Entity:GetClass() ~= "prop_ragdoll")
            or (IsValid(trace.Entity) and trace.Entity:GetClass() == "prop_dynamic") then
            current = TBOYS.SlideVelocity(current, trace.HitNormal)
            if current:LengthSqr() < 1 then return vector_origin end
        elseif IsValid(trace.Entity) then
            filtered[#filtered + 1] = trace.Entity
        else
            return vector_origin
        end
    end

    return vector_origin
end

function TBOYS.GetCurrentFlyingSpeed(weapon, owner)
    owner = owner or (IsValid(weapon) and weapon:GetOwner() or NULL)
    if not IsValid(owner) then return 0 end

    local overrideSpeed = weapon.m_OverrideVelocity and weapon.m_OverrideVelocity:Length() or 0
    local desiredSpeed = weapon.m_DesiredFlyingVelocity and weapon.m_DesiredFlyingVelocity:Length() or 0
    return math.max(owner:GetVelocity():Length(), overrideSpeed, desiredSpeed)
end

function TBOYS.DoFlightDamage(weapon, data)
    if not SERVER or not IsValid(weapon) then return false end

    data = data or {}
    local owner = data.owner or weapon:GetOwner()
    if not IsValid(owner) then return false end

    local superFlying = data.superFlying
    if superFlying == nil then superFlying = weapon:GetNW2Bool(data.superNW or "SuperFlying", false) end

    local velocity = data.velocity or weapon.m_DesiredFlyingVelocity or weapon.m_OverrideVelocity or owner:GetVelocity()
    local speed = data.speed or TBOYS.GetCurrentFlyingSpeed(weapon, owner)
    if speed <= (data.minSpeed or 0) then return false end

    local now = CurTime()
    weapon.TheBoysBaseNextFlyingDamageScan = weapon.TheBoysBaseNextFlyingDamageScan or 0
    if weapon.TheBoysBaseNextFlyingDamageScan > now then return false end
    weapon.TheBoysBaseNextFlyingDamageScan = now + (data.scanInterval or 0.05)

    local flightDir = velocity:GetNormalized()
    if flightDir:LengthSqr() <= 0.001 then flightDir = owner:EyeAngles():Forward() end

    local radius = superFlying and ((data.superRadius or 35) * (speed / math.max(data.minSpeed or 1, 1))) or (data.normalRadius or 30)
    local targets = {}
    local seen = {}

    local function addTarget(ent)
        if seen[ent] then return end
        if isfunction(data.isBlockedEntity) and data.isBlockedEntity(ent) then return end
        if not TBOYS.IsFlyingDamageTarget(ent, owner, data) then return end
        if not superFlying and not TBOYS.IsCharacter(ent) then return end

        if not superFlying then
            local nearest = ent.NearestPoint and ent:NearestPoint(owner:WorldSpaceCenter()) or ent:WorldSpaceCenter()
            if nearest:DistToSqr(owner:WorldSpaceCenter()) > (data.normalTouchDistance or 45) ^ 2 then return end
        end

        seen[ent] = true
        targets[#targets + 1] = ent
    end

    local traceStart = owner:WorldSpaceCenter()
    local traceLength = superFlying and math.max(radius + speed * (data.traceSpeedScale or 0.08), data.minTraceLength or 80) or (data.normalTraceLength or 12)
    local trace = util.TraceHull({
        start = traceStart,
        endpos = traceStart + flightDir * traceLength,
        mins = superFlying and (data.superMins or Vector(-20, -20, -20)) or (data.normalMins or Vector(-12, -12, -12)),
        maxs = superFlying and (data.superMaxs or Vector(20, 20, 20)) or (data.normalMaxs or Vector(12, 12, 12)),
        filter = data.filter or { owner, weapon },
        mask = data.mask or MASK_SHOT
    })

    if IsValid(trace.Entity) then addTarget(trace.Entity) end
    for _, ent in ipairs(ents.FindInSphere(owner:WorldSpaceCenter(), radius)) do
        addTarget(ent)
    end

    weapon.TheBoysBaseNextFlyingDamageTime = weapon.TheBoysBaseNextFlyingDamageTime or {}
    local didHit = false

    for _, ent in ipairs(targets) do
        if weapon.TheBoysBaseNextFlyingDamageTime[ent] and now < weapon.TheBoysBaseNextFlyingDamageTime[ent] then continue end
        if isfunction(data.shouldSkipTarget) and data.shouldSkipTarget(ent, superFlying) then continue end

        didHit = true

        local wasCharacter = TBOYS.IsCharacter(ent)
        local killPos = ent:WorldSpaceCenter()
        local victimModel = ent:GetModel()
        local damageAmount = tonumber(data.damage) or 0
        if isfunction(data.scaleDamage) then damageAmount = data.scaleDamage(ent, damageAmount, superFlying) end

        local damage = DamageInfo()
        damage:SetDamage(damageAmount)
        damage:SetDamageForce(velocity * (speed * (data.damageForceScale or 2)))
        damage:SetAttacker(owner)
        damage:SetInflictor(weapon)
        damage:SetDamageType(TBOYS.CombineDamageTypes(DMG_GENERIC, DMG_CRUSH, DMG_CLUB, DMG_VEHICLE or 0, DMG_ALWAYSGIB or 0))
        damage:SetDamagePosition(killPos)
        TBOYS.ApplyCompatDamage(weapon, ent, damage, data.damageOptions or { fallbackTakeDamage = true, fallbackScale = 0.25 })

        if isfunction(data.onTargetDamaged) then
            timer.Simple(0, function()
                if IsValid(weapon) then data.onTargetDamaged(ent, flightDir, killPos, wasCharacter, victimModel, superFlying) end
            end)
        end

        local phys = ent:GetPhysicsObject()
        if superFlying and IsValid(phys) then
            phys:Wake()
            phys:SetVelocity((velocity / 300) * math.min(speed, 1000))
        elseif TBOYS.IsCharacter(ent) then
            ent:SetVelocity(flightDir * math.min(speed * 0.7, 1500) + vector_up * 80)
        end

        weapon.TheBoysBaseNextFlyingDamageTime[ent] = now + (data.targetCooldown or 0.1)
    end

    if didHit and data.screenShake ~= false then
        util.ScreenShake(owner:GetPos(), data.hitShakeAmplitude or 4, data.hitShakeFrequency or 25, data.hitShakeDuration or 0.3, data.hitShakeRadius or 700, true)
    end

    return didHit
end

function TBOYS.CheckFlightImpact(weapon, data)
    data = data or {}

    local owner = data.owner or (IsValid(weapon) and weapon:GetOwner() or NULL)
    if not IsValid(owner) then return false end

    local scale = data.scale or 1
    local mins, maxs = owner:GetRotatedAABB(owner:OBBMins(), owner:OBBMaxs())
    local aimDir = data.dir or owner:GetAimVector()
    local filter = data.filter or { owner, weapon }
    local startPos = data.startPos or owner:GetPos()

    local trace = util.TraceHull({
        start = startPos,
        endpos = startPos + aimDir * ((data.length or 90) * scale),
        filter = filter,
        mins = (data.mins or (mins * 0.8)) * scale,
        maxs = (data.maxs or (maxs * 0.8)) * scale,
        mask = data.mask or MASK_SOLID
    })

    return trace.Hit, trace
end

function TBOYS.DoFlightImpact(weapon, data)
    if not SERVER or not IsValid(weapon) then return end

    data = data or {}
    local owner = data.owner or weapon:GetOwner()
    local trace = data.trace
    if not IsValid(owner) or not trace then return end

    local impactDir = data.dir or owner:GetAimVector()
    if isfunction(data.playSounds) then data.playSounds(owner, trace) end

    if data.screenShake ~= false then
        util.ScreenShake(owner:GetPos(), data.shakeAmplitude or 35000, data.shakeFrequency or 35000, data.shakeDuration or 1.5, data.shakeRadius or 2500, true)
    end

    TBOYS.BreakAndScatterImpactProps(weapon, {
        pos = trace.HitPos,
        dir = impactDir,
        attacker = owner,
        destroyRadius = data.propDestroyRadius,
        scatterRadius = data.propScatterRadius,
        scatterForce = data.propScatterForce,
        damage = data.propDamage,
        onBreakProp = data.onBreakProp,
        isBlockedEntity = data.isBlockedEntity,
        vehicleClassHints = data.vehicleClassHints,
        flyingDamageClasses = data.flyingDamageClasses
    })

    for _, ent in ipairs(ents.FindInSphere(trace.HitPos, data.radius or 0)) do
        if isfunction(data.isBlockedEntity) and data.isBlockedEntity(ent) then continue end
        if TBOYS.IsBreakableProp(ent, data) then continue end
        if not TBOYS.IsFlyingDamageTarget(ent, owner, data) then continue end

        local dir = (ent:WorldSpaceCenter() - owner:WorldSpaceCenter()):GetNormalized()
        if dir:LengthSqr() <= 0.001 then dir = owner:GetAimVector() end

        local force = dir * (data.force or 300000) + vector_up * (data.upForce or 200)
        local wasCharacter = TBOYS.IsCharacter(ent)
        local killPos = ent:WorldSpaceCenter()
        local victimModel = ent:GetModel()
        local damageAmount = tonumber(data.damage) or 0
        if isfunction(data.scaleDamage) then damageAmount = data.scaleDamage(ent, damageAmount, true) end

        local damage = DamageInfo()
        damage:SetDamage(damageAmount)
        damage:SetDamageForce(force)
        damage:SetAttacker(owner)
        damage:SetInflictor(weapon)
        damage:SetDamageType(TBOYS.CombineDamageTypes(DMG_GENERIC, DMG_BLAST, DMG_CRUSH, DMG_VEHICLE or 0, DMG_ALWAYSGIB or 0))
        damage:SetDamagePosition(killPos)
        TBOYS.ApplyCompatDamage(weapon, ent, damage, data.damageOptions or { fallbackTakeDamage = true, fallbackScale = 0.25 })

        if isfunction(data.onTargetDamaged) then
            timer.Simple(0, function()
                if IsValid(weapon) then data.onTargetDamaged(ent, dir, killPos, wasCharacter, victimModel, true) end
            end)
        end

        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:ApplyForceCenter(force)
        elseif TBOYS.IsCharacter(ent) then
            ent:SetVelocity(force:GetNormalized() * (data.characterVelocity or 1200) + vector_up * 200)
        end
    end

    local normal = trace.HitNormal
    if normal:LengthSqr() <= 0.001 or IsValid(trace.Entity) then normal = -impactDir end
    if isfunction(data.sendImpactFX) then data.sendImpactFX("flight_impact", trace.HitPos, normal, true, true) end

    owner:SetLocalVelocity(vector_origin)
    if isfunction(data.onStopSuperFlight) then data.onStopSuperFlight() end
end

function TBOYS.FireLaser(weapon, data)
    if not SERVER or not IsValid(weapon) then return nil end

    data = data or {}
    local owner = data.owner or weapon:GetOwner()
    if not IsValid(owner) then return nil end

    local startPos = data.startPos or owner:EyePos()
    local aimDir = data.dir or owner:EyeAngles():Forward()
    if aimDir:LengthSqr() <= 0.001 then aimDir = owner:EyeAngles():Forward() end
    aimDir:Normalize()

    local range = data.range or 12000
    local mask = data.mask or MASK_SHOT
    local filter = {}
    if istable(data.filter) then
        for _, ent in ipairs(data.filter) do
            filter[#filter + 1] = ent
        end
    elseif IsValid(data.filter) then
        filter[#filter + 1] = data.filter
    else
        filter[#filter + 1] = owner
    end

    local function addFilterEntity(ent)
        if not IsValid(ent) then return end
        for _, existing in ipairs(filter) do
            if existing == ent then return end
        end
        filter[#filter + 1] = ent
    end

    local function canPenetrateEntity(ent, trace, hitTarget, hitCharacter)
        if not IsValid(ent) or ent:IsWorld() or hitCharacter then return false end

        local custom = callOption(data, "shouldPenetrateEntity", ent, trace, hitTarget)
        if custom ~= nil then return custom == true end

        return true
    end

    local function findWorldExit(trace)
        local maxDepth = tonumber(data.worldPenetrationDepth) or 0
        if maxDepth <= 0 then return nil end

        local step = tonumber(data.worldPenetrationStep) or 6
        step = math.Clamp(step, 2, math.max(maxDepth, 2))

        for depth = step, maxDepth, step do
            local probeStart = trace.HitPos + aimDir * depth
            local probe = util.TraceLine({
                start = probeStart,
                endpos = trace.HitPos + aimDir,
                filter = filter,
                mask = mask
            })

            if not probe.StartSolid and not probe.AllSolid then
                if not probe.Hit then
                    return probeStart, depth, probe
                end

                if probe.HitWorld or (IsValid(probe.Entity) and probe.Entity:IsWorld()) then
                    return probe.HitPos, depth, probe
                end
            end
        end

        return nil
    end

    local function damageLaserHit(trace)
        if not trace.Hit or not IsValid(trace.Entity) then return nil, false end

        local hitTarget = TBOYS.ResolveCharacterTarget(trace.Entity, data.traceOptions) or trace.Entity
        local hitCharacter = TBOYS.IsCharacter(hitTarget)
        local killPos = trace.HitPos
        local victimModel = hitTarget:GetModel()
        local hitInfo

        if hitCharacter and isfunction(data.buildHitInfo) then
            hitInfo = data.buildHitInfo(hitTarget, trace, aimDir)
        end

        local damageAmount = tonumber(data.damage) or 0
        if isfunction(data.scaleDamage) then damageAmount = data.scaleDamage(hitTarget, damageAmount) end

        local damage = DamageInfo()
        damage:SetAttacker(owner)
        damage:SetInflictor(weapon)
        damage:SetDamage(damageAmount)
        damage:SetDamageType(data.damageType or (DMG_ENERGYBEAM + DMG_BURN))
        damage:SetDamagePosition(trace.HitPos)
        damage:SetDamageForce(data.damageForce or vector_origin)
        TBOYS.ApplyCompatDamage(weapon, hitTarget, damage, data.damageOptions or { fallbackTakeDamage = true, fallbackScale = 0.25 })

        if hitCharacter and isfunction(data.afterCharacterDamage) then
            local hitEnt = hitTarget
            local wasDead = hitEnt:IsPlayer() and not hitEnt:Alive()
                or (not hitEnt:IsPlayer() and hitEnt.Health and hitEnt:Health() <= 0)
            timer.Simple(0, function()
                if IsValid(weapon) then
                    data.afterCharacterDamage(hitEnt, trace, hitInfo, killPos, aimDir, victimModel, wasDead)
                end
            end)
        end

        return hitTarget, hitCharacter
    end

    local maxEntityPenetrations = data.penetrate and (tonumber(data.maxEntityPenetrations) or 12) or 0
    local maxWorldPenetrations = data.penetrate and (tonumber(data.maxWorldPenetrations) or 0) or 0
    local entityPenetrations = 0
    local worldPenetrations = 0
    local remainingRange = range
    local traceStart = startPos
    local lastTrace

    for pass = 1, (data.penetrate and (tonumber(data.maxTracePasses) or 32) or 1) do
        owner:LagCompensation(true)
        local trace = TBOYS.TraceCharacterLine({
            start = traceStart,
            endpos = traceStart + aimDir * remainingRange,
            filter = filter,
            mask = mask
        }, data.traceOptions)
        owner:LagCompensation(false)

        lastTrace = trace
        if isfunction(data.onTrace) then data.onTrace(trace, aimDir, pass) end

        if trace.Hit and not trace.HitSky and isfunction(data.onWorldHit) then
            data.onWorldHit(trace, aimDir, pass)
        end

        local hitTarget, hitCharacter = damageLaserHit(trace)
        if not data.penetrate or not trace.Hit or trace.HitSky then break end
        if hitCharacter then break end

        local traveled = traceStart:Distance(trace.HitPos)
        remainingRange = remainingRange - traveled
        if remainingRange <= 1 then break end

        if IsValid(trace.Entity) and not trace.Entity:IsWorld() then
            if entityPenetrations >= maxEntityPenetrations or not canPenetrateEntity(trace.Entity, trace, hitTarget, hitCharacter) then break end

            entityPenetrations = entityPenetrations + 1
            addFilterEntity(trace.Entity)
            if IsValid(hitTarget) then addFilterEntity(hitTarget) end
            traceStart = trace.HitPos + aimDir * 3
            remainingRange = remainingRange - 3
        elseif trace.HitWorld or (IsValid(trace.Entity) and trace.Entity:IsWorld()) then
            if worldPenetrations >= maxWorldPenetrations then break end

            local exitPos, depth, exitTrace = findWorldExit(trace)
            if not exitPos then break end

            worldPenetrations = worldPenetrations + 1
            if isfunction(data.onWorldExit) then
                data.onWorldExit(exitTrace or trace, aimDir, pass, exitPos, depth)
            end

            traceStart = exitPos + aimDir * 3
            remainingRange = remainingRange - (depth or 0) - 3
        else
            break
        end

        if remainingRange <= 1 then break end
    end

    return lastTrace
end


-- Shared gore assets and sounds.
TBOYS.GoreRandomChunks = TBOYS.GoreRandomChunks or {
    "models/gore/Debris_GoreDebris01.mdl",
    "models/gore/Debris_GoreDebris02.mdl",
    "models/gore/Debris_GoreDebris03.mdl",
    "models/gore/Debris_GoreDebris04.mdl"
}

TBOYS.GoreGibs = TBOYS.GoreGibs or {
    head = {
        mandatory = {
            "models/gore/GoreHead.mdl",
            "models/gore/Head_Eye01.mdl",
            "models/gore/Head_Eye02.mdl",
            "models/gore/Head_JawLo.mdl"
        },
        random = {
            "models/gore/Head_HeadBitBackLeft.mdl",
            "models/gore/Head_HeadBitBackRight.mdl",
            "models/gore/Head_HeadBitFrontLeft.mdl",
            "models/gore/Head_HeadBitFrontRight.mdl",
            "models/gore/Head_HeadBitTopLeft.mdl",
            "models/gore/Head_HeadBitTopRight.mdl"
        },
        randomCount = { 2, 4 }
    },
    left_arm = {
        mandatory = {
            "models/gore/LArm_ArmGoreUpperL.mdl",
            "models/gore/LArm_ArmGoreLowerL.mdl",
            "models/gore/LArm_ArmGoreHandL.mdl"
        },
        randomCount = { 2, 4 }
    },
    right_arm = {
        mandatory = {
            "models/gore/RArm_ArmGoreUpperR.mdl",
            "models/gore/RArm_ArmGoreLowerR.mdl",
            "models/gore/RArm_ArmGoreHandR.mdl"
        },
        randomCount = { 2, 4 }
    },
    left_leg = {
        mandatory = {
            "models/gore/LLeg_MeatBit001L.mdl",
            "models/gore/LLeg_LegPartMidL.mdl",
            "models/gore/LLeg_LegPartFootL001.mdl"
        },
        random = {
            "models/gore/LLeg_MeatBit002L.mdl",
            "models/gore/LLeg_MeatBit003L.mdl",
            "models/gore/LLeg_MeatBit004L.mdl",
            "models/gore/LLeg_LegPartFootL002.mdl"
        },
        randomCount = { 2, 5 }
    },
    right_leg = {
        mandatory = {
            "models/gore/RLeg_MeatBit001R.mdl",
            "models/gore/RLeg_LegPartMidR.mdl",
            "models/gore/RLeg_LegPartFootR001.mdl"
        },
        random = {
            "models/gore/RLeg_MeatBit002R.mdl",
            "models/gore/RLeg_MeatBit003R.mdl",
            "models/gore/RLeg_MeatBit004R.mdl",
            "models/gore/RLeg_LegPartFootR002.mdl"
        },
        randomCount = { 2, 5 }
    },
    upper = {
        mandatory = {
            "models/gore/UpperTorso.mdl",
            "models/gore/UpperTorso_LeftLung.mdl",
            "models/gore/UpperTorso_RightLung.mdl",
            "models/gore/UpperTorso_Stomach.mdl"
        },
        random = {
            "models/gore/UpperTorso_BonesLowerLeft.mdl",
            "models/gore/UpperTorso_Intestine.mdl",
            "models/gore/UpperTorso_LeftKidney.mdl",
            "models/gore/UpperTorso_Liver.mdl",
            "models/gore/UpperTorso_LowerRightRibs.mdl",
            "models/gore/UpperTorso_RightKidney.mdl",
            "models/gore/UpperTorso_UpperRightBones.mdl"
        },
        randomCount = { 3, 6 }
    },
    lower = {
        mandatory = {
            "models/gore/Pelvis.mdl",
            "models/gore/LLeg_MeatBit001L.mdl",
            "models/gore/RLeg_MeatBit001R.mdl"
        },
        random = {
            "models/gore/LLeg_MeatBit002L.mdl",
            "models/gore/LLeg_MeatBit003L.mdl",
            "models/gore/LLeg_LegPartMidL.mdl",
            "models/gore/RLeg_MeatBit002R.mdl",
            "models/gore/RLeg_MeatBit003R.mdl",
            "models/gore/RLeg_LegPartMidR.mdl"
        },
        randomCount = { 4, 7 }
    }
}

TBOYS.GoreFullBodyParts = TBOYS.GoreFullBodyParts or {
    "head",
    "left_arm",
    "right_arm",
    "left_leg",
    "right_leg",
    "upper",
    "lower"
}

sound.Add({
    name = "TheBoysBaseGoreOnRootBoneGib",
    sound = {
        "physics/body/body_medium_break2.wav",
        "physics/body/body_medium_break3.wav"
    },
    level = 90,
    volume = 1,
    pitch = { 88, 92 },
    channel = CHAN_STATIC
})

sound.Add({
    name = "TheBoysBaseGoreOnGib",
    sound = {
        "physics/flesh/flesh_squishy_impact_hard3.wav",
        "physics/flesh/flesh_squishy_impact_hard4.wav",
        "physics/body/body_medium_break4.wav"
    },
    level = 80,
    volume = 0.8,
    pitch = { 95, 105 },
    channel = CHAN_STATIC
})

sound.Add({
    name = "TheBoysBaseGoreGibCollision",
    sound = {
        "physics/flesh/flesh_squishy_impact_hard1.wav",
        "physics/flesh/flesh_squishy_impact_hard2.wav",
        "physics/flesh/flesh_squishy_impact_hard3.wav",
        "physics/flesh/flesh_squishy_impact_hard4.wav"
    },
    level = 70,
    volume = 0.6,
    pitch = { 110, 120 },
    channel = CHAN_BODY
})


local function addGoreModel(list, model, scale, allowDuplicate)
    if not model or model == "" then return false end

    local key = model:lower()
    local duplicate = list._seenModels and list._seenModels[key]
    if duplicate and not allowDuplicate then return false end

    list._seenModels = list._seenModels or {}
    list._seenModels[key] = true
    list[#list + 1] = {
        model = model,
        scale = scale or 1
    }

    return true
end

local function addRandomGoreModels(list, source, count, allowDuplicate, scaleMin, scaleMax)
    if not source or #source == 0 or count <= 0 then return end

    local attempts = 0
    local added = 0
    local maxAttempts = math.max(count * 8, #source * 2)

    while added < count and attempts < maxAttempts do
        attempts = attempts + 1
        local scale = scaleMin and math.Rand(scaleMin, scaleMax or scaleMin) or 1
        if addGoreModel(list, source[math.random(#source)], scale, allowDuplicate) then
            added = added + 1
        end
    end
end

local function randomScaledCount(minCount, maxCount, scale)
    local minValue = math.floor((minCount or 0) * scale)
    local maxValue = math.floor((maxCount or minCount or 0) * scale)
    if maxValue <= 0 then return 0 end

    minValue = math.Clamp(minValue, 0, maxValue)
    return math.random(minValue, maxValue)
end

function TBOYS.BuildGoreModelsForMode(kind, mode, gibAmount)
    gibAmount = tonumber(gibAmount) or 1

    local models = {}
    if gibAmount <= 0 then return models end

    if kind == "full" then
        local bodyParts = table.Copy(TBOYS.GoreFullBodyParts or {})
        local bigPartCount = math.Clamp(math.Round(#bodyParts * math.Rand(0.6, 0.8) * math.min(gibAmount, 2)), 1, #bodyParts)

        for _ = 1, bigPartCount do
            if #bodyParts <= 0 then break end

            local index = math.random(#bodyParts)
            local part = table.remove(bodyParts, index)
            local data = TBOYS.GoreGibs and TBOYS.GoreGibs[part]
            if data and data.mandatory and #data.mandatory > 0 then
                addGoreModel(models, data.mandatory[math.random(#data.mandatory)])
            end
        end

        addRandomGoreModels(models, TBOYS.GoreRandomChunks, randomScaledCount(28, 48, gibAmount), true, 2, 3)
        addRandomGoreModels(models, TBOYS.GoreGibs.upper.random, randomScaledCount(6, 14, gibAmount))
        addRandomGoreModels(models, TBOYS.GoreGibs.left_leg.random, randomScaledCount(4, 10, gibAmount))
        addRandomGoreModels(models, TBOYS.GoreGibs.right_leg.random, randomScaledCount(4, 10, gibAmount))

        models._seenModels = nil
        return models
    end

    local data = TBOYS.GoreGibs and TBOYS.GoreGibs[mode or ""]
    if not data then
        addRandomGoreModels(models, TBOYS.GoreRandomChunks, randomScaledCount(8, 16, gibAmount), true, 2, 3)
        models._seenModels = nil
        return models
    end

    for _, model in ipairs(data.mandatory or {}) do
        addGoreModel(models, model)
    end

    local randomCount = data.randomCount or { 1, 3 }
    addRandomGoreModels(models, data.random or TBOYS.GoreRandomChunks, randomScaledCount((randomCount[1] or 0) * 2, (randomCount[2] or randomCount[1] or 0) * 2, gibAmount))
    addRandomGoreModels(models, TBOYS.GoreRandomChunks, randomScaledCount(4, 10, gibAmount), true, 2, 3)

    models._seenModels = nil
    return models
end


TBOYS.DismemberBones = TBOYS.DismemberBones or {
    head = { "ValveBiped.Bip01_Head1" },
    left_arm = { "ValveBiped.Bip01_L_UpperArm" },
    right_arm = { "ValveBiped.Bip01_R_UpperArm" },
    left_leg = { "ValveBiped.Bip01_L_Thigh" },
    right_leg = { "ValveBiped.Bip01_R_Thigh" },
    upper = { "ValveBiped.Bip01_Spine2" },
    lower = { "ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_R_Thigh" }
}

function TBOYS.ApplyGoreDismember(ragdoll, mode, options)
    if not TBOYS.IsDismemberEnabled() then return false end
    if not SERVER or not IsValid(ragdoll) or not mode or mode == "" then return false end
    options = options or {}
    local bones = options.dismemberBones or TBOYS.DismemberBones
    if not bones[mode] then return false end

    ragdoll.TheBoysBaseGoreBloodColor = options.bloodColor or BLOOD_COLOR_RED
    ragdoll.TheBoysBaseGoreDismemberMode = mode
    if ragdoll.SetNW2String then
        ragdoll:SetNW2String(options.nwModeName or "TheBoysBaseDismemberMode", mode)
    end

    return true
end

function TBOYS.PrecacheGoreAssets()
    if not SERVER then return end

    for _, modelPath in ipairs(TBOYS.GoreRandomChunks or {}) do
        util.PrecacheModel(modelPath)
    end
    for _, data in pairs(TBOYS.GoreGibs or {}) do
        for _, modelPath in ipairs(data.mandatory or {}) do util.PrecacheModel(modelPath) end
        for _, modelPath in ipairs(data.random or {}) do util.PrecacheModel(modelPath) end
    end
end

if SERVER then
    AddCSLuaFile("effects/theboys_gib_burst/init.lua")
    TBOYS.AddBaseResources()
    AddCSLuaFile()
end
