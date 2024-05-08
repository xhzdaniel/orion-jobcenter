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
    local Object = {
        Functions = {
            GetPlayer = function(playerId)
                if Resource:Started('qb-core') then
                    return {
                        Functions = {
                            SetJob = Core.Functions.GetPlayer(playerId).Functions.SetJob,
                        }
                    }
                end

                if Resource:Started('es_extended') then
                    return {
                        Functions = {
                            SetJob = Core.GetPlayerFromId(playerId).setJob,
                        }
                    }
                end

                return {
                    Functions = {
                        SetJob = function(job, grade)
                            print('Setting job', job, grade)
                        end,
                    }
                }
            end,
            Notify = function(playerId, ...)
                if Resource:Started('es_extended') then
                    local xPlayer = Core.GetPlayerFromId(playerId)
                    return xPlayer.showNotification(...)
                end

                if Resource:Started('qb-core') then
                    return Core.Functions.Notify(playerId, ...)
                end
            end,
            CreateCallback = function(name, cb)
                if Resource:Started('es_extended') then
                    return Core.RegisterServerCallback(name, cb)
                end

                if Resource:Started('qb-core') then
                    return Core.Functions.CreateCallback(name, cb)
                end
                
                print('New callback', name)
            end
        }
    }

    return Object, selectedFramework
end