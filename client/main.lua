QBCore = exports['qb-core']:GetCoreObject()

local Shops = {
    [1] = {
        coords = vector3(-1195.6551, -1577.7689, 4.631155)
    },
}
local checkskills = {
    [1] = {
        coords = vector3(-1199.33, -1580.15, 4.61)
    },
}

local PlayerData = {}
local training = false
local resting = false
local membership = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    QBCore.Debug('QBCore:Client:OnPlayerLoaded')
    Wait(1000) -- ensure that everything is established!
    FetchSkills()
    if ConfigGym.DeleteStats == true then
        while true do
            local seconds = ConfigGym.UpdateFrequency * 1000
            Wait(seconds)

            for skill, value in pairs(ConfigGym.Skills) do
                UpdateSkill(skill, value["RemoveAmount"])
            end
            QBCore.Debug(ConfigGym.DeleteStats)
            TriggerServerEvent("qb-skills:update", json.encode(ConfigGym.Skills))
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

local function round(num) 
    return math.floor(num+.5) 
end

local function GetCurrentSkill(skill)
    return ConfigGym.Skills[skill]
end

function RefreshSkills()
    for type, value in pairs(ConfigGym.Skills) do
        if value["Stat"] then
            StatSetInt(value["Stat"], round(value["Current"]), true)
        end
    end
end

--RegisterCommand('fetchgym', function() -- not necessary only for my dev things
    --FetchSkills()
--end)

function FetchSkills()
    QBCore.Functions.TriggerCallback("qb-skills:fetchStatus", function(data)
		if data then
            for status, value in pairs(data) do
                if ConfigGym.Skills[status] then
                    ConfigGym.Skills[status]["Current"] = value["Current"]
                else
                    QBCore.Debug("Removing: " .. status) 
                end
            end
		end
        RefreshSkills()
    end)
end


function UpdateSkill(skill, amount)

    if not ConfigGym.Skills[skill] then
        QBCore.Debug("Skill " .. skill .. " doesn't exist")
        return
    end
    local SkillAmount = ConfigGym.Skills[skill]["Current"]
    if SkillAmount + tonumber(amount) < 0 then
        ConfigGym.Skills[skill]["Current"] = 0
    elseif SkillAmount + tonumber(amount) > 100 then
        ConfigGym.Skills[skill]["Current"] = 100
    else
        ConfigGym.Skills[skill]["Current"] = SkillAmount + tonumber(amount)
    end
    RefreshSkills()
    if tonumber(amount) > 0 then
        QBCore.Functions.Notify('' .. amount .. '% ' .. skill, 'success')
    end
	TriggerServerEvent("qb-skills:update", json.encode(ConfigGym.Skills))
end

local function CheckTraining()
	if resting == true then
        QBCore.Functions.Notify('You are resting...', 'primary')
		resting = false
		Wait(60000)
		training = false
	end
	if resting == false then
        QBCore.Functions.Notify('Your rest is over!', 'success')
	end
end

function SkillMenu2()
    ped = PlayerPedId();
    RefreshSkills()
    exports['qb-menu']:openMenu(SkillStats())
end

function SkillStats()
    local skillStatsMenu = {
        {
            header = "Skill-Stats",
            isMenuHeader = true,
        }
    }

    for type, value in pairs(ConfigGym.Skills) do
        local skillItem = {
            header = type,
            txt = value["Current"] .. "%",
            disabled = false,
            params = {
                event = "nil", -- we dont wanna trigger any event with it, only see our stats :)
                args = {
                    number = 1,
                }
            }
        }
        table.insert(skillStatsMenu, skillItem)
    end

    return skillStatsMenu
end

function BuyMembership()
    ped = PlayerPedId()
    RefreshSkills()
    exports['qb-menu']:openMenu( BuyGymCard() )
end

function BuyMembership2()
        ped = PlayerPedId()
        RefreshSkills()
        TriggerServerEvent('qb-gym:buyMembership')
end

function BuyGymCard()
    local BuyGymCardMenu = {
        {
            header = "Gym-Membership",
            isMenuHeader = true,
        }
    }

    local BuyMemb = {
        header = "Buy for $365",
        txt = "Buy now!",
        disabled = false,
        params = {
            event = 'buyMembership2',
        }
    }
    table.insert(BuyGymCardMenu, BuyMemb)

    return BuyGymCardMenu
end

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

CreateThread(function()
		while true do
			Wait(60000)
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(ped)

		if IsPedRunning(ped) then
			UpdateSkill("resistance", 0.2)
		elseif IsPedInMeleeCombat(ped) then
			UpdateSkill("strength", 0.5)
		elseif IsPedSwimmingUnderWater(ped) then
			UpdateSkill("diving", 0.5)
		elseif IsPedShooting(ped) then
			UpdateSkill("shooting", 0.5)
		elseif DoesEntityExist(vehicle) then
			local speed = GetEntitySpeed(vehicle) * 3.6

			if GetVehicleClass(vehicle) == 8 or GetVehicleClass(vehicle) == 13 and speed >= 5 then
				local rotation = GetEntityRotation(vehicle)
				if IsControlPressed(0, 210) then
					if rotation.x >= 25.0 then
						UpdateSkill("wheelie_ability", 0.5)
					end 
				end
			end
			if speed >= 120 then
				UpdateSkill("driving", 0.2)
			end
		end
	end
end)

	
CreateThread(function()
	blip = AddBlipForCoord(-1201.2257, -1568.8670, 4.6101)
	SetBlipSprite(blip, 311)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipColour(blip, 7)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Gym')
	EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('qb-gym:trueMembership', function()
	membership = true
end)

RegisterNetEvent('qb-gym:falseMembership', function()
	membership = false
end)

CreateThread(function()
    while true do
        sleep = 1000
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            for k, v in pairs(Shops) do
                local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                if dist < 4.5 then
                    if dist < 2.5 then
                        sleep = 0
                        DrawText3D(v.coords.x, v.coords.y, v.coords.z, "~g~[E]~w~ - Buy membership")
                        if IsControlJustReleased(0, 38) then
                            BuyMembership2()   
                        end
                        Menu.renderGUI() 
                    end  
                end
            end
            for k, v in pairs(checkskills) do
                local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                if dist < 4.5 then
                    if dist < 2.5 then
                        sleep = 0
                        DrawText3D(v.coords.x, v.coords.y, v.coords.z, "~g~[E]~w~ - Train-Stats")
                        if IsControlJustReleased(0, 38) then
                            SkillMenu2()      
                            Menu.hidden = not Menu.hidden  
                        end
                        Menu.renderGUI() 
                    end  
                end
            end


            for k, v in pairs(ConfigGym.Locations) do
                local dist = #(pos - vector3(ConfigGym.Locations[k].coords.x, ConfigGym.Locations[k].coords.y, ConfigGym.Locations[k].coords.z))
                if dist < 4.5 then
                    if dist < ConfigGym.Locations[k].viewDistance then
                        sleep = 0
                        DrawText3D(ConfigGym.Locations[k].coords.x, ConfigGym.Locations[k].coords.y, ConfigGym.Locations[k].coords.z, ConfigGym.Locations[k].Text3D)
                        if IsControlJustReleased(0, 38) then
                            if training == false then
                                TriggerServerEvent('qb-gym:checkChip')
                                QBCore.Functions.Notify('Start up...', 'success')
                                Wait(1000)					
                                if membership == true then
                                    SetEntityHeading(ped, ConfigGym.Locations[k].heading)
                                    SetEntityCoords(ped, ConfigGym.Locations[k].coords.x, ConfigGym.Locations[k].coords.y, ConfigGym.Locations[k].coords.z - 1)
                                    TaskStartScenarioInPlace(ped, ConfigGym.Locations[k].animation, 0, true)
                                    Wait(30000)
                                    ClearPedTasksImmediately(ped)
                                    UpdateSkill(ConfigGym.Locations[k].skill, ConfigGym.Locations[k].SkillAddQuantity)
                                    QBCore.Debug(ConfigGym.Locations[k].skill, ConfigGym.Locations[k].SkillAddQuantity)
                                    QBCore.Functions.Notify('You will have to wait abt. to 60 sec. to rest', 'error')
                                    training = true
                                    resting = true
                                    CheckTraining()
                                elseif membership == false then
                                    QBCore.Functions.Notify('You have to be a member to do your training here!', 'error')
                                end
                            elseif training == true then
                                QBCore.Functions.Notify('You have to rest some time!', 'primary')
                                resting = true
                                CheckTraining()
                            end
                        end
                    end  
                end
            end
		Wait(sleep)
    end
end)
