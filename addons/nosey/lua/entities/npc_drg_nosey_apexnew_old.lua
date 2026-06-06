if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Nosey (OLD)"
ENT.Category = "TikTok: Citra"
ENT.Models = {"models/gentoi/walterfiles/nosey.mdl"}
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
ENT.SpawnHealth = 3500
ENT.CanBeInmuneToDmg = true
ENT.InmuneToDmgType = {DMG_DISSOLVE, DMG_RADIATION, DMG_DROWN, DMG_BULLET}
ENT.DefaultAttackAnimRate = 1

ENT.MonsterStates = {}

ENT.CurrentMonsterState = nil
ENT.Monster_EnemyIsFar = false

-- Footsteps --
ENT.Monster_CanUseFootsteps = true
ENT.Monster_Footsteps = {
    		{
		animation = "walk",
		timers = {21/151, 93/151},
		foot_bone = "ORIGIN",
		shake = true ,
		shake_amplitude = 3.5,
		shake_frequency = 5,
		shake_duration = 1,
		shake_radius = 300,
		sound = {"nosey/Nosey_footstep1.wav","nosey/Nosey_footstep2.wav"},
		effect = {
			{
				effect = nil,
				effect_lifetime = 2
			}
		},
		dmg_data = {
			dmg = 0,
			dmg_type = DMG_BLAST,
			dmg_radius = 10,
			
		}
	},
    {
		animation = "run",
		timers = {5/39, 25/39},
		foot_bone = "ORIGIN",
		shake = true ,
		shake_amplitude = 4.5,
		shake_frequency = 7,
		shake_duration = 1,
		shake_radius = 500,
		sound = {"nosey/Nosey_footstep3.wav","nosey/Nosey_footstep4.wav"},
		effect = {
			{
				effect = nil,
				effect_lifetime = 2
			}
		},
		dmg_data = {
			dmg = 0,
			dmg_type = DMG_BLAST,
			dmg_radius = 10,
			
		}
	},
	{
		animation = "CrawlMovement",
		timers = {24/48, 48/48},
		foot_bone = "ORIGIN",
		shake = true ,
		shake_amplitude = 4.5,
		shake_frequency = 7,
		shake_duration = 1,
		shake_radius = 500,
		sound = {"nosey/Nosey_footstep1.wav","nosey/Nosey_footstep5.wav"},
		effect = {
			{
				effect = nil,
				effect_lifetime = 2
			}
		},
		dmg_data = {
			dmg = 0,
			dmg_type = DMG_BLAST,
			dmg_radius = 10,
			
		}
	},
}

-- AI --
ENT.SpotDuration = 20
ENT.RangeAttackRange = 3500
ENT.LeapRange = 500
ENT.MaxJumpRange = 0
ENT.MeleeAttackRange = 50
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
ENT.Acceleration = 2000
ENT.Deceleration = 1000

ENT.Crouch_WalkSpeed = 20
ENT.Crouch_RunSpeed = 40
ENT.Crouch_Acceleration = 2000
ENT.Crouch_Deceleration = 1000
ENT.Crouch_JumpMultiplier = 0.3

ENT.Default_WalkSpeed = 41
ENT.Default_RunSpeed = 420
ENT.Default_Acceleration = 2000
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
ENT.ClimbSpeed = 20
ENT.ClimbUpAnimation = "CrawlMovement"
ENT.ClimbDownAnimation = "CrawlMovement"
ENT.ClimbAnimRate = 1
ENT.ClimbOffset = Vector(0, 0, 0)

-- Detection --
ENT.EyeBone = "Head"
ENT.EyeOffset = Vector(0, 0, 0)

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
  {
    offset = Vector(0, 30, 0),
    distance = 125,
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
			if self:GetPos():Distance(ent:GetPos()) < 50 then
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
	}}
}

if SERVER then

AddCSLuaFile()
util.AddNetworkString('bon_jumpscare_lsd')

sound.Add({
	name = "",
	sound = {"nosey/Nosey_footstep1.wav", "nosey/Nosey_footstep2.wav", "nosey/Nosey_footstep1.wav", "nosey/Nosey_footstep2.wav", "nosey/Nosey_footstep1.wav"},
	channel = CHAN_BODY,
	volume = 1.0,
	level = 67,
	pitch = 100
})

sound.Add({
	name = "",
	sound = {"nosey/Nosey_footstep3.wav", "nosey/Nosey_footstep4.wav", "nosey/Nosey_footstep3.wav", "nosey/Nosey_footstep3.wav"},
	channel = CHAN_BODY,
	volume = 1.0,
	level = 67,
	pitch = 100
})

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
	if self:IsValid() and ent:IsValid() then
										--ent:Freeze(true)
			if ent:IsPlayer() then
				net.Start('bon_jumpscare_lsd')
            	net.WriteEntity(self)
            	net.WriteBool(true)
           		net.Send(ent)
				ent:Freeze(true)
				ent:StripWeapons()
			else
				-- Disable NPC's future thinking to simulate freezing them
                ent:NextThink(CurTime() + 1e9)
				ent:SetIK(false) 
			end

			self:SetVelocity(Vector(0,0,0))
			self:SetPos(self:GetPos())
			self:SetAngles(self:GetAngles())

			-- Move the entity into position relative to the self
            -- ent:SetPos(self:GetPos() + self:GetForward() * 65 + self:GetUp() * 10)
			-- ent:SetAngles(self:GetAngles() + Angle(180, 0, 180))
			-- ent:SetVelocity(Vector(0,0,0))
			
			self:EmitSound('nosey/NoseyExecution.wav')

			-- self:StopSound("lsdvita/idle.wav")

			self.Executing = true
			self.ExecutionEnemy = ent
			self.PosForward = 0
			self.PosHeight = -65

			ent:AddFlags(FL_NOTARGET)
			
			ent:SetMoveType( MOVETYPE_NONE )

                timer.Simple(3.25, function()
					if IsValid(ent) and IsValid(self) then
						                    local effectdata = EffectData()
                    effectdata:SetOrigin(self:LocalToWorld(Vector(75, 0, 50)))
                    effectdata:SetNormal(ent:GetAngles():Forward())
                    effectdata:SetMagnitude(3)
                    effectdata:SetScale(15)
                    effectdata:SetColor(0)
                    effectdata:SetFlags(3)
                    util.Effect('bloodspray', effectdata)
					if ent:IsPlayer() then
					ent:ScreenFade(SCREENFADE.IN,Color(255,0,0,255),0.5,0.5)
					timer.Simple(1, function()
						ent:ScreenFade(SCREENFADE.OUT,Color(100,0,0,100),2.42,0.5)
					end)
				end
				end
			end)

			timer.Simple(4.92, function()
				if IsValid(ent) and IsValid(self) then
					self.PosForward = -35
					self.PosHeight = -40
				end
			end)

			self:PlaySequenceAndWait("kill")

			self.Executing = false
			self.ExecutionEnemy = nil 

			-- self:AfterKillVoiceline()

			-- ent:Freeze(false)
			if IsValid(ent) and IsValid(self) then
								if ent:IsPlayer() then
					local lastposply = ent:GetPos()
					local lastangply = ent:GetAngles()
					ent:SetPos(lastposply)
					ent:SetAngles(lastangply)
					ent:Kill(self)
					ent:Freeze(false)
					ent:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),2,0.5)
					ent:RemoveFlags(FL_NOTARGET)
				elseif ent:IsNPC() or ent:IsNextBot() then
							local lastpos = ent:GetPos()
			local lastang = ent:GetAngles()
								ent:SetPos(lastpos)
					ent:SetAngles(lastang)
				ent:TakeDamage(3500, self)
				ent:NextThink(CurTime())
				ent:RemoveFlags(FL_NOTARGET)
				end
	end
			end
end

function ENT:CustomInitialize()
	self:SetDefaultRelationship(self.Monster_DefaultRelationship)
	self:SetPlayersRelationship(self.Monster_PlayersRelationship)
	self:SetDamageAttackMultiplier(1)
	self:SetARMultiplier(2)
	self:SetDamageReduction(5.0)
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

	if weapons.Get("ca_tablet") and SERVER then
		local ca_camera = ents.Create("ca_camera")
		ca_camera:SetParent(self)
		ca_camera:SetRenderMode(RENDERMODE_NONE)
		
		ca_camera:SetCameraName("Pumpkin Rabbit Debug Camera")
		ca_camera:FollowBone(self,4)
		ca_camera:AddEffects(EF_FOLLOWBONE)
		ca_camera:SetPos(self:GetPos() + (self:GetUp() * 120) + (self:GetRight() * 1) + (self:GetForward() * 10))
		ca_camera:SetAngles(self:GetAngles()+Angle(90,90,0))
		ca_camera:Spawn()
		ca_camera:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		
		for _,ply in ipairs(player.GetAll()) do
			ply:ConCommand("ca_cams_sync_server")
		end
	end
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

function ENT:CustomThink()

if self.Executing == true then
	self:ExecutionThink(self.ExecutionEnemy)
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
	if table.Count(self.CurrentExecution) > 0 then
	if self.CurrentExecution.firstperson_jumpscare == true then
	if IsValid(self:GetGrabbedPlayer()) then
		if not self.CurrentExecution.execanim_nomatters then
			if self:GetSequence() != self:LookupSequence(self.CurrentExecution.exec_anim) then
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
		elseif isstring(self.CurrentExecution.execanim_otheranim) then
			if self:GetSequence() != self:LookupSequence(self.CurrentExecution.execanim_otheranim) then
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
		else
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
		local camerapos = self:GetAttachment(self:LookupAttachment(self.CurrentExecution.firstperson_jumpscare_camera)).Pos
		self:GetGrabbedEnemy():SetPos(camerapos)
		if not self.CurrentExecution.execanim_nomatters then
			if self:GetSequence() != self:LookupSequence(self.CurrentExecution.exec_anim) then
				if IsValid(self:GetGrabbedEnemy()) then
					self:SetGrabbedEnemy(nil)
				end
			end
		elseif isstring(self.CurrentExecution.execanim_otheranim) then
			if self:GetSequence() != self:LookupSequence(self.CurrentExecution.execanim_otheranim) then
				if IsValid(self:GetGrabbedEnemy()) then
					self:SetGrabbedEnemy(nil)
				end
			end
		else
			if IsValid(self:GetGrabbedEnemy()) then
				self:SetGrabbedEnemy(nil)
			end
		end
	end
	end
	end
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
	if IsValid(self:GetGrabbedPlayer()) then
		self:GetGrabbedPlayer():SetParent(nil)
		self:GetGrabbedPlayer():SetViewEntity(nil)
		self:GetGrabbedPlayer():Freeze(false)
		self:GetGrabbedPlayer():SetNoDraw(false)
		if IsEntity(self.cent) then
			self.cent:Remove()
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
		self.cent:SetParent(self, self:LookupAttachment(exec.firstperson_jumpscare_camera))
		self.cent:SetLocalPos(Vector(0, 0, 0))
		self.cent:SetAngles(Angle(self:GetAngles().x, self:GetAngles().y, self:GetAngles().z) + exec.firstperson_jumpscare_cameraang)
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
            
            local targetFOV = 60 

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

end -- CLIENTSERVER endif

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
