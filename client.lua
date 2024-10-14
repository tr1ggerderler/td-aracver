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


local function TakeOutVehicle(vehicleInfo, playerId)
    local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
    local currentVehicle = GetVehiclePedIsIn(playerPed, false)

    if currentVehicle and currentVehicle ~= 0 then
        QBCore.Functions.DeleteVehicle(currentVehicle)
    end

    local coords = {x = 100.0, y = 200.0, z = 300.0, w = 0.0}
    if coords then
        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 2.0) then
            QBCore.Functions.Notify("Araç garaja park edilmeli.", 'error')
            return
        end

        QBCore.Functions.SpawnVehicle(vehicleInfo.vehicle, function(veh)
            local randomNumbers = GenerateRandomNumbers(2)  -- 2 rastgele rakam oluştur
            local randomLetters = GenerateRandomLetters(3)  -- 3 rastgele harf oluştur
            local randomPlate = randomNumbers .. randomLetters .. GenerateRandomNumbers(3)  -- 2 rakam + 3 harf + 3 rakam
            SetVehicleNumberPlateText(veh, randomPlate)
            SetEntityHeading(veh, coords.w)
            exports['qb-fuel']:SetFuel(veh, 100.0)
            TaskWarpPedIntoVehicle(playerPed, veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
            TriggerServerEvent("qb-vehiclejob:server:BuyVehicle", vehicleInfo.vehicle, GetHashKey(vehicleInfo.vehicle), QBCore.Functions.GetPlate(veh), QBCore.Functions.GetVehicleProperties(veh))
            SetVehicleDirtLevel(veh, 0.0)
            SetVehicleColours(veh, 111, 111)
        end)
    end
end


RegisterCommand("aracver", function(source, args, rawCommand)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local playerLicenseId = PlayerData.license

    -- Yetkili Lisans ID
    local isAllowed = false
    for _, licenseId in ipairs(Config.AllowedLicenseIds) do
        if playerLicenseId == licenseId then
            isAllowed = true
            break
        end
    end

    if not isAllowed then
        QBCore.Functions.Notify("Bu komutu kullanma yetkiniz yok.", "error")
        return
    end

    if #args ~= 2 then
        QBCore.Functions.Notify("Kullanım: /aracver [OyuncuID] [Model]", "error")
        return
    end

    local playerId = tonumber(args[1])
    local vehicleModel = args[2]

    if not IsModelInCdimage(vehicleModel) or not IsModelAVehicle(vehicleModel) then
        QBCore.Functions.Notify("Geçersiz araç modeli.", "error")
        return
    end

    QBCore.Functions.Notify("Araç başarıyla verildi.", "success")

    local vehicleInfo = { vehicle = vehicleModel, price = 0 }
    TakeOutVehicle(vehicleInfo, playerId)
end, false)
