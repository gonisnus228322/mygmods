if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Nosey"
ENT.Category = "TikTok: Citra"
ENT.Models = {"models/gentoi/walterfiles/noseyHT.mdl"}
ENT.CollisionBounds = Vector(10, 10, 72)
ENT.CrouchCollisionBounds = Vector(10, 10, 36)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.ModelScale = 1
ENT.CanOpenDoors = true
ENT.CanDestroyDoors = true
ENT.CanCrouch = true
ENT.CanJumpOnChase = false
ENT.Monster_DefaultRelationship = D_HT
ENT.Monster_PlayersRelationship = D_HT
ENT.Monster_CanRun = true --Can run
ENT.Monster_EnemyHealthToRun = 1000 --Run if enemy health
ENT.Monster_HealthToRun = 0.35 --Run if monster health percentage
ENT.Monster_CanWhileIsCrouching = false --Can run on crouching
ENT.Monster_MinEnemySizeToRun = 1000 --Min enemy size for run
ENT.Monster_CanRunIfEnemyIsFar = true
ENT.Monster_DistanceFromEnemyToRun = 1 --If the enemy is to far
ENT.RagdollOnDeath = true

ENT.MonsterAnimEvents = {}

-- Evolutions --

ENT.Monster_Evolutions = {}
ENT.MainEvolution = false
ENT.MainEvolutionTimer = false

-- Stats --
ENT.SpawnHealth = 2000
ENT.CanBeInmuneToDmg = true
ENT.InmuneToDmgType = {DMG_DISSOLVE, DMG_RADIATION, DMG_DROWN, DMG_BULLET}
ENT.DefaultAttackAnimRate = 1

ENT.MonsterStates = {}

ENT.CurrentMonsterState = nil
ENT.Monster_EnemyIsFar = false

-- Footsteps --
ENT.Monster_CanUseFootsteps = false 
ENT.Monster_Footsteps = {}

-- AI --
ENT.SpotDuration = 20
ENT.RangeAttackRange = 3500
ENT.LeapRange = 500
ENT.MaxJumpRange = 0
ENT.MeleeAttackRange = 90
ENT.ReachEnemyRange = 0
ENT.AvoidEnemyRange = 0
ENT.PatrolDistance = 15000

-- Skills --
ENT.CanTeleport = false
ENT.CanTeleportWhileIsFlying = false
ENT.CanTeleportByTimer = false

ENT.Teleport_Timer = 4
ENT.Teleport_MinChance = 1
ENT.Teleport_Chance = 25
ENT.Teleport_MaxChance = 100

ENT.Teleport_MinDistanceToNoTeleport = 1000
ENT.Teleport_Distance = 2000
ENT.Teleport_Sounds = {}
ENT.Teleport_OutSounds = {}
ENT.Teleport_Effects = {}
ENT.Teleport_OutEffects = {}
ENT.Teleport_EffectsLifeTime = 0.2
ENT.Teleport_Damage = {
					can_dmg = false,
					dmg = 300,
					dmg_radius = 300,
					dmg_type = DMG_DISSOLVE,
			}

ENT.HasToxicAmbience = false
ENT.ToxicAmbience_AffectProps = false
ENT.ToxicAmbience_Damage = 5
ENT.ToxicAmbience_Radius = 1000
ENT.ToxicAmbience_Timer = 0.2
ENT.ToxicAmbience_DamageType = DMG_RADIATION

ENT.CanUseTelekinesis = false
ENT.Telekinesis_AllowMultipleEnemies = false
ENT.Telekinesis_Radius = 100
ENT.Telekinesis_Power = 100

ENT.CanMakeExplosions = false
ENT.Explosions = nil

ENT.CanHealItSelf = false
ENT.HealData = nil

-- Flying Movement --
ENT.CanFly = false
ENT.CanFlyOnChase = false
ENT.FlySpeed = 550
ENT.Fly_CanStrafe = false
ENT.Fly_ChangeStrafeDirectionTimer = 2.8
ENT.Fly_ChangeStrafeToChargeTimer = 5
ENT.Fly_StrafeDistance = 20
ENT.MinGroundDistanceToFly = 250
ENT.FlyTimerOnChase = 5

-- Contact --
ENT.Contact_CanDestroyProps = true
ENT.Contact_DamageOnContact = false
ENT.Contact_Damage = 800
ENT.Contact_IgnoredEntities = {}
ENT.IsToxic = false

-- Helpers --
ENT.CanExitFromStuck = true
ENT.StuckEnemyDistanceTolerance = 250
ENT.LastStuck = 0
ENT.StuckTries = 0
ENT.LastJumpScan = 0
ENT.Fly_WantCharge = false
ENT.CurrentExplosion = {}
ENT.Monster_NoAnim_RangeAttacks = {}
ENT.CurrentRangeAttack = {}
ENT.IsWatchingMe = false
ENT.enemyang_diff = 0
ENT.enemyfov = 0

-- Attacks --
ENT.Monster_HasMeleeAttacks = false
ENT.Monster_MeleeAttacks = nil

ENT.Monster_HasRangeAttacks = true
ENT.Monster_RangeAttacks = nil

-- Sounds --
ENT.RoarSound = {}

-- Executions --
ENT.CanUseInfectionSystem = false
ENT.Infection_NpcClass = "npc_drg_monsterbase"
ENT.Infection_CopyModel = false
ENT.MinHealthPercentForGrab = 35
ENT.MinHealthForGrab = 30

ENT.Monster_CanUseExecution = false
ENT.Executions = nil

-- Grab And Throw --
ENT.Monster_CanGrabAndThrow = false
ENT.ThrowMechanics = nil
ENT.CurrentThrowMechanic = nil

-- Relationships --
ENT.Factions = {"FACTION_CITRACREATIONS"}
ENT.Frightening = true

-- Animations --
ENT.IdleAnimation = "idle"
ENT.WalkAnimation = "walk"
ENT.RunAnimation = "run"
ENT.JumpAnimation = ACT_HL2MP_JUMP_SLAM
ENT.LeaveGroundAnimation = nil
ENT.LandGroundAnimation = nil

ENT.Crouch_IdleAnimation = "Crouch"
ENT.Crouch_WalkAnimation = "CrawlMovement"
ENT.Crouch_RunAnimation = "CrawlMovement"

ENT.FlyAnimation = ACT_HL2MP_SWIM

ENT.Beam_IdleAnimation = ACT_HL2MP_IDLE_MAGIC
ENT.Beam_WalkAnimation = ACT_HL2MP_WALK_MAGIC
ENT.Beam_RunAnimation = ACT_HL2MP_RUN_MAGIC
ENT.Beam_JumpAnim = ACT_HL2MP_JUMP_MAGIC

ENT.Default_IdleAnimation = "idle"
ENT.Default_WalkAnimation = "walk"
ENT.Default_RunAnimation = "run"

ENT.DefaultJumpAnim = ACT_HL2MP_JUMP_KNIFE

-- Movements --
ENT.UseWalkframes = false
ENT.WalkSpeed = 41
ENT.RunSpeed = 420
ENT.Acceleration = 1000
ENT.Deceleration = 1000

ENT.Crouch_WalkSpeed = 20
ENT.Crouch_RunSpeed = 20
ENT.Crouch_Acceleration = 1000
ENT.Crouch_Deceleration = 1000
ENT.Crouch_JumpMultiplier = 0.3

ENT.Default_WalkSpeed = 41
ENT.Default_RunSpeed = 420
ENT.Default_Acceleration = 1000
ENT.Default_Deceleration = 1000

-- Climbing --
ENT.ClimbLedges = true
ENT.ClimbLedgesMaxHeight = 1000
ENT.ClimbLedgesMinHeight = 0
ENT.LedgeDetectionDistance = 20
ENT.ClimbProps = true
ENT.ClimbLadders = true
ENT.ClimbLaddersUp = true
ENT.LaddersUpDistance = 20
ENT.ClimbLaddersUpMaxHeight = 1000
ENT.ClimbLaddersUpMinHeight = 0
ENT.ClimbLaddersDown = true
ENT.LaddersDownDistance = 20
ENT.ClimbLaddersDownMaxHeight = 1000
ENT.ClimbLaddersDownMinHeight = 0
ENT.ClimbSpeed = 40
ENT.ClimbUpAnimation = "Climb"
ENT.ClimbDownAnimation = "Climb"
ENT.ClimbAnimRate = 2
ENT.ClimbOffset = Vector(0, 0, 0)

-- Detection --
ENT.EyeBone = "Head"
ENT.EyeOffset = Vector(0, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 150
ENT.SightRange = 5000
ENT.Omniscient = false

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
  {
    offset = Vector(0, 30, 0),
    distance = 175,
    eyepos = true
  },
  {
    offset = Vector(7.5, 0, 0),
    distance = 0,
    eyepos = true
  }
}
ENT.PossessionBinds = {
	[IN_ATTACK] = {{
		coroutine = true,
		onkeydown = function(self)
			local ent = self:GetClosestEnemy()
			if not IsValid(ent) then return end
			if self:GetPos():Distance(ent:GetPos()) < 90 then
				self:OnMeleeAttack(ent)
			end
		end
	}},
	[IN_DUCK] = {{
		coroutine = false,
		onkeypressed = function(self)
			if self:IsCrouching() then
				self:UnCrouch()
			else
				self:ToCrouch()
			end
		end
	}},
	[IN_RELOAD] = {{
		coroutine = true,
		onkeypressed = function(self)
			if self:GetNWInt("lasttimeusedNOSEYSCANCooldown") > CurTime() then return end
			if self:GetNWInt("lasttimeusedNOSEYSCAN") > CurTime() then return end
			if self.IsJumpscaring then return end

			local dur = self:SequenceDuration(self:LookupSequence("echolocation"))
			self:PlaySequenceAndWait("echolocation")
		end
	}},
	[IN_USE] = {{
		coroutine = false,
		onkeypressed = function(self)
			-- Toggle point light
			if IsValid(self._NoseyLight) then
				self._NoseyLight:Remove()
				self._NoseyLight = nil
				self:EmitSound("buttons/button10.wav", 70, 100)
				return
			end

			local light = ents.Create("light_dynamic")
			if not IsValid(light) then return end

			light:SetPos(self:GetPos())
			light:FollowBone(self,2)
            light:SetKeyValue("distance", "500")
            light:SetKeyValue("brightness", "1.5")
            light:SetKeyValue("_light", "255 255 255 255") -- white
            light:Spawn()
            light:Activate()
            light:Fire("TurnOn", "", 0)

			self._NoseyLight = light
			self:EmitSound("buttons/button3.wav", 70, 100)
		end
	}}
}

if SERVER then

	-- Shared/Server
util.AddNetworkString("NoseyLightToggle")

net.Receive("NoseyLightToggle", function(len, ply)
    local npc = net.ReadEntity()
    local on = net.ReadBool()
    if IsValid(npc) and npc:IsNextBot() then
        npc._islighton = on
		npc:SetNWBool("ShouldUseLight", npc._islighton)
		--print("npc lightlvl: " .. tostring(npc._islighton))
    end
end)


function ENT:GetGrabbedPlayer()
	return self:GetNW2Entity("GrabbedPlayer")
end

function ENT:SetGrabbedPlayer(value)
	return self:SetNW2Entity("GrabbedPlayer", value)
end

function ENT:GetGrabbedEnemy()
	return self:GetNW2Entity("GrabbedEnemy")
end

function ENT:SetGrabbedEnemy(value)
	return self:SetNW2Entity("GrabbedEnemy", value)
end

AddCSLuaFile()
util.AddNetworkString('bon_jumpscare_lsd')
util.AddNetworkString('nosey_scanmap')

util.AddNetworkString"monsterbaselaser"
local function Laser(from, to, mat, col, thickness, lifetime)
	if not isnumber(lifetime) then lifetime = 0.2 end
	if not isnumber(thickness) then thickness = 100 end
	if not isvector(from) then return end
	if not isvector(to) then return end
	if not IsColor(col) then return end
	if not isstring(mat) then return end
	net.Start"monsterbaselaser"
		net.WriteFloat(lifetime)
		net.WriteFloat(thickness)
		net.WriteVector(from)
		net.WriteVector(to)
		net.WriteString(mat)
		net.WriteColor(col)
	net.Broadcast()
end

function ENT:LaserTest()
	Laser(self:GetPos(), self:GetPos()+self:GetForward()*500, "effects/laser1", Color(255, 0, 0))
end

function ENT:MonsterLaser(mfrom, mto, mmat, mcol, mthickness, mlifetime)
	Laser(mfrom, mto, mmat, mcol, mthickness, mlifetime)
end

function ENT:FindEntsByClasses(ents_t)
	if not istable(ents_t) then return end
	local t_ents = {}
	for k, class_g in pairs(ents_t) do
		if isstring(class_g) then
			if istable(ents.FindByClass(class_g)) then
				table.Add(t_ents, ents.FindByClass(class_g))
			end
		end
	end
end

-- Init/Think --

function ENT:Monster_Init()
end

function ENT:Monster_Think()
	if not self:IsExecuting() then
		if self:IsPossessed() then
			self:DirectPoseParametersAt(self:PossessorTrace().HitPos, "aim_pitch", "aim_yaw", self:EyePos())
		elseif self:HasEnemy() and GetConVarNumber("ai_disabled") == 0 then
			self:DirectPoseParametersAt(self:GetEnemy():GetPos(), "aim_pitch", "aim_yaw", self:EyePos())
		else
			self:DirectPoseParametersAt(nil, "aim_pitch", "aim_yaw", self:EyePos())
		end
	else
		self:DirectPoseParametersAt(nil, "aim_pitch", "aim_yaw", self:EyePos())
	end
end

function ENT:GetMonsterState()
	if not isstring(self.CurrentMonsterState) then return "NONE" end
	return self.CurrentMonsterState
end

function ENT:SetMonsterState(state)
	if not isstring(state) then return end
	if istable(self.MonsterStates) and not table.IsEmpty(self.MonsterStates) then
		local s_state = self.MonsterStates[state]
		if isfunction(s_state) then
			s_state(self)
			self.CurrentMonsterState = state
		end
	end
end

function ENT:Monster_Jump(lenght)
	if self:OnGround() then
		if self:IsCrouching() then
			self.loco:SetJumpHeight(lenght*self:GetScale()*self.Crouch_JumpMultiplier)
			self.loco:Jump()
			self.loco:SetJumpHeight(lenght*self:GetScale()*self.Crouch_JumpMultiplier)
		else
			self.loco:SetJumpHeight(lenght*self:GetScale())
			self.loco:Jump()
			self.loco:SetJumpHeight(lenght*self:GetScale())
		end
	end
end

function ENT:OnLandOnGround()
	if self.LandGroundAnimation != nil then
		self:CallInCoroutine(function(self, delay)
			if delay > 0.1 then return end
			self:PlaySequenceAndMove(self.LandGroundAnimation)
		end)
	end
end

function ENT:OnLeaveGround()
	if self.LeaveGroundAnimation != nil then
		self:CallInCoroutine(function(self, delay)
			if delay > 0.1 then return end
			self:PlaySequenceAndMove(self.LeaveGroundAnimation)
		end)
	end
end

function ENT:CustomExecution(ent)
    if not IsValid(self) or not IsValid(ent) then return end

    -- Freeze NPC and player
    self:SetVelocity(Vector(0,0,0))
    self:SetPos(self:GetPos())
    self:SetAngles(self:GetAngles())

    if ent:IsPlayer() then
        self:FreezePlayer(ent)
	elseif ent:IsNPC() or ent:IsNextBot() then
		ent:NextThink(CurTime() + 1e9)
    end

    self:EmitSound('nosey/NoseyExecution.wav')
    self.Executing = true
    self.ExecutionEnemy = ent
    self.PosForward = 0
    self.PosHeight = -35

    ent:AddFlags(FL_NOTARGET)

	local function Lambda_CreateRagdoll(ent, dmg)
		if not util.IsValidRagdoll(ent:GetModel()) then return NULL end
		local ragdoll = ents.Create("prop_ragdoll")
		if IsValid(ragdoll) then
			if not dmg then dmg = DamageInfo() end
			ragdoll:SetPos(ent:GetPos())
			ragdoll:SetAngles(ent:GetAngles())
			ragdoll:SetModel(ent:GetModel())
			ragdoll:SetSkin(ent:GetSkin())
			ragdoll:SetColor(ent:GetColor())
			ragdoll:SetModelScale(ent:GetModelScale())
			ragdoll:SetBloodColor(ent:GetBloodColor())
			for i = 1, #ent:GetBodyGroups() do
				ragdoll:SetBodygroup(i-1, ent:GetBodygroup(i-1))
			end
			ragdoll:Spawn()
			for i = 0, (ragdoll:GetPhysicsObjectCount()-1) do
				local bone = ragdoll:GetPhysicsObjectNum(i)
				if not IsValid(bone) then continue end
				local pos, angles = ent:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
				bone:SetPos(pos)
				bone:SetAngles(angles)
			end
			local phys = ragdoll:GetPhysicsObject()
			phys:SetVelocity(ent:GetVelocity())
			local force = dmg:GetDamageForce()
			local position = dmg:GetDamagePosition()
			if IsValid(phys) and isvector(force) and isvector(position) then
				phys:ApplyForceOffset(force, position)
			end
			if dmg:IsDamageType(DMG_DISSOLVE) then ragdoll:DrG_Dissolve()
			elseif ent:IsOnFire() then ragdoll:Ignite(10) end
			local attacker = dmg:GetAttacker()
			if IsValid(attacker) and attacker.IsDrGNextbot then
				attacker:SpotEntity(ragdoll)
			end
			ragdoll.EntityClass = ent:GetClass()
			return ragdoll
		else return NULL end
	end

    -- Create ragdoll or lambda death
    local function Lambda_RagdollDeath(ent, dmg)
        if ent:IsPlayer() then
            if not ent:Alive() then return NULL end
            ent:KillSilent()
        elseif not ent.IsLambdaPlayer then
            ent:AddFlags(FL_TRANSRAGDOLL)
            ent:SetNoDraw(true )
			ent:DrawShadow(false)
        end

        if ent.IsLambdaPlayer and dmg then
            ent:PlaySoundFile(ent:GetVoiceLine("death"))
            ent:LambdaOnKilled(dmg, true)
        end

        local ragdoll = Lambda_CreateRagdoll(ent, dmg)
        return ragdoll
    end

    local dmg = DamageInfo()
    dmg:SetAttacker(self)
    local ragdoll = Lambda_RagdollDeath(ent, dmg)

    local entragdoll = self:GrabRagdoll(ragdoll, "head", "camera")
    if ent:IsPlayer() then
        self:SetGrabbedPlayer(ent)
        self:FreezePlayer(ent)
    end
    self:SetGrabbedEnemy(ent)

    -- Blood impact timers
    local function DoBloodEffect()
        if not IsValid(entragdoll) or not IsValid(self) then return end
        local cam = self:GetAttachment(self:LookupAttachment("camera"))
        local effectdata = EffectData()
        effectdata:SetOrigin(cam.Pos)
        effectdata:SetNormal(self:GetAngles():Forward())
        effectdata:SetMagnitude(3)
        effectdata:SetScale(25)
        effectdata:SetColor(0)
        effectdata:SetFlags(3)
        util.Effect("BloodImpact", effectdata)
        if ent:IsPlayer() then
            ent:ScreenFade(SCREENFADE.IN, Color(255,0,0,150), 0.5, 0)
        end
    end

    timer.Simple(1.35, DoBloodEffect)
    timer.Simple(1.95, DoBloodEffect)
    timer.Simple(4, function()
        if not IsValid(entragdoll) or not IsValid(self) then return end
        local cam = self:GetAttachment(self:LookupAttachment("camera"))
        local effectdata = EffectData()
        effectdata:SetOrigin(cam.Pos)
        effectdata:SetNormal(self:GetAngles():Forward())
        effectdata:SetMagnitude(3)
        effectdata:SetScale(25)
        effectdata:SetColor(0)
        effectdata:SetFlags(3)
        util.Effect("BloodImpact", effectdata)
        if ent:IsPlayer() then
            ent:ScreenFade(SCREENFADE.IN, Color(255,0,0,150), 1, 0.5)
        end
    end)

    -- Remove ragdoll after execution
    timer.Simple(5.5, function()
        if IsValid(entragdoll) and IsValid(self) then
            self:DropAllRagdolls()
            entragdoll:Fire("fadeandremove", 1, 10)
        end
    end)

    self:SetNWInt('lasttimeusedNOSEYSCANCooldown',CurTime()+12)

    -- Play kill animation
    self:PlaySequenceAndWait("kill")

	if IsValid(ragdoll) then
		ent:SetPos(ragdoll:GetPos())
	else
		ent:SetPos(self:GetAttachment(self:LookupAttachment("camera")).Pos)
	end
	ent:SetNoDraw(false )
	ent:DrawShadow(true )
	ent:RemoveFlags(FL_NOTARGET)
	ent:RemoveFlags(FL_TRANSRAGDOLL)
	if IsValid(ragdoll) then
		ragdoll:Remove()
	end
	ent:TakeDamage(5000)
	ent:NextThink(CurTime())

    -- Cleanup
    self.Executing = false
    self.ExecutionEnemy = nil
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

function ENT:InitHandleAnims()
  if not isfunction(self.old_HandleAnimEvent) then
    self.old_HandleAnimEvent = self.HandleAnimEvent
  end

  -- use "me" as the closure owner to avoid confusion with the callback 'ent' arg
  self.HandleAnimEvent = function(me, event, eventTime, cycle, type, options)
    if isfunction(me.old_HandleAnimEvent) then
      me.old_HandleAnimEvent(me, event, eventTime, cycle, type, options)
    end

    if event == 1100 and options == "Step" then
      util.ScreenShake(me:GetPos(), 10, 5, 0.5, 350)
    	if IsValid(self) then
            AdvancedPillSound({
                stringe = "nosey/Nosey_footstep"..math.random(1,5)..".wav",
                pitchPercent = 100,
                soundLevel = 67
            }, self)
        end
    end

	if event == 1100 and options == "echolocation" then
        self:SetNWInt('lasttimeusedNOSEYSCAN',CurTime()+7)
        self:SetNWInt('lasttimeusedNOSEYSCANCooldown',CurTime()+21)
            if self:IsPossessed() then
                local ply = self:GetPossessor()
                net.Start("nosey_scanmap")
                net.WriteEntity(self)
                net.Send(ply)
            end
    end
  end
end

function ENT:CustomUpdateEnemy()
	local enemy

	-- do nothing if possessed
	if self:IsPossessed() then
		enemy = NULL
	else
		-- nemesis always takes priority
		if self:HasNemesis() then
			return self:GetNemesis()
		end

		-- call the normal DRGBase hook
		enemy = self:OnUpdateEnemy()
		if enemy == nil then
			return self:GetEnemy()
		end

		-- drop enemy if invalid or beyond sight range (instead of EnemyRadius)
		if not IsValid(enemy) or self:GetRangeSquaredTo(enemy) > self:GetSightRange()^2 then
			enemy = NULL
		end

		-- afraid check
		if self:IsAfraidOf(enemy) and not self:IsInRange(enemy, self.WatchAfraidOfRange) then
			enemy = NULL
		end
	end

	-- finally, set enemy (replaces DRGBase’s internal SetEnemy call)
	self:SetEnemy(enemy)
	return enemy
end

local TARGET_MOVE_THRESHOLD = 50 -- units before recompute

local function ShouldComputeCustom(self, path, pos)
	if not IsValid(path) then return true end

	self._LastTargetPos = self._LastTargetPos or pos

	-- Only recompute if the target moved enough
	local targetMoved = self._LastTargetPos:DistToSqr(pos) > (TARGET_MOVE_THRESHOLD ^ 2)

	if targetMoved then
		self._LastTargetPos = pos
		return true
	end

	local lastSeg = self._DrGBasePathLastSegment
	if not lastSeg or not lastSeg.pos then return true end

	local remaining = path:GetLength() - path:GetCursorPosition()
	return lastSeg.pos:DistToSqr(pos) > (remaining * remaining * 0.25)
end

function ENT:CustomFollowPath(pos, tolerance, generator)
	if isentity(pos) then
		if not IsValid(pos) then return "unreachable" end
		pos = pos:GetClass() == "npc_barnacle" and util.DrG_TraceLine({
			start = pos:GetPos(),
			endpos = pos:GetPos() - Vector(0, 0, 999999),
			collisiongroup = COLLISION_GROUP_DEBRIS
		}).HitPos or pos:GetPos()
	end

	tolerance = isnumber(tolerance) and tolerance or 20
	local myPos = self:GetPos()

	if navmesh.IsLoaded() and self:GetGroundEntity():IsWorld() then
		local path = self:GetPath()
		path:SetGoalTolerance(tolerance)

		local area = navmesh.GetNearestNavArea(pos)
		if IsValid(area) then pos = area:GetClosestPointOnArea(pos) or pos end

		if not IsValid(path) and self:GetRangeSquaredTo(pos) <= tolerance^2 then return "reached" end
		if ShouldComputeCustom(self, path, pos) then
			path:Compute(self, pos, generator)
			self._DrGBasePathLastSegment = path:LastSegment()
		end
		if not IsValid(path) then return "unreachable" end

		local current = path:GetCurrentGoal()
		if not current then return "unreachable" end

		local ledge = self:FindLedge(current.type ~= 2)
		if isvector(ledge) then
			self:ClimbLedge(ledge)
			path:Invalidate()
			return "ledge", ledge
		end

		local goalType = current.type
		if goalType == 2 and self:GetRangeTo(current.pos) <= path:GetGoalTolerance() then
			if not self:AvoidObstacles(true) then
				self:MoveTowards(path:NextSegment().pos)
				if self.loco:IsStuck() then
					self:HandleStuck()
					return "stuck"
				else return "moving" end
			else return "obstacle" end
		elseif goalType == 4 or goalType == 5 then
			local ladder = current.ladder
			local climbUp = goalType == 4
			if climbUp and not self.ClimbLaddersUp then return "unreachable" end
			if not climbUp and not self.ClimbLaddersDown then return "unreachable" end

			local checkPos = climbUp and ladder:GetBottom() or ladder:GetTop()
			local dist = climbUp and self.LaddersUpDistance or self.LaddersDownDistance
			if self:GetHullRangeSquaredTo(checkPos) < dist^2 then
				if climbUp then self:ClimbLadderUp(ladder) else self:ClimbLadderDown(ladder) end
				path:Invalidate()
				return climbUp and "ladder_up" or "ladder_down", ladder
			elseif not self:AvoidObstacles(true) then
				self:MoveTowards(current.pos)
				return "moving", ladder
			else return "obstacle" end
		elseif not self:LastComputeSuccess() and
			path:GetCurrentGoal().distanceFromStart == path:LastSegment().distanceFromStart then
			return "unreachable"
		elseif not self:AvoidObstacles(true) then
			path:Update(self)
			if not IsValid(path) then return "reached"
			elseif self.loco:IsStuck() then
				self:HandleStuck()
				return "stuck"
			else return "moving" end
		else return "obstacle" end
	else
		local ledge = self:FindLedge()
		if isvector(ledge) then
			self:ClimbLedge(ledge)
			self:InvalidatePath()
			return "ledge", ledge
		elseif not self:AvoidObstacles(true) then
			if self:GetRangeSquaredTo(pos) > tolerance^2 then
				self:MoveTowards(pos)
				if self.loco:IsStuck() then
					self:HandleStuck()
					return "stuck"
				else return "moving" end
			else return "reached" end
		else return "obstacle" end
	end
end

function ENT:CustomChaseEntity(ent, tolerance, callback)
	if not isentity(ent) then return false end
	if not isfunction(callback) then callback = function() end end
	while IsValid(ent) do
		local res = self:CustomFollowPath(ent, tolerance)
		if res == "reached" then return true
		elseif res == "unreachable" then
			return false
		else
			res = callback(self, self:GetPath())
			if isbool(res) then return res end
			self:YieldCoroutine(true)
		end
	end
	return false
end

function ENT:CustomInitialize()
	self.PathRecompute = CurTime()
	self.UpdateEnemy = self.CustomUpdateEnemy
	self.ChaseEntity = self.CustomChaseEntity
	self.FollowPath = self.CustomFollowPath
	self.ShouldCompute = self.ShouldComputeCustom
	self.IsScanning = false -- unlock after done
	self:SetNWInt('lasttimeusedNOSEYSCAN',CurTime())
    self:SetNWInt('lasttimeusedNOSEYSCANCooldown',CurTime())
	self:InitHandleAnims(self)
	self:SetDefaultRelationship(self.Monster_DefaultRelationship)
	self:SetPlayersRelationship(self.Monster_PlayersRelationship)
	self:SetDamageAttackMultiplier(1)
	self:SetARMultiplier(2)
	self:SetDamageReduction(10.0)
	self:SetCanExecute(true)
	self.CurrentExecution = {}
	self.DefaultJumpAnim = self.JumpAnimation
	self.Default_IdleAnimation = self.IdleAnimation
	self.Default_WalkAnimation = self.WalkAnimation
	self.Default_RunAnimation = self.RunAnimation
	self.Default_WalkSpeed = self.WalkSpeed
	self.Default_RunSpeed = self.RunSpeed
	self.Default_Acceleration = self.Acceleration
	self.Default_Deceleration = self.Deceleration
	self:SetCooldown("AI_Crouch", 2)
	self:SetCooldown("AI_UnCrouch", 2)
	self.FlyUpD = math.random(0.5,3)
	self:SetCooldown("FlyPatron", self.FlyTimerOnChase)
	self.TraceD = 0
	self:SetIsFlying(false)
	self:SetIsCrouching(false)
	self.WantFly = false
	self.ExecutionUpdateDelay = 0
	self.ExecutionEnemy = nil 
	if self.Monster_MeleeAttacks != nil then
		for i=1,#self.Monster_MeleeAttacks do
			local attack = self.Monster_MeleeAttacks[i]
			self:SetAttack(attack.attack_anim, true)
		end
	end
	if istable(self.MonsterAnimEvents) and not table.IsEmpty(self.MonsterAnimEvents) then
		for k, animevent in pairs(self.MonsterAnimEvents) do
    		self:SequenceEvent(animevent.seq, animevent.frames, animevent.event)
		end
	end
	if isstring(self.MainEvolution) then
		if isnumber(self.MainEvolutionTimer) then
			self:Timer(self.MainEvolutionTimer, function()
				self:Evolve(self:SearchEvolution(self.MainEvolution))
			end)
		elseif isfunction(self.MainEvolutionTimer) then
			self.MainEvolutionTimer(self)
		end
	end
	self:AddMeleeAttackEventSequences()
	self:AddRangeAttackEventSequences()
	self:AddFootstepEventSequences()
	self:Monster_Init()

	self:SetIK(true)

	-- if weapons.Get("ca_tablet") and SERVER then
	-- 	local ca_camera = ents.Create("ca_camera")
	-- 	self.Camera = ca_camera
	-- 	ca_camera:SetParent(self)
	-- 	ca_camera:SetRenderMode(RENDERMODE_NONE)
		
	-- 	ca_camera:SetCameraName("Nosey Debug Camera")
	-- 	ca_camera:FollowBone(self,5)
	-- 	ca_camera:AddEffects(EF_FOLLOWBONE)
	-- 	ca_camera:SetPos(self:GetPos() + (self:GetUp() * 135) + (self:GetRight() * 1) + (self:GetForward() * 17))
	-- 	ca_camera:SetAngles(self:GetAngles()+Angle(90,90,0))
	-- 	ca_camera:Spawn()
	-- 	ca_camera:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		
	-- 	for _,ply in ipairs(player.GetAll()) do
	-- 		ply:ConCommand("ca_cams_sync_server")
	-- 	end
	-- end
end

function ENT:ShouldRun()
	if self.Monster_CanRun == true then
		if not IsValid(self:GetEnemy()) then return false end
		if self.Monster_CanRunIfEnemyIsFar then if self.Monster_EnemyIsFar then return true else if self:GetPos():Distance(self:GetEnemy():GetPos()) > self.Monster_DistanceFromEnemyToRun then self.Monster_EnemyIsFar = true return true end end end
		if self.Monster_EnemyHealthToRun and self:Health() <= self:GetMaxHealth()*self.Monster_HealthToRun then return true end
		if self.Monster_EnemyHealthToRun and self:GetEnemy():Health() > self.Monster_EnemyHealthToRun then return true end
		if self:IsCrouching() and self.Monster_CanWhileIsCrouching == true then
			return self:HasEnemy() and self:GetEnemySize(self:GetEnemy()) > self.Monster_MinEnemySizeToRun
		elseif not self:IsCrouching() then
			return self:HasEnemy() and self:GetEnemySize(self:GetEnemy()) > self.Monster_MinEnemySizeToRun
		end
	else
		return false
	end
end

function ENT:AddMeleeAttackEventSequences()
	if self.Monster_HasMeleeAttacks == true then
	for m,attack in pairs(self.Monster_MeleeAttacks) do
		for s,timer in pairs(attack.attack_timers) do
			self:SequenceEvent(attack.attack_anim,timer.attack_timer,function()
				self:AttackFunction(timer.attack_func)
			end)
		end
	end
	end
end

function ENT:AddFootstepEventSequences()
	if not self.Monster_CanUseFootsteps or not self.Monster_Footsteps then return end
	
	for _, footstep in pairs(self.Monster_Footsteps) do
		if not footstep.timers then continue end
		
		for _, f_timer in pairs(footstep.timers) do
			self:SequenceEvent(footstep.animation, f_timer, function()
				self:Footstep(footstep)
			end)
		end
	end
end

function ENT:AddRangeAttackEventSequences()
	if self.Monster_RangeAttacks == nil then return end
	if not self.Monster_HasRangeAttacks then return end
    
    for _, attack in ipairs(self.Monster_RangeAttacks or {}) do
        if #attack.attack_anim > 0 then
            for _, timer in ipairs(attack.attack_timers or {}) do
                local proj_class = timer.proj_class
                
                self:SequenceEvent(
                    attack.attack_anim,
                    timer.attack_timer,
                    function()
                        self:ProjectileFunction(proj_class, table.Random(timer.proj_options))
                    end
                )
            end
        else
            table.insert(self.Monster_NoAnim_RangeAttacks, attack)
        end
    end
end

function ENT:DestroyedDoor()
	if self.CanOpenDoors == true or self.CanDestroyDoors == true then
	for v,ball in pairs(ents.FindInSphere(self:LocalToWorld(Vector(0,0,5)), 50)) do
		if IsValid(ball) && IsValid(self) then
			if ball:GetClass() == "prop_door_rotating" then
				local pos = ball:GetPos()
				local angles = ball:GetAngles()
				local model = ball:GetModel()
				local bodygroups = ball:GetBodyGroups()
				local skinn = ball:GetSkin()

				--print(model)

				local broken_door = ents.Create("prop_physics")
				if not IsValid(broken_door) then return end
				broken_door:SetPos(pos)
				broken_door:SetAngles(angles)
				broken_door:SetModel(model)
				if istable(bodygroups) and #bodygroups > 0 then
					for k,bodygroup in pairs(bodygroups) do
						broken_door:SetBodygroup(bodygroup.id,ball:GetBodygroup(bodygroup.id))
					end
				end
				if broken_door.SetSkin then
					broken_door:SetSkin(skinn)
				end
				broken_door:SetCustomCollisionCheck(true)

				ball:EmitSound("doors/heavy_metal_stop1.wav",350,120)
				ball:Remove()

				broken_door:Spawn()
          
				local phys = broken_door:GetPhysicsObject()
				if IsValid(phys) then
					phys:ApplyForceOffset(self:GetForward() * 30000, phys:GetMassCenter())
				end
			elseif ball:GetClass() == "func_door" || ball:GetClass() == "func_door_rotating" then
				if self.CanOpenDoors == true then
				ball:Fire("Open")
				end
			end
		end
	end
	end
end

function ENT:ExecutionThink(enemy)
	local camID = self:LookupAttachment('camera')
	local cam = self:GetAttachment(camID)

	if not cam then return end
		if IsValid(enemy) then
			if enemy:Health() < 0.1 then
        		self.ExecutionEnemy = nil
     			return
    		end
			if self.ExecutionUpdateDelay <= CurTime() then
				enemy:SetPos(cam.Pos + enemy:GetUp() * self.PosHeight + enemy:GetForward() * self.PosForward)
				enemy:SetAngles(cam.Ang)
				self.ExecutionUpdateDelay = CurTime() + 0.01
			end
		end
end

function ENT:LightThink()
    if not self.NextLightCheck then self.NextLightCheck = 0 end
    if CurTime() < self.NextLightCheck then return end
    self.NextLightCheck = CurTime() + 0.25 -- check every 0.25s

    local shouldUseLight = self:GetNWBool("ShouldUseLight", false)

    -- Turn on the light
    if shouldUseLight then
        if not IsValid(self._NoseyLight) then
            local light = ents.Create("light_dynamic")
            if not IsValid(light) then return end

			light:SetPos(self:GetPos())
			light:FollowBone(self,2)
            light:SetKeyValue("distance", "500")
            light:SetKeyValue("brightness", "1.5")
            light:SetKeyValue("_light", "255 255 255 255") -- white
            light:Spawn()
            light:Activate()
            light:Fire("TurnOn", "", 0)

            self._NoseyLight = light
            self:EmitSound("buttons/button3.wav", 70, 100)
        end
    else
        if IsValid(self._NoseyLight) then
            self._NoseyLight:Remove()
            self._NoseyLight = nil
            self:EmitSound("buttons/button10.wav", 70, 100)
        end
    end
end

function ENT:CustomThink()

	self:SetNWBool("Nosey_pill_scan", true)

	if !self:IsPossessed() then
		self:LightThink()
	end

	      if IsValid(self:GetGrabbedPlayer()) then
		if self:GetSequence() != self:LookupSequence("kill") then
			if IsValid(self:GetGrabbedPlayer()) then
				self:GetGrabbedPlayer():SetParent(nil)
				self:GetGrabbedPlayer():SetViewEntity(nil)
				self:GetGrabbedPlayer():Freeze(false)
				self:GetGrabbedPlayer():SetNoDraw(false)
				self:SetIgnored(self:GetGrabbedPlayer(), false)
				self:SetGrabbedPlayer(nil)
				if IsEntity(self.cent) then
					self.cent:Remove()
				end
			end
		end
	end
	if IsValid(self:GetGrabbedEnemy()) and not IsValid(self:GetGrabbedPlayer()) then
		if self:GetSequence() != self:LookupSequence("kill") then
			if IsValid(self:GetGrabbedEnemy()) then
				self:SetGrabbedEnemy(nil)
			end
		end
	end

if not GetConVar("ai_disabled"):GetBool() then
	if not self:IsPossessed() and not self:HasEnemy() then
		if self:GetNWInt("lasttimeusedNOSEYSCANCooldown", 0) > CurTime() then return end
		if self:GetNWInt("lasttimeusedNOSEYSCAN", 0) > CurTime() then return end
		if self.IsJumpscaring or self.IsScanning then return end

		self.IsScanning = true
		self:CallInCoroutine(function(self)
			if not self:IsPossessed() then

				self:PlaySequenceAndWait("echolocation")

				self:SetSightRange(50000)
				self:SetSightFOV(360)
				self:SetOmniscient(true)

				timer.Simple(7 + 1.4, function()
					if IsValid(self) then
						self:SetSightRange(5000)
						self:SetSightFOV(150)
						self:SetOmniscient(false)
					end
				end)

				self.IsScanning = false -- unlock after done
			end
		end)
	end
end

self:DestroyedDoor()

--Grab and Throw
	--[[
	if (not self:IsInWorld()) or (self:GetPos() == nil) then
		local playerstarts = ents.FindByClass("info_player_start")
		self:SetPos(playerstarts[math.random(1, #playerstarts)]:GetPos())
	end
]]
if self.Monster_CanGrabAndThrow == true then
	if table.Count(self.CurrentThrowMechanic) > 0 then
		local t_mechanic = self.CurrentThrowMechanic
		if IsValid(self:GetCurrentEntityToThrow()) then
			local attachname = self:LookupAttachment(t_mechanic.grab_attachment)
			local attach = self:GetAttachment(attachname)
			self:GetCurrentEntityToThrow():SetPos(attach.Pos)
		end
		if not (self:GetCooldown("ThrowStuff") > 0) and self:HasEnemy() and not IsValid(self:GetCurrentEntityToThrow()) then
			self:CallInCoroutine(function(self,delay)
				if delay > 0.3 then return end
				local attacking = false
				for k,obstacleprop in pairs(ents.FindInSphere(self:GetPos(), t_mechanic.grab_check)) do
					if IsValid(obstacleprop) and obstacleprop:GetClass() == "prop_physics" and attacking == false then
						if not IsValid(obstacleprop:GetOwner()) then
							attacking = true
      							self:SetCooldown("ThrowStuff", t_mechanic.usable_throw_timer)
							self:GrabAndThrow(obstacleprop, t_mechanic)
						end
					end
				end
			end)
		end
	else
		self.CurrentThrowMechanic = table.Random(self.ThrowMechanics)
	end
end
//End Grab and Throw

//Common Think
	self:CheckPlayerLookingAtNPC_Monster()
//Fly Mechanic

if self.CanFly == true and not self:IsPossessed() then
if self:IsCrouching() == false and self:IsClimbing() == false then
	if IsValid(self) and self:HasEnemy() then
		if self:FlyCheck() != nil and (not self:IsFlying()) and (self:GetEnemy():GetPos().z > self:FlyCheck().z) then
			self:SetIsFlying(true)
		elseif self.WantFly == false and (self:FlyCheck() != nil and not (self:GetEnemy():GetPos().z > self:FlyCheck().z)) then
			if self:IsFlying() then
				self:SetIsFlying(false)
			end
		end
	end
if self.Fly_CanStrafe == false or self.Fly_WantCharge == true then
	if IsValid(self) and self:HasEnemy() and self:IsFlying() then
		self:SetVelocity(self:GetForward()*self.FlySpeed+self:GetRight()*self.FlySpeed)
		local trd = util.TraceLine( {
			start = self:GetPos(),
			endpos = self:GetPos()+(self:GetForward()*self.FlySpeed),
			ignoreworld = false,
			filter = self
		} )
		if(trd.HitWorld) then 
			self:Monster_Jump(self:GetEnemySize(self:GetEnemy())+(self:GetEnemy():GetPos().z - self:GetPos().z))
			if IsValid(self:GetEnemy()) then
				self:SetAngles((self:GetEnemy():GetPos() - self:GetPos() ):Angle())
			end
		end
	
		local trd2 = util.TraceLine( {
			start = self:GetPos(),
			endpos = self:GetPos()+(self:GetUp()*(-24550*(self:GetEnemySize(self:GetEnemy())+(self:GetEnemy():GetPos().z - self:GetPos().z)+1))),
			ignoreworld = false,
			filter = self
		} )
		if(trd2.HitWorld) then 
			self:Monster_Jump(self:GetEnemySize(self:GetEnemy())+(self:GetEnemy():GetPos().z - self:GetPos().z))
			self:SetVelocity(self:GetForward()*self.FlySpeed+self:GetUp()*(self:GetEnemySize(self:GetEnemy())+(self:GetEnemy():GetPos().z - self:GetPos().z)+1))
		end
	end
else
	if IsValid(self) and self:HasEnemy() and self:IsFlying() then
		local trd3 = util.TraceLine( {
			start = self:GetPos(),
			endpos = self:GetPos()+self:GetUp()*-self.MinGroundDistanceToFly,
			ignoreworld = false,
			filter = self
		} )
		self:SetVelocity(self:GetForward()*self.FlySpeed)
		local trd = util.TraceLine( {
			start = self:GetPos(),
			endpos = self:GetPos()+(self:GetForward()*self.FlySpeed),
			ignoreworld = false,
			filter = self
		} )
		if(trd.HitWorld) then 
			self:Monster_Jump(self:GetEnemySize(self:GetEnemy())+(self:GetEnemy():GetPos().z - self:GetPos().z))
			if IsValid(self:GetEnemy()) then
				self:SetAngles((self:GetEnemy():GetPos() - self:GetPos() ):Angle())
			end
		end
	
	      	if not (self:GetCooldown("ChangeFlyDirection") > 0) then
	      		self:SetCooldown("ChangeFlyDirection", self.Fly_ChangeStrafeDirectionTimer)
			self.FlyUpD = math.random(-1,1)
		end
	
		local trd2 = util.TraceLine( {
			start = self:GetPos(),
			endpos = self:GetPos()+(self:GetUp()*(-self.MinGroundDistanceToFly*(self:GetEnemySize(self:GetEnemy())+(self:GetEnemy():GetPos().z - self:GetPos().z)+1))),
			ignoreworld = false,
			filter = self
		} )
		if(trd2.HitWorld) then
			if self:FlyCheck() != nil and self:FlyCheck().z-self.MinGroundDistanceToFly < self:GetEnemySize(self:GetEnemy())+(self:GetEnemy():GetPos().z - self:GetPos().z) then
				self:SetVelocity(self:GetForward()*( (self:GetPos()-Vector(0,0,self:GetPos().z)):Distance( self:GetEnemy():GetPos()-Vector(0,0,self:GetEnemy():GetPos().z) )-self.Fly_StrafeDistance^2 ) + self:FlyUpCheck() + self:GetRight()*(self.FlySpeed*self.FlyUpD))
			else
				self:SetVelocity(self:GetForward()*(self:GetHullRangeSquaredTo(self:GetEnemy())*0.00001) + self:GetUp()*(self:GetEnemySize(self:GetEnemy())+(self:GetEnemy():GetPos().z - self:GetPos().z)+1) + self:GetRight()*(self.FlySpeed*self.FlyUpD))
			end
		end
	elseif IsValid(self) and self:IsFlying() then
		if self:FlyCheck() != nil then
			if self:IsOnGround() then
				self:Monster_Jump(self.StepHeight+1)
			end
			if (self:GetPos().z - self:FlyCheck().z)*-1 > math.random(20,30) then
				self:SetVelocity(self:GetUp()*((self:GetPos().z - self:FlyCheck().z)*-1))
			else
				self:SetVelocity(self:GetUp()*2)
			end
		else
			self:SetVelocity(self:GetUp()*2)
		end
	end
end
end
end

//Crouch Mechanic

if self.CanCrouch == true and not self:IsPossessed() then
	local ncb = self.CollisionBounds
	local ccb = self.CrouchCollisionBounds
	local mins = Vector(ccb.x*-1, ccb.y*-1, 0)
	local maxs = Vector(ccb.x, ccb.y, ccb.z)
	local startpos = self:GetPos()
	local dir = self:GetUp()
	local len = ncb.z-ccb.z
	local forw = self:GetForward()
	local vel = self:GetVelocity():Length()

if self:IsCrouching() == false and self:IsClimbing() == false and self:IsFlying() == false then
	local tcrouchtr = util.TraceHull( {
		start = startpos + forw * ccb.x + Vector(0,0,ccb.z),
		endpos = startpos + forw * ccb.x + dir * len,
		maxs = maxs,
		mins = mins,
		filter = self
	} )

	if tcrouchtr.Hit == true then
		local hitclass = tcrouchtr.Entity
		if not (hitclass:IsPlayer() or hitclass:IsNPC() or hitclass.IsDrGNextbot or hitclass.IsVJBaseSNPC or hitclass.CPTBase_NPC or hitclass.IsMonsterProjectile) then
			self:ToCrouch()
			if self:GetPos():Distance(tcrouchtr.HitPos) > 1 then
				self:SetCooldown("AI_UnCrouch", self:GetPos():Distance(tcrouchtr.HitPos)/vel+1)
			else
				self:SetCooldown("AI_UnCrouch", 1)
			end
		end
	end
else
	local ucrouchtr = util.TraceHull( {
		start = startpos + forw * (ncb.z*-1) +Vector(0,0,ccb.z),
		endpos = startpos + forw * (ncb.z*-1) + dir * len,
		maxs = maxs,
		mins = mins,
		filter = ent
	} )

	if ucrouchtr.Hit == false then
		self:UnCrouch()
	end

end
end

//Skills system
	self:UpdateSkills()
//Custom
	self:Monster_Think()

end

-- Crouch system --

function ENT:ToCrouch()
	self:SetIsCrouching(true)
	self.UseWalkframes = false 
	self.IdleAnimation = self.Crouch_IdleAnimation
	self.WalkAnimation = self.Crouch_WalkAnimation
	self.RunAnimation = self.Crouch_RunAnimation

	self.WalkSpeed = self.Crouch_WalkSpeed
	self.RunSpeed = self.Crouch_RunSpeed
	self.Acceleration = self.Crouch_Acceleration
	self.Deceleration = self.Crouch_Deceleration
	if isvector(self.CrouchCollisionBounds) then
		self:SetCollisionBounds(
			Vector(self.CrouchCollisionBounds.x, self.CrouchCollisionBounds.y, self.CrouchCollisionBounds.z),
			Vector(-self.CrouchCollisionBounds.x, -self.CrouchCollisionBounds.y, 0)
		)
	else
		self:SetCollisionBounds(self:GetModelBounds())
	end
	self:ToCrouch_Monster()
end

function ENT:ToCrouch_Monster()
end

-- Horror system --

function ENT:CheckPlayerLookingAtNPC_Monster()
    local ply = self:GetEnemy()
    
    if (not self:HasEnemy()) and not IsValid(ply) then return end

    if ply:IsPlayer() or ply.IsLambdaPlayer then
    local eye_pos = ply:EyePos()
    local eye_ang = ply:EyeAngles()
    self.enemyfov = ply:GetFOV()

    local npc_ang = (self:GetPos() - eye_pos):Angle()
    
    self.enemyang_diff = math.abs(math.AngleDifference(eye_ang.y, npc_ang.y))
    local dist = eye_pos:Distance(self:GetPos())
    
    local trl = util.TraceLine({
    	start = eye_pos,
    	endpos = self:GetPos(),
    	filter = function(self, ply, ent) return not ( ent == self or ent == ply ) end
    })

    if self.enemyang_diff <= self.enemyfov / 2 and not trl.Hit then
        self.IsWatchingMe = true
    else
        self.IsWatchingMe = false
    end
    end
end

function ENT:UnCrouch()
	self:SetIsCrouching(false)
	self.UseWalkframes = false 
	self.IdleAnimation = self.Default_IdleAnimation
	self.WalkAnimation = self.Default_WalkAnimation
	self.RunAnimation = self.Default_RunAnimation

	self.WalkSpeed = self.Default_WalkSpeed
	self.RunSpeed = self.Default_RunSpeed
	self.Acceleration = self.Default_Acceleration
	self.Deceleration = self.Default_Deceleration
	if isvector(self.CollisionBounds) then
		self:SetCollisionBounds(
			Vector(self.CollisionBounds.x, self.CollisionBounds.y, self.CollisionBounds.z),
			Vector(-self.CollisionBounds.x, -self.CollisionBounds.y, 0)
		)
	else
		self:SetCollisionBounds(self:GetModelBounds())
	end
	self:UnCrouch_Monster()
end
function ENT:UnCrouch_Monster()
end


-- AI --

function ENT:FlyUpCheck()
	if self:HasEnemy() then
		if self:GetEnemy():GetPos().z < self:FlyCheck().z then
			return self:GetUp()*((self:GetPos().z - self:FlyCheck().z)*-1)
		else
			return self:GetUp()*(self:GetEnemySize(self:GetEnemy())+(self:GetEnemy():GetPos().z - self:GetPos().z)+1)
		end
	end
end

function ENT:FlyCheck()
	local fspos = self:GetPos()
	local farea = navmesh.GetNearestNavArea(fspos)
    	if IsValid(farea) then
		local fnpos = self:DrG_TraceHull(nil, {
			start = farea:GetCenter(),
			endpos = farea:GetClosestPointOnArea(fspos),
			collisiongroup = COLLISION_GROUP_WORLD,
			step = true
	       	}).HitPos + Vector(0,0,250)
	return fnpos
	end
end

function ENT:RoarEvent()
	if istable(self.RoarSound) and #self.RoarSound > 0 then
		if isstring(table.Random(self.RoarSound)) then
			self:EmitSound(table.Random(self.RoarSound))
		end
	end
end

function ENT:OnStuck()
	if self:IsClimbing() then return end
	if self:IsPossessed() then return end
	if self:IsFlying() then return end
	if self.CanExitFromStuck == false then return end
	if not navmesh.IsLoaded() then return end
	self.LastStuck = CurTime()

	-- Don't warp across the whole map.
	-- Besides, if we try to warp onto a player, it doesn't work.
	-- Not sure why, but it might have something to do with the hook we're in.
	if self.StuckTries > 10 then
		self.StuckTries = 0
	end

	-- Jump forward a bit on the path.
	local newCursor = self:GetPath():GetCursorPosition()
		+ 40*self:GetScale() * math.pow(2, self.StuckTries)
	local newPos = self:GetPath():GetPositionOnPath(newCursor)
	self.StuckTries = self.StuckTries + 1

	-- Some malformed navmeshes have climb junctions that pass through the
	-- void. We'll check for those and try not to fall out of the map.
	if not util.IsInWorld(newPos) then
		-- The next stuck check will retry this.
		return
	end
	if self:HasEnemy() and IsValid(self:GetEnemy()) then
		if not (newPos:IsEqualTol(self:GetEnemy():GetPos(), self.StuckEnemyDistanceTolerance )) then
			self:SetPos(newPos)
		end
	else
		self:SetPos(newPos)
	end
	-- Hope that we're not stuck anymore.
	self.loco:ClearStuck()
	self:OnStuck_Monster()
end
function ENT:OnStuck_Monster()
end

function ENT:UnstickFromCeiling()
	if self.CanExitFromStuck == false then return end
	if not navmesh.IsLoaded() then return end
	if self:IsOnGround() then return end

	-- NextBots LOVE to get stuck. Stuck in the morning. Stuck in the evening.
	-- Stuck in the ceiling. Stuck on each other. The stuck never ends.
	local myPos = self:GetPos()
	local myHullMin, myHullMax = self:GetCollisionBounds()
	local myHull = myHullMax - myHullMin
	local myHullTop = myPos + vector_up * myHull.z
	trace.start = myPos
	trace.endpos = myHullTop
	trace.filter = self
	local upTrace = util.TraceLine(trace)

	if upTrace.Hit and upTrace.HitNormal ~= vector_origin
		and upTrace.Fraction > 0.5
	then
		local unstuckPos = myPos
			+ upTrace.HitNormal * (myHull.z * (1 - upTrace.Fraction))
		self:SetPos(unstuckPos)
	end
end

function ENT:OnRemove()
	if IsValid(self._NoseyLight) then
        self._NoseyLight:Remove()
        self._NoseyLight = nil
    end

	if IsValid(self:GetGrabbedPlayer()) then
		self:GetGrabbedPlayer():SetParent(nil)
		self:GetGrabbedPlayer():SetViewEntity(nil)
		self:GetGrabbedPlayer():Freeze(false)
		self:GetGrabbedPlayer():SetNoDraw(false)
		if IsEntity(self.cent) then
			self.cent:Remove()
		end
		if IsEntity(self.Camera) then
			self.Camera:Remove()
		end
	end
	self:StopSound("nosey/NoseyExecution.wav")

	self:OnRemove_Monster()

	if IsValid(self.ExecutionEnemy) then
		self.ExecutionEnemy:RemoveFlags(FL_NOTARGET)
		local lastpos = self.ExecutionEnemy:GetPos()
		self.ExecutionEnemy:SetPos(lastpos)
		self.ExecutionEnemy:SetAngles(Angle(0, 0, 0))
		
		if self.ExecutionEnemy:IsNPC() or self.ExecutionEnemy:IsNextBot() then
				self.ExecutionEnemy:NextThink(CurTime())
		elseif self.ExecutionEnemy:IsPlayer() then
			self.ExecutionEnemy:Freeze(false)
		end
	end
	self.ExecutionEnemy = nil
end
function ENT:OnRemove_Monster()
end

function ENT:OnNewEnemy(enemy)
	if self.CanTeleport and self.CanTeleportByTimer then
		self:SetCooldown("TeleportTimer", self.Teleport_Timer)
	end

	if enemy.IsVJBaseSNPC or enemy.CPTBase_NPC then
		self:SetDefaultRelationship(self.Monster_DefaultRelationship)
		self:RoarEvent()
	end
	self:OnNewEnemy_Monster(enemy)
	self:MonsterRoar(enemy)
end

function ENT:OnNewEnemy_Monster(enemy)
end

function ENT:OnChaseEnemy(enemy)
	currentime = CurTime()
	-- Try to jump at a target in the air.
	local scanInterval = 1
	if self:IsOnGround() and currentime - self.LastJumpScan >= scanInterval then
		self:AttemptJumpAtTarget()
		self.LastJumpScan = currentime
	end

//Fly Mechanic
	if self.CanFly == true then
	if self:IsCrouching() == false then
	if self.CanFlyOnChase == true then
			self.Fly_WantCharge = true
	if self.FlyTimerOnChase > 0 then
      	if not (self:GetCooldown("FlyPatron") > 0) then
	if self:FlyCheck() != nil then
			self.WantFly = true
	end
	end
	else
	if self:FlyCheck() != nil then
		if not self:IsFlying() then
			self.WantFly = true
			self:Jump(self.StepHeight)
			self:SetIsFlying(true)
		end
	end
	end
	end
	end
	end
	self:OnChaseEnemy_Monster(enemy)
end

function ENT:OnChaseEnemy_Monster(enemy)
end

function ENT:OnEnemyChange(oldEnemy, newEnemy)
	self.Monster_EnemyIsFar = false
	if newEnemy.IsVJBaseSNPC or newEnemy.CPTBase_NPC then
		self:SetDefaultRelationship(self.Monster_DefaultRelationship)
	end
	self:OnEnemyChange_Monster(oldEnemy, newEnemy)
end
function ENT:OnEnemyChange_Monster(oldEnemy, newEnemy)
end

function ENT:OnLastEnemy(enemy)
	self.Monster_EnemyIsFar = false
	self:OnLastEnemy_Monster(enemy)
end
function ENT:OnLastEnemy_Monster(enemy)
end

function ENT:LiteGibs_Check(enemy)
	if not IsValid(enemy) then return false end
	if not self.CheckForLiteGibs then return false end
	if LiteGibs then
		local valvebone = enemy:DrG_SearchBone("Valve")
		if valvebone then
			return true
		elseif (enemy:IsPlayer() or enemy:GetClass() == "npc_lambdaplayer" or enemy:GetClass() == "npc_zetaplayer") then
			return true
		else
			return false
		end
	else
		return false
	end
end

function ENT:OnMeleeAttack(enemy)
	self:CustomExecution(enemy)
end
function ENT:OnMeleeAttack_Monster(enemy)
end

function ENT:OnRangeAttack(enemy)
	self:SecondaryCharacterAttack()
	self:OnRangeAttack_Monster(enemy)
end
function ENT:OnRangeAttack_Monster(enemy)
end

function ENT:OnReachedPatrol()
	self.MPatrolPos = nil
	self:Wait(math.random(3, 4))
	if self.CanHealItSelf == true and self:Health() < self:GetMaxHealth() then
		self:HealFunction(self.HealData)
	end
	self:OnReachedPatrol_Monster()
end
function ENT:OnReachedPatrol_Monster()
end

function ENT:OnTakeDamage(dmg, hitgroup)
	self:SpotEntity(dmg:GetAttacker())
	if self.Telekinesis_AllowProps then
		if dmg:GetDamageType() == DMG_CRUSH or dmg:GetDamageType() == DMG_VEHICLE then
			dmg:SetDamage(0)
		end
	end
	if self.CanBeInmuneToDmg == true then
	if not table.HasValue(self.InmuneToDmgType, dmg:GetDamageType()) then
	if hitgroup == HITGROUP_HEAD then
		dmg:SetDamage(dmg:GetDamage()/self:GetDamageReduction()*100)
	else
		dmg:SetDamage(dmg:GetDamage()/self:GetDamageReduction())
	end
	else
		dmg:SetDamage(0)
	end
	else
	if hitgroup == HITGROUP_HEAD then
		dmg:SetDamage(dmg:GetDamage()/self:GetDamageReduction()*100)
	else
		dmg:SetDamage(dmg:GetDamage()/self:GetDamageReduction())
	end
	end
	local healdata = self.HealData
	if self.CanHealItSelf == true and dmg:GetDamage() > healdata.damage_check then
		if math.random(healdata.damage_check_min_chance, healdata.damage_check_max_chance) < healdata.damage_check_chance then
			self:CallInCoroutine(function(self, delay)
				if delay > 0.1 then return end
				self:HealFunction(self.HealData)
			end)
		end
	end
	self:OnTakeDamage_Monster(dmg, hitgroup)
end
function ENT:OnTakeDamage_Monster(dmg, hitgroup)
end

function ENT:OnIdle()
	local pd = self:RandomPos(self.PatrolDistance)
	self:AddPatrolPos(pd)
	self.MPatrolPos = pd
	self:OnIdle_Monster()
end
function ENT:OnIdle_Monster()
end

-- GettersSetters --

function ENT:IsCrouching()
	return self:GetNW2Bool("IsCrouching")
end

function ENT:SetIsCrouching(value)
	return self:SetNW2Bool("IsCrouching", value)
end

function ENT:IsExecuting()
	return self:GetNW2Bool("IsExecuting")
end

function ENT:SetIsExecuting(value)
	return self:SetNW2Bool("IsExecuting", value)
end

function ENT:CanExecute()
	return self:GetNW2Bool("CanExecute")
end

function ENT:SetCanExecute(value)
	return self:SetNW2Bool("CanExecute", value)
end

function ENT:IsFlying()
	return self:GetNW2Bool("IsFlying")
end

function ENT:SetIsFlying(value)
	if value != self:IsFlying() then
	if value == true then
		if self.JumpAnimation != self.FlyAnimation then
			self.JumpAnimation = self.FlyAnimation
		end
	else
		if self.JumpAnimation != self.DefaultJumpAnim then
			self.JumpAnimation = self.DefaultJumpAnim
		end
	end
	return self:SetNW2Bool("IsFlying", value)
	else
		return self:GetNW2Bool("IsFlying")
	end
end

function ENT:SetCurrentEntityToThrow(value)
	return self:SetNW2Entity("CurrentEntityToThrow", value)
end

function ENT:GetCurrentEntityToThrow()
	return self:GetNW2Entity("CurrentEntityToThrow")
end

function ENT:GetGrabbedPlayer()
	return self:GetNW2Entity("GrabbedPlayer")
end

function ENT:SetGrabbedPlayer(value)
	return self:SetNW2Entity("GrabbedPlayer", value)
end

function ENT:GetGrabbedEnemy()
	return self:GetNW2Entity("GrabbedEnemy")
end

function ENT:SetGrabbedEnemy(value)
	return self:SetNW2Entity("GrabbedEnemy", value)
end

function ENT:GetDamageReduction()
	if self:GetNW2Float("DamageReduction") < 1 then
		return 1
	else
		return self:GetNW2Float("DamageReduction")
	end
end

function ENT:SetDamageReduction(value)
	return self:SetNW2Float("DamageReduction", value)
end

function ENT:GetDamageAttackMultiplier()
	return self:GetNW2Float("DamageAttackMultiplier")
end

function ENT:SetDamageAttackMultiplier(value)
	return self:SetNW2Float("DamageAttackMultiplier", value)
end

function ENT:SetARMultiplier(value)
	return self:SetNW2Int("ARMultiplier", value)
end

function ENT:GetARMultiplier()
	return self:GetNW2Int("ARMultiplier")
end

function ENT:GetEnemySize(ent)
	self.enemy_BoxMin, self.enemy_BoxMax = ent:OBBMins(), ent:OBBMaxs()				
	self.enemy_SizeX = (math.abs(self.enemy_BoxMin.x)+math.abs(self.enemy_BoxMax.x))/2
	self.enemy_SizeY = (math.abs(self.enemy_BoxMin.y)+math.abs(self.enemy_BoxMax.y))/2
	self.enemy_SizeZ = (math.abs(self.enemy_BoxMin.z)+math.abs(self.enemy_BoxMax.z))/2
	return self.enemy_SizeZ
end

function ENT:GetCharacterSize()
	self.mecha_BoxMin, self.mecha_BoxMax = self:OBBMins(), self:OBBMaxs()				
	self.mecha_SizeX = (math.abs(self.mecha_BoxMin.x)+math.abs(self.mecha_BoxMax.x))/2
	self.mecha_SizeY = (math.abs(self.mecha_BoxMin.y)+math.abs(self.mecha_BoxMax.y))/2
	self.mecha_SizeZ = (math.abs(self.mecha_BoxMin.z)+math.abs(self.mecha_BoxMax.z))/2
	return self.mecha_SizeZ
end

-- Skill Helpers --

function ENT:Evolve(evolution)
	if self:GetPos() == nil then return end
	if isstring(evolution) then
		local c_evol = self:SearchEvolution(evolution) 
		if istable(c_evol) then
			if c_evol.class then
				evolution.class = c_evol.class
			end
			if c_evol.callback then
				evolution.callback = c_evol.callback
			end
		end
	end
	if evolution.class == nil then return end
	if not isstring(evolution.name) then evolution.name = self.PrintName end
	if not isfunction(evolution.callback) then evolution.callback = function(self, evolution, evol_table) end end
	local evol = ents.Create(evolution.class)
	if not IsValid(evol) then return end
	evol:SetPos(self:GetPos())
	evol:SetAngles(self:GetAngles())
	evol.Factions = self:GetFactions()
	evol:SetCreator(self:GetCreator())
	evol:Spawn()

    if IsValid(evol) and isfunction(evol.SetDamageAttackMultiplier) then
    	evol:SetDamageAttackMultiplier(self:GetDamageAttackMultiplier())
    end
    
	if IsValid(self:GetCreator()) then
        self:GetCreator():DrG_AddUndo(evol, "NPC", evolution.name)
	end

	evolution.callback(self, evol, evolution)

	self:Remove()
end

function ENT:SearchEvolution(name)
	if not isstring(name) then return end
	if not istable(self.Monster_Evolutions) then return end
	if self.Monster_Evolutions[name] then
		return self.Monster_Evolutions[name]
	end
end

function ENT:SpawnSkillEntitiesAround(npc, entclass, radius, numEntities, enemypos, ang, angleInc, canparent, parent, entfunc, entfuncs)
	if not IsValid(npc) then return end
	if ang == nil then ang = self:GetAngles() end
	if canparent == nil then canparent = false end
	if enemypos == nil then enemypos = true end
	if parent == nil then parent = self end
	if radius == nil then radius = 500 end
	if numEntities == nil then numEntities = 1 end
	if angleInc == nil then angleInc = 360 end
	local a_spotted = self:GetSpotted()
    local npcPos = npc:GetPos() -- npc position
    local angleIncrement = angleInc / numEntities -- Incremento del ángulo para cada entidad

    for i = 1, numEntities do
        local angle = math.rad(angleIncrement * i) -- Convertir el ángulo a radianes
        local offsetX = math.cos(angle) * radius -- Calcular el desplazamiento en el eje X
        local offsetY = math.sin(angle) * radius -- Calcular el desplazamiento en el eje Y
        local entityPos = npcPos + Vector(offsetX, offsetY, 0) -- Calcular la posición de la entidad
        if istable(a_spotted) and IsValid(a_spotted[i]) and a_spotted[i] != self then
        	currentpos = Vector(a_spotted[i]:GetPos().x,a_spotted[i]:GetPos().y,self:GetPos().z)
        	currentent = self:SpawnSkillEntity(entclass, currentpos, ang, canparent, parent, entfunc) -- Llamar a la función para crear la entidad en la posición calculada
        	if not isfunction(entfuncs) then entfuncs = function() end end
			entfuncs(self, currentent, i, a_spotted[i])
        else
        	currentent = self:SpawnSkillEntity(entclass, entityPos, ang, canparent, parent, entfunc) -- Llamar a la función para crear la entidad en la posición calculada
        	if not isfunction(entfuncs) then entfuncs = function() end end
			entfuncs(self, currentent, i, a_spotted[i])
        end
    end
end

function ENT:SpawnSkillEntity(entclass, pos, ang, canparent, parent, entfunc, prefunc)
	if pos == nil then pos = self:GetPos() end
	if ang == nil then ang = self:GetAngles() end
	if canparent == nil then canparent = false end
	if parent == nil then parent = self end
    local ent = ents.Create(entclass)
    ent:SetPos(pos)
    ent:SetAngles(ang)
    if canparent then
    	ent:SetParent(parent)
    end
    ent:SetOwner(self)
	if not isfunction(prefunc) then prefunc = function() end end
	prefunc(self, ent)
    ent:Spawn()
    if IsValid(ent) and isfunction(ent.SetDamageAttackMultiplier) then
    	ent:SetDamageAttackMultiplier(self:GetDamageAttackMultiplier())
    end
    if IsValid(ent) and isfunction(ent.SetDrGOwner) then
    	ent:SetDrGOwner(self)
    end
	if not isfunction(entfunc) then entfunc = function() end end
	entfunc(self, ent)
	return ent
end

function ENT:SpawnMinion(entclass, pos, ang, minionname, entfunc, enttable, maxvalue)
	if pos == nil then return end
	if ang == nil then ang = self:GetAngles() end
	if minionname == nil then minionname = "Monster (Minion)" end

	local canspawn = false

	if istable(enttable) then
		if isnumber(maxvalue) then
			if #enttable < maxvalue then
				canspawn = true
			end
		else
			canspawn = true
		end
	else
		canspawn = true
	end

	if not canspawn then return end
	local nugget = ents.Create(entclass)
	if not IsValid(nugget) then return end
	nugget:SetPos(pos)
	nugget:SetAngles(ang)
	nugget:Spawn()
	if istable(enttable) then
		table.insert(enttable, nugget)
	end
	nugget.Factions = self:GetFactions()
	nugget:SetCreator(self:GetCreator())
    if IsValid(ent) and isfunction(ent.SetDamageAttackMultiplier) then
    	ent:SetDamageAttackMultiplier(self:GetDamageAttackMultiplier())
    end
    if IsValid(ent) and isfunction(ent.SetDrGOwner) then
    	ent:SetDrGOwner(self)
    end
	if IsValid(self:GetCreator()) then
        self:GetCreator():DrG_AddUndo(nugget, "NPC", minionname)
	end
	if not isfunction(entfunc) then entfunc = function() end end
	entfunc(self, nugget)
	return ent
end

function ENT:UpdateSkills()
	if IsValid(self:GetEnemy()) then
	if self.CanTeleport and self:GetHullRangeSquaredTo(self:GetEnemy()) > self.Teleport_MinDistanceToNoTeleport^2 then
		if (not self:IsFlying()) or self.CanTeleportWhileIsFlying then
			self:TeleportSpos()
		end
	end
	end

	if self.CanUseTelekinesis then
		self:Telekinesis()
	end

	if self.CanMakeExplosions then
		if table.Count(self.CurrentExplosion) > 0 then
			self:ChooseExplosion()
			self:ExplosionFunction(self.CurrentExplosion)
		else
			self:ChooseExplosion()
		end
	end

	if self.HasToxicAmbience then
		self:ToxicAmbience()
	end
end

//Teleport
function ENT:TeleportPosCheck()
	local fspos = self:GetEnemy():GetPos()+Vector(math.random(-self.Teleport_Distance,self.Teleport_Distance)*self:GetModelScale(), math.random(-self.Teleport_Distance-1,self.Teleport_Distance+1)*self:GetModelScale(), 0)
	local farea = navmesh.GetNearestNavArea(fspos)
    	if IsValid(farea) then
		local fnpos = self:DrG_TraceHull(nil, {
			start = farea:GetCenter(),
			endpos = farea:GetClosestPointOnArea(fspos),
			collisiongroup = COLLISION_GROUP_WORLD,
			step = true
	       	}).HitPos + Vector(0,0,170)
	if fnpos:Distance(self:GetEnemy():GetPos()) < self.Teleport_MinDistanceToNoTeleport then return end
	return fnpos
	end
end

function ENT:Fly_TeleportPosCheck()
	local fspos = self:GetEnemy():GetPos()+Vector(math.random(-self.Teleport_Distance,self.Teleport_Distance)*self:GetModelScale(), math.random(-self.Teleport_Distance-1,self.Teleport_Distance+1)*self:GetModelScale(), 0)
	return fspos
end

function ENT:TeleportMPosCheck()
	if (self:IsFlying() and self.CanTeleportWhileIsFlying == true) then return self:Fly_TeleportPosCheck() else return self:TeleportPosCheck() end
end

function ENT:TeleportSpos()
	if self:HasEnemy() then
		if self.CanTeleportByTimer then
      			if not (self:GetCooldown("TeleportTimer") > 0) then
				local tdmg = self.Teleport_Damage
				local pos = self:TeleportMPosCheck()
				if pos != nil then
					local oldpos = self:GetPos()
					if #self.Teleport_OutEffects > 0 then
    					local effect = table.Random(self.Teleport_OutEffects)
    					self:EmitEffect(effect, oldpos, self, self.Teleport_EffectsLifeTime)
					end
					if #self.Teleport_OutSounds > 0 then
    					self:MonsterSound(table.Random(self.Teleport_Sounds),self:GetPos())
					end
					self:SetCooldown("TeleportTimer", self.Teleport_Timer)
					self:Timer(0.2,function()
						self:SetPos(pos)
						self:SetCooldown("TeleportTimer", self.Teleport_Timer)
						if #self.Teleport_Sounds > 0 then
							self:MonsterSound(table.Random(self.Teleport_Sounds),self:GetPos())
						end
						if #self.Teleport_Effects > 0 then
							self:EmitEffect(table.Random(self.Teleport_Effects), pos, self, self.Teleport_EffectsLifeTime)
						end
						if tdmg.can_dmg == true then
							self:ExplosionDamage(tdmg.dmg, tdmg.dmg_radius, self:GetPos(), tdmg.dmg_type)
						end
					end)
				end
			end
		else
			if math.random(self.Teleport_MinChance, self.Teleport_MaxChance) == self.Teleport_Chance then
				local tdmg = self.Teleport_Damage
				local pos = self:TeleportMPosCheck()
				if pos != nil then
					local oldpos = self:GetPos()
					if #self.Teleport_OutEffects > 0 then
						self:EmitEffect(table.Random(self.Teleport_OutEffects), oldpos, self, self.Teleport_EffectsLifeTime)
					end
					if #self.Teleport_OutSounds > 0 then
						self:MonsterSound(table.Random(self.Teleport_OutSounds),self:GetPos())
					end
					self:Timer(0.2,function()
						self:SetPos(pos)
						if #self.Teleport_Sounds > 0 then
							self:MonsterSound(table.Random(self.Teleport_Sounds),self:GetPos())
						end
						if #self.Teleport_Effects > 0 then
							self:EmitEffect(table.Random(self.Teleport_Effects), pos, self, self.Teleport_EffectsLifeTime)
						end
						if tdmg.can_dmg == true then
							self:ExplosionDamage(tdmg.dmg, tdmg.dmg_radius, self:GetPos(), tdmg.dmg_type)
						end
					end)
				end
			end
		end
	end
end

//Toxic ambience

function ENT:ToxicAmbience()
      	if not (self:GetCooldown("ToxicAmbienceTimer") > 0) then
      		self:SetCooldown("ToxicAmbienceTimer", self.ToxicAmbience_Timer)
		for k,toxin in pairs(ents.FindInSphere(self:GetPos(), self.ToxicAmbience_Radius)) do
			if IsValid(toxin) and not self:IsAlly(toxin) then
				if toxin.Health and toxin:Health() > 0 then
					if IsValid(toxin:GetPhysicsObject()) and self.ToxicAmbience_AffectProps == true then
						toxin:TakeDamage(self.ToxicAmbience_Damage, self, self)
					end

					local dmg = DamageInfo()
					dmg:SetDamage(self.ToxicAmbience_Damage)
					dmg:SetDamageType(self.ToxicAmbience_DamageType)
					dmg:SetAttacker(self)
					dmg:SetReportedPosition(self:GetPos())

					toxin:TakeDamageInfo(dmg)
				end
			end
		end
	end
end

//Telekinesis

function ENT:CustomRelationship(ent)
	if isfunction(ent.GetActor) then
		self:_SetRelationship(ent, 1, 0)
		ent:GetActor():AddEnemy(self)
		return 1, 0
	end
end

function ENT:OnRelationshipChange(ent, curr, disp)
	if isfunction(ent.GetActor) then
		self:_SetRelationship(ent, 1, 0)
		ent:GetActor():AddEnemy(self)
	end
end

--[[
	if isfunction(v.GetActor) then
		self:_SetRelationship(v, 1, 10)
	end
]]

function ENT:Telekinesis()
	local radius = self.Telekinesis_Radius

	local destroyList = {}
	for k,v in ipairs(ents.FindInSphere(self:GetPos(),10)) do --Using collision boxes
		if v != self and (v:IsPlayer() or v:GetPhysicsObject():IsValid()) then
			destroyList[v] = true
		end
	end
	
	local pullDist = (radius*20)
	local pullDistSqr = pullDist^2
	local unfreezeDist = (radius*2)^2
	if self.Telekinesis_AllowMultipleEnemies == true then
	for k,v in ipairs(ents.FindInSphere(self:GetPos(),pullDist)) do
		if v != self and (not self:IsAlly(v)) and v:IsValid() then
			local dist = self:GetPos():DistToSqr(v:GetPos())
			local power = (1-dist/pullDistSqr)*self.Telekinesis_Power
			local vel = ((self:GetPos()-v:GetPos()):GetNormalized()*power)
	--[[		
	if isfunction(v.GetActor) then
		self:_SetRelationship(v, 1, 10)
	end
	]]
			local inKillRange = destroyList[v]
			if v:IsPlayer() or v:IsNPC() then
				v:SetLocalVelocity(v:GetVelocity()+vel)
			elseif v.IsLambdaPlayer then
				if v.loco then 
					if v.loco:IsOnGround() then
						v.loco:SetJumpHeight(100)
						v.loco:Jump()
					end
					v.loco:SetVelocity(v:GetVelocity()+vel)
				end
			end

			if self.Telekinesis_AllowProps then
			if v != self and (IsValid(v:GetPhysicsObject())) and IsValid(v) then
				local dist = self:GetPos():DistToSqr(v:GetPos())
				local power = (1-dist/pullDistSqr)*self.Telekinesis_Power
				local vel = ((self:GetPos()-v:GetPos()):GetNormalized()*power)

				if dist < unfreezeDist then
					if !v:GetPhysicsObject():IsMotionEnabled() then
						v:GetPhysicsObject():EnableMotion(true)
					end
					constraint.RemoveAll(v)
				end
				v:GetPhysicsObject():AddVelocity(vel)
			end
			end
		end
	end
	else
	for k,v in ipairs(ents.FindInSphere(self:GetPos(),pullDist)) do
		if v != self and (v == self:GetEnemy()) and v:IsValid() then
			local dist = self:GetPos():DistToSqr(v:GetPos())
			local power = (1-dist/pullDistSqr)*self.Telekinesis_Power
			local vel = ((self:GetPos()-v:GetPos()):GetNormalized()*power)
			
			local inKillRange = destroyList[v]
			if v:IsPlayer() or v:IsNPC() then
				v:SetLocalVelocity(v:GetVelocity()+vel)
			elseif v.IsLambdaPlayer then
				if v.loco then 
					if v.loco:IsOnGround() then
						v.loco:SetJumpHeight(100)
						v.loco:Jump()
					end
					v.loco:SetVelocity(v:GetVelocity()+vel)
				end
			end
			if self.Telekinesis_AllowProps then
			if v != self and (IsValid(v:GetPhysicsObject())) and IsValid(v) then
				local dist = self:GetPos():DistToSqr(v:GetPos())
				local power = (1-dist/pullDistSqr)*self.Telekinesis_Power
				local vel = ((self:GetPos()-v:GetPos()):GetNormalized()*power)

				if dist < unfreezeDist then
					if !v:GetPhysicsObject():IsMotionEnabled() then
						v:GetPhysicsObject():EnableMotion(true)
					end
					constraint.RemoveAll(v)
				end
				v:GetPhysicsObject():AddVelocity(vel)
			end
			end
		end
	end
	end
end

//Effects

function ENT:ChooseExplosion()
      	if not (self:GetCooldown("ChooseExplosionTimer") > 0) then
		local explosion = table.Random(self.Explosions)
		self:SetCooldown("ChooseExplosionTimer", explosion.usable_time)
		self:SetCooldown("ExplosionTimer", explosion.timer)
		self.CurrentExplosion = explosion
	end
end

function ENT:ExplosionFunction(expdata, isshockwave, shockwave_index, shockwave_distance, shockwave_direction)
	if self:HasEnemy() and IsValid(self:GetEnemy()) then
		if shockwave_index != nil and shockwave_index > expdata.shockwaves_count then
			self:SetCooldown("ExplosionTimer", expdata.timer)
		else
      		if shockwave_index != nil or not (self:GetCooldown("ExplosionTimer") > 0) then
			if self:GetPos():Distance(self:GetEnemy():GetPos()) >= expdata.distance_check then
				self:SetCooldown("ExplosionTimer", expdata.timer)
		
				if shockwave_index == nil and table.Count(expdata.animations) > 0 then
					self:CallInCoroutine(function(self, delay)
						if delay > 0.1 then return end		
						if self:IsPossessed() then
							self:PlaySequenceAndMove(table.Random(expdata.animations),expdata.anim_rate*self:GetARMultiplier(),self.PossessionFaceForward)
						else
							self:PlaySequenceAndMove(table.Random(expdata.animations),expdata.anim_rate*self:GetARMultiplier(),self.FaceEnemy)
						end
					end)
				end

				if table.Count(expdata.sound) > 0 then
					if expdata.startpos_inenemy == true then
						sound.Play(table.Random(expdata.sound), self:ShockwaveDirectionCheck(self:GetEnemy():GetPos(), shockwave_index, shockwave_distance, shockwave_direction))
					else
						sound.Play(table.Random(expdata.sound), self:ShockwaveDirectionCheck(self:GetPos(), shockwave_index, shockwave_distance, shockwave_direction))
					end
				end

				if table.Count(expdata.particle) > 0 then
					if expdata.startpos_inenemy == true then
						self:EmitEffect(table.Random(expdata.particle), self:ShockwaveDirectionCheck(self:GetEnemy():GetPos(), shockwave_index, shockwave_distance, shockwave_direction), self, expdata.particle_life)
					else
						self:EmitEffect(table.Random(expdata.particle), self:ShockwaveDirectionCheck(self:GetPos(), shockwave_index, shockwave_distance, shockwave_direction), self, expdata.particle_life)
					end
				end

				if expdata.startpos_inenemy == true then
					self:ExplosionDamage(expdata.dmg, expdata.dmg_radius, self:ShockwaveDirectionCheck(self:GetEnemy():GetPos(), shockwave_index, shockwave_distance, shockwave_direction), expdata.dmg_type)
				else
					self:ExplosionDamage(expdata.dmg, expdata.dmg_radius, self:ShockwaveDirectionCheck(self:GetPos(), shockwave_index, shockwave_distance, shockwave_direction), expdata.dmg_type)
				end

				if expdata.is_shockwave == true then
					self:Timer(expdata.shockwaves_timer, function()
					if shockwave_index == nil then
						self:ExplosionFunction(expdata, expdata.is_shockwave, 2, expdata.shockwaves_distance, ((self:GetEnemy():GetPos() - self:GetPos()):Angle()):Forward())
					elseif shockwave_direction != nil then
						self:ExplosionFunction(expdata, expdata.is_shockwave, shockwave_index + 1, expdata.shockwaves_distance, shockwave_direction)
					else
						self:ExplosionFunction(expdata, expdata.is_shockwave, shockwave_index + 1, expdata.shockwaves_distance, ((self:GetEnemy():GetPos() - self:GetPos()):Angle()):Forward())
					end
					end)
				end
			end
		end
		end
	end
end

function ENT:ShockwaveDirectionCheck(pos, shockwave_index, shockwave_distance, shockwave_direction)
	if shockwave_index != nil then
		local newpos = pos + shockwave_direction*(shockwave_distance*shockwave_index-1)
		if newpos != nil then
			return newpos
		else
			return pos
		end
	else
		return pos
	end
end

function ENT:HealFunction(healdata)
	local hpos = self:GetPos() + healdata.effect_pos
	if self:IsPossessed() then
		self:PlaySequenceAndMove(table.Random(healdata.animations),healdata.anim_rate*self:GetARMultiplier(),self.PossessionFaceForward)
	else
		self:PlaySequenceAndMove(table.Random(healdata.animations),healdata.anim_rate*self:GetARMultiplier(),self.FaceEnemy)
	end

	if table.Count(healdata.sound) > 0 then
		sound.Play(table.Random(healdata.sound), hpos)
	end

	if table.Count(healdata.particle) > 0 then
		self:EmitEffect(table.Random(healdata.particle), hpos, self, healdata.particle_life)
	end
	if healdata.can_heal_allies == true then
		self:AddHealth(healdata.heal*self:GetDamageAttackMultiplier())
		for k,healedactor in pairs(ents.FindInSphere(hpos, healdata.heal_radius)) do
			if IsValid(healedactor) and self:IsAlly(healedactor) then
				if healedactor.IsDrGNextbot then
					healedactor:AddHealth(healdata.heal*self:GetDamageAttackMultiplier())
				end
			end
		end
	else
		self:AddHealth(healdata.heal*self:GetDamageAttackMultiplier())
	end
end

function ENT:MonsterSound(msound, mpos)
	if not IsValid(msound) then return end
	sound.Play(msound,mpos)
end

function ENT:EmitEffect(particle, pos, parent, lifetime)
	if particle == nil then return end
	local effect = ents.Create("info_particle_system")
	effect:SetKeyValue("effect_name", particle)
	if pos != nil then
		effect:SetPos(pos)
	else
		effect:SetPos(self:GetPos())
	end
	if parent != nil then
		effect:SetParent(parent)
	else
		effect:SetParent(self)
	end
	effect:Spawn()
	effect:Activate()
	effect:Fire("Start","",0)
	if lifetime != nil then
		effect:Fire("Kill","",lifetime)
	else
		effect:Fire("Kill","",4.5)
	end
end

function ENT:ExplosionDamage(dmg, radius, pos, dmg_type)
	if dmg  == nil then
		dmg = 300
	end
	if radius  == nil then
		radius = 100
	end
	if pos == nil then
		pos = self:GetPos()
	end
	if dmg_type == nil then
		dmg_type = DMG_BLAST
	end
	for k,explodedactor in pairs(ents.FindInSphere(pos, radius)) do
		if IsValid(explodedactor) then
			exp_tr = util.TraceLine({
				start = pos,
				endpos = explodedactor:GetPos(),
			})
			if IsValid(explodedactor) and (not self:IsAlly(explodedactor)) and (not exp_tr.HitWorld) then
				local edmg = DamageInfo()
				edmg:SetDamage(dmg*self:GetDamageAttackMultiplier())
				edmg:SetDamageType(dmg_type)
				edmg:SetAttacker(self)
				edmg:SetReportedPosition(pos)
				explodedactor:TakeDamageInfo(edmg)			
			end
		end
	end
end

-- Helpers --

function ENT:AttemptJumpAtTarget()
	-- No double-jumping.
if self.CanJumpOnChase == true then
if not self.AdvancedLeap then
	if not self:HasEnemy() then return end
	if not self:IsOnGround() then return end
	if not IsValid(self:GetEnemy()) then return end

	local targetPos = self:GetEnemy():GetPos()
	local xyDistSqr = (targetPos - self:GetPos()):Length2DSqr()
	local zDifference = targetPos.z - self:GetPos().z
	if xyDistSqr <= math.pow(self.LeapRange + 200, 2)
		and zDifference >= self.MeleeAttackRange
	then
		--TODO: Set up jump so target lands on parabola.
		if self.MaxJumpRange < 1 then
		local jumpHeight = zDifference + 70
		self.loco:SetJumpHeight(jumpHeight)
		self.loco:Jump()
		self.loco:SetJumpHeight(300)
		else
		local jumpHeight = math.Clamp(zDifference, 0, self.MaxJumpRange) + 70
		self.loco:SetJumpHeight(jumpHeight)
		self.loco:Jump()
		self.loco:SetJumpHeight(300)
		end
	end
else
	if not self:HasEnemy() then return end
	if not IsValid(self:GetEnemy()) then return end
	if not self:IsOnGround() then return end

	local targetPos = self:GetEnemy():GetPos()
	local targetPos_s = self:GetEnemy():GetPos()+self:GetEnemy():GetVelocity()
	local monster_s = self:GetPos()+self:GetVelocity()
	if monster_s == nil then monster_s = self:GetPos() end
	if targetPos_s == nil then targetPos_s = targetPos end
	local xyDistSqr = (targetPos - self:GetPos()):Length2DSqr()
	local xyDistSqr_s = (targetPos_s - monster_s):Length2DSqr()
	local zDifference = targetPos.z - self:GetPos().z
	local zDifference_s = targetPos_s.z - self:GetPos().z
	if xyDistSqr_s == nil then zDifference_s = zDifference end
	local jump_calculate = ((xyDistSqr_s <= math.pow(self.LeapRange + self.ReachEnemyRange*self:GetScale(), 2) and self:GetVelocity():Length() >= 1) or xyDistSqr <= math.pow(self.MeleeAttackRange, 2)) and zDifference >= self.MeleeAttackRange
	if jump_calculate then
		--TODO: Set up jump so target lands on parabola.
		if self.MaxJumpRange < 1 then
		local jumpHeight = zDifference + 70
		self.loco:SetJumpHeight(jumpHeight)
		self.loco:Jump()
		self.loco:SetJumpHeight(300)
		else
		local jumpHeight = math.Clamp(zDifference, 0, self.MaxJumpRange) + 70
		self.loco:SetJumpHeight(jumpHeight)
		self.loco:Jump()
		self.loco:SetJumpHeight(300)
		end
	end
end
end
end

function ENT:FreezePlayer(ent, exec)
	if IsValid(ent) and ent:IsPlayer() then
		ent:Freeze(true)
		ent:StripWeapons()
		ent:SetNoDraw(true)
		self:SetIgnored(ent, true)
		self.cent = ents.Create("prop_physics")
		self.cent:SetModel("models/dav0r/camera.mdl")
		self.cent:SetRenderMode(1)
		self.cent:SetColor(Color(255, 255, 255, 0))
		self.cent:DrawShadow(false)
		self.cent:SetMoveType( MOVETYPE_NONE )
		self.cent:SetParent(self, self:LookupAttachment("camera"))
		self.cent:SetLocalPos(Vector(0, 0, 0))
		self.cent:SetAngles(Angle(self:GetAngles().x, self:GetAngles().y, self:GetAngles().z) + Angle(0,0,0))
		if !IsValid(self.cent) then return end
		ent:SetViewEntity(self.cent)
	end
end

function ENT:OnOtherKilled(ent, dmg)
	local attacker = dmg:GetAttacker()
	if IsValid(attacker) and attacker == self and self.CanUseInfectionSystem == true then
	local nugget = ents.Create(self.Infection_NpcClass)
		if not IsValid(nugget) then return end
		nugget:SetPos(ent:GetPos())
		if self.Infection_CopyModel then
			inftyp = ents.Create("base_anim")
			inftyp:SetNoDraw(false)
			inftyp:DrawShadow(true)
			inftyp:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			inftyp:SetOwner( nugget )
			inftyp:SetModel( ent:GetModel() )

			inftyp:SetSkin(ent:GetSkin())
			inftyp:SetMaterial(ent:GetMaterial())
			inftyp:SetColor(ent:GetColor())
			inftyp:SetBodygroup(1,ent:GetBodygroup(1))
			inftyp:SetBodygroup(2,ent:GetBodygroup(2))
			inftyp:SetBodygroup(3,ent:GetBodygroup(3))
			inftyp:SetBodygroup(4,ent:GetBodygroup(4))
			inftyp:SetBodygroup(5,ent:GetBodygroup(5))
			inftyp:SetBodygroup(6,ent:GetBodygroup(6))
			inftyp:SetBodygroup(7,ent:GetBodygroup(7))
			inftyp:SetBodygroup(8,ent:GetBodygroup(8))
			inftyp:SetBodygroup(9,ent:GetBodygroup(9))
			inftyp:Spawn()
			inftyp:SetSolid(SOLID_NONE)
			inftyp:SetParent(nugget)
			inftyp:Fire("setparentattachment", nugget:GetAttachments()[1])
			inftyp:AddEffects(EF_BONEMERGE)
			nugget:SetMaterial("Models/effects/vol_light001")
			nugget:DrawShadow(false)
		end
		nugget:SetAngles(ent:GetAngles())
		nugget.Factions = self:GetFactions()
		nugget:Spawn()
		nugget:SetCreator(self:GetCreator())
		if IsValid(self:GetCreator()) then
        		self:GetCreator():DrG_AddUndo(nugget, "NPC", self.PrintName)
		end
	if IsValid(ent) then
		ent:Remove()
	end
	end
end

function ENT:Monster_AnimState(animt)
	if animt.onlystate then 
		if animt.state == self:GetMonsterState() then 
			return true 
		else 
			return false 
		end
	else 
		return true
	end
end

function ENT:SelectExecution(target) --Checks what execution do
	if not self:CanExecute() then self:CharacterAttack() return end
	local execution_list = {}
	for e, exec in ipairs(self.Executions) do
		if self:Monster_AnimState(exec) then
			if exec.condition then
				if isfunction(exec.condition) then
					if exec.condition(self, target) then
						table.insert(execution_list, exec)
					end
				end
			else
				table.insert(execution_list, exec)
			end
		end
	end

	if #execution_list > 0 then
		self:Execution(target, table.Random(execution_list))
	else
		self:CharacterAttack()
	end
end

function ENT:MonsterRoar(target)
	if not IsValid(target) then return end
	if not istable(self.Roars) then return end

	local roar_list = {}
	for r, roar in ipairs(self.Roars) do
		if self:Monster_AnimState(roar) then
			if roar.condition then
				if isfunction(roar.condition) then
					if roar.condition(self, enemy) then
						table.insert(roar_list, roar)
					end
				end
			else
				table.insert(roar_list, roar)
			end
		end
	end

	if #roar_list > 0 then
		current_roar = table.Random(roar_list)
		if isstring(current_roar.seq) then
			self:CallInCoroutine(function(self, delay)
				if delay > 0.1 then return end
				self:PlaySequenceAndMove(current_roar.seq)
			end)
		end
		if isstring(current_roar.sound) then
			self:EmitSound(current_roar.sound)
		end
		if current_roar.roarfunc then
			if isfunction(current_roar.roarfunc) then
				current_roar.roarfunc(self, target)
			end
		end
	end
end

function ENT:CharacterAttack()
	if not istable(self.Monster_MeleeAttacks) then return end
	if self.Monster_HasMeleeAttacks == true then
	local attack_list = {}
	for k,attack in ipairs(self.Monster_MeleeAttacks) do
		local attack_con = function() 
			if isfunction(attack.condition) then 
				return attack.condition(self,self:GetEnemy())
			end
		end
		if self:Monster_AnimState(attack) then
			if isfunction(attack.condition) and attack.condition(self,self:GetEnemy()) then
				if (self:IsOnGround() and self:IsCrouching()) and attack.attack_incrouch == true then
					table.insert(attack_list, attack)
				elseif (self:IsOnGround() and not self:IsCrouching()) and attack.attack_inground == true then
					table.insert(attack_list, attack)
				elseif (not self:IsOnGround()) and attack.attack_inair == true then
					table.insert(attack_list, attack)
				end
			elseif not isfunction(attack.condition) then
				if (self:IsOnGround() and self:IsCrouching()) and attack.attack_incrouch == true then
					table.insert(attack_list, attack)
				elseif (self:IsOnGround() and not self:IsCrouching()) and attack.attack_inground == true then
					table.insert(attack_list, attack)
				elseif (not self:IsOnGround()) and attack.attack_inair == true then
					table.insert(attack_list, attack)
				end
			end
		end
	end

	if table.Count(attack_list) > 0 then
		local current_attack = table.Random(attack_list)
		if self:IsPossessed() then
			self:PlaySequenceAndMove(table.Random(current_attack.attack_anim),current_attack.attack_anim_rate*self:GetARMultiplier(),self.PossessionFaceForward)
		else
			self:PlaySequenceAndMove(table.Random(current_attack.attack_anim),current_attack.attack_anim_rate*self:GetARMultiplier(),self.FaceEnemy)
		end
	end
	end
end

function ENT:ChangeRangeAttackByForceCheck()
	local f_current_attack = self.CurrentRangeAttack
	if table.Count(f_current_attack) <= 0 then
		return true
	elseif f_current_attack.attack_inground == true and self:IsOnGround() then
		return true
	elseif f_current_attack.attack_inair == true and (not self:IsOnGround()) then
		return true
	elseif f_current_attack.attack_incrouch == true and (self:IsOnGround() and self:IsCrouching()) then
		return true
	end
end

function ENT:SecondaryCharacterAttack()
	if not istable(self.Monster_RangeAttacks) then return end
	if self.Monster_HasRangeAttacks == true then
      	if not (self:GetCooldown("ChangeRangeAttack") > 0) or self:ChangeRangeAttackByForceCheck() then
		local attack_list = {}
		for k,attack in ipairs(self.Monster_RangeAttacks) do
			if self:Monster_AnimState(attack) then
				if isfunction(attack.condition) and attack.condition(self,self:GetEnemy()) then
					if (self:IsOnGround() and self:IsCrouching()) and attack.attack_incrouch == true then
						table.insert(attack_list, attack)
					elseif (self:IsOnGround() and not self:IsCrouching()) and attack.attack_inground == true then
						table.insert(attack_list, attack)
					elseif (not self:IsOnGround()) and attack.attack_inair == true then
						table.insert(attack_list, attack)
					end
				elseif not isfunction(attack.condition) then
					if (self:IsOnGround() and self:IsCrouching()) and attack.attack_incrouch == true then
						table.insert(attack_list, attack)
					elseif (self:IsOnGround() and not self:IsCrouching()) and attack.attack_inground == true then
						table.insert(attack_list, attack)
					elseif (not self:IsOnGround()) and attack.attack_inair == true then
						table.insert(attack_list, attack)
					end
				end
			end
		end
		if #attack_list > 0 then
			local current_attack = table.Random(attack_list)
			self.CurrentRangeAttack = current_attack
			self:SetCooldown("ChangeRangeAttack", math.random(current_attack.attack_min_skill_usable_timer, current_attack.attack_max_skill_usable_timer))
		end
	end
	if istable(self.CurrentRangeAttack) and self.CurrentRangeAttack.skill_profile then
	local a_current_attack = self.CurrentRangeAttack
	
	if #a_current_attack.attack_anim > 0 then
      		if not (self:GetCooldown("RangeAttack_Timer") > 0) then
			self:SetCooldown( "RangeAttack_Timer", math.random(a_current_attack.attack_min_usable_timer, a_current_attack.attack_max_usable_timer) )
			if self:IsPossessed() then
				self:PlaySequenceAndMove(table.Random(a_current_attack.attack_anim),a_current_attack.attack_anim_rate*self:GetARMultiplier(),self.PossessionFaceForward)
			else
				self:PlaySequenceAndMove(table.Random(a_current_attack.attack_anim),a_current_attack.attack_anim_rate*self:GetARMultiplier(),self.FaceEnemy)
			end
		end
	else
      		if not (self:GetCooldown("RangeAttack_Timer") > 0) then
			local r_attack_timer = table.Random(a_current_attack.attack_timers)
			self:SetCooldown( "RangeAttack_Timer", r_attack_timer.attack_timer )
			self:ProjectileFunction(r_attack_timer.proj_class, table.Random(r_attack_timer.proj_options))
		end
	end
	end

	end
end

function ENT:ProjectileFunction(proj_class, proj_options)
	if not isfunction(proj_options.onspawnproj_func) then proj_options.onspawnproj_func = function() end end
	self.Proj = self:CreateProjectile(nil, {}, proj_class)
	if IsValid(self.Proj) then
	self.Contact_IgnoredEntities[self.Proj] = true
	self.Proj.Contact_IgnoredEntities[self] = true
	local spawn_attach = nil
	local new_spawn_pos = self:GetForward()*proj_options.proj_spawn_pos.x + self:GetRight()*proj_options.proj_spawn_pos.y + self:GetUp()*proj_options.proj_spawn_pos.z
	proj_options.onspawnproj_func(self, self.Proj, proj_class, proj_options)
	if table.Count(proj_options.proj_spawn_attachments) > 0 then
		spawn_attach = table.Random(proj_options.proj_spawn_attachments)
		self.Proj:SetPos(self:GetAttachment(self:LookupAttachment(spawn_attach)).Pos + new_spawn_pos)
	else
		self.Proj:SetPos(self:GetPos() + new_spawn_pos)
	end
	if self.Proj.SetDamageAttackMultiplier then
		self.Proj:SetDamageAttackMultiplier(self:GetDamageAttackMultiplier())
	end
	if self.Proj.Physgun then
		self.Proj.Physgun = proj_options.proj_physgun
	end
	if self.Proj.Gravgun then
		self.Proj.Gravgun = proj_options.proj_gravgun
	end
	if self.Proj.Gravity then
		self.Proj.Gravity = proj_options.proj_gravity
	end
	if table.Count(proj_options) > 0 then
		if self.Proj.InitOptions then
			self.Proj:InitOptions(proj_options, spawn_attach, proj_options.proj_spawn_pos)
		end
	end
	if not self:IsPossessed() then
		self.Proj:AimAt(self:GetEnemy(), proj_options.proj_speed)
	else
		self.Proj:SetVelocity(self:GetPossessor():GetAimVector()*proj_options.proj_speed)
	end
	end
end

function ENT:AttackFunction(attack_func)
	if not isfunction(attack_func.onattack_func) then attack_func.onattack_func = function() end end
	if not isfunction(attack_func.afterattack_func) then attack_func.afterattack_func = function(self, hit) end end
	if not isfunction(attack_func.onswing_func) then attack_func.onswing_func = function() end end
	if not isfunction(attack_func.onhit_func) then attack_func.onhit_func = function() end end
	attack_func.onattack_func(self, attack_func)
	self:Attack({
		damage = math.random(attack_func.min_dmg,attack_func.max_dmg)*self:GetDamageAttackMultiplier(),
		viewpunch = attack_func.viewpunch,
		type = attack_func.dmg_type,
		range = attack_func.dmg_range,
		angle = attack_func.dmg_angle,
	}, function(self, hit)
		attack_func.afterattack_func(self, hit)
		if #hit == 0 then 
			attack_func.onswing_func(self, attack_func)
			if table.Count(attack_func.swing_sounds) > 0 then
				self:EmitSound(table.Random(attack_func.swing_sounds))
			end
		return end 
		attack_func.onhit_func(self, hit, attack_func)
		if table.Count(attack_func.hit_sounds) > 0 then
			self:EmitSound(table.Random(attack_func.hit_sounds))
		end
		for e,hitent in pairs(hit) do
			if IsValid(self) and IsValid(hitent) then
				if hitent.IsDrGNextbot then
					local impulse = attack_func.hit_impulse
					hitent:SetVelocity( self:GetForward() * impulse.x +self:GetRight() * impulse.y +self:GetUp() * impulse.z)
					hitent:Jump(impulse.z)
				else
					local impulse = attack_func.hit_impulse
					hitent:SetVelocity( self:GetForward() * impulse.x +self:GetRight() * impulse.y +self:GetUp() * impulse.z)
				end
			end
		end
	end)
end

function ENT:Footstep_ReturnBone(footstep)
	if footstep.foot_bone != nil then
		return self:GetBonePosition(self:LookupBone(footstep.foot_bone))
	else
		return self:GetPos()
	end
end

function ENT:Footstep(footstep)
	local fpos = self:Footstep_ReturnBone(footstep)
	if footstep.shake == true then
		util.ScreenShake( self:GetPos(), footstep.shake_amplitude, footstep.shake_frequency, footstep.shake_duration, footstep.shake_radius )
	end
	if table.Count(footstep.sound) > 0 then
		sound.Play(table.Random(footstep.sound), fpos)
	end
	if table.Count(footstep.effect) > 0 then
		local meta_effect = table.Random(footstep.effect)
		if meta_effect.effect != nil then
			local effect = ents.Create("info_particle_system")
			effect:SetKeyValue("effect_name",meta_effect.effect)
			effect:SetPos(fpos)
			if meta_effect.effect_parent then
				if meta_effect.effect_parent == true then
					effect:SetParent(self)
				end
			end
			effect:Spawn()
			effect:Activate()
			effect:Fire("Start","",0)
			effect:Fire("Kill","",meta_effect.effect_lifetime)
		end
	end
	local fdmg = footstep.dmg_data
	for k,explodedactor in pairs(ents.FindInSphere(fpos, fdmg.dmg_radius)) do
		if not IsValid(explodedactor) then return end
		exp_tr = util.TraceLine({
			start = fpos,
			endpos = explodedactor:GetPos(),
		})
		if IsValid(explodedactor) and (not self:IsAlly(explodedactor)) and (not exp_tr.HitWorld) then
			local edmg = DamageInfo()
			edmg:SetDamage(fdmg.dmg*self:GetDamageAttackMultiplier())
			edmg:SetDamageType(fdmg.dmg_type)
			edmg:SetAttacker(self)
			edmg:SetReportedPosition(fpos)
			explodedactor:TakeDamageInfo(edmg)
		elseif IsValid(explodedactor) and not (not exp_tr.HitWorld) then
			if not self.Contact_IgnoredEntities[explodedactor] then
			if explodedactor:GetClass() == "prop_physics" or explodedactor:GetClass() == "prop_ragdoll" then
				constraint.RemoveAll(explodedactor)

				explodedactor:TakeDamage(fdmg.dmg, self, self)

				local phys = explodedactor:GetPhysicsObject()
				if not IsValid(phys) then return end

				if explodedactor:IsRagdoll() then
					for b = 0,explodedactor:GetBoneCount() do
						physbone = explodedactor:GetPhysicsObjectNum(explodedactor:TranslateBoneToPhysBone(b))
						if IsValid(physbone) then physbone:EnableMotion(true) end
					end
					physbone = nil
				else
					phys:EnableMotion(true)
				end
				phys:ApplyForceOffset((explodedactor:GetPos() - self:GetPos()):GetNormalized() * 1e7, explodedactor:GetPos())
			end
			end			
		end
	end
end

function ENT:Execution(ent, exec)
	if not isfunction(exec.ontrygrab_func) then exec.ontrygrab_func = function() end end
	if not isfunction(exec.ongrab_func) then exec.ongrab_func = function() end end
	if not isfunction(exec.onexecutedbodypart_func) then exec.onexecutedbodypart_func = function() end end
	self.CurrentExecution = exec
	local grbc_tr = util.TraceLine({
		start = self:GetPos()+(self:GetForward()*-self.CollisionBounds.x),
		endpos = ent:GetPos()
	})
	local grabbed = false
	local succeed = false
	exec.ontrygrab_func(self, ent, exec)
	self:PlaySequenceAndMove(exec.grab_seq, exec.grab_rate*self:GetARMultiplier(), function(self, cycle)
		if grabbed or cycle < exec.grab_cycle then return end
		grabbed = true
		if not IsValid(ent) then return end
		if self:GetHullRangeSquaredTo(ent) > exec.grab_distance^2 then return end
		if not grbc_tr.Entity == ent then return end
		succeed = true
		
		local dmg = DamageInfo() dmg:SetAttacker(self) dmg:SetInflictor(self)
  local function Lambda_RagdollDeath(ent, dmg)
    if ent:IsPlayer() then
      if not ent:Alive() then return NULL end
      ent:KillSilent()
    else
      ent:AddFlags(FL_TRANSRAGDOLL)
      ent:Remove()
    end
		if ent.IsLambdaPlayer and  dmg then
			ent:SetMaterial("Models/effects/vol_light001")
      --ent:PlaySoundFile( ent:GetVoiceLine( "death" ) )
			ent:LambdaOnKilled( dmg, false )
    elseif dmg then
    	ent:DrG_DeathNotice(dmg:GetAttacker(), dmg:GetInflictor())
    end

    local ragdoll = ent:DrG_CreateRagdoll(dmg)
    if not ent:IsPlayer() and IsValid(ragdoll) then
      undo.ReplaceEntity(ent, ragdoll)
      cleanup.ReplaceEntity(ent, ragdoll)
    end
    return ragdoll
  end

  	--[[
		if ent.IsLambdaPlayer then
			ent:LambdaOnKilled( dmg, false )
		end
		]]

		--local ragdoll = ent:DrG_RagdollDeath(dmg)
		local ragdoll = Lambda_RagdollDeath(ent, dmg)
		
		--[[
		local dmg = DamageInfo() dmg:SetAttacker(self) dmg:SetInflictor(self)
		if ent.IsLambdaPlayer then
			dmg:SetDamage(999999)
			dmg:SetDamageType(DMG_BLAST)
			ent:DrawShadow(false)
			ent:SetMaterial("Models/effects/vol_light001")
			ent:LambdaOnKilled( dmg, false )
            ent:PlaySoundFile( ent:GetVoiceLine( "death" ) )
		end
		local ragdoll = ent:DrG_RagdollDeath(dmg)
		]]
		
		grab_parts = exec.grab_parts

		for v,part in pairs(grab_parts) do
			actualragdoll = self:GrabRagdoll(ragdoll, part.bone, part.attach)
		end

		if exec.firstperson_jumpscare == true then
		self:SetGrabbedEnemy(ent)
        	if ent:IsPlayer() then self:SetGrabbedPlayer(ent) self:FreezePlayer(ent, exec) end
		else
		if ent:IsPlayer() then ent:SetPos(self:GetPos() + (self:GetForward()*exec.exec_camera_distance*self:GetScale()) + exec.thirdperson_camerapos*self:GetScale()) end
		end
		return true
	end)
	if succeed then
		self:SetIsExecuting(true)
		if self.UsePackingForTableFunc then
			--[[
				print("OJOLERAAAAAAAAAAA")
				print(self)
				print(ent)
				print(exec)
			]]
			local execpack = table.Pack( self, ent, exec )
			exec.ongrab_func( execpack )
		else
			exec.ongrab_func(self, ent, exec)
		end
		if table.Count(exec.exec_player_scream) > 0 then
			if (ent:IsPlayer() and !ent:Alive()) then
				self:EmitSound(table.Random(exec.exec_player_scream),0,100)
			end
		end
		if table.Count(exec.exec_monster_roar) > 0 then
			self:EmitSound(table.Random(exec.exec_monster_roar),0,100)
		end
		for v,event in pairs(exec.exec_timers) do
		if not isfunction(event.beforeexec_func) then event.beforeexec_func = function() end end
		if not isfunction(event.afterexec_func) then event.afterexec_func = function() end end
		event.beforeexec_func(self, ent, bodysinhand)
		self:Timer(event.exec_timer,function()
			if table.Count(event.exec_break_sound) > 0 then
			self:EmitSound(table.Random(event.exec_break_sound),511,100)
			end
			if table.Count(event.exec_blood_particle) > 0 then
			ParticleEffectAttach(table.Random(event.exec_blood_particle),PATTACH_POINT_FOLLOW,self,event.exec_blood_particle_attach)
			end
			if (ent:IsPlayer() and !ent:Alive()) then
				ent:ScreenFade(SCREENFADE.IN,Color(255,0,0,255),0.3,0.2)
				self:EmitSound("player/pl_pain"..math.random(5,7)..".wav",511,100)
			end
			if event.exec_eatwhole == true then
				exec.onexecutedbodypart_func(self, ent, exec, true)
				for bodysinhand, attachs in pairs(self._DrGBaseGrabbedRagdolls) do
					if IsValid(bodysinhand) then
						SafeRemoveEntity(bodysinhand)
					end
				end
			else
			self:DropAllRagdolls()
			if IsValid(actualragdoll) then
				actualragdoll:Fire("fadeandremove",1,10)
				for n,bone in pairs(event.exec_bonestobreak) do
					local BreakedBone = actualragdoll:DrG_SearchBone(bone)
					if BreakedBone then
						exec.onexecutedbodypart_func(self, ent, exec, false, BreakedBone)
						actualragdoll:ManipulateBoneScale(BreakedBone, Vector(0,0,0))
					end
				end
			end
			end
		end)
		event.afterexec_func(self, ent)
		end
		self:PlaySequenceAndMove(exec.exec_anim,exec.exec_anim_rate)
		self:SetIsExecuting(false)
	end
end

function ENT:GrabAndThrow(ent, exec)
	if not isfunction(exec.ontrygrab_func) then exec.ontrygrab_func = function() end end
	if not isfunction(exec.ongrab_func) then exec.ongrab_func = function() end end
	if not istable(exec.throw_options) then exec.throw_options = {} end
	local grabbed = false
	local succeed = false
	exec.ontrygrab_func(self, ent, exec)
	self:PlaySequenceAndMove(exec.grab_seq, exec.grab_rate*self:GetARMultiplier(), function(self, cycle)
		if grabbed or cycle < exec.grab_cycle then return end
		grabbed = true
		if not IsValid(ent) then return end
		if self:GetHullRangeSquaredTo(ent) > exec.grab_distance^2 then return end
		succeed = true
		
		self:SetCurrentEntityToThrow(ent)
		return true
	end)
	if succeed then
		exec.ongrab_func(self, ent, exec)
		self:Timer(exec.throw_timer,function()
			self:SetCurrentEntityToThrow(NULL)
			if self:HasEnemy() and IsValid(ent) then
				ent:DrG_ThrowAt(self:GetEnemy(), exec.throw_options)
			end
		end)
		self:PlaySequenceAndMove(exec.throw_anim)
	end
end

function ENT:OnContact(ent)
	if ent.IsVJBaseSNPC or ent.CPTBase_NPC then return end
	if self.Contact_CanDestroyProps == true then
	if not IsValid(ent) then return end

	if not self.Contact_IgnoredEntities[ent] then
		if not LiteGibs then
		constraint.RemoveAll(ent)
		end

	if self.Contact_DamageOnContact == true then
	if self.IsToxic == true then
		if ent:Health() > 0 and not (self:IsAlly(ent)) then
			ent:TakeDamage(self.Contact_Damage, self, self)
		end
	else
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) and ent:Health() > 0 and not (ent:IsPlayer() or ent:IsNPC() or ent.IsDrGNextbot or ent.IsVJBaseSNPC or ent.CPTBase_NPC) then
			ent:TakeDamage(self.Contact_Damage, self, self)
		end
	end
	end

	local phys = ent:GetPhysicsObject()
	if not IsValid(phys) then return end

	if ent:IsRagdoll() then
		for b = 0,ent:GetBoneCount() do
			physbone = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(b))
			if IsValid(physbone) then physbone:EnableMotion(true) end
		end
		physbone = nil
	else
		phys:EnableMotion(true)
	end
	phys:ApplyForceOffset((ent:GetPos() - self:GetPos()):GetNormalized() * 1e7, ent:GetPos())
	if ent.IsRope and ent.IsRope == true then
		SafeRemoveEntityDelayed(ent,0.2)
	end
	end
end

end

elseif CLIENT then

local havemodel, torender, mat, beamcol, laser = false, {}, Material"effects/laser1", Color(255, 0, 0)

local thickness = 100
local l_lifetime = 0.2

steamworks.FileInfo(1384226325, function(res)
	if res.installed and not res.disabled then
		havemodel = true
	end
end)

local function RenderMonsterBaseLaser(_, sky)
	if sky then return end
	render.SetMaterial(mat)
	for i = 1,#torender do
		laser = torender[i]
		if not laser or laser[1] < CurTime() then
			table.remove(torender, i)
		else
			render.StartBeam(2)
				render.AddBeam(laser[2], thickness, CurTime(), beamcol)
				render.AddBeam(laser[3], thickness, CurTime() + 1, beamcol)
			render.EndBeam()
		end
	end
	laser = nil
end
hook.Add("PostDrawTranslucentRenderables", "RenderMonsterbaseLaser", RenderMonsterBaseLaser)

local function receive()
	l_lifetime = net.ReadFloat()
	thickness = net.ReadFloat()
	torender[#torender + 1] = {CurTime() + l_lifetime, net.ReadVector(), net.ReadVector()}
	mat = Material(net.ReadString())
	beamcol = net.ReadColor()
end
net.Receive("monsterbaselaser", receive)

    net.Receive('bon_jumpscare_lsd', function()
        local ent = net.ReadEntity()
        local state = net.ReadBool()
        local startTime = CurTime()

        local hookID = "sbon_jumpscare_lsd_" .. LocalPlayer():SteamID()

        hook.Add('CalcView', hookID, function(ply, pos, angles, fov)
            if not IsValid(ply) or not ply:Alive() or not IsValid(ent) or not state then
                hook.Remove('CalcView', hookID)
                if IsValid(ply) then
                    ply:RemoveFlags(FL_NOTARGET)
                    ply:Freeze(false)
                    ply:DrawViewModel(true)
                end
                return
            end

            local cam = ent:GetAttachment(ent:LookupAttachment('camera'))
            if not cam then hook.Remove('CalcView', hookID) return end

            ply:AddFlags(FL_NOTARGET)
            ply:Freeze(true)
            ply:DrawViewModel(false)

            local lerpFactor = math.Clamp((CurTime() - startTime) / 0.7, 0, 1)
            
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

	function ENT:OnRemove()
		hook.Remove("HUDPaint", "Nosey_pill_paintingNextbot")
	end

	function ENT:CustomInitialize()
		    local preservedmats = {
        [0] = Material("icons/NoseyScan.png")
    }

	self:SetNWBool("ShouldUseLight", false )

    hook.Add("HUDPaint", "Nosey_pill_paintingNextbot", function()
		if self:IsPossessed() then
			       local ply = LocalPlayer()
        local pillentity = self
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

                draw.SimpleText("R", "CloseCaption_BoldItalic", xaxis+ScreenScale(1), yaxis+ScreenScale(1), Color(255, color, color), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                surface.SetDrawColor(color, color, color, 255)
                surface.SetMaterial(preservedmats[0])
                surface.DrawTexturedRect(xaxis, yaxis, iconsize, iconsize)

                --draw.SimpleText("Ghastly Ominance", "Trebuchet18", xaxis+iconsize/2, yaxis+iconsize*0.85, Color(165, 0, 165), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

        end
		end
    end)
	end

function ENT:CustomThink()
-- Client
local selfCenter = self:WorldSpaceCenter()
local isAtLight = ( render.GetLightColor(selfCenter):LengthSqr() > 0.0004 )
net.Start("NoseyLightToggle")
net.WriteEntity(self)
net.WriteBool(not isAtLight)
net.SendToServer()
end

end -- CLIENTSERVER endif

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
