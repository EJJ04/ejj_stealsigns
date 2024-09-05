local holdingSign = false
local prop = nil
local propPosition = nil

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

local function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Wait(10)
    end
end

local options = {}

table.insert(options, {
    icon = "fa-solid fa-sign-hanging",
    label = Config.Strings.title,
    distance = 3,
    onSelect = function(data)
        local entity = data.entity
        local hash = GetEntityModel(entity)
        local position = GetEntityCoords(entity)
        
        SetEntityAsMissionEntity(entity, true, true)

        local animDict = "amb@prop_human_bum_bin@base"
        loadAnimDict(animDict)
        TaskPlayAnim(cache.ped, animDict, "base", 8.0, -8.0, -1, 49, 0, false, false, false)
        
        local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1}, 'easy'}, {'e', 'e', 'e', 'e'})
        
        if success then
            if lib.progressBar({
                duration = 2000,
                label = Config.Strings.progressbartitle,
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
                },
            }) then
                StopAnimTask(cache.ped, animDict, "base", 1.0)
                
                CreateModelHide(position, 3.0, hash, true)
                TriggerServerEvent('ejj_stealsigns:hidesignsmodels', hash, position)
            else
                StopAnimTask(cache.ped, animDict, "base", 1.0)
            end
        else
            
        end
    end
})

local signHashes = {}

for hash, _ in pairs(Config.SignHashes) do
    table.insert(signHashes, hash)
end

exports.ox_target:addModel(signHashes, options)

RegisterNetEvent('ejj_stealsigns:hidesignsmodels2')
AddEventHandler('ejj_stealsigns:hidesignsmodels2', function(hash, position, propPosition)
    CreateModelHideExcludingScriptObjects(position, 3.0, hash, true)
end)

RegisterNetEvent('ejj:addPropToPlayerAndAnim')
AddEventHandler('ejj:addPropToPlayerAndAnim', function(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    loadAnimDict("amb@world_human_janitor@male@base")
    local x, y, z = table.unpack(GetEntityCoords(cache.ped))
    
    if not HasModelLoaded(prop1) then
        LoadPropDict(prop1)
    end

    holdingSign = true
    
    local prop = CreateObject(prop1, x, y, z + 0.2, true, true, true)
    local propPosition = vector3(x, y, z + 0.2) 
    AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(prop1)
    TaskPlayAnim(cache.ped, "amb@world_human_janitor@male@base", "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0)

    CreateThread(function()
        while holdingSign do
            Wait(1000)
            if not IsEntityPlayingAnim(cache.ped, "amb@world_human_janitor@male@base", "base", 3) and holdingSign then
                holdingSign = false
                if prop then
                    DeleteEntity(prop)
                end
            end
        end
    end)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if prop then
            DeleteEntity(prop)
            holdingSign = false
        end
    end
end)