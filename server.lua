lib.locale()

local hash = nil

local ESX, QBCore, Framework

if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
    Framework = 'esx'

elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    Framework = 'qb'
else
    -- Add your own framework here.
end

if Framework == 'esx' then
    ESX.RegisterUsableItem('stopsign', function(playerId)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', playerId, -949234773, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    ESX.RegisterUsableItem('walkingmansign', function(playerId)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', playerId, 1502931467, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    ESX.RegisterUsableItem('dontblockintersectionsign', function(playerId)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', playerId, 1191039009, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    ESX.RegisterUsableItem('uturnsign', function(playerId)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', playerId, 4138610559, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    ESX.RegisterUsableItem('noparkingsign', function(playerId)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', playerId, 3830972543, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    ESX.RegisterUsableItem('leftturnsign', function(playerId)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', playerId, -1651641860, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    ESX.RegisterUsableItem('rightturnsign', function(playerId)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', playerId, 793482617, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    ESX.RegisterUsableItem('notrespassingsign', function(playerId)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', playerId, 1021214550, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    ESX.RegisterUsableItem('yieldsign', function(playerId)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', playerId, 3654973172, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

elseif Framework == 'qb' then
    QBCore.Functions.CreateUseableItem('stopsign', function(source)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', source, -949234773, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    QBCore.Functions.CreateUseableItem('walkingmansign', function(source)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', source, 1502931467, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    QBCore.Functions.CreateUseableItem('dontblockintersectionsign', function(source)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', source, 1191039009, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    QBCore.Functions.CreateUseableItem('uturnsign', function(source)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', source, 4138610559, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    QBCore.Functions.CreateUseableItem('noparkingsign', function(source)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', source, 3830972543, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    QBCore.Functions.CreateUseableItem('leftturnsign', function(source)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', source, -1651641860, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    QBCore.Functions.CreateUseableItem('rightturnsign', function(source)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', source, 793482617, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    QBCore.Functions.CreateUseableItem('notrespassingsign', function(source)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', source, 1021214550, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)

    QBCore.Functions.CreateUseableItem('yieldsign', function(source)
        TriggerClientEvent('ejj:addPropToPlayerAndAnim', source, 3654973172, 57005, 0.10, -1.0, 0.0, -90.0, -250.0, 0.0)
    end)
end

RegisterNetEvent('ejj_stealsigns:hidesignsmodels')
AddEventHandler('ejj_stealsigns:hidesignsmodels', function(hash, position)

    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('ejj_stealsigns:hidesignsmodels2', -1, hash, position)

    local itemName = nil

    for storedHash, name in pairs(Config.SignHashes) do
        if storedHash == hash then
            itemName = name
            break
        end
    end

    if itemName then
        exports.ox_inventory:AddItem(source, itemName, 1)
    else
        print("Hash not found in Config.SignHashes: " .. tostring(hash))
    end
end)

RegisterNetEvent('ejj_stealsigns:removeitem')
AddEventHandler('ejj_stealsigns:removeitem', function(propHash)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    local itemName = Config.SignHashes[propHash] 

    if itemName then
        if Framework == 'esx' then
            xPlayer.removeInventoryItem(itemName, 1) 
        elseif Framework == 'qb' then
            local identifier = xPlayer.identifier
            exports['qb-inventory']:RemoveItem(identifier, itemName, 1) 
        end
    else
        print("Item name not found for prop hash: " .. propHash)
    end
end)