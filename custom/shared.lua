Custom = {}
Resource = {}

function Resource:Started(resource)
    return GetResourceState(resource):match('start')
end

function Resource:Stopped(resource)
    return not self:Started(resource)
end