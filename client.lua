local RDR = Config.RDR

Citizen.CreatThread(function()
    if(Config.UseCommand) then
    TriggerEvent('chat:addSuggestion', '/'.. Config.DiceCommand, 'Roll Dice', {
        {name='Dice', help='Number of dice rolled - Max: '..Config.DiceMax},
        {name='Sides', help='Number of sides per die - Max: '..Config.SidesMax}
    })
end
end)

RegisterNetEvent("DiceRoller:Client:Roll")
AddEventHandler("DiceRoller:Client:Roll", function(sourceId, maxDistance, rollTable, sides, location)
    local rollString = CreateRollString(rollTable, sides)
    globalPlayerPedId = GetPlayerPed(-1)
    if(location.x == 0.0 and location.y == 0.0 and location.z == 0.0)then 
        location = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)))
    end 
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
    local dist = #(location - coords)

    if dist < Config.Distance then
        local display = true

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
end

function DrawText3D(x, y, z, text, bgAlpha)
    if RDR then
        local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
        local dist = #(GetGameplayCamCoord() - vector3(x, y, z))
    
        if GetRenderingCam() ~= -1 then
            dist = #(GetCamCoord(GetRenderingCam()) - vector3(x, y, z))
        end

        local scale = (1 / dist) * (IsPedOnFoot(PlayerPedId()) and Config.FootScale or Config.VehicleScale)
        local fov = (1 / GetGameplayCamFov()) * 100
        scale = scale * fov
    
        if onScreen then
            SetTextScale(0.0, 0.35 * scale)
            SetTextColor(255, 255, 255, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)

            local lineCount = select(2, string.gsub(text, "~n~", "")) + 1
            local textLength = #text - (bgAlpha ~= 0 and 3 or 0)
            local endW = 0.005 * textLength / lineCount * scale
            local textWidth = endW + 0.01 * scale
            local textHeight = 0.03 * lineCount * scale

            if Config.textureDict ~= '' and Config.textureName ~= '' then
                local spriteWidth = textWidth
                local spriteHeight = textHeight
                DrawSprite(Config.textureDict, Config.textureName, _x, _y + textHeight / 2.2, spriteWidth, spriteHeight, 0, 0, 0, 0, bgAlpha)
            else
                local bgColor = {0, 0, 0, bgAlpha}
                DrawRect(_x, _y + textHeight / 2.2, textWidth, textHeight, bgColor[1], bgColor[2], bgColor[3], bgColor[4])
            end

            Citizen.InvokeNative(0xADA9255D, Config.Font)

            Citizen.InvokeNative(0xBE5261939FBECB8C, true)
            Citizen.InvokeNative(0xd79334a4bb99bad1,
                Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", text, Citizen.ResultAsLong()), _x, _y)
        end
    else

        local onScreen, _x, _y = World3dToScreen2d(x, y, z)
        local camCoords = GetGameplayCamCoords()
        local dist = #(camCoords - vector3(x, y, z))

        local scale = (1 / dist) * (IsPedOnFoot(PlayerPedId()) and Config.FootScale or Config.VehicleScale)
        local fov = (1 / GetGameplayCamFov()) * 100
        scale = scale * fov

        if onScreen then
            SetTextScale(0.0, 0.35 * scale)
            SetTextFont(Config.Font)
            SetTextProportional(1)
            SetTextColour(255, 255, 255, 255)
            SetTextCentre(1)

            local lineCount = select(2, string.gsub(text, "~n~", "")) + 1
            local textLength = #text - (bgAlpha ~= 0 and 3 or 0)
            local endW = 0.005 * textLength / lineCount * scale
            local textWidth = endW + 0.01 * scale
            local textHeight = 0.03 * lineCount * scale

            if Config.textureDict ~= '' and Config.textureName ~= '' then
                local spriteWidth = textWidth
                local spriteHeight = textHeight
                DrawSprite(Config.textureDict, Config.textureName, _x, _y + textHeight / 2.2, spriteWidth, spriteHeight, 0, 0, 0, 0, bgAlpha)
            else
                local bgColor = {0, 0, 0, bgAlpha}
                DrawRect(_x, _y + textHeight / 2.2, textWidth, textHeight, bgColor[1], bgColor[2], bgColor[3], bgColor[4])
            end

            SetTextEntry("STRING")
            AddTextComponentString(text)
            DrawText(_x, _y)
        end
    end
end

local playerOffsets = {}
local offsetIncrement = 0.1
local baseOffset = 0.4

Citizen.CreateThread(function() --Keeps resource usage down
    while true do
        Citizen.Wait(60000)
        collectgarbage("collect")
    end 
end)