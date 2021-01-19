local IsInMarker = false
local hasExited = false
local HasAlreadyEnteredMarker = false
local CurrentAction = false
local CurrentActionMsg
local CurrentActionData = {}
local sleep = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

--Create Blips
Citizen.CreateThread(function()
	for k,v in ipairs(Config.Zones) do
		local blip = AddBlipForCoord(v)

		SetBlipSprite (blip, Config.BlipSprite)
		SetBlipDisplay(blip, Config.Display)
		SetBlipScale  (blip, Config.Scale)
		SetBlipColour (blip, Config.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString("Technikine")
		EndTextCommandSetBlipName(blip)
	end
	--Credits
	while Citizen.Wait(900000) do
		print("esx_technikine is made by SteaX. Go to https://github.com/SteaXs")
	end
end)


--Create Marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker = false

		for k,v in pairs(Config.Zones) do
			local distance = #(playerCoords - v)
			
			if distance < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)

				if distance < Config.MarkerSize.x then
					IsInMarker = true
				else
					IsInMarker = false
				end
			end
		end

		if IsInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_technikine:hasEnteredMarker')
		end

		if not IsInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_technikine:hasExitedMarker')
		end
	end
end)

--Key Control
Citizen.CreateThread(function()
	local letSleep = false
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'menu_tech' then
					if IsPedInAnyVehicle(PlayerPedId(), false) then
						local vehicle = GetVehiclePedIsUsing(PlayerPedId())
						if IsVehicleDamaged(vehicle) then
							ESX.ShowNotification("Jusu transporto priemone yra ~r~aplamdyta~s~, atsiprasome bet jus neperejote technikines!")
						else
							ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
								if hasLicense then
									ESX.ShowNotification("Jus jau turite technikines licensija!")
								else
									ESX.TriggerServerCallback('esx_technikine:Addlicdstskdjiotisdtoih', function ()
										ESX.ShowNotification("Jusu transporto priemone ~g~sekmingai~s~ perejo technikine!")
									end)
								end
							end, GetPlayerServerId(PlayerId()), 'technikine')
						end
					else
						ESX.ShowNotification("Jus ~r~neeasate~s~ jokioje transporto priemoneje!")
					end
				end
			end
		end
		if letSleep then
			Citizen.Wait(1000)
			letSleep = false
		end
	end
end)

AddEventHandler('esx_technikine:hasEnteredMarker', function()
	CurrentAction = 'menu_tech'
	CurrentActionMsg = "Spauskite ~INPUT_CONTEXT~ jai norite kad praeitumete technikine"
	CurrentActionData = {}
end)

AddEventHandler('esx_technikine:hasExitedMarker', function()
	CurrentAction = nil
end)
