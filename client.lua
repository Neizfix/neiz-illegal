local markerLocation = vector3(1975.5, 4816.53, 43.42)
local radius = 30.0
local itemName = "weed"
local itemAmount = 1
local isInsideMarker = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - markerLocation)

        DrawMarker(27, markerLocation.x, markerLocation.y, markerLocation.z + 1.0, 
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
            radius, radius, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)

        if distance < radius then
            if not isInsideMarker then
                isInsideMarker = true
                while isInsideMarker do
                    TriggerServerEvent('neiz:giveItem', itemName, itemAmount)
                    Citizen.Wait(30000)
                    local newCoords = GetEntityCoords(playerPed)
                    if #(newCoords - markerLocation) > radius then
                        isInsideMarker = false
                    end
                end
            end
        else
            isInsideMarker = false
        end
    end
end)

--SİLAH ÜRETİMİ

local QBCore = exports['qb-core']:GetCoreObject()

local npcModel = `a_m_m_og_boss_01`
local npcCoords = vector3(841.42, -2308.73, 30.66)
local npcHeading = 90.0

local menuOpened = false

Citizen.CreateThread(function()
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Wait(100)
    end
    local npc = CreatePed(4, npcModel, npcCoords.x, npcCoords.y, npcCoords.z - 1, npcHeading, false, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local dist = #(playerCoords - npcCoords)

        if dist < 2.0 then
            sleep = 5
            DrawText3D(npcCoords.x, npcCoords.y, npcCoords.z + 1.0, "[E] Silah Üret")
            if IsControlJustReleased(0, 38) then
                TriggerEvent("neiz:openWeaponMenu")
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent("neiz:openWeaponMenu", function()
    if menuOpened then return end
    menuOpened = true
    exports['qb-menu']:openMenu({
        {
            header = "Silah Üretimi",
            isMenuHeader = true
        },
        {
            header = "Silah Üret",
            txt = "Gerekli malzemeler: Kaydırak, Namlu, Şarjör, Tetik, Tutamaç, Yay",
            params = { event = "neiz:craftWeapon" }
        },
        {
            header = "Kapat",
            txt = "Menüyü kapat",
            params = { event = "neiz:closeMenu" }
        }
    })
    Citizen.SetTimeout(1000, function() menuOpened = false end)
end)

RegisterNetEvent("neiz:closeMenu", function()
    exports['qb-menu']:closeMenu()
end)

RegisterNetEvent("neiz:craftWeapon", function()
    TriggerServerEvent("neiz:weaponCrafting")
end)
