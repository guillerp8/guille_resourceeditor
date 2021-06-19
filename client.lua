-- A PART OF THE UI IS MADE BY https://forum.cfx.re/t/release-devtools-getcoords/1074960

RegisterNetEvent("guille_resourceeditor:client:editResource")
AddEventHandler("guille_resourceeditor:client:editResource", function(resource, name, route)
    SendNUIMessage({
        resource = resource;
        name = name;
        route = route;
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("getResource", function(resource)
    TriggerServerEvent("guille_resourceeditor:server:editResource", resource.code, resource.name, resource.route)
    SetNuiFocus(false, false)
end)

RegisterNUICallback("exit", function(resource)
    SetNuiFocus(false, false)
end)

RegisterNetEvent("logr")
AddEventHandler("logr", function(resource)
    SetNotificationTextEntry('STRING')
	AddTextComponentString("Look f8")
	DrawNotification(0,1)
    print(resource)
end)

RegisterNetEvent("guille_resourceeditor:client:notify")
AddEventHandler("guille_resourceeditor:client:notify", function(t)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(t)
    DrawNotification(0,1)
end)