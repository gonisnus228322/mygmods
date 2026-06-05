local Angle = Angle

CA_CamsData = CA_CamsData || {}
CA_CamsDataByEnt = CA_CamsDataByEnt || {}
CA_CamCount = CA_CamCount || 0


local ADMIN_ONLY = CreateConVar("ca_cams_adminonly", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Determine if only admin can interact with cameras")
local PICKUP_ENABLED = CreateConVar("ca_cams_physgun", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Determine if player can interact with camera using physgun")
local AUTOSAVE_ENABLED = CreateConVar("ca_autosave_enabled", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enable/Disable camera preset autosave on disconnect")
local AUTOLOAD_ENABLED = CreateConVar("ca_autoload_enabled", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enable/Disable loading current map camera preset auto-loading")
local HOLSTERANIM_SKIP = CreateConVar("ca_holsterskip", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Disables holster animation")
local CAMPIXELRATE_SVONLY = CreateConVar("ca_cams_pixelrate_svonly", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Forces camera's pixelation rate using serverside variable")
local CAMPIXELRATE_SV = CreateConVar("ca_cams_pixelrate_sv", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Server's camera's pixelation rate",1)
local CAMUPDATE_SVONLY = CreateConVar("ca_camdelay_serversideonly", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Forces camera's update delay using serverside variable")
local CAMUPDATE_SV = CreateConVar("ca_cams_updatetime_sv", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Server's camera's update time")
local FLASHLIGHT_ENABLED = CreateConVar("ca_cams_flashlight_enabled", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enable flashlight for cameras(F by default) (CLIENTSIDE ONLY)")
//local PICKUP_ADMINONLY = CreateConVar("ca_cams_physgun_adminonly", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Determine if player only")

CA_SAVELOAD_DIR = "ca_camsdata"
CA_CAMVIEW_OFFSET = Vector(6,-2.5,-3.5)

if SERVER then

    resource.AddWorkshop("3506743440") // я не буду для каждого файла эту хуйню писать

    util.AddNetworkString("CA_AddCamera")
    util.AddNetworkString("CA_DeleteCamera")
    util.AddNetworkString("CA_Notify")

    function CA_InitCamera(camEntity,ply,dontBroadcast)
        local newIndex = table.insert(CA_CamsData,camEntity)
        CA_CamsDataByEnt[camEntity:EntIndex()] = #CA_CamsData
        CA_CamCount = #CA_CamsData
        camEntity:SetCamID(newIndex)

        if IsValid(ply) then
            undo.Create("CA Camera")
                undo.AddEntity(camEntity)
                undo.SetPlayer(ply)
            undo.Finish()
        end

        if !dontBroadcast then
            timer.Simple(0,function()
                net.Start("CA_AddCamera")
                    net.WriteInt(camEntity:EntIndex(),16)
                net.Broadcast()
            end)
        end

        return newIndex
    end

    function CA_CreateCamera(pos,ang,ply,dontBroadcast,overrideVars)
        if ADMIN_ONLY:GetBool() && IsValid(ply) then
            if !ply:IsAdmin() then 
                net.Start("CA_Notify")
                    net.WriteString("Only admins are allowed to spawn cameras on this server")
                    net.WriteInt(1,4)
                net.Send(ply)
                return 
            end
        end
        if !pos || !ang then return end

        local camEnt = ents.Create("ca_camera")
        camEnt:SetPos(pos)
        camEnt:SetAngles(ang)
        camEnt.overrideVars = overrideVars
        camEnt:Spawn()
        local newID = CA_InitCamera(camEnt,ply,dontBroadcast)

        hook.Call("CA_CameraCreate",nil,newID)
        return camEnt
    end

    function CA_DeleteCamera(index)
        local countNum = CA_CamsDataByEnt[index]

        if !CA_CamsData[countNum] then return end
        
        table.remove(CA_CamsData,countNum)
        CA_CamsDataByEnt[index] = nil
        CA_CamCount = #CA_CamsData
        for k,ind in pairs(CA_CamsDataByEnt) do
            if ind > countNum then
                local newIndex = ind - 1
                CA_CamsDataByEnt[k] = newIndex
                local camEnt = Entity(k)
                camEnt:SetCamID(newIndex)
            end
        end

        net.Start("CA_DeleteCamera")
            net.WriteInt(index,10)
        net.Broadcast()

        hook.Call("CA_CameraDelete",nil,countNum)
    end

    local function cleanUpCameras()
        local camCounter = 0
        for _,ent in ipairs( ents.FindByClass("ca_camera") ) do
            ent:Remove() // вообще эта хуйня в теории должна сама справляться с уборкой камер без кода ниже, но увы
            camCounter = camCounter + 1
        end

        CA_CamsData = {}
        CA_CamsDataByEnt = {}
        CA_CamCount = 0
        for _,ply in player.Iterator() do // говнокод
            ply:SendLua("CA_CamsData = {}  CA_CamsDataByEnt = {}  CA_CamCount = 0")
        end

        net.Start("CA_Notify")
            net.WriteString("Cleaned up "..camCounter.." cameras")
            net.WriteInt(2,4)
        net.Broadcast()
    end

    hook.Add("PreCleanupMap","CA_CleanupCameras",function() // абсолютно пососный метод, увы
        cleanUpCameras()
    end)

    // добавление в видимость игрока поле зрения камеры

    hook.Add("SetupPlayerVisibility","CA_ConfPVS",function(ply,viewEntity)
        local obsTarget = ply:GetObserverTarget()
        local pl = ( ply:GetObserverMode() == OBS_MODE_IN_EYE && obsTarget:IsPlayer() ) and obsTarget or ply

        local wep = pl:GetActiveWeapon()

        if !IsValid(wep) || wep:GetClass() != "ca_tablet" then return end
        if CA_CamCount <= 0 then return end
        local camEnt = CA_CamsData[wep:GetCurCamera()]
        if !IsValid( camEnt ) then return end // || camEnt:TestPVS(pl)

        local ang = camEnt:GetAngles()

        AddOriginToPVS( camEnt:GetPos() + ang:Forward() * (CA_CAMVIEW_OFFSET.x * 0.9) + ang:Right() * CA_CAMVIEW_OFFSET.y + ang:Up() * CA_CAMVIEW_OFFSET.z )
    end)

    // обработка удаления камера

    hook.Add("EntityRemoved","CA_CameraRemoved",function(delEnt)
        if delEnt:GetClass() != "ca_camera" then return end

        CA_DeleteCamera(delEnt:EntIndex())
    end)

    // загрузка-сохранение пресета камер

    function CA_ReInitServer()
        CA_CamsData = {}
        CA_CamsDataByEnt = {}
        CA_CamCount = 0

        local kostilTbl = {}
        
        local camTbl = ents.FindByClass("ca_camera")
        local camAmount = #camTbl

        for _,ent in ipairs( camTbl ) do
            if ent:GetCamID() <= 0 then 
                ent:SetCamID(camAmount)
            end
            local subTbl = {ent:EntIndex(),ent:GetCamID()}
            table.insert(kostilTbl,subTbl)
        end

        for _,data in SortedPairsByMemberValue(kostilTbl,2) do
            CA_InitCamera(Entity(data[1]))
        end

        for _,ply in player.Iterator() do
            ply:ConCommand("ca_cams_sync_client")
        end
    end

    local function loadCameraPreset(fileName,subDir,needToReInit)
        if !fileName then 
            return 
        end

        local loadPath = CA_SAVELOAD_DIR.."/"
        if subDir then
            loadPath = loadPath..subDir.."/"
        end
        local loadFile = loadPath..fileName..".json"

        if file.Exists( loadFile , "DATA" ) then
            local camData = file.Read(loadFile)
            camTbl = util.JSONToTable(camData)
            if !camTbl then return end

            local camCount = 0
            for _,data in pairs(camTbl) do
                local camEntity = CA_CreateCamera(data.pos,data.ang,nil,needToReInit,data.vars)
                if IsValid(camEntity) then
                    camEntity:GetPhysicsObject():EnableMotion(false)
                    camCount = camCount + 1
                end
            end

            net.Start("CA_Notify")
                net.WriteString("Preset loaded with "..camCount.." cameras")
                net.WriteInt(0,4)
            net.Broadcast()

            if needToReInit then // слегка бесполезно бтв
                CA_ReInitServer()
            end
        end
    end

    local function saveCameraPreset(fileName,subDir)
        if !fileName then return end

        local savetbl = {}
        local camCount = 0
        for _,cameraEnt in ipairs(CA_CamsData) do
            local camDt = {pos = cameraEnt:GetPos(),ang = cameraEnt:GetAngles(),vars = cameraEnt:GetNetworkVars()}
            table.insert(savetbl,camDt)
            camCount = camCount + 1
        end

        local saveJSON = util.TableToJSON(savetbl)
        local savePath = CA_SAVELOAD_DIR.."/"
        file.CreateDir(CA_SAVELOAD_DIR)
        if subDir then
            file.CreateDir(savePath.."/"..subDir)
            savePath = savePath.."/"..subDir.."/"
        end

        file.Write( savePath..fileName..".json", saveJSON )
    end

    hook.Add("InitPostEntity","CA_LoadCameraPreset",function()
        if !AUTOLOAD_ENABLED:GetBool() then return end
        loadCameraPreset(game.GetMap())
    end)

    hook.Add( "ShutDown", "CA_SaveCameraPreset", function()
        //if CA_CamCount <= 0 then return end
        if !AUTOSAVE_ENABLED:GetBool() then return end
        saveCameraPreset(game.GetMap())
    end )

    // обработка поднятия камеры физганом

    hook.Add( "PhysgunPickup", "CA_PhysgunPickup", function( ply, ent )
        if ent:GetClass() != "ca_camera" then return end

        if ADMIN_ONLY:GetBool() && !ply:IsAdmin() then
            return false
        end

        if PICKUP_ENABLED:GetBool() then
            return true
        end

        return false
    end )

    concommand.Add("ca_savepreset",function(ply,cmd,args)
        if IsValid(ply) && !ply:IsSuperAdmin() then return end

        local fileName = args[1]
        local prefixDir = args[2]
        saveCameraPreset(fileName,prefixDir)

    end,nil,"Saves preset using 1st argument as file name and 2nd argument as subdirectory")

    concommand.Add("ca_loadpreset",function(ply,cmd,args)
        if IsValid(ply) && !ply:IsSuperAdmin() then return end

        local fileName = args[1]
        local dirPrefix = args[2]
        loadCameraPreset(fileName,dirPrefix,true)

    end,nil,"Loads preset using 1st argument as file name and 2nd argument as subdirectory")

    concommand.Add("ca_cleanup",function(ply,cmd,args)
        if IsValid(ply) && !ply:IsSuperAdmin() then return end

        cleanUpCameras()

    end)

    concommand.Add("ca_cams_sync_server",function( ply )
        if IsValid(ply) && !ply:IsSuperAdmin() then return end

        CA_ReInitServer()
    end)


else 

    local DEFAULT_DATA

    local notifySounds = {
        [0] = "buttons/button15.wav",
        [1] = "buttons/button10.wav",
        [2] = "buttons/button15.wav",
        [3] = "buttons/button15.wav",
        [4] = "buttons/button15.wav",
    }

    local matScreen = Material( "models/vondaram/tablet/ekran" )

    local function recalculateDefaultData()
        DEFAULT_DATA = {
            origin = Vector(0,0,0),
            angles = Angle(0,0,0),
            x = 0, y = 0,
            w = matScreen:Width(), h = matScreen:Height(),
            drawviewmodel = false,
            drawviewer = true,
            fov = 90,
            viewid = 2,
        }
    end

    recalculateDefaultData()

    local function createCamera(entIndex)
        local enti = Entity(entIndex)
        if !IsValid(enti) then return end

        local new_data = table.Copy(DEFAULT_DATA)
        new_data.origin = enti:GetPos()
        new_data.angles = enti:GetAngles()
        new_data.internEntity = enti
        
        local newIndex = table.insert(CA_CamsData,new_data)
        CA_CamsDataByEnt[enti:EntIndex()] = #CA_CamsData
        CA_CamCount = #CA_CamsData
        hook.Call("CA_CameraCreate",nil,newIndex)
    end

    local function deleteCamera(index)
        local countNum = CA_CamsDataByEnt[index]
        if countNum then
            table.remove(CA_CamsData,countNum)
            CA_CamsDataByEnt[index] = nil
            CA_CamCount = #CA_CamsData

            for k,ind in pairs(CA_CamsDataByEnt) do
                if ind > countNum then
                    CA_CamsDataByEnt[k] = ind - 1
                end
            end
            
            hook.Call("CA_CameraDelete",nil,countNum)
        end
    end

    local function reInitClient()
        CA_CamsData = {}
        CA_CamsDataByEnt = {}
        CA_CamCount = 0

        local kostilTbl = {}
        
        for _,camEnt in ipairs( ents.FindByClass("ca_camera") ) do
            if !camEnt.GetCamID then // энтити еще не инициализирован?
                timer.Simple(0.3,function()
                    reInitClient()
                end)
                return
            end
            local newTbl = {camEnt:EntIndex(),camEnt:GetCamID()}
            table.insert(kostilTbl,newTbl)
        end

        for _,data in SortedPairsByMemberValue(kostilTbl,2) do
            createCamera(data[1])
        end
    end

    net.Receive("CA_AddCamera",function()
        local entIndex = net.ReadInt(16)
        createCamera(entIndex)
    end)

    net.Receive("CA_DeleteCamera",function()
        local index = net.ReadInt(10)
        deleteCamera(index)
    end)

    net.Receive("CA_Notify",function()
        local str = net.ReadString()
        local index = net.ReadInt(4)

        notification.AddLegacy( str, index, 3 )

        if notifySounds[index] then
            surface.PlaySound( notifySounds[index] )
        end
        
    end)

    // подгрузка камер на клиенте

    hook.Add( "InitPostEntity", "CA_InitCams", function()
        timer.Simple(0,function()
            reInitClient()
        end)
    end )

    concommand.Add("ca_cams_sync_client",function()
        reInitClient()
    end)

end