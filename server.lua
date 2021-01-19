ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_technikine:Addlicdstskdjiotisdtoih', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_license:addLicense', source, 'technikine', function()
		cb(true)
	end)
end)
