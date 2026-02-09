ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterCommand("terr", 'user', function()
    TriggerClientEvent("weaponCountdownStarted", -1)
end)

ESX.RegisterCommand("disfire", 'admin', function()
    TriggerClientEvent("disablefire", -1)
end)