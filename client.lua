local globalPlayerPedId = nil

Citizen.CreatThread(function()
    if(Config.UseCommand) then
    TriggerEvent('chat:addSuggestion', '/'.. Config.DiceCommand, 'Roll Dice', {
        {name='Dice', help='Number of dice rolled - Max: '..Config.DiceMax},
        {name='Sides', help='Number of sides per die - Max: '..Config.SidesMax}
    })
end
end)

RegisterNetEVent("DiceRoller:Client:Roll")
AddEventHandler("DiceRoller:Client:Roll", function(sourceId, maxDistance, rollTable, sides, location)
    local rollString = CreateRollString(rollTable, sides)
    globalPlayerPedId = GetPlayerPed(-1)

ShowRoll(rollString, sourceId, maxDistance, location)
end)

function CreatRollString(rollTable, sides)
    local text = 'Roll: '
    local total = 0

    for k, roll in pairs(rollTable, sides) do
        total = total + roll
        if k == 1 then
            text = text .. roll .. "/" .. sides
        else
            text = text .. " | " .. "/" .. sides
        end
    end

    text = text .. " | (Total: "..total..")"
    return text
end

function ShowRoll(text, sourceId, maxDistance, location)
    local coords = GetEntityCoords(globalPlayerPedId, false)
    local = dist = #(location - coords)

    if dist < Config.Distance then
        local dispaly = true
    Citizen.CreateThread(function()
        Wait(Config.DisplayTime * 1000)
        display = false
    end)

    Citizen.CreatThread(function()
        serverPed = GetPlayerPed(GetPlayerFromServerId(sourceId))
        while display do
            Wait(7)
        local currentcoords = GetEntityCoords(serverPed)
            DrawText3D(currentcoords.x, currentcoords.y, currentcoords.z + Config.Offset - 1.25, text)
        end
    end)

end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 100)
      end
end

Citizen.CreateThread(function() --Keeps resource usage down
    while true do
        Citizen.Wait(60000)
        collectgarbage("collect")
    end 
end)