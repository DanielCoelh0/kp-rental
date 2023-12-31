local QBCore = exports['qb-core']:GetCoreObject()

local pedsSpawned = false
local blips = {}


-- Custom Useful Functions
local function createBlip(options)
    if not options.coords or type(options.coords) ~= 'table' and type(options.coords) ~= 'vector3' then return error(('createBlip() expected coords in a vector3 or table but received %s'):format(options.coords)) end
    local blip = AddBlipForCoord(options.coords.x, options.coords.y, options.coords.z)
    SetBlipSprite(blip, options.sprite or 1)
    SetBlipDisplay(blip, options.display or 4)
    SetBlipScale(blip, options.scale or 1.0)
    SetBlipColour(blip, options.colour or 1)
    SetBlipAsShortRange(blip, options.shortRange or false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(options.title or 'No Title Given')
    EndTextCommandSetBlipName(blip)
    return blip
end

local function deleteBlips()
    if not next(blips) then return end
    for i = 1, #blips do
        local blip = blips[i]
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    blips = {}
end

local function initBlips()
    for i = 1, #Config.Rentals do
        local rental = Config.Rentals[i]
        if rental.ShowBlip then
            blips[#blips + 1] = createBlip({
                coords = rental.Npc.coords,
                sprite = Config.Blips.sprite,
                display = Config.Blips.display,
                scale = Config.Blips.scale,
                colour = Config.Blips.colour,
                shortRange = true,
                title = Lang:t("blip.name")
            })
        end
    end
end

local function spawnPeds()
    if not Config.Rentals or not next(Config.Rentals) or pedsSpawned then return end
    for i = 1, #Config.Rentals do
        local currentRental = Config.Rentals[i]
        local currentNpc = currentRental.Npc
        currentNpc.model = type(currentNpc.model) == 'string' and joaat(currentNpc.model) or currentNpc.model
        RequestModel(currentNpc.model)
        while not HasModelLoaded(currentNpc.model) do
            Wait(0)
        end
        local ped = CreatePed(0, currentNpc.model, currentNpc.coords.x, currentNpc.coords.y, currentNpc.coords.z - 1, currentNpc.heading, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, currentNpc.scenario, true, true)
        currentNpc.pedHandle = ped
        
        local opts = nil
            
        opts = {
            label = Lang:t("menu.target"),
            icon = 'fa-solid fa-car',
            action = function()
                TriggerEvent('kp-Rental:client:openRentalMenu', currentRental)
            end
        }

        if opts then
            exports['qb-target']:AddTargetEntity(ped, {
                options = { opts },
                distance = 2.0
            })
        end
    end
    pedsSpawned = true
end

local function deletePeds()
    if not Config.Peds or not next(Config.Peds) or not pedsSpawned then return end
    for i = 1, #Config.Peds do
        local current = Config.Peds[i]
        if current.pedHandle then
            DeletePed(current.pedHandle)
        end
    end
    pedsSpawned = false
end

local function isThisParkAvaiable(coords)
    if not (IsPositionOccupied(coords.x, coords.y, coords.z, 3, false, true, false)) then
        return true
    else
        return false
    end
end


-- Custom Client Events
RegisterNetEvent('kp-Rental:client:openRentalMenu', function(rental)

    local rentalMenu = {
        {
            header = Lang:t("menu.header"),
            icon = "fa-solid fa-car",
            isMenuHeader = true,
        },
    }

    for i = 1, #Config.Vehicles do
        local currentVehicle = Config.Vehicles[i]
        local selectedParams = {}

        if Config.EnableBankPayment then
            selectedParams = {
                event = "kp-Rental:client:openPaymentMenu",
                args = {
                    vehicle = {
                        name = currentVehicle.name,
                        model = currentVehicle.modelName,
                        price = currentVehicle.price,
                        needLicense = currentVehicle.needLicense
                    },
                    currentRental = rental
                }
            }
        else
            selectedParams = {
                event = "kp-Rental:client:attemptRentVehicle",
                args = {
                    paymentType = 'cash',
                    vehicle = {
                        name = currentVehicle.name,
                        model = currentVehicle.modelName,
                        price = currentVehicle.price,
                        needLicense = currentVehicle.needLicense
                    },
                    currentRental = rental
                }
            }
        end

        rentalMenu[#rentalMenu + 1] = 
        {
            header = currentVehicle.name,
            txt = Lang:t("menu.price") .. currentVehicle.price,
            icon = currentVehicle.menuIcon,
            params = selectedParams
        }
    end

    rentalMenu[#rentalMenu + 1] = {
        header = Lang:t("menu.exit"),
        icon = "fa-solid fa-sign-out-alt",
        params = {
            event = "qb-menu:closeMenu",
        }
    }

    exports['qb-menu']:openMenu(rentalMenu)
end)

RegisterNetEvent('kp-Rental:client:openPaymentMenu', function(data)

    local paymentMenu = {
        {
            header = Lang:t("menu.payment_type_header"),
            txt = Lang:t("menu.payment_type_description"),
            icon = "fa-solid fa-comments-dollar",
            isMenuHeader = true,
        },
        {
            header = Lang:t("menu.bank_title"),
            txt = Lang:t("menu.bank_description"),
            icon = "fa-solid fa-money-check-dollar",
            params = {
                event = "kp-Rental:client:attemptRentVehicle",
                args = {
                    paymentType = 'bank',
                    vehicle = data.vehicle,
                    currentRental = data.currentRental
                }
            }
        },
        {
            header = Lang:t("menu.money_title"),
            txt = Lang:t("menu.money_description"),
            icon = "fa-solid fa-money-bill",
            params = {
                event = "kp-Rental:client:attemptRentVehicle",
                args = {
                    paymentType = 'cash',
                    vehicle = data.vehicle,
                    currentRental = data.currentRental
                }
            }
        }
    }

    paymentMenu[#paymentMenu + 1] = {
        header = Lang:t("menu.exit"),
        icon = "fa-solid fa-sign-out-alt",
        params = {
            event = "qb-menu:closeMenu",
        }
    }

    exports['qb-menu']:openMenu(paymentMenu)
end)

RegisterNetEvent("kp-Rental:client:attemptRentVehicle", function(data)
    local isParkFree = false;
    local availablePark = nil

    for i, v in ipairs(data.currentRental.VehicleSpawn) do
        if (isThisParkAvaiable(v.coords)) then
            isParkFree = true
            availablePark = v
            break
        else
            isParkFree = false
        end
    end

    if isParkFree then
        TriggerServerEvent("kp-Rental:server:attemptPayRent", data.paymentType, data.vehicle, availablePark)
    else
        QBCore.Functions.Notify(Lang:t("error.parking_lot_full"), 'error', 5000)
    end

end)

RegisterNetEvent("kp-Rental:client:payRent", function(paymentType, vehicle, availablePark)
    TriggerServerEvent("kp-Rental:server:payRent", paymentType, vehicle, availablePark)
end)

RegisterNetEvent("kp-Rental:client:vehicleSpawn", function(vehicleModel, vehiclePrice, availablePark, cb)
    local model = vehicleModel

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    SetModelAsNoLongerNeeded(model)

    QBCore.Functions.SpawnVehicle(model, function(veh)
        SetEntityHeading(veh, availablePark.heading)
        exports[Config.FuelExport]:SetFuel(veh, 100.0)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        local currentPlate = QBCore.Functions.GetPlate(veh)

        TriggerServerEvent("qb-rental:purchase", vehiclePrice)
        TriggerServerEvent("kp-Rental:server:giveRentalPaper", model, currentPlate)
    end, availablePark.coords, true)

    local timeout = 10
    while not NetworkDoesEntityExistWithNetworkId(veh) and timeout > 0 do
        timeout = timeout - 1
        Wait(1000)
    end
end)


-- Standart Client Events
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    deleteBlips()
    deletePeds()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    spawnPeds()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    deletePeds()
end)


-- Threads
CreateThread(function()
    initBlips()
    spawnPeds()
end)