local QBCore = exports['qb-core']:GetCoreObject()

-- Custom Server Events
RegisterServerEvent('kp-Rental:server:attemptPayRent', function(paymentType, vehicle, availablePark)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local driverLicense = Player.PlayerData.metadata["licences"]["driver"]

    local playerCash = Player.PlayerData.money["cash"]
    local playerBankCash = Player.PlayerData.money["bank"]

    if not driverLicense and vehicle.needLicense then
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_license"), "error")
        return
    end

    if paymentType == 'cash' then
        if playerCash >= vehicle.price then
            TriggerClientEvent('kp-Rental:client:payRent', src, 'cash', vehicle, availablePark)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_money"), "error")
        end
    elseif paymentType == 'bank' then
        if playerBankCash >= vehicle.price then
            TriggerClientEvent('kp-Rental:client:payRent', src, 'bank', vehicle, availablePark)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_money"), "error")
        end
    end
end)

RegisterServerEvent('kp-Rental:server:payRent', function(paymentType, vehicle, availablePark)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveMoney(paymentType, vehicle.price, "rentals")
    TriggerClientEvent('QBCore:Notify', src, Lang:t("success.rented_vehicle") .. vehicle.price, "success")
    TriggerClientEvent('kp-Rental:client:vehicleSpawn', src, vehicle.model, vehicle.price, availablePark)
end)

RegisterServerEvent('kp-Rental:server:giveRentalPaper', function(model, plateText)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerData = Player.PlayerData
    local info = {
        temporaryOwner = PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname,
        citizenid = PlayerData.citizenid,
        vehicleModel = model,
        plate = plateText
    }
    Player.Functions.AddItem('rental_papers', 1, false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['rental_papers'], "add")
end)