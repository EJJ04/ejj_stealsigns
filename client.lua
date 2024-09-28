lib.locale()

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
    label = locale('sign_interact'), 
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
                label = locale('pickingup_sign'), 
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
                },
            }) then
                ClearPedTasks(cache.ped)
                CreateModelHide(position, 3.0, hash, true)
                TriggerServerEvent('ejj_stealsigns:hidesignsmodels', hash, position)
            else
                ClearPedTasks(cache.ped)
            end
        else
            -- Handle failure case if needed
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
    local x, y, z = table.unpack(GetEntityCoords(cache.ped))

    holdingSign = true
    local TextUI = false

    if lib.progressCircle({
        duration = Config.progressCircleduration,
        label = locale('dialogtitle'), 
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
        },
    }) then
        local prop = CreateObjectNoOffset(prop1, x, y, z + 0.2, true, true, true)
        PlaceObjectOnGroundProperly(prop)

        lib.showTextUI(locale('dialogenter'), {
            position = "left-center",
            icon = 'sign',
        })
        TextUI = true

        ClearPedTasks(cache.ped)

        CreateThread(function()
            local rotationSpeed = Config.rotationSpeed
            local moveSpeed = Config.moveSpeed
            local maxDistance = Config.maxDistance
            local originalCoords = GetEntityCoords(cache.ped) 
            local rotation = GetEntityHeading(prop)

            while holdingSign do
                Wait(0)

                DisableControlAction(0, 30, true)
                DisableControlAction(0, 31, true) 

                local signCoords = GetEntityCoords(prop)
                local distanceFromOriginal = Vdist(signCoords.x, signCoords.y, signCoords.z, originalCoords.x, originalCoords.y, originalCoords.z)

                if distanceFromOriginal < maxDistance then
                    if IsControlPressed(0, 32) then 
                        local heading = GetEntityHeading(cache.ped)
                        local newCoords = vector3(signCoords.x + moveSpeed * math.sin(math.rad(heading)), signCoords.y + moveSpeed * math.cos(math.rad(heading)), signCoords.z)

                        if Vdist(newCoords.x, newCoords.y, newCoords.z, originalCoords.x, originalCoords.y, originalCoords.z) <= maxDistance then
                            SetEntityCoords(prop, newCoords.x, newCoords.y, newCoords.z, true, false, false, true)
                        end
                    end
                end

                if IsControlPressed(0, 33) then 
                    if distanceFromOriginal > 0 then 
                        local heading = GetEntityHeading(cache.ped)
                        local moveBackCoords = vector3(signCoords.x - moveSpeed * math.sin(math.rad(heading)), signCoords.y - moveSpeed * math.cos(math.rad(heading)), signCoords.z)

                        if Vdist(moveBackCoords.x, moveBackCoords.y, moveBackCoords.z, originalCoords.x, originalCoords.y, originalCoords.z) <= maxDistance then
                            SetEntityCoords(prop, moveBackCoords.x, moveBackCoords.y, moveBackCoords.z, true, false, false, true)
                        end
                    end
                end

                if IsControlPressed(0, 34) then 
                    local newCoords = vector3(signCoords.x - moveSpeed * math.cos(math.rad(GetEntityHeading(cache.ped))), signCoords.y + moveSpeed * math.sin(math.rad(GetEntityHeading(cache.ped))), signCoords.z)

                    if Vdist(newCoords.x, newCoords.y, newCoords.z, originalCoords.x, originalCoords.y, originalCoords.z) <= maxDistance then
                        SetEntityCoords(prop, newCoords.x, newCoords.y, newCoords.z, true, false, false, true)
                    end
                end

                if IsControlPressed(0, 35) then 
                    local newCoords = vector3(signCoords.x + moveSpeed * math.cos(math.rad(GetEntityHeading(cache.ped))), signCoords.y - moveSpeed * math.sin(math.rad(GetEntityHeading(cache.ped))), signCoords.z)

                    if Vdist(newCoords.x, newCoords.y, newCoords.z, originalCoords.x, originalCoords.y, originalCoords.z) <= maxDistance then
                        SetEntityCoords(prop, newCoords.x, newCoords.y, newCoords.z, true, false, false, true)
                    end
                end

                PlaceObjectOnGroundProperly(prop)

                if IsControlPressed(0, 44) then 
                    rotation = rotation - rotationSpeed
                end
                if IsControlPressed(0, 46) then 
                    rotation = rotation + rotationSpeed
                end

                SetEntityHeading(prop, rotation)

                if IsControlJustPressed(0, 73) then 
                    if TextUI then
                        lib.hideTextUI()
                        TextUI = false
                    end
                    if prop then
                        DeleteEntity(prop)
                    end
                    holdingSign = false
                    break
                end

                if IsControlJustPressed(0, 22) then
                    local finalCoords = GetEntityCoords(prop)
                    local finalHeading = GetEntityHeading(prop)
                    
                    local placedProp = CreateObjectNoOffset(prop1, finalCoords.x, finalCoords.y, finalCoords.z, true, true, true)
                    PlaceObjectOnGroundProperly(placedProp)
                    SetEntityHeading(placedProp, finalHeading)
                
                    TriggerServerEvent('ejj_stealsigns:removeitem', prop1)
                
                    if TextUI then
                        lib.hideTextUI()
                        TextUI = false
                    end
                
                    holdingSign = false
                    break
                end
            end

            if not holdingSign and prop then
                DeleteEntity(prop)
                if TextUI then
                    lib.hideTextUI()
                    TextUI = false
                end
            end
        end)
    else
        -- Handle failure case if needed
    end
end)


AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if prop then
            DeleteEntity(prop)
            holdingSign = false
        end
        local isOpen, text = lib.isTextUIOpen()
        if isOpen then
            lib.hideTextUI()
        end
    end
end)
