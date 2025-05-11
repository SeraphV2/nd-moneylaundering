local QBCore = exports['qb-core']:GetCoreObject()

-- Get player's dirty money amount
QBCore.Functions.CreateCallback('nd_moneylaundering:getDirtyMoney', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        -- Use exports.ox_inventory:GetItemCount for OX Inventory
        local itemCount = exports.ox_inventory:GetItemCount(source, Config.DirtyMoneyItem)
        if itemCount > 0 then
            cb(itemCount * Config.MarkedBillsValue, itemCount)
        else
            cb(0, 0)
        end
    else
        cb(0, 0)
    end
end)

-- Check if player has enough dirty money
QBCore.Functions.CreateCallback('nd_moneylaundering:checkDirtyMoney', function(source, cb, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        -- Use exports.ox_inventory:GetItemCount for OX Inventory
        local itemCount = exports.ox_inventory:GetItemCount(source, Config.DirtyMoneyItem)
        if itemCount > 0 and itemCount * Config.MarkedBillsValue >= amount then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

-- Launder all dirty money
RegisterNetEvent('nd_moneylaundering:launderAllComplete')
AddEventHandler('nd_moneylaundering:launderAllComplete', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Use exports.ox_inventory:GetItemCount for OX Inventory
    local itemCount = exports.ox_inventory:GetItemCount(src, Config.DirtyMoneyItem)
    if itemCount <= 0 then
        TriggerClientEvent('QBCore:Notify', src, Config.NotifyNoMoney, "error")
        return
    end
    
    -- Calculate total value and fee
    local totalValue = itemCount * Config.MarkedBillsValue
    local fee = math.floor(totalValue * Config.LaunderingFee)
    local cleanAmount = totalValue - fee
    
    -- Remove ALL dirty money using OX Inventory
    exports.ox_inventory:RemoveItem(src, Config.DirtyMoneyItem, itemCount)
    
    -- Add clean money based on configuration
    if Config.UseMoneyItem then
        -- Add money as an item using OX Inventory
        exports.ox_inventory:AddItem(src, Config.CleanMoneyItem, cleanAmount)
    else
        -- Add money to cash account
        Player.Functions.AddMoney("cash", cleanAmount)
    end
    
    -- Notify player
    TriggerClientEvent('QBCore:Notify', src, string.format(Config.NotifySuccess, cleanAmount, fee), "success")
    
    -- Log the transaction (optional)
    local citizenid = Player.PlayerData.citizenid
    local charinfo = Player.PlayerData.charinfo
    exports['qb-log']:AddLog('moneylaundering', 'Money Laundering', 'green', 
        citizenid .. ' (' .. charinfo.firstname .. ' ' .. charinfo.lastname .. ') laundered $' .. totalValue .. ' and received $' .. cleanAmount)
end)

-- Complete the laundering process for custom amount
RegisterNetEvent('nd_moneylaundering:launderComplete')
AddEventHandler('nd_moneylaundering:launderComplete', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Use exports.ox_inventory:GetItemCount for OX Inventory
    local itemCount = exports.ox_inventory:GetItemCount(src, Config.DirtyMoneyItem)
    if itemCount <= 0 or itemCount * Config.MarkedBillsValue < amount then
        TriggerClientEvent('QBCore:Notify', src, Config.NotifyCheat, "error")
        return
    end
    
    -- Calculate the fee using config value
    local fee = math.floor(amount * Config.LaunderingFee)
    local cleanAmount = amount - fee
    
    -- Calculate how many bills to remove
    local billsToRemove = math.ceil(amount / Config.MarkedBillsValue)
    
    -- Remove dirty money using OX Inventory
    exports.ox_inventory:RemoveItem(src, Config.DirtyMoneyItem, billsToRemove)
    
    -- Add clean money based on configuration
    if Config.UseMoneyItem then
        -- Add money as an item using OX Inventory
        exports.ox_inventory:AddItem(src, Config.CleanMoneyItem, cleanAmount)
    else
        -- Add money to cash account
        Player.Functions.AddMoney("cash", cleanAmount)
    end
    
    -- Notify player
    TriggerClientEvent('QBCore:Notify', src, string.format(Config.NotifySuccess, cleanAmount, fee), "success")
    
    -- Log the transaction (optional)
    local citizenid = Player.PlayerData.citizenid
    local charinfo = Player.PlayerData.charinfo
    exports['qb-log']:AddLog('moneylaundering', 'Money Laundering', 'green', 
        citizenid .. ' (' .. charinfo.firstname .. ' ' .. charinfo.lastname .. ') laundered $' .. amount .. ' and received $' .. cleanAmount)
end)
