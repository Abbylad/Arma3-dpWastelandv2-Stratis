 /*  
  Simple Vehicle Respawn Script v2.0
  
  Author: AimZ =(dp)= 
  [fixed] recoded to remove the conflicting time check and sleep.

  
  Original: Tophe of �stg�ta Ops [OOPS] (Contact & Bugreport: harlechin@hotmail.com) taken from 404 Wasteland

  Options:
  There are some optional settings. The format for these are:
  veh = [this, Delay, Deserted timer, Respawns, Effect, Static] execVM "vehicle.sqf"
  
  Default respawn delay is 30 seconds, to set a custom
  respawn delay time, put that in the init as well. 
  Like this:
  veh = [this, 15] execVM "vehicle.sqf"

  Default respawn time when vehicle is deserted, but not
  destroyed is 120 seconds. To set a custom timer for this 
  first put the respawn delay, then the deserted vehicle timer. (0 = disabled)
  Like this:  
  veh = [this, 15, 10] execVM "vehicle.sqf"

  By default the number of respawns is infinite. To set a limit
  First set the other values then the number of respawns you want (0 = infinite).
  Like this:
  veh = [this, 15, 10, 0] execVM "vehicle.sqf"

  Set this value to TRUE to add a special explosion effect to the wreck when respawning.
  Default value is FALSE, which will simply have the wreck disappear.
  Like this:
  veh = [this, 15, 10, 5, TRUE] execVM "vehicle.sqf"
  
  By default the vehicle will respawn to the point where it first
  was when the mission started (static). This can be changed to 
  dynamic. Then the vehicle will respawn to the position where it was destroyed. 
  First set all the other values then set TRUE for dynamic or FALSE for static.
  Like this:
  veh = [this, 15, 10, 5, TRUE, TRUE] execVM "vehicle.sqf"

  Default values of all settings are:
  veh = [this, 30, 120, 0, FALSE, FALSE] execVM "vehicle.sqf"
*/

if (!isServer) exitWith {};

private ["_unit","_delay","_deserted","_respawns","_run","_explode","_dynamic","_position","_type","_dead"];

// Define variables
_unit = _this select 0;
_delay = if (count _this > 1) then {_this select 1} else {30};
_deserted = if (count _this > 2) then {_this select 2} else {120};
_respawns = if (count _this > 3) then {_this select 3} else {0};
_explode = if (count _this > 4) then {_this select 4} else {false};
_dynamic = if (count _this > 5) then {_this select 5} else {false};

if (DEBUG_MESSAGES) then {diag_log format["SPAWN - Box has just been spawned: %1", typeOf _unit];};

_run = true;

_position = getPosASL _unit;
_type = typeOf _unit;
_dead = false;
_timeout = time;
 
while {_run} do 
{
	_dammage = getDammage _unit;

	// check if empty
	_contentWeapon = (getWeaponCargo _unit) select 0;
	if (count _contentWeapon < 1) then 
	{
		_dead = true;
		_deserted = 120;
		_delay = 240;
	};
	
	// check for badly broken
	if (_dammage > 0.90 or !alive _unit) then 
	{
		_dead = true;
		_deserted = 120;
	};
	
	// Respawn vehicle
	if (_dead) then 
	{	
		if (DEBUG_MESSAGES) then {diag_log format["SPAWN - Box dead: %1", typeOf _unit];};
		
		// there is a maximum of 10 seconds, before the damage is detected...
		sleep _delay;
		deleteVehicle _unit;
		sleep _deserted;

		_type = floor (random (count ammoBoxes));
		[_position, _type] call boxCreation;	
		_run = false;
	};
	
	sleep 10;
};
