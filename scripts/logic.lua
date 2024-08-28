
function dump_table(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end

function has(item, amount)
	local count = Tracker:ProviderCountForCode(item)
	amount = tonumber(amount)
	if not amount then
	  return count > 0
	else
	  return count == amount
	end
end

function has(item)
    return Tracker:ProviderCountForCode(item) == 1
  end
  
function checkRequirements(reference, check_count)
    local reqCount = Tracker:ProviderCountForCode(reference)
    local count = Tracker:ProviderCountForCode(check_count)
  
    if count >= reqCount then
        return true
    else
        return false
    end
end

function Gomode()
    return (((has("darkmatterhuntoff") and has("crystal")) or 
            (has("darkmatterhunton") and Tracker:FindObjectForCode("darkmatter").AcquiredCount >= 30)) 
            and ((has("pass") and has("passenabledon")) or has("darknesscrystal")))
end


function CrystalForGoMode()
    if Tracker:FindObjectForCode("crystal").Active == true then
        if Gomode() then
            Tracker:FindObjectForCode("go_mode").Active = true
        else
            Tracker:FindObjectForCode("go_mode").Active = false
        end
    elseif Tracker:FindObjectForCode("crystal").Active == false then
        if Gomode() == false then
            Tracker:FindObjectForCode("go_mode").Active = false
        end
    end
end

function DarknessCrystalForGoMode()
    if Tracker:FindObjectForCode("darknesscrystal").Active == true then
        if Gomode() then
            Tracker:FindObjectForCode("go_mode").Active = true
        else
            Tracker:FindObjectForCode("go_mode").Active = false
        end
    elseif Tracker:FindObjectForCode("darknesscrystal").Active == false then
        if Gomode() == false then
            Tracker:FindObjectForCode("go_mode").Active = false
        end
    end
end

function PassForGoMode()
    if Tracker:FindObjectForCode("pass").Active == true then
        if Gomode() then
            Tracker:FindObjectForCode("go_mode").Active = true
        else
            Tracker:FindObjectForCode("go_mode").Active = false
        end
    elseif Tracker:FindObjectForCode("pass").Active == false then
        if Gomode() == false then
            Tracker:FindObjectForCode("go_mode").Active = false
        end
    end
end

function DarkMatterForGoMode()
    if Tracker:FindObjectForCode("darkmatter").AcquiredCount == 30 then
        if Gomode() then
            Tracker:FindObjectForCode("go_mode").Active = true
        else
            Tracker:FindObjectForCode("go_mode").Active = false
        end
    elseif Tracker:FindObjectForCode("darkmatter").AcquiredCount < 30 then
        if Gomode() == false then
            Tracker:FindObjectForCode("go_mode").Active = false
        end
    end
end

ScriptHost:AddWatchForCode("crystalwatcher", "crystal", CrystalForGoMode)
ScriptHost:AddWatchForCode("darknesscrystalwatcher", "darknesscrystal", DarknessCrystalForGoMode)
ScriptHost:AddWatchForCode("passwatcher", "pass", PassForGoMode)
ScriptHost:AddWatchForCode("darkmatterwatcher", "darkmatter", DarkMatterForGoMode)