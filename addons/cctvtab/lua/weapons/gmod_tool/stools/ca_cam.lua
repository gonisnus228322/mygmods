// основная часть этого говнокода в sh_screen.lua

TOOL.Category		= "CA Cameras"
TOOL.Name			= "#tool.ca_cam.name"

if CLIENT then

	surface.CreateFont( "ca_headerfont", {
		font = "Roboto",
		size = 45,
		weight = 650,
		//underline = true,\
		
	} )

	surface.CreateFont( "ca_settingsfont", {
		font = "Arial",
		size = 15,
		weight = 450,
		//underline = true,\
		
	} )

	TOOL.Information = {

		{ name = "left" },

	}

	language.Add("tool.ca_cam.name", "Configurator")
	language.Add("tool.ca_cam.desc", "Tool for spawning and configurating Case Animatronics cameras")
	language.Add("tool.ca_cam.left", "Spawn camera using your current view")


	language.Add("tool.ca_cam.cam_draw", "Enable render of camera entities")
	language.Add("tool.ca_cam.cam_flashlight_enabled", "Allow players to use camera's flashlight")

	language.Add("tool.ca_cam.cam_updatetime_svonly", "Force camera's update time serverside")
	language.Add("tool.ca_cam.cam_updatetime_sv", "Server's camera's update cooldown")

	language.Add("tool.ca_cam.cam_pixelrate_svonly", "Force camera's pixelation rate serverside")
	language.Add("tool.ca_cam.cam_pixelrate_sv", "Server's camera's pixelation rate (1 - highest quality)")

	language.Add("tool.ca_cam.holsterskip", "Disable tablet's holster animation")

	language.Add("tool.ca_cam.adminonly", "Determine if only admin can interact with cameras")
	language.Add("tool.ca_cam.autosave", "Enable camera preset autosave on disconnect/map change")
	language.Add("tool.ca_cam.autoload", "Enable camera preset autoload on join")
	language.Add("tool.ca_cam.cam_physgun", "Enable physgun interaction with camera entities")
	language.Add("tool.ca_cam.cleanup", "Cleanup cameras (THINK TWICE)")
	language.Add("tool.ca_cam.saveload_warn", "\nSave/load browser wasn't loaded because you are not server host. Check ca_* concommands if you still want to use presets")
	language.Add("tool.ca_cam.load", "Load selected camera preset")
	language.Add("tool.ca_cam.save", "Save current camera preset")
	language.Add("tool.ca_cam.reinit_server", "ReInitiliaze cameras on server")

	language.Add("tool.ca_cam.cam_resolution", "Camera's view resolution")
	//language.Add("tool.ca_cam.cam_predict_camswitch", "Enable camera's switch prediction (reduces inputlag but may cause visual problems)")
	language.Add("tool.ca_cam.cam_updatetime", "Camera's update cooldown")
	language.Add("tool.ca_cam.cam_pixelrate", "Camera's pixelation rate (1 - highest quality)")
	language.Add("tool.ca_cam.reinit_client", "ReInitiliaze cameras on client")

	// TODO: Оптимизировать под разные разрешения моника
	// TODO: Переписать или как-либо увеличить читаемость кода (я сам уже нихуя в нем не понимаю)

	local function removeZalupa(path,addIn)
		addIn = addIn or 0
		local newPath = ""
		local removeAmount = #CA_SAVELOAD_DIR + 1 + addIn
		for i = 1 + removeAmount, #path do
			newPath = newPath..path[i]
		end
		return newPath
	end

	local function removeDuplicateSlash(str)
		local prevChar
		local newStr = ""
		for i = 1, #str do
			local char = str[i]
			if !prevChar then 
				prevChar = char
				newStr = newStr..char
				continue 
			end
			if char == prevChar && char == "/" then
				continue
			end
			newStr = newStr..char
			prevChar = char 
		end

		return newStr
	end

	local curSelectedFile = nil
	local curSelectedDir = ""

	local saveBrowser = nil
	local warningMenu = nil

	local noVariants = {
		"bla-bla-~",
		"No",
		"Idi nahui",
		"Nein"
	}

	local restrictedSymbols = { // проверка на дурака
		["."] = true,
		["/"] = true,
		//["\"] = true,
	}


	local function checkStrValid(str)
		for _,char in ipairs(str) do
			if restrictedSymbols[char] then
				return false
			end
		end
		return true
	end

	local function createSaveMenu()
		local fr = vgui.Create("DFrame")
		fr:SetTitle("SAVE")
		fr:SetSize( 200, 150 )
		fr:Center()
		fr:MakePopup()
		
		local name = vgui.Create("DTextEntry",fr)
		name:Dock(TOP)
		name:DockMargin(0,5,0,0)
		name:SetPlaceholderText("Save file name")

		local dir = vgui.Create("DTextEntry",fr)
		dir:Dock(TOP)
		dir:DockMargin(0,5,0,0)
		dir:SetPlaceholderText("Save folder name( optional )")

		local approve = vgui.Create("DButton",fr)
		approve:Dock(BOTTOM)
		approve:DockMargin(0,10,0,5)
		approve:SetText("Save preset")
		approve.DoClick = function(s)
			if name:GetValue() == "" then 
				notification.AddLegacy( "File name field is empty", NOTIFY_ERROR, 2 )
				surface.PlaySound( "buttons/button10.wav" )
				return 
			end
			if !checkStrValid( string.ToTable( name:GetValue() ) ) || !checkStrValid( string.ToTable( dir:GetValue() ) ) then
				notification.AddLegacy( "File name or save folder name contains restricted characters", NOTIFY_ERROR, 2 )
				surface.PlaySound( "buttons/button10.wav" )
				return
			end
			local exactCommand = "ca_savepreset "..name:GetValue().." "..dir:GetValue()
			LocalPlayer():ConCommand(exactCommand)
			timer.Simple(0.5,function()
				saveBrowser:SetupTree()
				saveBrowser:SetCurrentFolder(CA_SAVELOAD_DIR)
				saveBrowser:SetOpen(true)
			end)
			fr:Remove()
		end

	end

	local function createWarningMenu(funcYes,funcNo,warningMsg,yBoost)
		if IsValid(warningMenu) then warningMenu:Close() end
		local fr = vgui.Create("DFrame")
		fr:SetTitle("WARNING")
		fr:SetSize( 200, 100 )
		fr:Center()
		fr:MakePopup()

		fr.PaintOver = function(s)
			draw.DrawText( warningMsg or "а где", "TargetID", 100, 35 + (yBoost and yBoost or 0), Color(255,255,255), TEXT_ALIGN_CENTER )
		end
		
		local yes = vgui.Create("DButton",fr)
		yes:Dock(LEFT)
		yes:DockMargin(0,40,20,5)
		yes:SetText("Yes")

		yes.DoClick = function(s)
			if isfunction(funcYes) then
				funcYes()
			end
			fr:Remove()
		end

		local no = vgui.Create("DButton",fr)
		no:Dock(RIGHT)
		no:DockMargin(20,40,0,5)
		no:SetText( noVariants[ math.random(#noVariants) ] )

		no.DoClick = function(s)
			fr:Close()
		end

		fr.OnClose = function(s)
			if isfunction(funcNo) then
				funcNo()
			end
			warningMenu = nil
		end
		warningMenu = fr
	end

	local function createSaveBrowser(formPanel)
		
		saveBrowser = vgui.Create( "DFileBrowser" )
		saveBrowser:SetPath( "DATA" )
		saveBrowser:SetBaseFolder( CA_SAVELOAD_DIR ) 
		saveBrowser:SetOpen( true ) 
		saveBrowser:SetCurrentFolder(CA_SAVELOAD_DIR)
		function saveBrowser:OnSelect( path, pnl ) 
			curSelectedDir = removeZalupa( saveBrowser:GetCurrentFolder() )
			curSelectedFile = string.StripExtension( pnl:GetColumnText(1) )
		end	
		formPanel:AddItem(saveBrowser)

		saveBrowser:SetHeight(200)

		local nodeToDelete

		local function yesFolderDelete()
			if !nodeToDelete then return end
			if nodeToDelete:GetFolder() == saveBrowser:GetCurrentFolder() then
				saveBrowser:SetCurrentFolder(CA_SAVELOAD_DIR)
				curSelectedDir = ""
				curSelectedFile = nil
			end
			local folder = nodeToDelete:GetFolder() //removeZalupa( nodeToDelete:GetFolder() )
			local isRoot = string.EndsWith(folder,CA_SAVELOAD_DIR)
			if isRoot then
				notification.AddLegacy( "You are not allowed to delete root folder", NOTIFY_ERROR, 2 )
				surface.PlaySound( "buttons/button10.wav" )
				return
			end
			//local mainPath = CA_SAVELOAD_DIR.."/"..folderName
			local filesInside = file.Find( folder.."/*","DATA")
			for _,foundFile in ipairs(filesInside) do
				local deletePath = folder.."/"..foundFile
				file.Delete(deletePath,"DATA")
			end
			file.Delete( folder )
			nodeToDelete:Remove()
			saveBrowser:SetOpen(true)
		end


		saveBrowser.Tree.DoRightClick = function(s, node)
			nodeToDelete = node
			createWarningMenu(yesFolderDelete,nil,"Do you really want\n to delete this folder?",-5)
			
		end

		local panelToDelete,fileToDelete

		local function yesFileDelete()
			if !panelToDelete || !fileToDelete then return end
			//fileToDelete = removeDuplicateSlash(fileToDelete)
			/*local fileName = removeZalupa( fileToDelete,#curSelectedDir > 0 and #curSelectedDir+1 or 0 )	
			finalPath = CA_SAVELOAD_DIR.."/"
			if curSelectedDir != "" then
				finalPath = finalPath..curSelectedDir.."/"
			end
			finalPath = finalPath..fileName*/
			file.Delete(fileToDelete,"DATA")
			curSelectedFile = nil
			curSelectedDir = ""
			saveBrowser.Files:RemoveLine(panelToDelete:GetID())
		end

		local function noFileDelete()
			curSelectedFile = nil
			curSelectedDir = ""
		end

		saveBrowser.OnRightClick = function(s, filepath,selectedPanel)
			panelToDelete = selectedPanel
			fileToDelete = filepath
			createWarningMenu(yesFileDelete,noFileDelete,"Do you really want\n to delete this file?",-5)
		end

		
	end

	local function createSaveLoadButton( formPanel )
		local saveButton = formPanel:Button("#tool.ca_cam.save")
		local loadButton = formPanel:Button("#tool.ca_cam.load")
		formPanel:AddItem(saveButton,loadButton)
		saveButton:SetWide(saveButton:GetWide() * 1.65)
		loadButton:SetWide(loadButton:GetWide() * 0.35)

		function saveButton:DoClick()
			createSaveMenu()
		end

		local function yesChoice()
			if !curSelectedFile then
				notification.AddLegacy( "You didn't selected any file to load!", NOTIFY_ERROR, 2 )
				surface.PlaySound( "buttons/button10.wav" )
				return
		 	end
			local exactCommand = "ca_loadpreset "..curSelectedFile.." "..curSelectedDir
			LocalPlayer():ConCommand(exactCommand)
		end

		function loadButton:DoClick()
			createWarningMenu(yesChoice,nil,"Are you sure?")
		end
	end

	local function createCleanupButton( formPanel )
		local cleanupButton = formPanel:Button("#tool.ca_cam.cleanup")

		local function yesFunction()
			LocalPlayer():ConCommand("ca_cleanup")
		end

		cleanupButton.DoClick = function(s)
			createWarningMenu(yesFunction,nil,"Are you REALLY sure?")
		end
	end


	function TOOL.BuildCPanel( CPanel )

		//CPanel:AddControl( "Header", { Description = "#tool.ballsocket.help" } )

		//CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "ballsocket", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

		//CPanel:AddControl( "Slider", { Label = "#tool.forcelimit", Command = "ballsocket_forcelimit", Type = "Float", Min = 0, Max = 50000, Help = true } )

		//CPanel:AddControl( "CheckBox", { Label = "#tool.nocollide", Command = "ballsocket_nocollide", Help = true } )

		local serverHeader = CPanel:ControlHelp("SERVER")

		serverHeader:SetFont("ca_headerfont")
		serverHeader:DockMargin(5,0,0,0)

		CPanel:CheckBox("#tool.ca_cam.cam_draw","ca_cams_draw")
		CPanel:CheckBox("#tool.ca_cam.adminonly","ca_cams_adminonly")
		CPanel:CheckBox("#tool.ca_cam.autosave","ca_autosave_enabled")
		CPanel:CheckBox("#tool.ca_cam.autoload","ca_autoload_enabled")
		CPanel:CheckBox("#tool.ca_cam.cam_physgun","ca_cams_physgun")
		CPanel:CheckBox("#tool.ca_cam.cam_flashlight_enabled","ca_cams_flashlight_enabled")
		CPanel:CheckBox("#tool.ca_cam.holsterskip","ca_holsterskip")
		CPanel:CheckBox("#tool.ca_cam.cam_updatetime_svonly","ca_camdelay_serversideonly")
		CPanel:NumSlider("#tool.ca_cam.cam_updatetime_sv","ca_cams_updatetime_sv",0,10,2)
		CPanel:CheckBox("#tool.ca_cam.cam_pixelrate_svonly","ca_cams_pixelrate_svonly")
		CPanel:NumSlider("#tool.ca_cam.cam_pixelrate_sv","ca_cams_pixelrate_sv",1,32,1)
		
		if LocalPlayer():IsListenServerHost() then
			createSaveBrowser( CPanel )
			createSaveLoadButton( CPanel )
		else
			CPanel:ControlHelp("#tool.ca_cam.saveload_warn")
		end

		CPanel:Button("#tool.ca_cam.reinit_server","ca_cams_sync_server")
		createCleanupButton( CPanel )

		local clientHeader = CPanel:ControlHelp("CLIENT")

		clientHeader:SetFont("ca_headerfont")
		clientHeader:DockMargin(5,0,0,0)

		local resCombo,resLabel = CPanel:ComboBox("#tool.ca_cam.cam_resolution","ca_cams_resolution")
		resCombo:SetSortItems(false)
		resCombo:DockMargin(20,0,0,0)
		resLabel:SetWide(resLabel:GetWide() * 1.5)

		resCombo:AddChoice("1024x1024",1024)
		resCombo:AddChoice("512x512",512)
		resCombo:AddChoice("256x256",256)
		resCombo:AddChoice("128x128",128)

		//CPanel:CheckBox("#tool.ca_cam.cam_predict_camswitch","ca_cams_predict_camswitch")
		CPanel:NumSlider("#tool.ca_cam.cam_updatetime","ca_cams_updatetime",0,10,2)
		CPanel:NumSlider("#tool.ca_cam.cam_pixelrate","ca_cams_pixelrate",1,32,1)
		CPanel:Button("#tool.ca_cam.reinit_client","ca_cams_sync_client")

	end

end

TOOL.LeftClickAutomatic = false
TOOL.RightClickAutomatic = false
TOOL.RequiresTraceHit = false

function TOOL:LeftClick( trace )
	if CLIENT then return end

	local ply = self:GetOwner()
    if !IsValid(ply) then return end
	local ang = ply:EyeAngles()
	local calcPos = ply:EyePos() - ang:Forward() * CA_CAMVIEW_OFFSET.x - ang:Right() * CA_CAMVIEW_OFFSET.y - ang:Up() * CA_CAMVIEW_OFFSET.z
    local ent = CA_CreateCamera(calcPos,ang,ply)
	if IsValid(ent) then
		ent:GetPhysicsObject():EnableMotion(false)
	end
	return true
end