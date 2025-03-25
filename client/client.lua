local _ENTERED_ZONES = {}

CreateThread(function()
    while true do
        Wait(100)
        local _PED = PlayerPedId()
        local _IN_VEHICLE = IsPedInAnyVehicle(_PED, false)

        if _IN_VEHICLE then
            local _POS = GetEntityCoords(_PED)

            for _ZONE_ID, _ZONE in pairs(Config.Booths) do
                local _DIST = #(_POS - _ZONE.coords)
                local _IN_ZONE = _DIST < _ZONE.distance

                if _IN_ZONE and not _ENTERED_ZONES[_ZONE_ID] then
                    _ENTERED_ZONES[_ZONE_ID] = true

                    -- Shoutout Playboy Carti For The Callback Name - I AM MUSIC!
                    
                    lib.callback('forcng:ChargeDemHoesAFee!', false, function(_WAS_CHARGED, _INCOME_SOURCE)
                        if _WAS_CHARGED then
                            local _SOURCE_NAME = (_INCOME_SOURCE == "cash" and "pockets") or "bank"
                            lib.notify({
                                title = 'Toll Booth',
                                description = 'You were charged $' .. _ZONE.fee .. ' from your ' .. _SOURCE_NAME .. '.',
                                type = 'inform',
                                icon = "fa-solid fa-car",
                            })
                        end
                    end, _ZONE.fee)

                elseif not _IN_ZONE and _ENTERED_ZONES[_ZONE_ID] then
                    _ENTERED_ZONES[_ZONE_ID] = false
                end
            end
        else
            for _ZONE_ID, _ in pairs(Config.Booths) do
                _ENTERED_ZONES[_ZONE_ID] = false
            end
        end
    end
end)
