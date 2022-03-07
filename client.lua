Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function OpenBlanchisseur(ped)

	local Blanchisseur = RageUI.CreateMenu("Blanchisseur", " ", 1, 1, "commonmenu", "gradient_nav", 5, --[[Rouge]] 0, --[[Vert]] 0, --[[Bleu]] 0);

	function RageUI.PoolMenus:Example()
		Blanchisseur:IsVisible(function(Items)
			-- Item
			Items:AddSeparator("~h~💸 Lavage de ~r~faux billets~s~ 💸")
			Items:AddButton("Blanchir l'argent", nil, { IsDisabled = false , RightLabel = "→"}, function(onSelected)
				if (onSelected) then
					deplacement  = true
					DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
					while (UpdateOnscreenKeyboard() == 0) do
						DisableAllControlActions(0);
						Wait(0);
					end
					if (GetOnscreenKeyboardResult()) then
						local montant = GetOnscreenKeyboardResult()
						if tonumber(montant) then
							blanchiment(montant, ped)
						end
					end
				end
			end, Vehicule)


		end, function(Panels)
		end)

	end

	RageUI.Visible(Blanchisseur, not RageUI.Visible(Blanchisseur))
end

function blanchiment(montant, ped)
	
	while not HasAnimDictLoaded("mp_common") do
		RequestAnimDict("mp_common")
		Citizen.Wait(1)
	end

	local Player = PlayerId()
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(-1))

    ESX.ShowAdvancedNotification(GetPlayerName(Player), '', "Salut tu veut bien ~r~blanchir~s~ mon argent ?", mugshotStr, 1)
    UnregisterPedheadshot(mugshot)

	Citizen.Wait(2000)
	ESX.ShowAdvancedNotification("Blanchisseur", '', "Ouai tu veut blanchir ~r~" .. montant .. "$~s~ c'est ça ?", 'CHAR_LESTER_DEATHWISH', 1)

	Citizen.Wait(2000)
	ESX.ShowAdvancedNotification(GetPlayerName(Player), '', "Exact tu prends combien de ~r~pourcentage~s~ rappelle-moi ?", mugshotStr, 1)

	Citizen.Wait(2000)
	ESX.ShowAdvancedNotification("Blanchisseur", '', "Je prends ~r~" .. Config.Pourcentage .. "%~s~ pourquoi ça te plaît pas ?" , 'CHAR_LESTER_DEATHWISH', 1)

	Citizen.Wait(2000)
	ESX.ShowAdvancedNotification(GetPlayerName(Player), '', "Si si très bien.", mugshotStr, 1)

	TaskPlayAnim(GetPlayerPed(-1), "mp_common", "givetake1_a", 2.0, 2.0, -1, 0, 0, false, false, false) --animation du donner
	TaskPlayAnim(ped, "mp_common", "givetake1_a", 2.0, 2.0, -1, 0, 0, false, false, false) --animation du donner
	
	Citizen.Wait(2000)
	ESX.ShowAdvancedNotification("Blanchisseur", '', "Attend moi la j'arrive dans 1 min." , 'CHAR_LESTER_DEATHWISH', 1)

	FreezeEntityPosition(ped, 0)  --Un freeze du ped pour quil  puisse bouger

	local posblanchir = Config.PosPedQuandBlanchi
	local x, y, z = table.unpack(posblanchir)

	TaskGoToCoordAnyMeans(ped --[[ Ped ]], x --[[ number ]], y --[[ number ]], z--[[ number ]], 1.0 --[[ number ]]) -- on fait  allez le ped jusqu'a la pos

	Citizen.Wait(30000)

	ESX.ShowAdvancedNotification("Blanchisseur", '', "Plus que 30 petites secondes." , 'CHAR_LESTER_DEATHWISH', 1)

	
	Citizen.Wait(10000)

	local posbase = Config.PosBlanchiment
	local x1, y1, z1 = table.unpack(posbase)

	TaskGoToCoordAnyMeans(ped --[[ Ped ]], x1 --[[ number ]], y1 --[[ number ]], z1 --[[ number ]], 1.0 --[[ number ]]) -- on fait revenir  le ped au spanw a sa position

	Citizen.Wait(10000)
	SetEntityHeading(ped --[[ Entity ]], Config.PedRotation --[[ number ]]) -- on remet le ped à son heading de base
	FreezeEntityPosition(ped, 1) -- on refreeze le ped pour eviter les malins qui feraient de la merde
	Citizen.Wait(10000)

	TaskPlayAnim(GetPlayerPed(-1), "mp_common", "givetake1_a", 2.0, 2.0, -1, 0, 0, false, false, false) -- animation du donner
	TaskPlayAnim(ped, "mp_common", "givetake1_a", 2.0, 2.0, -1, 0, 0, false, false, false)  -- animation du donner

	TriggerServerEvent('Xel_Blanchisseur:blanchir', tonumber(montant)) -- trigger pour donner l'argent

	Citizen.Wait(2000)
	ESX.ShowAdvancedNotification(GetPlayerName(Player), '', "Merci, Aurevoir.", mugshotStr, 1)
end


Citizen.CreateThread(function()
	if Config.UtiliserUnPed then
		function LoadModel(model)
			while not HasModelLoaded(model) do
				RequestModel(model)
				Wait(1)
			end
		end
		
		local pedspawn = Config.PosPed
		local x, y, z = table.unpack(pedspawn)

		LoadModel(Config.ModelPed)
		Ped = CreatePed(2, GetHashKey(Config.ModelPed), x, y, z-0.96, Config.PedRotation, 0, 0)
		SetEntityInvincible(Ped, true)
		SetBlockingOfNonTemporaryEvents(Ped, 1)
		FreezeEntityPosition(Ped, 1)
	end

    while true do
		local wait = 750
		local pos = GetEntityCoords(PlayerPedId())
		local dist = #(pos - Config.PosBlanchiment)
		local marker = Config.PosBlanchiment
		local x, y, z = table.unpack(marker)

		if dist < 5 then
			wait = 0
			if Config.UtiliserUnPed == false then
				DrawMarker(21, x, y, z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, true, true, 2, nil, nil, true)
			end

			if dist < 1 then
				wait = 0
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~r~blanchir~s~ votre argent ~r~sale ~s~!")
				if IsControlJustPressed(0, 51) then
					OpenBlanchisseur(Ped)
				end
			end
		end
		Citizen.Wait(wait)
    end
end)
