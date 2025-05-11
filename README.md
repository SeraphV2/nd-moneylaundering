### nd-moneylaundering

## Money Laundering Script for QBCore with OX Inventory Support
A configurable money laundering script for QBCore framework that works with OX Inventory, allowing players to convert marked bills into clean cash.

# Features
Launder marked bills (dirty money) into clean cash
Configurable laundering fee
Multiple laundering locations using vector3 coordinates
Option to launder all dirty money at once or a custom amount
Customizable blips and notifications
Progress bar with animation during laundering
Logging of laundering transactions
Full OX Inventory compatibility
Installation
Download the resource
Place it in your server's resources folder
Add ensure nd_moneylaundering to your server.cfg
Configure the script in config.lua to match your server's needs
Restart your server
Configuration
The script is highly configurable through the config.lua file:

# Money Laundering Settings
Config.LaunderingFee = 0.3 -- 30% fee
Config.LaunderingTime = 10000 -- 10 seconds in ms
Config.MarkedBillsValue = 100 -- Each marked bill is worth $100

# Item Settings
Config.DirtyMoneyItem = "markedbills" -- The item name for dirty money in your server
Config.UseMoneyItem = false -- Set to true if your server uses an item for cash instead of an account
Config.CleanMoneyItem = "cash" -- The item name for clean money (if UseMoneyItem is true)

# Blip Settings
Config.EnableBlips = true -- Set to false to disable all blips
Config.BlipName = "Money Laundering" -- Name that appears on the map blip
Config.BlipSprite = 500 -- Blip icon on the map
Config.BlipColor = 1 -- Blip color on the map
Config.BlipScale = 0.7 -- Size of the blip on the map

Notification Settings
Config.NotifySuccess = "Money laundered successfully. You received $%s after a $%s fee"
Config.NotifyNoMoney = "You don't have any dirty money to launder"
Config.NotifyNotEnough = "You don't have enough dirty money"
Config.NotifyInvalid = "Invalid amount"
Config.NotifyCancelled = "Cancelled"
Config.NotifyCheat = "Nice try, but that won't work"

Laundering Locations
Config.LaunderingLocations = {
    vector3(1136.14, -989.54, 46.11), -- Example location (customize as needed)
    vector3(-1117.21, -503.12, 35.81), -- Example location (customize as needed)
    -- Add more locations as needed
}

# Usage
Approach one of the money laundering locations on the map
Press E to interact with the money launderer
Choose to either launder all your dirty money at once or enter a custom amount
Wait for the laundering process to complete
Receive your clean money minus the laundering fee
OX Inventory Integration

# This script is specifically designed to work with OX Inventory for QBCore. It uses the OX Inventory exports to:

Check for marked bills in the player's inventory
Remove marked bills when laundering
Add clean money as an item (if configured)
The script handles all marked bills correctly, ensuring that when a player chooses to "Launder All", it properly removes all marked bills from their inventory.

# Dependencies
QBCore Framework
OX Inventory
qb-menu
qb-input
Optional Dependencies
qb-log (for transaction logging)
How It Works
The script allows players to convert their marked bills (dirty money) into clean cash that can be used legally in the server. When a player chooses to launder money, the script:

Uses OX Inventory exports to check if the player has enough marked bills
Calculates the fee based on the configured percentage
Removes the marked bills from the player's inventory using OX Inventory exports
Adds the clean money (minus the fee) to the player's cash account or as an item
Notifies the player of the successful transaction
Troubleshooting
If you encounter issues with marked bills not being properly removed:

Make sure OX Inventory is properly installed and configured
Check that the item name in your config matches the actual item name in your OX Inventory database
Verify that the player has the marked bills in their inventory

License
This resource is released under the MIT License.

Support
For support, please open an issue on the GitHub repository or contact us through our Discord server.
