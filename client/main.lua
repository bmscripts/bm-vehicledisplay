local QBCore = exports['qb-core']:GetCoreObject()

local Colours = Colours  -- use the global defined in colours.lua
local spawnedVehicles = {}

-- Default distances
local defaultSpawnDistance = 150.0
local defaultDespawnDistance = 180.0

-- Cleanup all vehicles
local function cleanupSpawnedVehicles()
    for _, veh in pairs(spawnedVehicles) do
        if DoesEntityExist(veh) then
            DeleteEntity(veh)
        end
    end
    spawnedVehicles = {}
end

-- Make vehicle fully static
local function makeVehicleStatic(veh)
    FreezeEntityPosition(veh, true)
    SetEntityDynamic(veh, false)
    SetVehicleWheelsCanBreak(veh, false)
end

-- Convert colour name → ID
local function resolveColour(value)
    if type(value) == "number" then
        return value
    elseif type(value) == "string" then
        return Colours[value]
    end
    return nil
end

-- Apply colour system (GTA IDs only)
local function applyVehicleColours(veh, data)
    -- Primary
    local primaryID = resolveColour(data.primary)
    if primaryID then
        local _, sec = GetVehicleColours(veh)
        SetVehicleColours(veh, primaryID, sec)
    end

    -- Secondary
    local secondaryID = resolveColour(data.secondary)
    if secondaryID then
        local pri, _ = GetVehicleColours(veh)
        SetVehicleColours(veh, pri, secondaryID)
    end

    -- Pearlescent + wheel colour
    local pearl, wheel = GetVehicleExtraColours(veh)

    local pearlID = resolveColour(data.pearlescent)
    if pearlID then
        pearl = pearlID
    end

    local wheelID = resolveColour(data.wheelColour)
    if wheelID then
        wheel = wheelID
    end

    SetVehicleExtraColours(veh, pearl, wheel)

    -- Interior
    local interiorID = resolveColour(data.interior)
    if interiorID then
        SetVehicleInteriorColour(veh, interiorID)
    end

    -- Dashboard
    local dashID = resolveColour(data.dashboard)
    if dashID then
        SetVehicleDashboardColour(veh, dashID)
    end
end

-- Spawn vehicle
local function spawnVehicle(id, data)
    local model = GetHashKey(data.vehicle)

    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local coords = data.coords

    -- Spawn high to bypass ground correction
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z + 50.0, false, false)

    SetModelAsNoLongerNeeded(model)
    SetEntityAsMissionEntity(veh, true, true)
    SetEntityInvincible(veh, true)
    SetVehicleDirtLevel(veh, 0.0)
    SetVehicleDoorsLocked(veh, 3)

    Wait(50)

    makeVehicleStatic(veh)

    -- Z offset
    local finalZ = coords.z + (data.zOffset or 0.0)
    SetEntityCoordsNoOffset(veh, coords.x, coords.y, finalZ, false, false, false)

    -- Rotation
    if data.rotation then
        local pitch, roll, yaw = table.unpack(data.rotation)
        SetEntityRotation(veh, pitch, roll, yaw, 2, true)
    elseif coords.w then
        SetEntityHeading(veh, coords.w)
    end

    -- Apply colours
    applyVehicleColours(veh, data)

    -- Plate
    if data.plate then
        SetVehicleNumberPlateText(veh, data.plate)
    end

    spawnedVehicles[id] = veh
end

-- Despawn vehicle
local function despawnVehicle(id)
    if spawnedVehicles[id] and DoesEntityExist(spawnedVehicles[id]) then
        DeleteEntity(spawnedVehicles[id])
    end
    spawnedVehicles[id] = nil
end

-- Proximity loop
CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        for id, data in ipairs(Config) do
            local spawnDist = data.spawnDistance or defaultSpawnDistance
            local despawnDist = data.despawnDistance or defaultDespawnDistance

            local dist = #(playerCoords - vector3(data.coords.x, data.coords.y, data.coords.z))

            if dist < spawnDist then
                if not spawnedVehicles[id] then
                    spawnVehicle(id, data)
                end
            elseif dist > despawnDist then
                if spawnedVehicles[id] then
                    despawnVehicle(id)
                end
            end
        end

        Wait(500)
    end
end)

-- Cleanup on resource stop
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        cleanupSpawnedVehicles()
    end
end)
