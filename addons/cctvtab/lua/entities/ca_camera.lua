AddCSLuaFile()

ENT.Base = "base_gmodentity" 
	
ENT.Type = "anim"
ENT.Spawnable = false
ENT.Editable = true

local Angle = Angle // честно, хуй знает, имеет ли этот перевод в локальную переменную смысл, но вай нот

local CAMERA_MODEL = Model( "models/dav0r/camera.mdl" )
local SHOULD_DRAW = CreateConVar("ca_cams_draw", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Determine if player can see cameras",0,1)   //CreateClientConVar("ca_cams_draw", 1, true, false, "Determine if player can see cameras")
local FLASHLIGHT_ENABLED = GetConVar("ca_cams_flashlight_enabled")
local ADMIN_ONLY = GetConVar("ca_cams_adminonly")

function ENT:SetupDataTables()
	
	self:NetworkVar("Vector",0,"ColorMultiplyRGB", {KeyName = "colormultrgb", Edit = { type = "VectorColor",order = 1}} )
	self:NetworkVar("Float",0,"ColorMultiplyGeneral", {KeyName = "colormultgen", Edit = { type = "Float",order = 2,min = 0, max = 3}} )

	self:NetworkVar("Vector",1,"ColorAdditionRGB", {KeyName = "coloraddrgb", Edit = { type = "VectorColor",order = 3}} )
	self:NetworkVar("Float",2,"ColorAdditionGeneral", {KeyName = "coloraddgen", Edit = { type = "Float",order = 4,min = 0, max = 1}} )

	self:NetworkVar("Float",3,"Brightness", {KeyName = "brightness", Edit = { type = "Float",order = 5,min = -0.5,max = 0.5}} )

	self:NetworkVar("Float",4,"Contrast", {KeyName = "contrast", Edit = { type = "Float",order = 6,min = 0,max = 50}} )

	self:NetworkVar("Float",5,"Colourness", {KeyName = "colour", Edit = { type = "Float",order = 7,min = -1,max = 3}} )

	self:NetworkVar("Int",6,"FOV", {KeyName = "fov", Edit = { type = "Int",order = 9,min = 30, max = 150}} )

	self:NetworkVar("String",0,"CameraName", {KeyName = "camname", Edit = { type = "Generic",order = 10,waitforenter = true}} )

	// flashlight settings

	self:NetworkVar("Bool",7,"FlashlightOn")

	self:NetworkVar("Float",7,"FlashlightBrightness", {KeyName = "flashbright", Edit = { type = "Float",order = 11,min = 0,max = 5,category = "Flashlight"}} )

	self:NetworkVar("Vector",7,"FlashlightColor", {KeyName = "flashcolor", Edit = { type = "VectorColor",order = 12,category = "Flashlight"}} )

	/*self:NetworkVar("Float",8,"FlashlightHorizontalFOV", {KeyName = "flashhorizfov", Edit = { type = "Float",order = 13,min = 30,max = 120,category = "Flashlight"}} )

	self:NetworkVar("Float",9,"FlashlightVerticalFOV", {KeyName = "flashvertfov", Edit = { type = "Float",order = 14,min = 30,max = 120,category = "Flashlight"}} )*/

	self:NetworkVar("Float",8,"FlashlightFOV", {KeyName = "flashfov", Edit = { type = "Float",order = 13,min = 30,max = 150,category = "Flashlight"}} )

	self:NetworkVar("Int",9,"FlashlightFarZ", {KeyName = "flashfarz", Edit = { type = "Float",order = 15,min = 5,max = 7500,category = "Flashlight"}} )

	self:NetworkVar("Bool",10,"FlashlightEnableShadows", {KeyName = "flashenableshadows", Edit = { type = "Boolean",order = 16,category = "Flashlight"}} )

	self:NetworkVar("Int",11,"CamID")

	if SERVER then
		self:SetColorMultiplyGeneral(1)
		self:SetColorAdditionGeneral(1)
		self:SetBrightness(0)
		self:SetContrast(1)
		self:SetColourness(0.25)
		self:SetFOV(90)
		self:SetCameraName("")

		self:SetFlashlightOn(false)
		self:SetFlashlightBrightness(1)
		self:SetFlashlightColor(Vector(1,1,1))
		/*self:SetFlashlightHorizontalFOV(90)
		self:SetFlashlightVerticalFOV(90)*/
		self:SetFlashlightFOV(90)
		self:SetFlashlightFarZ(500)
		self:SetFlashlightEnableShadows(true)

	end

	self:NetworkVarNotify("FlashlightOn",self.OnFlashVarChanged)
	self:NetworkVarNotify("FlashlightBrightness",self.OnFlashVarChanged)
	self:NetworkVarNotify("FlashlightColor",self.OnFlashVarChanged)
	self:NetworkVarNotify("FlashlightFOV",self.OnFlashVarChanged)
	self:NetworkVarNotify("FlashlightFarZ",self.OnFlashVarChanged)
	self:NetworkVarNotify("FlashlightEnableShadows",self.OnFlashVarChanged)
	
end

function ENT:Initialize()
		self:SetModel( CAMERA_MODEL )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )
        self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		if SERVER then
			if istable(self.overrideVars) then
				for k,v in pairs(self.overrideVars) do
					local func = self["Set"..k]
					if isfunction(func) then
						func(self,v)
					end
				end
			end
			self.overrideVars = nil
		end

		if CLIENT then
			self.FlashlightOn = false
		end
end

function ENT:CanProperty(ply,property) // на клиенте много раз вызывается из-за блядской предикции, но при этом нельзя не возвращать ничего ???
	if ADMIN_ONLY:GetBool() then
		return ply:IsAdmin()
	end
	return true
end

function ENT:OnFlashVarChanged(name,old,new)
	if SERVER then // TODO: Сделать фонарики на стороне сервера (оптимально)
	
	else
		if IsValid(self.lamp) then
			self.lamp:Remove()
			self.lamp = nil
		end
	end
end

if CLIENT then

	// Я уверен, что код ниже можно реализовать лучше, но скорее всего придется изобретать велосипед так что тут используется простейшее решение

	local function getCameraEnt(index) // дубликат функции но я не хочу делать ее глобальной т.к оптимизация уже идет по пизде
		local camData = CA_CamsData[index]
		if !camData then return end
		return camData.internEntity
	end

	function ENT:OnRemove()
		if ( IsValid( self.lamp ) ) then
			self.lamp:Remove()
		end
	end

	local curCam

	function ENT:Draw(flags)
		if !SHOULD_DRAW:GetBool() then return end
		if self == CA_RenderingCamera then return end
		self:DrawModel()
	end

	hook.Add("RenderScene","CA_CheckCurWep",function()
		local lply = LocalPlayer()
		local vwEnt = lply:GetObserverTarget()
		local pl = (lply:GetObserverMode() == OBS_MODE_IN_EYE && vwEnt:IsPlayer() ) and vwEnt or lply
		
		if !IsValid(pl) then curCam = nil return end
		local curWep = pl:GetActiveWeapon()
		if !IsValid(curWep) || curWep:GetClass() != "ca_tablet" || curWep:GetIsHolstering() then curCam = nil return end
		curCam = getCameraEnt(curWep:GetCurCamera())
	end)

	hook.Add("PreDrawOpaqueRenderables","CA_UpdateFlashlight",function(isDrawingDepth,isDrawSkybox,isDraw3DSkybox )
		//if CA_RenderingCamera then return end // По неизвестной мне причине если камера не находится в поле зрения игрока, то освещения ломается к хуям (сорс энджин момент)
		if IsValid(curCam) and IsValid(curCam.lamp) then
			local camLamp = curCam.lamp
			local ang = curCam:GetAngles()
			camLamp:SetPos( curCam:GetPos() + ang:Forward() * (CA_CAMVIEW_OFFSET.x * 1.6) + ang:Right() * CA_CAMVIEW_OFFSET.y + ang:Up() * CA_CAMVIEW_OFFSET.z )
			camLamp:SetAngles( ang )
			camLamp:Update()
		end
	end)

	function ENT:Think()
		if IsValid(self.lamp) then
			if IsValid(curCam) && self.FlashlightOn && FLASHLIGHT_ENABLED:GetBool() then
				if curCam:EntIndex() != self:EntIndex() then
					self.lamp:Remove()
					self.lamp = nil
				end
			else
				self.lamp:Remove()
				self.lamp = nil
			end
		end
	end

else 

	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end

	function ENT:PostEntityPaste(ply,ent)
		if timer.Exists("CA_DupeReInit") then timer.Remove("CA_DupeReInit") end
		timer.Create("CA_DupeReInit",0.5,1,function()
			CA_ReInitServer()
		end)
	end

	function ENT:OnEntityCopyTableFinish( data )
		// TODO: Добавить сюда игнорирование серверного фонарика при копировании
	end

	function ENT:CanEditVariables(ply)
		if ADMIN_ONLY:GetBool() then
			return ply:IsAdmin()
		end
		return true
	end

	/*hook.Add("CanEditVariable","CA_CanEditCamerasVariables",function(ent,ply,key,val,editor)
		if !IsValid(ent) || ent:GetClass() != "ca_camera" then return end
		if ADMIN_ONLY:GetBool() then
			return ply:IsAdmin()
		end
	end)*/

end

duplicator.RegisterEntityClass("ca_camera", function(ply, data) // честно, не до конца разобрался в том, может ли он копировать и/или перезаписывать функции, но надеюсь, что не умеет(иначе это пизда)
	/*if IsValid(ply) && (ADMIN_ONLY:GetBool() && !ply:IsAdmin()) then // глянул в код дупликатора, там уже есть похожие проверки так что смысла в этом нет
		return
	end*/
	return duplicator.GenericDuplicatorFunction(ply, data)
end, "Data")