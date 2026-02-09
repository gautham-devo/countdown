ESX = exports["es_extended"]:getSharedObject()

local weaponsDisabled = false
local countdownActive = false
local countdownTime = 60
local countdownEndTime = 0
local lastNotificationTime = 0
local notificationInterval = 10  -- Interval in seconds between notifications

RegisterNetEvent("weaponCountdownStarted")
AddEventHandler("weaponCountdownStarted", function()
    weaponsDisabled = true
    countdownActive = true
    countdownEndTime = GetGameTimer() + (countdownTime * 1000)
    exports['SY_Notify']:Alert("inform", "Weapon usage has been disabled for 1 minute.", 5000, 'error')
end)

RegisterNetEvent("weaponCountdownEnded")
AddEventHandler("weaponCountdownEnded", function()
    weaponsDisabled = false
    countdownActive = false
    exports['SY_Notify']:Alert("inform", "Weapon usage has been re-enabled.", 5000, 'success')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if countdownActive then
            local currentTime = GetGameTimer()
            local remainingTime = math.max(0, countdownEndTime - currentTime)

            local seconds = math.floor(remainingTime / 1000)

            if remainingTime <= 0 then
                countdownActive = false
                TriggerEvent("weaponCountdownEnded") -- Enable firing after countdown
                return
            end

            if seconds > 0 and seconds % notificationInterval == 0 and currentTime - lastNotificationTime >= (notificationInterval * 1000) then
                lastNotificationTime = currentTime
                exports['SY_Notify']:Alert("inform", "Weapon usage will be enabled in " .. seconds .. " seconds.", 5000, 'warning')
            end
        end

        if weaponsDisabled then
            DisablePlayerFiring(playerPed, true)
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent("disablefire")
AddEventHandler("disablefire", function()
    weaponsDisabled = not weaponsDisabled
    if weaponsDisabled then
        exports['SY_Notify']:Alert("inform", "Weapon Disabled", 5000, 'error')
    else
        exports['SY_Notify']:Alert("inform", "Weapon Enabled", 5000, 'success')
    end
end)
