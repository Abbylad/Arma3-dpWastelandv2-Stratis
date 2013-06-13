//	@file Version: 1.0
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Description: The main init.
//	@file Args:

// reset BIS_fnc_mp
"BIS_fnc_MP_packet" addPublicVariableEventHandler {};

#include "setup.sqf"

StartProgress = false;
enableSaving[false,false];

X_Server = false;
X_Client = false;
X_JIP = false;
hitStateVar = false;
versionName = "v1.0 Alpha";

modVersion = "Blended-Wasteland-build-1003";
vChecksum = 1;
{vChecksum = vChecksum + _x;} forEach (toArray modVersion); 

if(isServer) then { X_Server = true;};
if(!isDedicated) then { X_Client = true;};
if(isNull player) then {X_JIP = true;};

true spawn {
	if(!isDedicated) then {
		titleText ["Welcome to =(dp)= Wasteland, please wait for your player to setup", "BLACK", 0];
		waitUntil {player == player};
		client_initEH = player addEventHandler ["Respawn", {removeAllWeapons (_this select 0);}];
	};
};

//init Wasteland Core
[] execVM "config.sqf";
[] execVM "briefing.sqf";

if(X_Client) then {
	waitUntil {player == player};

	//Wipe Group.
	if(count units group player > 1) then
	{  
		diag_log "Player Group Wiped";
		[player] join grpNull;    
	};

	[] execVM "client\init.sqf";
};

if(X_Server) then {
	diag_log format ["############################# %1 #############################", missionName];
	#ifdef __DEBUG__
	diag_log format ["T%1,DT%2,F%3", time, diag_tickTime, diag_frameno];
	#endif
    diag_log format["WASTELAND SERVER - Initilizing Server"];
	[] execVM "server\init.sqf";
};

//init 3rd Party Scripts
[] execVM "addons\R3F_ARTY_AND_LOG\init.sqf";

if (X_Server) then
{
	[] execVM "server\functions\PartialAntiCheats.sqf";
}
else
{
	"THISIS437SPARTA" addPublicVariableEventHandler { [] spawn (_this select 1); };
    dat4ClientStarted = player;
    publicVariableServer "dat4ClientStarted";
};