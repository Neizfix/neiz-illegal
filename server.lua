local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('neiz:giveItem', function(item, amount)
    local src = source
    local success = exports.ox_inventory:AddItem(src, item, amount)
    if success then
        TriggerClientEvent('QBCore:Notify', src, 'You received ' .. amount .. 'x ' .. item .. '!', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Envanterin Full Veya İtem Yok', 'error')
    end
end)

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("neiz:attemptCraft", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local requiredItems = {"kaydirak", "namlu", "sarjor", "tetik", "tutamac", "yay"}
    local hasAllItems = true
    for _, item in pairs(requiredItems) do
        local itemData = Player.Functions.GetItemByName(item)
        if not itemData or itemData.amount < 1 then
            hasAllItems = false
            break
        end
    end
    if hasAllItems then
        for _, item in pairs(requiredItems) do
            Player.Functions.RemoveItem(item, 1)
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item], "remove")
        end
        Player.Functions.AddItem("weapon_g19", 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["weapon_g19"], "add")
        TriggerClientEvent("QBCore:Notify", src, "Başarıyla G19 ürettin!", "success")
    else
        TriggerClientEvent("QBCore:Notify", src, "Gerekli tüm malzemelere sahip değilsin!", "error")
    end
end)
