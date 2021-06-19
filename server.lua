function checkAdmin(s)
    local steam = nil
    for k,v in ipairs(GetPlayerIdentifiers(s))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steam = v
        end
    end
    for k,v in pairs(Config.Admins) do
        if v == steam then
            return true
        end
    end
    return false
end

function sendToDiscord(name, message, color)
    local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "guillerp scripts",
                ["icon_url"] = "https://i.ibb.co/GdpN9Zh/Wack.png",
            },
        }
    }
    PerformHttpRequest(Config.Webhhook, function(err, text, headers) end, 'POST', json.encode({username = "guillerp", embeds = connect, avatar_url = "https://i.ibb.co/GdpN9Zh/Wack.png"}), { ['Content-Type'] = 'application/json' })
end

RegisterCommand("checkresource", function(source, args)
    if checkAdmin(source) then
        local resource1 = LoadResourceFile(args[1], "__resource.lua")
        local resource2 = LoadResourceFile(args[1], "fxmanifest.lua")
        if resource1 then
            TriggerClientEvent("logr", source, resource1)
        elseif resource2 then
            TriggerClientEvent("logr", source, resource2)
        end
    end
end)

RegisterCommand("editresource", function(source, args)
    if checkAdmin(source) then
        local resource = args[1]

        local route = args[2]

        local loadedResource = LoadResourceFile(args[1], args[2])

        local blacklisted = false

        if loadedResource ~= nil then
            for k,v in pairs(Config.blacklistedResources) do
                if args[1] == v then
                    blacklisted = true
                end
            end
            if not blacklisted then 
                TriggerClientEvent("guille_resourceeditor:client:editResource", source, loadedResource, resource, route)
                SaveResourceFile(resource, route.."-security"..math.random(1, 300000000)..".lua", loadedResource, -1)
            else
                TriggerClientEvent('guille_resourceeditor:client:notify', source, "You are trying to edit a blacklisted resource")
                blacklisted = false
            end
            
        else
            TriggerClientEvent('guille_resourceeditor:client:notify', source, "The file or route doesn't exist or you are trying to edit a blacklisted resource")
        end
    else
        print("[guille_resourceeditor] Hey, the id " ..source.. " attempted to edit a resource with no perms")
        TriggerClientEvent('guille_resourceeditor:client:notify', source, "No perms")
    end

end, false)

RegisterServerEvent("guille_resourceeditor:server:editResource")
AddEventHandler("guille_resourceeditor:server:editResource", function(code, name, route)
    if checkAdmin(source) then
        local steam = nil
        for k,v in ipairs(GetPlayerIdentifiers(source))do
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
                steam = v
            end
        end
        sendToDiscord("guille_resourceeditor [resource edited]", "The admin **" ..GetPlayerName(source).. "** edited the resource **"..name.. "** - " ..steam, 65280)
        SaveResourceFile(name, route, code, -1)
        if Config.restartOnEdit then
            StopResource(name)
            StartResource(name)
        end
    else
        print("[EXPLOIT IN RESOURCE EDITOR] ID " ..source.. " ATTEMPTED TO EDIT A RESOURCE")
    end
end)

SetConvarServerInfo("guille_resourceeditor", "https://discord.gg/eBpmkW6e5j")
