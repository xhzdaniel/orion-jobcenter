local QBCore = Framework:Get()
local PlayerData = QBCore.Functions.GetPlayerData()
local isLoggedIn = QBCore.Functions.IsPlayerLoaded()
local playerPed = PlayerPedId()
local playerCoords = GetEntityCoords(playerPed)
local closestJobCenter = nil
local inJobCenterPage = false
local inRangeJobCenter = false
local pedsSpawned = false
local blips = {}

-- Functions

local function getClosestHall()
    local closest = 1
    local distance = #(playerCoords - Config.JobCenter.coords)
    local hall = Config.JobCenter.coords
    local dist = #(playerCoords - hall)
    if dist < distance then
        distance = dist
        closest = i
    end
    return closest
end

local function getJobs()
    QBCore.Functions.TriggerCallback('orion-jobcenter:server:receiveJobs', function(result)
        local userJob = PlayerData.job.name
        SendNUIMessage({
            action = 'setJobs',
            jobs = result,
            playerJob = userJob
        })
    end)
end

local function setJobCenterPageState(bool, message)
    getJobs()
    if message then
        local action = "open" or "close"
        SendNUIMessage({
            action = action
        })
        inRangeJobCenter = bool
    end
    SetNuiFocus(bool, bool)
    inJobCenterPage = bool
end

local function createBlip(options)
    if not options.coords or type(options.coords) ~= 'table' and type(options.coords) ~= 'vector3' then return error(('createBlip() expected coords in a vector3 or table but received %s'):format(options.coords)) end
    local blip = AddBlipForCoord(options.coords.x, options.coords.y, options.coords.z)
    SetBlipSprite(blip, options.sprite or 1)
    SetBlipDisplay(blip, options.display or 4)
    SetBlipScale(blip, options.scale or 1.0)
    SetBlipColour(blip, options.colour or 1)
    SetBlipAsShortRange(blip, options.shortRange or false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(options.title or 'Orion JobCenter')
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
    local hall = Config.JobCenter
        if hall.showBlip then
            blips[#blips + 1] = createBlip({
                coords = hall.coords,
                sprite = hall.blipData.sprite,
                display = hall.blipData.display,
                scale = hall.blipData.scale,
                colour = hall.blipData.colour,
                shortRange = true,
                title = hall.blipData.title
            })
        end
end

local function spawnPeds()
    if not Config.Peds or not next(Config.Peds) or pedsSpawned then return end
    local current = Config.Peds
        current.model = type(current.model) == 'string' and joaat(current.model) or current.model
        RequestModel(current.model)
        while not HasModelLoaded(current.model) do
            Wait(0)
        end
        local ped = CreatePed(0, current.model, current.coords.x, current.coords.y, current.coords.z, current.coords.w, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, current.scenario, true, true)
        current.pedHandle = ped
            local options = current.zoneOptions
            if options then
                local zone = BoxZone:Create(current.coords.xyz, options.length, options.width, {
                    name = "zone_JobCenter_" .. ped,
                    heading = current.coords.w,
                    debugPoly = false,
                    minZ = current.coords.z - 3.0,
                    maxZ = current.coords.z + 2.0
                })
                zone:onPlayerInOut(function(inside)
                    if isLoggedIn and closestJobCenter then
                        if inside then
                            inRangeJobCenter = true
                            Custom.DrawText(Config.Translate.open)
                        else
                            Custom.HideText(Config.Translate.open)
                            inRangeJobCenter = false
                        end
                    end
                end)
            end
    pedsSpawned = true
end

local function deletePeds()
    if not Config.Peds or not next(Config.Peds) or not pedsSpawned then return end
    local current = Config.Peds
        if current.pedHandle then
            DeletePed(current.pedHandle)
        end
    pedsSpawned = false
end


-- Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = Framework:Get().PlayerData
    isLoggedIn = true
    spawnPeds()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    isLoggedIn = false
    deletePeds()
end)

RegisterNetEvent('esx:playerLoaded', function()
    PlayerData = Framework:Get().PlayerData
    isLoggedIn = true
    spawnPeds()
end)

RegisterNetEvent('esx:playerDropped', function()
    PlayerData = {}
    isLoggedIn = false
    deletePeds()
end)


RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = Framework:Get().PlayerData
end)

RegisterNetEvent('esx:setPlayerData', function()
    PlayerData = Framework:Get().PlayerData
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    deleteBlips()
    deletePeds()
end)

-- NUI Callbacks

RegisterNUICallback('close', function(_, cb)
    setJobCenterPageState(false, false)
    if inRangeJobCenter then 
        Custom.DrawText(Config.Translate['open']) 
    end -- Reopen interaction when you're still inside the zone
    cb('ok')
end)

RegisterNUICallback('removeJob', function(data, cb)
    TriggerServerEvent('orion-jobcenter:server:removeJob', data)
    cb('ok')
end)  

RegisterNUICallback('applyJob', function(data, cb)
    TriggerServerEvent('orion-jobcenter:server:applyJob', data)
    cb('ok')
end)

RegisterNUICallback('updateJobs', function(_, cb)
    getJobs()
    cb('ok')
end)

-- Threads

CreateThread(function()
    while true do
        if isLoggedIn then
            playerPed = PlayerPedId()
            playerCoords = GetEntityCoords(playerPed)
            closestJobCenter = getClosestHall()
        end
        Wait(1000)
    end
end)

CreateThread(function()
    initBlips()
    spawnPeds()
    while true do
        local sleep = 1000
        if isLoggedIn and closestJobCenter then
            if inRangeJobCenter then
                if not inJobCenterPage then
                    sleep = 0
                    if IsControlJustPressed(0, 38) then
                        setJobCenterPageState(true, true)
                        Custom.KeyPressed()
                        Wait(500)
                        Custom.HideText()
                        sleep = 1000
                    end
                end
            end
        end
        Wait(sleep)
    end
end)