local Angle = Angle
local math = math
local render = render
local surface = surface
local cam = cam
local DrawColorModify = DrawColorModify

local function findClosestPOT(x)
	local closestOne = math.huge
	local lastOne = math.huge
	local lastDist = math.huge
	local curStep = 1

	while (lastOne == closestOne) do
		local newPOT = 2^curStep
		local newDist = x - newPOT
		if ( newDist < 0 ) then
			break
		end
		if ( newDist < lastDist) then
			closestOne = newPOT
			lastDist = newDist
		end
		lastOne = newPOT
		curStep = curStep + 1
	end
	return closestOne
end

local CAM_RES = CreateClientConVar("ca_cams_resolution", 1024, true, false, "",128,1024)

local CAMRES_W = findClosestPOT( CAM_RES:GetInt() )
local CAMRES_H = findClosestPOT( CAM_RES:GetInt() )

local CAMUPDATE_TIME = CreateClientConVar("ca_cams_updatetime", 0, true, false, "Determine delay between camera updates")
local CAMPIXEL_RATE = CreateClientConVar("ca_cams_pixelrate", 0, true, false, "Determine camera's pixelation rate",1)

local CAMUPDATE_SVONLY = GetConVar("ca_camdelay_serversideonly")
local CAMUPDATE_SV = GetConVar("ca_cams_updatetime_sv")

local CAMPIXELRATE_SVONLY = GetConVar("ca_cams_pixelrate_svonly")
local CAMPIXELRATE_SV = GetConVar("ca_cams_pixelrate_sv")

local CAMFLASH_ENABLED = GetConVar("ca_cams_flashlight_enabled")

local matScreen = Material( "models/vondaram/tablet/ekran" )

if matScreen:IsError() then
	ErrorNoHalt("Tablet's screen texture not found!")
end

local TEXTURE_SIZE_X = matScreen:Width()
local TEXTURE_SIZE_Y = matScreen:Height()

local CAMFONT_COLOR = Color(170,170,170,100)
local BLACK_COLOR = Color(0,0,0,255)
local CAMHUD_MARGIN_COOF = 0.03

local noiseMat = Material("vondaram/static_noise")

local RtTexture = GetRenderTargetEx("CA_TabletScreen",
	TEXTURE_SIZE_X, TEXTURE_SIZE_Y,
	RT_SIZE_NO_CHANGE,
	MATERIAL_RT_DEPTH_SEPARATE,
	bit.bor(2, 256, 512),
	0,
	IMAGE_FORMAT_BGRA8888
)

local RtView

local function createCamViewRT()
	RtView = GetRenderTargetEx("CA_RenderView_"..CAMRES_W.."_"..CAMRES_H,
		CAMRES_W, CAMRES_H,
		RT_SIZE_NO_CHANGE,
		MATERIAL_RT_DEPTH_SEPARATE,
		bit.bor(2, 256, 512),
		0,
		IMAGE_FORMAT_BGRA8888
	)
end

createCamViewRT()

local pixel_shader = {
	Materials = {
		RT = nil,
		Mat = nil
	},
	Wait = 0
}

local camName = ""

local curCam = nil

local cameraColorMod = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 0.25,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

surface.CreateFont("ca_main",{
	font = "Roboto",
	size = 33,
	extended = true,
})

cvars.AddChangeCallback("ca_cams_resolution",function(cvar,oldVal,newVal)
	local newPOT = findClosestPOT(newVal)
	CAMRES_W = newPOT
	CAMRES_H = newPOT
	createCamViewRT()
end)

local update_tmr = 0

local skipAmount = 0 // кадры, которые не будут записаны в текстуру
local forcedFrames = 0 // кадры, которые будут отрисованы в любом случае

// THANK YOU, CODYA

local origW,origH = ScrW(),ScrH()
local coofX,coofY = 1,1

local function calcRes(w,h)
	if origW < w then
		coofX = 1
	else
		coofX = origW/w
	end

	if origH < h then
		coofY = 1
	else
		coofY = origH/h
	end
end


pixel_shader.RebuildMaterials = function()
	if pixel_shader.Wait > SysTime() then return end
	local w, h = ScrW(), ScrH()

	calcRes(TEXTURE_SIZE_X,TEXTURE_SIZE_Y)

	pixel_shader.Materials.RT = GetRenderTarget("ca_pixelation_rt", w, h, RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_SEPARATE, 1, 0, IMAGE_FORMAT_BGRA8888)
	pixel_shader.Materials.Mat = CreateMaterial("ca_pixelation_material", "UnlitGeneric", {
		["$basetexture"] = pixel_shader.Materials.RT:GetName()
	})
	pixel_shader.Materials.Mat:SetInt("$flags", bit.bor(pixel_shader.Materials.Mat:GetInt("$flags"), 32768))
	pixel_shader.Wait = SysTime() + 1 
end

pixel_shader.Draw = function()
	local mat, rt = pixel_shader.Materials.Mat, pixel_shader.Materials.RT
	
	if not mat or not rt then return pixel_shader.RebuildMaterials() end

	local pixelLevel = CAMPIXELRATE_SVONLY:GetBool() and CAMPIXELRATE_SV:GetFloat() or CAMPIXEL_RATE:GetFloat()
	local w, h = ScrW(), ScrH()

	if pixelLevel <= 1 then return end

	//	pixelLevel = pixelLevel + math.Rand(0,0.2)

	render.CopyRenderTargetToTexture(render.GetScreenEffectTexture())

	local wDiv, hDiv = math.ceil(w / pixelLevel), math.ceil(h / pixelLevel)
	render.PushRenderTarget(pixel_shader.Materials.RT, 0, 0, wDiv, hDiv)
		render.DrawTextureToScreenRect(render.GetScreenEffectTexture(), 0, 0, wDiv, hDiv)
	render.PopRenderTarget()

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(pixel_shader.Materials.Mat)

	local filter = TEXFILTER.LINEAR
	render.PushFilterMag(filter)
	render.PushFilterMin(filter)
		surface.DrawTexturedRect(0, 0, math.ceil(w * pixelLevel * coofX), math.ceil(h * pixelLevel * coofY))
	render.PopFilterMag()
	render.PopFilterMin()
end

hook.Add( "OnScreenSizeChanged", "CA_PixelScreenSizeChanged", function( oldWidth, oldHeight,newWidth,newHeight )
	pixel_shader.Materials.Mat = nil 
	pixel_shader.Materials.RT = nil 

	origW = newWidth
	origH = newHeight

	calcRes(TEXTURE_SIZE_X,TEXTURE_SIZE_Y)
end )

/////

local function getCameraEnt(camData)
	if !camData then return end
	return camData.internEntity
end

local function clearTex(tex)
	render.PushRenderTarget( tex )
		render.Clear( 0, 0, 0, 255, true, true )
	render.PopRenderTarget()
end

local function drawBlackScreen()
	render.ClearRenderTarget(RtTexture,BLACK_COLOR)
	/*local w,h = ScrW(),ScrH()
    cam.Start2D()
        draw.RoundedBox(0,0,0,w,h,BLACK_COLOR)  
    cam.End2D()*/
end

local function processEntValues(camEnt,camDt)
	local addColor = camEnt:GetColorAdditionRGB()
	local addGeneral = camEnt:GetColorAdditionGeneral()

	cameraColorMod["$pp_colour_addr"] = addColor.r * addGeneral
	cameraColorMod["$pp_colour_addg"] = addColor.g * addGeneral
	cameraColorMod["$pp_colour_addb"] = addColor.b * addGeneral

	local multColor = camEnt:GetColorMultiplyRGB()
	local multGeneral = camEnt:GetColorMultiplyGeneral()
	
	cameraColorMod["$pp_colour_mulr"] = multColor.r * multGeneral
	cameraColorMod["$pp_colour_mulg"] = multColor.g * multGeneral
	cameraColorMod["$pp_colour_mulb"] = multColor.b * multGeneral

	local brightness = camEnt:GetBrightness()
	cameraColorMod["$pp_colour_brightness"] = brightness

	local contrast = camEnt:GetContrast()
	cameraColorMod["$pp_colour_contrast"] = contrast

	local colour = camEnt:GetColourness()
	cameraColorMod["$pp_colour_colour"] = colour

	local FOV = camEnt:GetFOV()
	camDt.fov = FOV

	camDt.w = CAMRES_W
	camDt.h = CAMRES_H

	local name = camEnt:GetCameraName()
	camName = name
end

local function drawTablet(curCam)
    local w,h = ScrW(),ScrH()
	render.DrawTextureToScreen(RtView)

	pixel_shader.Draw()
	DrawColorModify(cameraColorMod)

	surface.SetDrawColor( 0, 0, 0, 1 )  // TODO: Добавить модификатор для прозрачности шума и/или его интенсивности
	surface.SetMaterial( noiseMat )
	surface.DrawTexturedRect( 0, 0, w, h )


	draw.NoTexture()
	surface.SetDrawColor(17,17,17)
	surface.DrawOutlinedRect(0,0,w,h,2)

	surface.SetDrawColor( 172,172,172,2)
	surface.DrawOutlinedRect( w * CAMHUD_MARGIN_COOF, h * CAMHUD_MARGIN_COOF, w - 2 * (w * CAMHUD_MARGIN_COOF),  h - 2 * (h * CAMHUD_MARGIN_COOF), 2 )
	
	draw.SimpleText( "CAM"..curCam, "ca_main", w * 0.955, h * 0.04, CAMFONT_COLOR, TEXT_ALIGN_RIGHT )
	if camName != "" then
		draw.SimpleText( camName, "ca_main", w * 0.955, h * 0.085, CAMFONT_COLOR, TEXT_ALIGN_RIGHT )
	end
end

local function updateCameraData(wep,camIndex)
	if CA_CamCount <= 0 || wep:GetIsHolstering() then return end
	local camData = CA_CamsData[camIndex]
	local origEntity = getCameraEnt(camData)
	if !IsValid(origEntity) then
		//table.remove(CA_CamsData,camIndex)
		LocalPlayer():ConCommand("ca_cams_sync_client")
		//print("Camera slot is still in-work but camera entity is NULL! Re-initing client's cameras...")
		return
	end
	local ang,pos = origEntity:GetAngles(), origEntity:GetPos()
	camData.angles = ang
	camData.origin = pos + ang:Forward() * CA_CAMVIEW_OFFSET.x + ang:Right() * CA_CAMVIEW_OFFSET.y + ang:Up() * CA_CAMVIEW_OFFSET.z
	origEntity.FlashlightOn = wep:GetFlashlightOn()
	if CAMFLASH_ENABLED:GetBool() and origEntity.FlashlightOn then
		if !IsValid(origEntity.lamp) then
			local lamp = ProjectedTexture()

			lamp:SetTexture( "effects/flashlight001" )
			//local ang = origEntity:GetAngles()
			lamp:SetPos( origEntity:GetPos() + ang:Forward() * (CA_CAMVIEW_OFFSET.x * 1.6) + ang:Right() * CA_CAMVIEW_OFFSET.y + ang:Up() * CA_CAMVIEW_OFFSET.z )
			lamp:SetAngles( ang )

			lamp:SetBrightness(origEntity:GetFlashlightBrightness())
			/*lamp:SetHorizontalFOV(origEntity:GetFlashlightHorizontalFOV())
			lamp:SetVerticalFOV(origEntity:GetFlashlightVerticalFOV())*/
			lamp:SetFOV(origEntity:GetFlashlightFOV())
			lamp:SetFarZ(origEntity:GetFlashlightFarZ())
			lamp:SetColor(origEntity:GetFlashlightColor():ToColor())

			lamp:SetEnableShadows(origEntity:GetFlashlightEnableShadows())
			// lamp:SetNoCull(true)
			
			lamp:Update()
			origEntity.lamp = lamp
		end
	end
	processEntValues(origEntity,camData)
end

local function renderViewRT(renderData)
	render.PushRenderTarget(RtView)
		cam.Start2D()
			CA_RenderingCamera = getCameraEnt(renderData)
			render.RenderView( renderData )
			CA_RenderingCamera = false
		cam.End2D()
	render.PopRenderTarget()
end

function SWEP:renderTexture(shouldRender)
	if CA_CamCount <= 0 || self:GetIsHolstering() then
		drawBlackScreen()
	else
		local renderData = CA_CamsData[self:GetCurCamera()]

		if shouldRender then
			//clearTex(RtView)
			renderViewRT(renderData)
		end

		if skipAmount > 0 then skipAmount = math.max(skipAmount - 1,0) return end
		render.PushRenderTarget(RtTexture)
			cam.Start2D()
				drawTablet(self:GetCurCamera())
			cam.End2D()
		render.PopRenderTarget()
	end
end

local function getCameraUpdateTime()
	return CAMUPDATE_SVONLY:GetBool() and CAMUPDATE_SV:GetFloat() or CAMUPDATE_TIME:GetFloat()
end

function SWEP:RenderScreen()
	local isOnKD = CurTime() - update_tmr < getCameraUpdateTime() && forcedFrames <= 0
	if !isOnKD then
		updateCameraData( self, self:GetCurCamera() )
		if !self:GetIsHolstering() then
			update_tmr = CurTime()
			forcedFrames = math.max(forcedFrames - 1,0)
		end
	end
    self:renderTexture(!isOnKD)
    matScreen:SetTexture("$basetexture",RtTexture)
end

local FRAMES_TO_SKIP = 2
local FRAMES_TO_FORCE = 3

hook.Add("CA_TabletDeployed","CA_DebugUpdateDelay",function(wep)
	skipAmount = FRAMES_TO_SKIP //calcSkippedFrames()
	forcedFrames = FRAMES_TO_FORCE
end)

hook.Add("CA_CamSwitched","CA_DebugUpdateDelay",function(wep,oldVal,newVal)
	if LocalPlayer():GetActiveWeapon() != wep then return end
	if oldVal == newVal then return end
	skipAmount = FRAMES_TO_SKIP //calcSkippedFrames()
	forcedFrames = FRAMES_TO_FORCE
end)

hook.Add("CA_CamFlashToggled","CA_DebugUpdateDelay",function(wep,newState)
	if LocalPlayer():GetActiveWeapon() != wep then return end
	skipAmount = FRAMES_TO_SKIP //calcSkippedFrames()
	forcedFrames = FRAMES_TO_FORCE
end)