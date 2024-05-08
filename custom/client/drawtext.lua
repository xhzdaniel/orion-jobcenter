function Custom.DrawText(text)
    if Resource:Started('orion-drawtext') then

        return exports['orion-drawtext']:ShowText('E', text)
    end

    if Resource:Started('qb-core') then
        return exports['qb-core']:DrawText(text)
    end

    -- Your own DrawText here.
end

function Custom.HideText(text)
    if Resource:Started('orion-drawtext') then
        return exports['orion-drawtext']:HideText()
    end

    if Resource:Started('qb-core') then
        return exports['qb-core']:HideText()
    end

    -- Your own HideText here.
end

function Custom.KeyPressed()
    if Resource:Started('qb-core') then
        return exports['qb-core']:KeyPressed()
    end

    -- Your own KeyPressed here
end