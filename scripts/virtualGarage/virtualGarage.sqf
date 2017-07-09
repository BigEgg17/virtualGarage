// Developed by [GZA] David for German Zombie Apocalypse Servers (https://zombieapo.eu/)
// Rewritten by salival (https://github.com/oiad)

if (isNil "vg_init") then {
	player_getVehicle = compile preprocessFileLineNumbers "scripts\virtualGarage\player_getVehicle.sqf";
	player_removePad = compile preprocessFileLineNumbers "scripts\virtualGarage\player_removePad.sqf";
	player_storeVehicle = compile preprocessFileLineNumbers "scripts\virtualGarage\player_storeVehicle.sqf";
	vehicleInfo = compile preprocessFileLineNumbers "scripts\virtualGarage\vehicleInfo.sqf";
	vg_init = true;
};

private ["_class","_control","_displayName","_heliPad","_localVehicles","_plotCheck","_storedVehicles"];

disableSerialization;

createDialog "virtualGarage";

{ctrlShow [_x,false]} count [2803,2830,2850,2851,2852,2853];

PVDZE_queryVehicle = player;
publicVariableServer "PVDZE_queryVehicle";
waitUntil {!isNil "PVDZE_queryVehicleResult"};

_storedVehicles = PVDZE_queryVehicleResult;
PVDZE_queryVehicle = nil;
PVDZE_queryVehicleResult = nil;

_localVehicles = ([player] call FNC_getPos) nearEntities [["Air","LandVehicle","Ship"],vg_distance];
_heliPad = nearestObjects [player,vg_heliPads,vg_distance];

_plotCheck = [player, false] call FNC_find_plots;
if (count _heliPad > 0 && (_plotCheck select 1) > 0) then {ctrlShow[2853,true];};

_control = ((findDisplay 2800) displayCtrl 2802);
lbClear _control;

if (count _storedVehicles == 0 && {isNull DZE_myVehicle || {!(alive DZE_myVehicle)} || {!(local DZE_myVehicle)}}) exitWith {ctrlSetText[2811,localize "STR_VG_NO_VEHICLES"];};

vg_vehicleList = [];

{
	_displayName = getText(configFile >> "CfgVehicles" >> (_x select 1) >> "displayName");
	_control lbAdd _displayName;
	_control lbSetData [(lbSize _control)-1,str(_x)];
	vg_vehicleList set [count vg_vehicleList,_x];
} count _storedVehicles;

{
	if (!isNull DZE_myVehicle && {local DZE_myVehicle} && {alive DZE_myVehicle} && {DZE_myVehicle == _x}) then {
		_class = typeOf _x;
		_displayName = getText(configFile >> "CfgVehicles" >> _class >> "displayName");
		_control lbAdd _displayName;
		_control lbSetData [(lbSize _control)-1,_class];
		_control lbSetColor [(lbSize _control)-1,[0, 1, 0, 1]];
		vg_vehicleList set [count vg_vehicleList,_x];
	};
} count _localVehicles;

ctrlShow[2810,false];
ctrlShow[2811,false];