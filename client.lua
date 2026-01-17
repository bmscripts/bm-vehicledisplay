local QBCore = exports['qb-core']:GetCoreObject()

print("Config loaded successfully!")

local spawnedVehicles = {}

-- Function to delete previously spawned vehicles
local function cleanupSpawnedVehicles()
    for _, veh in ipairs(spawnedVehicles) do
        if DoesEntityExist(veh) then
            DeleteEntity(veh)
        end
    end
    spawnedVehicles = {}  -- Reset the table
end

-- Main thread
CreateThread(function()
    if not Config then
        print("^1[ERROR]^7 Config not found or failed to load!")
        return
    end

    cleanupSpawnedVehicles()  -- Clean up any previous vehicles

    for _, vehicleConfig in ipairs(Config) do
        local model = GetHashKey(vehicleConfig['vehicle'])
        RequestModel(model)

        while not HasModelLoaded(model) do
            Wait(0)
        end

        local veh = CreateVehicle(model, vehicleConfig['coords'].x, vehicleConfig['coords'].y, vehicleConfig['coords'].z - 0.5, false, false)
        SetModelAsNoLongerNeeded(model)
        SetEntityAsMissionEntity(veh, true, true)
        SetEntityInvincible(veh, true)
        SetVehicleDirtLevel(veh, 0.0)
        SetVehicleDoorsLocked(veh, 3)

        -- Set rotation if provided
        if vehicleConfig['rotation'] then
            local pitch, roll, yaw = table.unpack(vehicleConfig['rotation'])  -- X, Y, Z
            SetEntityRotation(veh, pitch, roll, yaw, 2, true)  -- 2 = ZYX
        else
            if vehicleConfig['coords'].w then
                SetEntityHeading(veh, vehicleConfig['coords'].w)
            end
            SetVehicleOnGroundProperly(veh)
        end

        -- Set vehicle color
        if vehicleConfig['color'] then
            local r, g, b = table.unpack(vehicleConfig['color'])
            SetVehicleCustomPrimaryColour(veh, r, g, b)
            SetVehicleCustomSecondaryColour(veh, r, g, b)
            SetVehicleExtraColours(veh, 1, 1)
        end

        FreezeEntityPosition(veh, true)

        -- Set vehicle plate if provided
        if vehicleConfig['plate'] then
            SetVehicleNumberPlateText(veh, vehicleConfig['plate'])
        end

        -- Track the spawned vehicle
        table.insert(spawnedVehicles, veh)
    end
end)

-- Command to refresh vehicles
RegisterCommand("refreshvehicles", function()
    if not Config then
        print("^1[ERROR]^7 Config not found or failed to load!")
        QBCore.Functions.Notify("Vehicle config not found!", "error")
        return
    end

    cleanupSpawnedVehicles()  -- Clean up previous vehicles

    for _, vehicleConfig in ipairs(Config) do
        local model = GetHashKey(vehicleConfig.vehicle)
        RequestModel(model)

        while not HasModelLoaded(model) do
            Wait(0)
        end

        local coords = vehicleConfig.coords
        local veh = CreateVehicle(model, coords.x, coords.y, coords.z - 0.5, false, false)
        SetModelAsNoLongerNeeded(model)
        SetEntityAsMissionEntity(veh, true, true)
        SetEntityInvincible(veh, true)
        SetVehicleDirtLevel(veh, 0.0)
        SetVehicleDoorsLocked(veh, 3)

        if vehicleConfig.rotation then
            local pitch, roll, yaw = table.unpack(vehicleConfig.rotation)
            SetEntityRotation(veh, pitch, roll, yaw, 2, true)
        else
            if coords.w then
                SetEntityHeading(veh, coords.w)
            end
            SetVehicleOnGroundProperly(veh)
        end

        if vehicleConfig.color then
            local r, g, b = table.unpack(vehicleConfig.color)
            SetVehicleCustomPrimaryColour(veh, r, g, b)
            SetVehicleCustomSecondaryColour(veh, r, g, b)
            SetVehicleExtraColours(veh, 1, 1)
        end

        FreezeEntityPosition(veh, true)

        if vehicleConfig.plate then
            SetVehicleNumberPlateText(veh, vehicleConfig.plate)
        end

        table.insert(spawnedVehicles, veh)
    end

    QBCore.Functions.Notify("Vehicles refreshed successfully!", "success")
end, false)
