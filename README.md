# Project TDI SMOKE
For all support questions, feel free to open a ticket a ask for help in my discord.

Discord link [here](https://discord.gg/JTQAuS7d2p)




https://github.com/ThesympnaticS/smp-tdismoke/assets/72625097/cb3cb6c5-ea62-4723-8adf-9579d18a7b6b



## Installation
• Download ZIP

• Drag and drop resource into your server files

• Ensure ***smp-tdismoke*** in your ***server.cfg*** 

## Informations
How long the smoke lasts:
```lua
local effect_time = 20
```
Prevent spam in minutes:
```lua
local spam_timer = 0
```
Size of the smoke:
```lua
local SIZE = 2.5
```
Type of smokes, feel free to test them:
```lua
local particleName = "proj_grenade_smoke"
local particleName = "veh_exhaust_truck_rig"
local particleName = "ent_amb_smoke_general"
local particleName = "ent_amb_generator_smoke"
local particleName = "ent_amb_exhaust_thick"
local particleName = "ent_amb_stoner_vent_smoke"
local particleName = "proj_grenade_smoke"
local particleName = "proj_grenade_smoke"
```
Only cars in this list will be able to use the script, make sure to add yours, ADDON cars work as well:
```lua
carblacklist = { 
    "car1"  ,
    "car2"  ,
}
```
Local key to use the script:
```lua
if IsControlJustPressed(0, key['your key here']) and smoke_ready == true 
```








