local key = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118 , ["CTRL"] = 60
}

local effect_time = 20   
local spam_timer = 0   
local SIZE = 2.5        
local particleDict = "core"
local particleName = "proj_grenade_smoke" 
local bone = "exhaust" 

carblacklist = { 
    "6lcupra"  ,
    "audis32"  ,
}

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

			elseif IsControlJustPressed(0, key['CTRL']) and smoke_ready == false then
			 smoke_ready = true
             checkCar1(vehicle)

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
