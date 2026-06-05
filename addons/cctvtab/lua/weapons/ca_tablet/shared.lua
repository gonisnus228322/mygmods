local game = game
local math = math

include("sh_screen.lua")

SWEP.Category		= "CA Camera System"
SWEP.PrintName		= "CCTV Tablet"

SWEP.ViewModel		= "models/vondaram/c_tablet.mdl"
SWEP.WorldModel		= "models/vondaram/w_tablet.mdl"

SWEP.UseHands		= true
SWEP.ViewModelFOV = 90
SWEP.Spawnable		= true

SWEP.Slot			= 5
SWEP.SlotPos		= 6
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary = {
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = false,
	Ammo = "none"
}

SWEP.Secondary = {
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = false,
	Ammo = "none"
}

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

local HOLSTERANIM_SKIP = GetConVar("ca_holsterskip")
local FLASHLIGHT_ENABLED = GetConVar("ca_cams_flashlight_enabled")
//local PREDICTED_CAMSWITCH

local ANG_ZERO = Angle(0,0,0)

local DEFAULT_FOV = 1
local MAX_FOV = DEFAULT_FOV
local MIN_FOV = 0.7
local FOV_STEP = 1

if CLIENT then
	//PREDICTED_CAMSWITCH = CreateClientConVar("ca_cams_predict_camswitch", 0, true, false, "Determine if cams should be switched without waiting for server response (may cause visual bugs with ping)",0,1)
	SWEP.ZoomStatus = false
	SWEP.CurFOV = DEFAULT_FOV
	SWEP.GoalFOV = DEFAULT_FOV
end

function SWEP:Initialize()

	self:SetHoldType( "pistol" )

	self.m_bInitialized = true
end

function SWEP:OnCameraSwitch(name,old,new)
	local ow = self:GetOwner()

	if !IsValid(ow) then return end
	
	hook.Call("CA_CamSwitched",nil,self,old,new)
end

if CLIENT then
	function SWEP:OnFlashToggle(name,old,new)
		local ow = self:GetOwner()

		if !IsValid(ow) || ( ow == LocalPlayer() && !game.SinglePlayer() ) then return end

		hook.Call("CA_CamFlashToggled",nil,self,new)
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "CurCamera" )

	// IDLE ANIM VARS
	self:NetworkVar( "Float",0,"IdleTimer")
	self:NetworkVar("Bool",0,"IsIdle")

	// HOLSTER VARS
	self:NetworkVar("Float",1,"HolsterTimer")
	self:NetworkVar("Bool",1,"IsHolstering")
	self:NetworkVar("Entity",1,"HolsterEntity")

	self:NetworkVar("Bool",3,"IsFullView" )

	self:NetworkVar("Bool", 4,"FlashlightOn")
	self:NetworkVar("Float",5,"ReloadTimer")

	if SERVER then
		self:SetCurCamera(1)
		self:SetFlashlightOn(false)
		self:resetWepDataInternal()
	end

	//self:resetWepDataInternal(true)
	
	self:NetworkVarNotify( "CurCamera", self.OnCameraSwitch )
	if CLIENT then
		self:NetworkVarNotify( "FlashlightOn", self.OnFlashToggle )
	end
end

function SWEP:resetWepDataInternal(isIniting)
	//self:SetIsHolstering(false)
	self:SetHolsterTimer( math.huge )
	self:SetIsFullView( false )
	self:SetHolsterEntity( NULL )
	if SERVER then
		self:SetIsHolstering(false)
	else
		if IsFirstTimePredicted() || isIniting then
			self.CurFOV = DEFAULT_FOV
			self.GoalFOV = DEFAULT_FOV
			self.ZoomStatus = false
		end
	end
end

function SWEP:EmitSoundPredicted(...) // на вики написано, что эта функция уже учитывает предикцию, но при проверке воспроизводимых звуков c помощью EntityEmitSound они высираются пачками
	if IsFirstTimePredicted() then
		self:EmitSound(...)
	end
end

function SWEP:deployInternal(kostilClient) // т.к используеся в двух функциях (костыль ебанный)
	self:SetHoldType("pistol")
	self:SendWeaponAnim( ACT_VM_DEPLOY )
	self:EmitSoundPredicted("ca_tablet/equip.wav",75,100,0.25)
	self:SetIsIdle(false)

	local vm = self:GetOwner():GetViewModel()

	self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() * 0.5)
	self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() * 0.5)
	self:SetIdleTimer(CurTime() + vm:SequenceDuration() * 0.75)

	self:resetWepDataInternal()

	if SERVER || (CLIENT && (IsFirstTimePredicted() || game.SinglePlayer() ) ) then
		hook.Call("CA_TabletDeployed",nil,self)
	end

	if SERVER then
		if kostilClient then
			self:CallOnClient("deployInternal")
		end
	end
end


function SWEP:Deploy()
	self:deployInternal(game.SinglePlayer())
	return true
end

function SWEP:Holster( wep )
	if HOLSTERANIM_SKIP:GetBool() then
		return true
	end

	if ( !IsValid(wep) && !self:GetIsHolstering() ) || wep:GetClass() == self:GetClass() then // фикс поднятия предметов
		return true
	end
	
	
	if self:GetHolsterTimer() <= CurTime() then
		self:SetHolsterTimer(math.huge)
		self:SetHolsterEntity(NULL)
		return true 
	end

	if !IsValid(wep) then return end
	
	if self:GetIsHolstering() then
		self:SetHolsterEntity(wep)
		return 
	end

	if self:GetIsFullView() then
		self:SendWeaponAnim( ACT_VM_HOLSTER_EMPTY )
	else 
		self:SendWeaponAnim( ACT_VM_HOLSTER )
	end

	self:EmitSoundPredicted("ca_tablet/holster.wav",75,100,0.8)

	self:SetHoldType("normal")

	self:SetHolsterEntity(wep)
	self:SetIsHolstering(true)
	self:SetHolsterTimer(CurTime() + self:GetOwner():GetViewModel():SequenceDuration())
	
	return false
end

function SWEP:GetHolsterTime()
	// эта функция нужна просто для того, чтобы один из аддонов на смену оружия игнорировал его и не ломал анимацию
end

function SWEP:Think()
	if (not self.m_bInitialized) then
		self:Initialize()
	end
	local owner = self:GetOwner()

	if !IsValid(owner) then return end
	
    if self:GetIsIdle() == false and self:GetIdleTimer() <= CurTime() and !self:GetIsHolstering() and !self:GetIsFullView() then -- Idle Sequence
		self:SendWeaponAnim(ACT_VM_IDLE)  
		self:SetIsIdle(true)
    end

	if CA_CamCount > 0 && !CA_CamsData[self:GetCurCamera()] then
		self:SetCurCamera(CA_CamCount)
	end

end

/*local function adaptPing(ply)
	if game.SinglePlayer() then return 0 end // || ( ply:Ping() < 5 )
	return 0 //( math.min(ply:Ping(),200) / 1000 ) * 0.35
end*/

local function solveCameraConditions(id)
	if id > CA_CamCount then
		id = 1
	elseif id < 1 then
		id = CA_CamCount
	end
	return id
end

function SWEP:attackInternal()
	if self:GetIsFullView() then
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK_2 )
		self:EmitSoundPredicted("ca_tablet/toggle.ogg",75,100,0.2)
	else 
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self:EmitSoundPredicted("ca_tablet/toggle.ogg",75,100,0.125)
	end

	self:SetIsIdle(false)

	local vm = self:GetOwner():GetViewModel()

	self:SetIdleTimer(CurTime() + vm:SequenceDuration())

	self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() * 0.1) // + adaptPing(self.Owner)
	self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() * 0.1) // + adaptPing(self.Owner)
end

function SWEP:PrimaryAttack()
	if self:GetIsHolstering() then return end

	if SERVER then // || PREDICTED_CAMSWITCH:GetBool()
		local oldVal = self:GetCurCamera()
		local nextCam = solveCameraConditions(self:GetCurCamera() + 1)
		self:SetCurCamera(nextCam)
	end

	self:attackInternal()
end

function SWEP:SecondaryAttack()
	if self:GetIsHolstering() then return end

	if SERVER then // || PREDICTED_CAMSWITCH:GetBool()
		local oldVal = self:GetCurCamera()
		local nextCam = solveCameraConditions(self:GetCurCamera() - 1)
		self:SetCurCamera(nextCam)
	end

	self:attackInternal()
end

function SWEP:Reload()
	/*if self:GetIsHolstering() then return end
	if self:GetReloadTimer() >= CurTime() then return end
	
	self:SetIsFullView( !self:GetIsFullView() )
	if self:GetIsFullView() then
		self:SendWeaponAnim( ACT_LOOKBACK_LEFT )
		self:SetHoldType("camera")
	else 
		self:SendWeaponAnim( ACT_LOOKBACK_RIGHT )
		self:SetHoldType("pistol")
	end

	self:SetIsIdle(false)
	self:SetIdleTimer(CurTime() + self.Owner:GetViewModel():SequenceDuration())

	self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() * 0.65)
	self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() * 0.65)
	self:SetReloadTimer(CurTime() + self.Owner:GetViewModel():SequenceDuration() * 0.65)*/
end

function SWEP:ReloadOverride()
	if self:GetIsHolstering() then return end
	if self:GetReloadTimer() >= CurTime() then return end
	
	self:SetIsFullView( !self:GetIsFullView() )

	if self:GetIsFullView() then
		self:SendWeaponAnim( ACT_LOOKBACK_LEFT )
		self:SetHoldType("camera")
	else 
		self:SendWeaponAnim( ACT_LOOKBACK_RIGHT )
		self:SetHoldType("pistol")
	end


	self:SetIsIdle(false)

	local vm = self:GetOwner():GetViewModel()

	self:SetIdleTimer(CurTime() + vm:SequenceDuration())

	self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() * 0.4)
	self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() * 0.4)

	self:SetReloadTimer(CurTime() + vm:SequenceDuration() * 0.4)
end

function SWEP:FlashlightOverride()
	if !FLASHLIGHT_ENABLED:GetBool() then return end

	if self:GetIsFullView() && !self:GetIsHolstering() then
		if self:GetNextPrimaryFire() < CurTime() then
			self:SetFlashlightOn(!self:GetFlashlightOn())

			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK_2 )
			self:EmitSoundPredicted("ca_tablet/toggle.ogg",75,100,0.190)

			if IsFirstTimePredicted() then
				hook.Call("CA_CamFlashToggled",nil,self,self:GetFlashlightOn())
			end

			self:SetIsIdle(false)

			local vm = self:GetOwner():GetViewModel()

			self:SetIdleTimer(CurTime() + vm:SequenceDuration())

			self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() * 0.1)
			self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() * 0.1)
		end
		return true
	end
end

function SWEP:OwnerChanged()
	if !IsValid(self:GetOwner()) then
		//print("weapon dropped, resetting temp data...")
		self:resetWepDataInternal(true)
	end
end

hook.Add("PlayerButtonDown","CA_ButtonReg",function(ply,button) // по сути, единственный способ гарантировать работоспобность фонарика при наличии других аддонов, ебущихся с биндами
	if button != KEY_F && button != KEY_R then return end

	if ( CLIENT && ply:GetObserverMode() == OBS_MODE_IN_EYE ) then return end

	local curWep = ply:GetActiveWeapon()
	if !IsValid(curWep) || curWep:GetClass() != "ca_tablet" then return end

	//local shouldSuppress = ( SERVER && !game.SinglePlayer() )

	/*if shouldSuppress then
		SuppressHostEvents(ply)
	end*/

	if button == KEY_F then

		curWep:FlashlightOverride()

	elseif button == KEY_R then // вманип блокирует перезарядку, но этот способ работает
		curWep:ReloadOverride()
	end

	/*if shouldSuppress then
		SuppressHostEvents(nil)
	end*/

end)

hook.Add( "StartCommand", "CA_HolsterWorkout", function( ply, cmd )

	local curWep = ply:GetActiveWeapon()

	if !IsValid(curWep) || curWep:GetClass() != "ca_tablet" || (CLIENT && curWep:GetOwner() != ply) || !curWep.m_bInitialized then return end

	if curWep:GetIsHolstering() && curWep:GetHolsterTimer() <= CurTime() then
		local nextWep = curWep:GetHolsterEntity()
		if IsValid(nextWep) && ply:HasWeapon(nextWep:GetClass()) then
			cmd:SelectWeapon(nextWep)
		else
			curWep:deployInternal()
		end
	end

end )

if CLIENT then

	local string = string
	local input = input

	local ZOOM_BIND = "+zoom"
	local FLASH_BIND = "impulse 100"
	local RELOAD_BIND = "+reload"


	function SWEP:ZoomCalcInternal()
		local wheelDelta = ( self:GetIsFullView() && self.ZoomStatus && !self:GetIsHolstering() ) and -1 or 1
		local addStep = FOV_STEP * wheelDelta
		local newFOV = math.Clamp(self.GoalFOV + addStep,MIN_FOV,MAX_FOV)
		local oldFOV = self.CurFOV
		local lerpedFOV = Lerp(FrameTime() * 7.5,oldFOV,newFOV)
		self.CurFOV = lerpedFOV
		self.GoalFOV = newFOV
		return lerpedFOV
	end

	// оффсет камеры под кость
	function SWEP:CalcView(ply,pos,ang,fov)
		local offAng = self.StoredVMAngles or ANG_ZERO
		ang = ang + offAng

		fov = fov * self:ZoomCalcInternal()

		return pos, ang, fov
	end

	function SWEP:ViewModelDrawn( vm )
		local headAtt = vm:LookupAttachment("anim_view")
		if headAtt <= 0 then self.StoredVMAngles = ANG_ZERO return end
		local headAng = vm:GetAttachment(headAtt).Ang
		headAng:RotateAroundAxis(headAng:Up(),90)
		headAng = vm:WorldToLocalAngles(headAng)
		self.StoredVMAngles = headAng
	end

	hook.Add("PlayerBindPress","CA_CamBinds",function(ply,bind,pressed,code)
		/*local isAliased = input.TranslateAlias(bind)
		bind = isAliased != nil and isAliased or bind*/

		if bind != ZOOM_BIND then return end
		//if ply:GetObserverMode() == OBS_MODE_IN_EYE then return end

		local curWep = ply:GetActiveWeapon()
		local shouldProcess = IsValid(curWep) && curWep:GetClass() == "ca_tablet"

		if !shouldProcess then return end

		if bind == ZOOM_BIND then
			curWep.ZoomStatus = pressed
			return true
		end

	end)

end

if SERVER then

	hook.Add( "PlayerCanPickupWeapon", "CA_TabletDoublePickUp", function( ply, weapon )
		local wepClass = weapon:GetClass()
		if wepClass == "ca_tablet" && ply:HasWeapon( wepClass ) then
			return false
		end
	end )

	hook.Add( "PlayerSwitchFlashlight", "CA_FlashlightLogic", function( ply, toggleOn ) // по сути, самый универсальный и правильный вариант по отношению к аддонам на фонарики
		if !FLASHLIGHT_ENABLED:GetBool() then return end
		local curWep = ply:GetActiveWeapon()
		if !IsValid(curWep) || curWep:GetClass() != "ca_tablet" then return end
		return Either( curWep:GetIsFullView() && !curWep:GetIsHolstering() , false, nil )
	end )

	function SWEP:CanBePickedUpByNPCs()
		return false
	end

end
