local QBCore = exports['qb-core']:GetCoreObject()

local function GenerateRandomLetters(length)
    local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local randomStr = ""
    for i = 1, length do
        local randIndex = math.random(1, #letters)
        randomStr = randomStr .. letters:sub(randIndex, randIndex)
    end
    return randomStr
end

local function GenerateRandomNumbers(length)
    local numbers = "0123456789"
    local randomStr = ""
    for i = 1, length do
        local randIndex = math.random(1, #numbers)
        randomStr = randomStr .. numbers:sub(randIndex, randIndex)
    end
    return randomStr
end

RegisterNetEvent('td-aracver:client:TakeOutVehicle', function(vehicleInfo)
    local playerId = source
    local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
    local currentVehicle = GetVehiclePedIsIn(playerPed, false)

    if currentVehicle and currentVehicle ~= 0 then
        QBCore.Functions.DeleteVehicle(currentVehicle)
    end

    local coords = {x = 100.0, y = 200.0, z = 300.0}
    if coords then
        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 2.0) then
            QBCore.Functions.Notify("Araç garaja park edilmeli.", 'error')
            return
        end

        QBCore.Functions.SpawnVehicle(vehicleInfo.vehicle, function(veh)
            local randomNumbers = GenerateRandomNumbers(2)
            local randomLetters = GenerateRandomLetters(3)
            local randomPlate = randomNumbers .. randomLetters .. GenerateRandomNumbers(3)
            SetVehicleNumberPlateText(veh, randomPlate)
            SetEntityHeading(veh, coords.w)
            exports['qb-fuel']:SetFuel(veh, 100.0)
            TaskWarpPedIntoVehicle(playerPed, veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
            TriggerServerEvent("td-aracver:server:BuyVehicle", vehicleInfo.vehicle, GetHashKey(vehicleInfo.vehicle), QBCore.Functions.GetPlate(veh), QBCore.Functions.GetVehicleProperties(veh))
            SetVehicleDirtLevel(veh, 0.0)
            SetVehicleColours(veh, 111, 111)
        end)
    end
end)
