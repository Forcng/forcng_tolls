ESX = exports["es_extended"]:getSharedObject()

lib.callback.register('forcng:ChargeDemHoesAFee!', function(_SOURCE, _COST)
    local _SRC = _SOURCE

    if GetResourceState('qb-core') == "started" then
        local _QBCORE = exports['qb-core']:GetCoreObject()
        local _PLAYER = _QBCORE.Functions.GetPlayer(_SRC)

        if _PLAYER then
            local _JOB = _PLAYER.PlayerData.job.name

            if _JOB == "police" or _JOB == "ambulance" then
                TriggerClientEvent('ox_lib:notify', _SRC, {
                    title = 'Toll Booth',
                    description = 'Enjoy your free toll pass',
                    type = 'success',
                    icon = "fa-solid fa-car",
                })
                return false
            end

            local _CASH = _PLAYER.Functions.GetMoney("cash")
            local _BANK = _PLAYER.Functions.GetMoney("bank")

            if _CASH >= _COST then
                _PLAYER.Functions.RemoveMoney("cash", _COST)
                return true, "cash"
            elseif _BANK >= _COST then
                _PLAYER.Functions.RemoveMoney("bank", _COST)
                return true, "bank"
            else
                TriggerClientEvent('ox_lib:notify', _SRC, {
                    title = 'Toll Booth',
                    description = 'You do not have enough funds to pay the toll',
                    type = 'error',
                })
                return false
            end
        end

    elseif GetResourceState('es_extended') == "started" then
        local _XPLAYER = ESX.GetPlayerFromId(_SRC)

        if _XPLAYER then
            local _JOB = _XPLAYER.getJob().name
            local _CASH = _XPLAYER.getMoney()
            local _BANK = _XPLAYER.getAccount('bank').money

            if _JOB == "police" or _JOB == "ambulance" then
                TriggerClientEvent('ox_lib:notify', _SRC, {
                    title = 'Toll Booth',
                    description = 'Enjoy your free toll pass',
                    type = 'success',
                    icon = "fa-solid fa-car",
                })
                return false
            end

            if _CASH >= _COST then
                _XPLAYER.removeMoney(_COST)
                return true, "cash"
            elseif _BANK >= _COST then
                _XPLAYER.removeAccountMoney('bank', _COST)
                return true, "bank"
            else
                TriggerClientEvent('ox_lib:notify', _SRC, {
                    title = 'Toll Booth',
                    description = 'You do not have enough funds to pay the toll',
                    type = 'error',
                })
                return false
            end
        end
    end

    return false
end)
