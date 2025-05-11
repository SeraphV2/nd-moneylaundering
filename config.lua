Config = {}

-- Money Laundering Settings
Config.LaunderingFee = 0.3 -- 30% fee
Config.LaunderingTime = 10000 -- 10 seconds in ms
Config.MarkedBillsValue = 100 -- Each marked bill is worth $100

-- Item Settings
Config.DirtyMoneyItem = "markedbills" -- The item name for dirty money in your server
Config.UseMoneyItem = false -- Set to true if your server uses an item for cash instead of an account
Config.CleanMoneyItem = "cash" -- The item name for clean money (if UseMoneyItem is true)

-- Blip Settings
Config.EnableBlips = true -- Set to false to disable all blips
Config.BlipName = "Money Laundering" -- Name that appears on the map blip
Config.BlipSprite = 500 -- Blip icon on the map
Config.BlipColor = 1 -- Blip color on the map
Config.BlipScale = 0.7 -- Size of the blip on the map

-- Notification Settings
Config.NotifySuccess = "Money laundered successfully. You received $%s after a $%s fee"
Config.NotifyNoMoney = "You don't have any dirty money to launder"
Config.NotifyNotEnough = "You don't have enough dirty money"
Config.NotifyInvalid = "Invalid amount"
Config.NotifyCancelled = "Cancelled"
Config.NotifyCheat = "Nice try, but that won't work"

-- Laundering locations - users can easily add or modify these
Config.LaunderingLocations = {
    vector3(-909.47, 125.44, 55.31), -- Example location (customize as needed)
    vector3(-1117.21, -503.12, 35.81), -- Example location (customize as needed)
    -- Add more locations as needed
}
