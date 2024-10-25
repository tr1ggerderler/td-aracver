local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add("aracver", "Bir oyuncuya araç ver (örnek: /aracver 1234560 car_model)", 
    {{name="oyuncuID", help="Oyuncu ID'si"}, {name="model", help="Araç modeli"}}, 
    false, 
    function(source, args)
        local targetPlayerId = tonumber(args[1])
        local vehicleModel = args[2]
        local playerLicenseId = QBCore.Functions.GetIdentifier(source, "license")  -- Kullanıcının license ID'sini al

        local isAllowed = false
        for _, allowedId in ipairs(Config.AllowedLicenseIds) do
            if playerLicenseId == allowedId then
                isAllowed = true
                break
            end
        end

        if not isAllowed then
            QBCore.Functions.Notify(source, "Bu komutu kullanma yetkiniz yok.", 'error')
            return
        end

        if not targetPlayerId or not vehicleModel then
            QBCore.Functions.Notify(source, "Geçersiz giriş. Doğru format: /aracver <oyuncuID> <model>", 'error')
            return
        end

        local targetPlayer = QBCore.Functions.GetPlayer(targetPlayerId)
        if targetPlayer then
            local vehicleInfo = {vehicle = vehicleModel}
            TriggerClientEvent('qb-vehiclejob:client:TakeOutVehicle', targetPlayer.PlayerData.source, vehicleInfo)
            QBCore.Functions.Notify(source, "Araç başarıyla verildi.", 'success')
        else
            QBCore.Functions.Notify(source, "Belirtilen oyuncu bulunamadı.", 'error')
        end
    end
)

RegisterNetEvent('qb-vehiclejob:server:BuyVehicle')
AddEventHandler('qb-vehiclejob:server:BuyVehicle', function (vehicle, hash, plate, mods)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    
    MySQL.Async.fetchAll("INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (@license, @citizenid, @vehicle, @hash, @mods, @plate, @garage, @state)", { 
        ["@license"] = xPlayer.PlayerData.license,
        ["@citizenid"] = xPlayer.PlayerData.citizenid,
        ["@vehicle"] = vehicle,
        ["@hash"] = hash,
        ["@mods"] = json.encode(mods),
        ["@plate"] = plate,
        ["@garage"] = "pillboxgarage",
        ["@state"] = 0,
    }, function() end)
end)
