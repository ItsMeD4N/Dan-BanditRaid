local spawnedBandits = {}
local isRaidAreaActive = false

function cleanupBandits()
    isRaidAreaActive = false
    for _, bandit in ipairs(spawnedBandits) do
        if DoesEntityExist(bandit) then
            SetEntityAsNoLongerNeeded(bandit)
            DeleteEntity(bandit)
        end
    end
    spawnedBandits = {}
end

function getSafeSpawnPoint(center, radius)
    for i = 1, 10 do
        local angle = math.random() * 2 * math.pi
        local r = radius 
        local x = center.x + r * math.cos(angle)
        local y = center.y + r * math.sin(angle)
        
        local foundGround, z = GetGroundZFor_3dCoord(x, y, center.z + 50.0)
        if foundGround then
            if GetInteriorFromCollision(x, y, z) == 0 then
                return vector3(x, y, z)
            end
        end
        Wait(50)
    end
    return nil
end

function monitorRaid()
    CreateThread(function()
        while isRaidAreaActive do
            local banditsAlive = 0
            for i = #spawnedBandits, 1, -1 do
                local bandit = spawnedBandits[i]
                if DoesEntityExist(bandit) and not IsPedFatallyInjured(bandit) then
                    banditsAlive = banditsAlive + 1
                else
                    table.remove(spawnedBandits, i)
                end
            end

            if banditsAlive == 0 and isRaidAreaActive then
                TriggerServerEvent('dan-banditraid:server:raidFinished')
                cleanupBandits()
                break
            end
            Wait(5000)
        end
    end)
end

function startClientRaid(raidConfig)
    cleanupBandits()
    isRaidAreaActive = true
    
    exports.ox_lib:notify({ description = 'Carefull Bandit Attack', type = 'error', duration = 7000 })

    CreateThread(function()
        for _, wave in ipairs(raidConfig.waves) do
            if not isRaidAreaActive then break end
            
            for i = 1, wave.count do
                if not isRaidAreaActive then break end
                
                local banditModel = GetHashKey('A_M_M_BivRoughTravellers_01') 

                RequestModel(banditModel)
                while not HasModelLoaded(banditModel) do Wait(50) end

                local spawnCoords = getSafeSpawnPoint(raidConfig.coords, raidConfig.radius)
                
                if spawnCoords then
                    local bandit = CreatePed(banditModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, true)
                    Wait(100) 

                    if DoesEntityExist(bandit) then
                        SetEntityAsMissionEntity(bandit, true, true)
                        SetPedRandomComponentVariation(bandit, true)
                        PlaceObjectOnGroundProperly(bandit)
                        
                        table.insert(spawnedBandits, bandit)
                        GiveWeaponToPed(bandit, GetHashKey(wave.weapon), 1000, true, true)
                        TaskCombatPed(bandit, PlayerPedId(), 0, 16)
                    end
                end
                
                SetModelAsNoLongerNeeded(banditModel)
                Wait(2000)
            end
            if isRaidAreaActive then Wait(15000) end
        end

        if isRaidAreaActive then
            monitorRaid()
        end
    end)
end

RegisterNetEvent('dan-banditraid:client:start', function(raidConfig)
    local playerCoords = GetEntityCoords(PlayerPedId())
    if #(playerCoords - raidConfig.coords) < raidConfig.radius + 150.0 then
        startClientRaid(raidConfig)
    end
end)

RegisterNetEvent('dan-banditraid:client:cleanup', cleanupBandits)
