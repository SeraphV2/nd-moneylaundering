local QBCore = exports['qb-core']:GetCoreObject()
local isLaundering = false

-- Create blips for laundering locations
Citizen.CreateThread(function()
    -- Skip blip creation if blips are disabled
    if not Config.EnableBlips then return end
    
    for _, coords in pairs(Config.LaunderingLocations) do
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, Config.BlipSprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.BlipScale)
        SetBlipColour(blip, Config.BlipColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.BlipName)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Check if player is near a laundering location
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isNearLaunderer = false
        
        for _, coords in pairs(Config.LaunderingLocations) do
            local distance = #(playerCoords - coords)
            if distance < 2.0 then
                isNearLaunderer = true
                DrawText3D(coords.x, coords.y, coords.z, "Press ~g~E~w~ to launder money")
                
                if IsControlJustReleased(0, 38) and not isLaundering then -- E key
                    TriggerEvent('nd_moneylaundering:openMenu')
                end
                break
            end
        end
        
        if not isNearLaunderer then
            Citizen.Wait(500)
        end
    end
end)

-- Open laundering menu
RegisterNetEvent('nd_moneylaundering:openMenu')
AddEventHandler('nd_moneylaundering:openMenu', function()
    QBCore.Functions.TriggerCallback('nd_moneylaundering:getDirtyMoney', function(dirtyMoney, itemCount)
        if dirtyMoney > 0 then
            exports['qb-menu']:openMenu({
                {
                    header = "Money Laundering",
                    isMenuHeader = true
                },
                {
                    header = "Launder All Dirty Money",
                    txt = "Fee: " .. (Config.LaunderingFee * 100) .. "% | Amount: $" .. dirtyMoney,
                    params = {
                        event = "nd_moneylaundering:launderAll",
                    }
                },
                {
                    header = "Launder Custom Amount",
                    txt = "Enter a custom amount to launder",
                    params = {
                        event = "nd_moneylaundering:inputAmount",
                    }
                },
                {
                    header = "Cancel",
                    txt = "",
                    params = {
                        event = "qb-menu:client:closeMenu"
                    }
                },
            })
        else
            QBCore.Functions.Notify(Config.NotifyNoMoney, "error")
        end
    end)
end)

-- Launder all dirty money
RegisterNetEvent('nd_moneylaundering:launderAll')
AddEventHandler('nd_moneylaundering:launderAll', function()
    if isLaundering then return end
    
    isLaundering = true
    local playerPed = PlayerPedId()
    
    -- Animation
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
    QBCore.Functions.Progressbar("laundering_money", "Laundering Money...", Config.LaunderingTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(playerPed)
        TriggerServerEvent('nd_moneylaundering:launderAllComplete')
        isLaundering = false
    end, function() -- Cancel
        ClearPedTasks(playerPed)
        QBCore.Functions.Notify(Config.NotifyCancelled, "error")
        isLaundering = false
    end)
end)

-- Input custom amount
RegisterNetEvent('nd_moneylaundering:inputAmount')
AddEventHandler('nd_moneylaundering:inputAmount', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Money Laundering",
        submitText = "Launder",
        inputs = {
            {
                text = "Amount to Launder",
                name = "amount",
                type = "number",
                isRequired = true
            }
        }
    })
    
    if dialog and dialog.amount and tonumber(dialog.amount) > 0 then
        TriggerEvent('nd_moneylaundering:launderMoney', {amount = tonumber(dialog.amount)})
    end
end)

-- Start laundering process for custom amount
RegisterNetEvent('nd_moneylaundering:launderMoney')
AddEventHandler('nd_moneylaundering:launderMoney', function(data)
    if isLaundering then return end
    
    local amount = data.amount
    
    if amount <= 0 then
        QBCore.Functions.Notify(Config.NotifyInvalid, "error")
        return
    end
    
    QBCore.Functions.TriggerCallback('nd_moneylaundering:checkDirtyMoney', function(hasEnough)
        if hasEnough then
            isLaundering = true
            local playerPed = PlayerPedId()
            
            -- Animation
            TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
            QBCore.Functions.Progressbar("laundering_money", "Laundering Money...", Config.LaunderingTime, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                ClearPedTasks(playerPed)
                TriggerServerEvent('nd_moneylaundering:launderComplete', amount)
                isLaundering = false
            end, function() -- Cancel
                ClearPedTasks(playerPed)
                QBCore.Functions.Notify(Config.NotifyCancelled, "error")
                isLaundering = false
            end)
        else
            QBCore.Functions.Notify(Config.NotifyNotEnough, "error")
        end
    end, amount)
end)

-- 3D Text function
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end
