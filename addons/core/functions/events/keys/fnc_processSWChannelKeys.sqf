#include "script_component.hpp"

/*
    Name: TFAR_fnc_processSWChannelKeys

    Author(s):
        NKey

    Description:
        Switches the active SW radio to the passed channel.

    Parameters:
        0: NUMBER - Channel : Range (0,7)

    Returns:
        BOOLEAN - If the event was handled by this function.

    Example:
        Called by CBA.
*/

params ["_sw_channel_number"];

private _result = false;

if ((call TFAR_fnc_haveSWRadio) and {alive TFAR_currentUnit}) then {
    private _radio = call TFAR_fnc_activeSwRadio;
    [_radio, _sw_channel_number] call TFAR_fnc_setSwChannel;
    [_radio, false] call TFAR_fnc_showRadioInfo;
    if (dialog) then {
        call compile getText(configFile >> "CfgWeapons" >> _radio >> "tf_dialogUpdate");
    };
    _result = true;
};
_result