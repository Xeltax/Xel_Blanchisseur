ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("Xel_Blanchisseur:blanchir")
AddEventHandler("Xel_Blanchisseur:blanchir", function(montant)

    local _src = source
	local xPlayer 		= ESX.GetPlayerFromId(_src)
	local account 		= xPlayer.getAccount(Config.TypeArgent)
    local pourcentage   = Config.Pourcentage

	if montant > 0 and account.money >= montant then
		
		local bonus = math.random(Config.BonusMin ,Config.BonusMax)
		local total = math.floor(montant / 100 * (pourcentage + bonus))	

		xPlayer.removeAccountMoney(Config.TypeArgent, montant)
		xPlayer.addMoney(total)
		
        TriggerClientEvent('esx:showAdvancedNotification', _src, 'Blanchisseur', '', "Tien je te donne ~g~" .. total .. "$ ~s~." , 'CHAR_LESTER_DEATHWISH', 2)
	else
		TriggerClientEvent('esx:showAdvancedNotification', _src, 'Blanchisseur', '', "Tu n'as pas assez de sous casse toi de la." , 'CHAR_LESTER_DEATHWISH', 2)
	end

end)