local QBCore, current = Framework:Get()
-- Callbacks

QBCore.Functions.CreateCallback('orion-jobcenter:server:receiveJobs', function(_, cb)
    cb(Config.JobCenter.AvailableJobs)
end)

-- Events

RegisterNetEvent('orion-jobcenter:server:applyJob', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if data.job or not Config.JobCenter.AvailableJobs[data.job] then
        return Custom.BanPlayer(playerId, 'Attemped to exploit.')
    end
    Player.Functions.SetJob(data.job, Config.JobCenter.AvailableJobs[data.job].grade)
    QBCore.Functions.Notify(src, string.format(Config.Translate['addJob'], data.label), "success", 5000)
end)

RegisterNetEvent('orion-jobcenter:server:removeJob', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.SetJob(Config.Unemployed.name, Config.Unemployed.grade)
    QBCore.Functions.Notify(src, string.format(Config.Translate['removeJob'], data.label), "success", 5000)
end)

RegisterNetEvent('QBCore:Client:UpdateObject', function()
    QBCore = exports['qb-core']:GetCoreObject()
end)

print(([[
^6[ORION JOB CENTER]^0 Framework Setup

^3[+]^0 Selected Framework: ^5[%s]^0
^3[+]^0 Successfully loaded
]]):format(current))