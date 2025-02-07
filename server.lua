Citizen.CreateThread(function()

    if (Config.UseCommand) then
    RegisterCommand(Config.RollCommand, function(source, args, rawCommand)
        if(args[1] ~= nil and args[2] ~= nil) then
            local dice = tonumber(args[1])
            local sides = tonumber(args[2])
            if (sides > 0 and sides <= Config.SidesMax) and (dice > 0 and dice <= Config.DiceMax) then
                TriggerEvent('DiceRoller:Server:Event', source, dice, sides)
            else
                TriggerClientEvent('chatMessage', source, "You need to roll the die at least once")
            end
    
        else
            TriggerClientEvent('chatMessage', source, "Enter the amount of die and the sides")
        end
    end,false)
    end
    end)
    RegisterServerEvent('DiceRoller:Server:Event')
    AddEventHandler('DiceRoller:Server:Event', function(source, dice, sides)
    
        local tabler = {}
        for i=1, dice do
            table.insert(tabler, math.random(1, sides))
        end
    
        TriggerClientEvent("DiceRoller:Client:Roll", -1, source, Config.Distance, tabler, sides, GetEntityCoords(GetPlayerPed(source)))
        end)