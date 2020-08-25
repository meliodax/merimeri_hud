-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local seatbelt = false
local ExNoCarro = false
local voice = 2
local sBuffer = {}
local dayMonth = 0
local hour = 0
local minute = 0
local varDay = "th"
local month = ""
local talking = false
local showHud = true
local showRadar = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusFome")
AddEventHandler("statusFome",function(number)
	hunger = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEDE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusSede")
AddEventHandler("statusSede",function(number)
	thirst = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GCPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
local menu_celular = false
RegisterNetEvent("status:celular")
AddEventHandler("status:celular",function(status)
	menu_celular = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if IsPauseMenuActive() or IsScreenFadedOut() or menu_celular then
			SendNUIMessage({ hud = false, movie = false })
		else
		local ped = PlayerPedId()
		local health = (GetEntityHealth(PlayerPedId())-100)/300*100
        local x,y,z = table.unpack(GetEntityCoords(ped))
        local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))

		calculateTimeDisplay()
		
		if not IsPedInAnyVehicle(ped) then 
			showRadar = false
		end

        if IsPedInAnyVehicle(ped) then 

            local vehicle = GetVehiclePedIsIn(ped)
            local fuel = GetVehicleFuelLevel(vehicle)
            local speed = GetEntitySpeed(vehicle) * 3.6


            
            if dayOfMonth == 1 then
				varDay = "st"
			elseif dayOfMonth == 2 then
				varDay = "nd"
			elseif dayOfMonth == 3 then
				varDay = "rd"
			else
				varDay = "th"
			end

			if not showHud then 
				showRadar = false 
			end

			if IsPedOnAnyBike(ped) then
				showRadar = true
			end

            SendNUIMessage({
				hud = showHud,
				car = true,
                seatbelt = seatbelt,
	    		show = IsPauseMenuActive(),
	    		armor = GetPedArmour(ped),
                health = parseInt(health),
                hunger = parseInt(hunger),
                thirst = parseInt(thirst),
                fuel = parseInt(fuel),
                speed = parseInt(speed),
                day = dayMonth..varDay,
                month = month,
                hour = hour,
                minute = minute,
                street = street,
                talking = talking,
                voice = voice
            })

        else 
            
            SendNUIMessage({
				hud = showHud,
                car = false,
	    		show = IsPauseMenuActive(),
	    		armor = GetPedArmour(ped),
                health = parseInt(health),
                hunger = parseInt(hunger),
                thirst = parseInt(thirst),
                day = dayMonth..varDay,
                month = month,
                hour = hour,
                minute = minute,
                street = street,
                talking = talking,
                voice = voice

			})
			end 
        end
        Citizen.Wait(200)
    end
end) 
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOKOVOIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_hud:Tokovoip")
AddEventHandler("vrp_hud:Tokovoip",function(status)
	voice = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOKOVOIPTALKING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_hud:TokovoipTalking")
AddEventHandler("vrp_hud:TokovoipTalking",function(status)
	talking = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
IsCar = function(veh)
	local vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 15 and vc <= 20)
end

Citizen.CreateThread(function()
	while true do
		local ORTiming = 500
		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(ped)

		if car ~= 0 and (ExNoCarro or IsCar(car)) then
            ExNoCarro = true
            
			if seatbelt then
				DisableControlAction(0,75)
			end

			ORTiming = 4
			sBuffer[2] = sBuffer[1]
			sBuffer[1] = GetEntitySpeed(car)

			if sBuffer[2] ~= nil and not seatbelt and GetEntitySpeedVector(car,true).y > 1.0 and sBuffer[1] > 10.25 and (sBuffer[2] - sBuffer[1]) > (sBuffer[1] * 0.255) then
				SetEntityHealth(ped,GetEntityHealth(ped)-10)
				TaskLeaveVehicle(ped,GetVehiclePedIsIn(ped),4160)
				timedown = 10
			end

			if IsControlJustReleased(1,47) then
				if seatbelt then
					TriggerEvent("vrp_sound:source","unbelt",0.5)
					showRadar = false
					seatbelt = false
				else
					TriggerEvent("vrp_sound:source","belt",0.5)
					seatbelt = true
					showRadar = true
				end
			end

			if not seatbelt and not showHud then 
				showRadar = false
			end

		elseif ExNoCarro then
			ExNoCarro = false
			seatbelt = false
			sBuffer[1],sBuffer[2] = 0.0,0.0
		end
		DisplayRadar(showRadar)
		Citizen.Wait(ORTiming)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALCULATETIMEDISPLAY
-----------------------------------------------------------------------------------------------------------------------------------------
function calculateTimeDisplay()
	hour = GetClockHours()
	month = GetClockMonth()
	minute = GetClockMinutes()
	dayMonth = GetClockDayOfMonth()

	if hour <= 9 then
		hour = "0"..hour
	end

	if minute <= 9 then
		minute = "0"..minute
	end

	if month == 0 then
		month = "January"
	elseif month == 1 then
		month = "February"
	elseif month == 2 then
		month = "March"
	elseif month == 3 then
		month = "April"
	elseif month == 4 then
		month = "May"
	elseif month == 5 then
		month = "June"
	elseif month == 6 then
		month = "July"
	elseif month == 7 then
		month = "August"
	elseif month == 8 then
		month = "September"
	elseif month == 9 then
		month = "October"
	elseif month == 10 then
		month = "November"
	elseif month == 11 then
		month = "December"
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hud",function(source,args)
	showHud = not showHud
	showRadar = not showRadar
--	print(showRadar)
end)
