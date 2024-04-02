local QBCore = exports['qb-core']:GetCoreObject()
local vehiclelist = {}
local recovervehicls = {}
local payreturn = {}
-- Custom Server Events

RegisterServerEvent('kp-Rental:server:recovevehicle', function(paymentType, vehicle, availablePark)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local playerBankCash = Player.PlayerData.money["bank"]
    if recovervehicls[vehicle.plate] then return TriggerClientEvent('QBCore:Notify', src, "Vehicle already recoverd", "error") end
    if vehiclelist[vehicle.plate] then
        local futureTimeStamp = os.time()
        if vehiclelist[vehicle.plate] < futureTimeStamp then
            if playerBankCash >= vehicle.price then
                Player.Functions.RemoveMoney(paymentType, vehicle.price, "rentals")
                TriggerClientEvent('QBCore:Notify', src, Lang:t("success.rented_vehicle") .. vehicle.price, "success")
                TriggerClientEvent('kp-Rental:client:vehicleReSpawn', src, vehicle.model, vehicle.plate, availablePark)
                recovervehicls[vehicle.plate] = true
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_money"), "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "Not possible to recove this vehicle at thi time", "error")
        end
    else
        Player.Functions.RemoveItem('rental_papers', 1, vehicle.slot)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['rental_papers'], "remove")
        TriggerClientEvent('QBCore:Notify', src, "Not possible to recove this vehicle", "error")
    end

end)

--
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
    payreturn[vehicle.model] = vehicle.price
end)

RegisterServerEvent('kp-Rental:server:giveRentalPaper', function(model, plateText)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerData = Player.PlayerData
    local currentTimeStamp = os.time()
    local newTimeStamp = currentTimeStamp + 3600
    vehiclelist[plateText] = newTimeStamp
    local info = {
        temporaryOwner = PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname,
        citizenid = PlayerData.citizenid,
        vehicleModel = model,
        plate = plateText,
    }
    Player.Functions.AddItem('rental_papers', 1, false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['rental_papers'], "add")
end)

QBCore.Functions.CreateCallback('kp-rental:server:hasrentalpapers', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        cb(Player.PlayerData)
    else
        cb(false)
    end
end)
RegisterServerEvent("kp-rental:server:removepaper", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.RemoveItem(data.name, data.amount, data.slot)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['rental_papers'], "remove")
        local amount = payreturn[data.info.vehicleModel] or 25
        amount = math.round((amount/2))
        Player.Functions.AddMoney("cash", amount, "rentals-return")
    end
end)
