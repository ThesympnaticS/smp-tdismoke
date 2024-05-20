⚠️ Warning
This script is provided for free and is intended for educational and personal use only. By using this script, you agree not to sell, redistribute, or use it for any commercial purposes without explicit permission from the author.

end
local effect_time = 20   -- how long it lasts in seconds
local spam_timer = 0    -- prevent spam ( in minutes )
local SIZE = 2.5        -- size of smoke 
local particleDict = "core" -- do not change
local particleName = "proj_grenade_smoke" -- particle smoke
local bone = "exhaust" -- what it comes out of 
end



--[[local key = 60]]--
--[[local key = 73 ]]-- x
--[[local key = 60]]-- CTRL
-- [ EFFECTS FOR PARTICLENAME ABOVE ]
-- veh_exhaust_truck_rig [size = 3.0]
-- ent_amb_smoke_general [size = 1.0]
-- ent_amb_generator_smoke [size = 1.0]
-- ent_amb_exhaust_thick [size = 0.8]
-- ent_amb_stoner_vent_smoke
--proj_grenade_smoke - 2.0 - the best so far

carblacklist = {   -- ONLY CARS IN THIS LIST CAN USE THIS SCRIPT
    "6lcupra"  ,
    "audis32"  ,
}
--## END OF CONFIG
--## END OF CONFIG
local smoke_ready = true
local car_net = nil
local vehicle
local ped
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        ped = GetPlayerPed(PlayerId())
        
        if IsPedInAnyVehicle(ped, false) then

            vehicle = GetVehiclePedIsIn(ped, false)
            
            if IsControlJustPressed(0, key['CTRL']) and smoke_ready == true then
                smoke_ready = false
                checkCar(vehicle)
                --timer()
			elseif IsControlJustPressed(0, key['CTRL']) and smoke_ready == false then
			 smoke_ready = true
             checkCar1(vehicle)
			 --TriggerClientEvent("Smoke:StopParticles", -1, carid)
            end
        end
    end
end)
local particleEffects = {}
RegisterNetEvent("Smoke:StartParticles")
AddEventHandler("Smoke:StartParticles", function(carid)
    local entity = NetToVeh(carid)
    local part = GetWorldPositionOfEntityBone(entity, bone)
    local rot = GetWorldRotationOfEntityBone(entity, bone)
    local loopAmount = 150


    for x=0,loopAmount do

        UseParticleFxAssetNextCall(particleDict)
        local particle = StartParticleFxLoopedOnEntityBone(particleName, entity, part.x, part.y, part.z, rot.x, rot.y, rot.z, GetEntityBoneIndexByName(entity, bone), SIZE, false, false, false)            

        SetParticleFxLoopedEvolution(particle, particleName, SIZE, true)
        table.insert(particleEffects, 1, particle)
        Citizen.Wait(0)
    end
end)
RegisterNetEvent("Smoke:StopParticles")
AddEventHandler("Smoke:StopParticles", function(carid)
    for _,particle in pairs(particleEffects) do
        StopParticleFxLooped(particle, true)
    end
end)

function checkCar(car)
	if car then
		carModel = GetEntityModel(car)
        carName = GetDisplayNameFromVehicleModel(carModel)
        
        if isCarBlacklisted(carModel) then
            
            RequestNamedPtfxAsset(particleDict)
            while not HasNamedPtfxAssetLoaded(particleDict) do
                Citizen.Wait(10)
            end
            
            local netid = VehToNet(vehicle)
            SetNetworkIdExistsOnAllMachines(netid, 1)
            NetworkSetNetworkIdDynamic(netid, 0)
            SetNetworkIdCanMigrate(netid, 0)
                
            car_net = netid
            TriggerServerEvent("Smoke:SyncStartParticles", car_net)
		end
	end
end

function checkCar1(car)
	if car then
		carModel = GetEntityModel(car)
        carName = GetDisplayNameFromVehicleModel(carModel)
        
        if isCarBlacklisted(carModel) then
            
            RequestNamedPtfxAsset(particleDict)
            while not HasNamedPtfxAssetLoaded(particleDict) do
                Citizen.Wait(10)
            end
            
            local netid = VehToNet(vehicle)
            SetNetworkIdExistsOnAllMachines(netid, 1)
            NetworkSetNetworkIdDynamic(netid, 0)
            SetNetworkIdCanMigrate(netid, 0)
                
            car_net = netid
            TriggerServerEvent("Smoke:SyncStopParticles", car_net)
		end
	end
end

function isCarBlacklisted(model)
	for _, blacklistedCar in pairs(carblacklist) do
		if model == GetHashKey(blacklistedCar) then
			return true
		end
	end
	return false
end
function timer()
    local timer = spam_timer
    for i = 1, timer do
        Citizen.Wait(60000)
    end
    smoke_ready = true
end
