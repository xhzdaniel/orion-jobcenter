Framework = {}

function Framework:Get()
    local selectedFramework
    local FRAMEWORK_FUNCTIONS = {
        ['es_extended'] = function()
            return exports.es_extended:getSharedObject()
        end,
        ['qb-core'] = function()
            return exports['qb-core']:GetCoreObject()
        end
    }

    for framework, callback in next, FRAMEWORK_FUNCTIONS do
        if GetResourceState(framework):match('start') then
            selectedFramework = framework
        end
    end

    local Core = FRAMEWORK_FUNCTIONS[selectedFramework]()
    local playerData = Core?.Functions and Core.Functions.GetPlayerData() or Core?.GetPlayerData and Core.GetPlayerData() or {
        job = {
            name = 'unemployed',
        }
    }

    return {
        PlayerData = {
            job = {
                name = playerData.job.name,
            }
        },
        Functions = {
            TriggerCallback = function(name, cb)
                if Core?.Functions then
                    return Core.Functions.TriggerCallback(name, cb)
                end

                return Core.TriggerServerCallback(name, cb)
            end,
            GetPlayerData = function()
                return playerData
            end,
            IsPlayerLoaded = function()
                return selectedFramework:match('es') and Core.IsPlayerLoaded() or LocalPlayer.state.isLoggedIn             
            end,
        }
    }, selectedFramework
end