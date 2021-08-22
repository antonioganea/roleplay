function isEmployedAs(player, jobType)
    local account = getPlayerAccount(player)

    if ( not ( account and not isGuestAccount(account) ~= false ) ) then
        return false
    end

    local job = getAccountData(account, "job")
    
    return job == jobType
end

function employAs(player, jobType)
    local account = getPlayerAccount(player)

    setAccountData(account, "job", jobType)
end

function isUnemployed(player)
    local account = getPlayerAccount ( player )

    if ( not ( account and not isGuestAccount(account) ~= false ) ) then
        return false
    end

    local job = getAccountData(account, "job")
    
    return job == false
end

function jobinfo(player, command)
    local account = getPlayerAccount(player)

    local job = getAccountData(account, "job")

    outputChatBox(job, player)
end
addCommandHandler("jobinfo",jobinfo)