local RSG = exports['rsg-core']:GetCoreObject()
local isRaidActive = false

local function startRaid(locationKey, source)
    if isRaidActive then
        TriggerClientEvent('ox_lib:notify', source, { title = 'Error', description = 'A raid is already in progress.', type = 'error' })
        return
    end

    local locationConfig = Config.RaidLocations[locationKey]
    if not locationConfig then
        TriggerClientEvent('ox_lib:notify', source, { title = 'Error', description = 'Unknown location', type = 'error' })
        return
    end
    
    isRaidActive = true
    print(('[dan-banditraid] An attack has begun at %s by %s.'):format(locationConfig.name, source))
    TriggerClientEvent('dan-banditraid:client:start', -1, locationConfig)
    TriggerClientEvent('ox_lib:notify', -1, {description = ('Bandits have been seen in %s.'):format(locationConfig.name), type = 'warning', duration = 10000 })
end

RegisterCommand('startraid', function(source, args)
    if RSG.Functions.HasPermission(source, 'admin') then
        local locationKey = args[1]
        if not locationKey then
            TriggerClientEvent('ox_lib:notify', source, { title = 'Info', description = 'Use: /startraid [Location]', type = 'info' })
            return
        end
        startRaid(locationKey, source)
    else
        TriggerClientEvent('ox_lib:notify', source, { title = 'Error', description = 'Access Denied', type = 'error' })
    end
end, false)

RegisterCommand('stopraid', function(source)
    if RSG.Functions.HasPermission(source, 'admin') then
        if not isRaidActive then
            TriggerClientEvent('ox_lib:notify', source, { title = 'Info', description = 'There is no attack in progress.', type = 'info' })
            return
        end

        isRaidActive = false
        TriggerClientEvent('dan-banditraid:client:cleanup', -1)
        print('[dan-banditraid] Serangan dihentikan manual.')
        TriggerClientEvent('ox_lib:notify', -1, { title = 'Info', description = 'The bandit threat has been neutralized.', type = 'success' })
    else
        TriggerClientEvent('ox_lib:notify', source, { title = 'Error', description = 'Access Denied', type = 'error' })
    end
end, false)

RegisterNetEvent('dan-banditraid:server:raidFinished', function()
    if isRaidActive then
        isRaidActive = false
        print('[dan-banditraid] Serangan telah selesai.')
        TriggerClientEvent('ox_lib:notify', -1, { title = 'Info', description = 'All bandits have been defeated.', type = 'success' })
    end
end)
