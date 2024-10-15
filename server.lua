local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('td-aracver:server:sendVehicle')
AddEventHandler('td-aracver:server:sendVehicle', function (vehicle, hash, plate, mods)
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
